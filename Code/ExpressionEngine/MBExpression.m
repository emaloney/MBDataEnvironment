//
//  MBExpression.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/25/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBExpression.h"
#import "MBMLParseToken.h"
#import "MBExpressionCache.h"
#import "MBMLFunction.h"
#import "MBVariableSpace.h"
#import "MBExpressionGrammar.h"
#import "MBExpressionCache+Internal.h"

#define DEBUG_LOCAL             0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

NSString* const kMBMLBooleanStringTrue   = @"T";
NSString* const kMBMLBooleanStringFalse  = @"F";

/******************************************************************************/
#pragma mark -
#pragma mark MBExpression implementation
/******************************************************************************/

@implementation MBExpression

/******************************************************************************/
#pragma mark Value interpretation & translation
/******************************************************************************/

+ (BOOL) booleanFromValue:(id)val
{
    if (!val) {
        return NO;
    }
    if (val == [NSNull null]) {
        // nulls/nils evaluate to false
        return NO;
    }
    if ([@NO isEqual:val]) {
        return NO;
    }
    if ([@YES isEqual:val]) {
        return YES;
    }
    if ([val isKindOfClass:[NSNumber class]]) {
        return [val boolValue];
    }
    if ([val isKindOfClass:[NSString class]]) {
        NSUInteger strLen = [val length];
        if (strLen == 0) {
            // empty strings evaluate to false
            return NO;
        }
        else if (strLen == 1) {
            // the strings "F", "f" & "0" evaluate to false
            unichar b = [val characterAtIndex:0];
            if (b == 'F' || b == 'f' || b == '0') {
                return NO;
            }
        }

        // all other non-empty strings evaluate to true
        return YES;
    }

    //
    // otherwise, all non-nil values evaluate to true
    //
    return YES;
}

+ (NSString*) stringFromBoolean:(BOOL)val
{
    return (val ? kMBMLBooleanStringTrue : kMBMLBooleanStringFalse);
}

+ (NSDecimalNumber*) numberFromValue:(id)val
{
    NSDecimalNumber* retVal = nil;
    if ([val isKindOfClass:[NSDecimalNumber class]]) {
        retVal = val;
    }
    else if ([val isKindOfClass:[NSNumber class]]) {
        retVal = [[NSDecimalNumber alloc] initWithDecimal:[val decimalValue]];
    }
    else if ([val isKindOfClass:[NSString class]]) {
        retVal = [NSDecimalNumber decimalNumberWithString:val];
    }
    if (retVal != [NSDecimalNumber notANumber]) {
        return retVal;
    }
    return nil;
}

+ (BOOL) value:(id)lValue isEqualTo:(id)rValue
{
    BOOL isEqual = NO;
    if (!lValue && !rValue) {
        isEqual = YES;
    } else if ([lValue isKindOfClass:[NSNumber class]] && ![rValue isKindOfClass:[NSNumber class]] && rValue != [NSNull null]) {
        isEqual = [lValue isEqual:@([[rValue description] doubleValue])];
    } else if ([rValue isKindOfClass:[NSNumber class]] && ![lValue isKindOfClass:[NSNumber class]] && lValue != [NSNull null]) {
        isEqual = [rValue isEqual:@([[lValue description] doubleValue])];
    } else {
        isEqual = [lValue isEqual:rValue];
    }
    return isEqual;
}

+ (NSComparisonResult) compareLeftValue:(id)lValue againstRightValue:(id)rValue
{
    if ((!lValue && !rValue) || lValue == rValue) {
        return NSOrderedSame;
    }

    // use native comparison if the lvalue and rvalue are compatible objects
    if ([lValue respondsToSelector:@selector(compare:)] && ([lValue isKindOfClass:[rValue class]] || [rValue isKindOfClass:[lValue class]])) {
        return [lValue compare:rValue];
    }

    // no native comparison possible, treat as numbers
    id lObj = nil;
    id rObj = nil;
    if ([lValue isKindOfClass:[NSNumber class]]) {
        lObj = lValue;
    }
    else if (lValue != [NSNull null]) {
        lObj = @([[lValue description] doubleValue]);
    }
    if ([rValue isKindOfClass:[NSNumber class]]) {
        rObj = rValue;
    }
    else if (rValue != [NSNull null]) {
        rObj = @([[rValue description] doubleValue]);
    }

    if (!lObj && !rObj) {
        return NSOrderedSame;
    }
    if (!lObj && rObj) {
        return NSOrderedAscending;
    }
    if (lObj && !rObj) {
        return NSOrderedDescending;
    }

    return [lObj compare:rObj];
}

/******************************************************************************/
#pragma mark High-level expression evaluation API - multiple objects
/******************************************************************************/

+ (NSArray*) asArray:(NSString*)expr
{
    return [self asArray:expr
         inVariableSpace:[MBVariableSpace instance]
                   error:nil];
}

+ (NSArray*) asArray:(NSString*)expr error:(MBExpressionError**)errPtr
{
    return [self asArray:expr
         inVariableSpace:[MBVariableSpace instance]
                   error:errPtr];
}

+ (NSArray*) asArray:(NSString*)expr inVariableSpace:(MBVariableSpace*)space error:(MBExpressionError**)errPtr
{
    debugTrace();

    if (!expr || expr.length == 0) {
        return nil;
    }

    MBExpressionCache* cache = [MBExpressionCache instance];
    MBExpressionGrammar* grammar = [MBMLObjectExpressionGrammar instance];
    NSArray* tokens = [cache cachedTokensForExpression:expr usingGrammar:grammar];
    if (!tokens) {
        // we don't perform this optimization check until after the cache is
        // consulted; on-device testing shows the cache is more efficient
        if ([grammar canOptimizeAsConstantExpression:expr]) {
            return @[expr];
        }
    }

    MBExpressionError* err = nil;
    tokens = [cache tokensForExpression:expr inVariableSpace:space usingGrammar:grammar error:&err];
    if (err) {
        err.offendingExpression = expr;
        [err reportErrorTo:errPtr];
        return nil;
    }

    return [self evaluateTokens:tokens inVariableSpace:space error:errPtr];
}


/******************************************************************************/
#pragma mark High-level expression evaluation API - single objects or string
/******************************************************************************/

+ (id) asObject:(NSString*)expr
{
    return [self asObject:expr
          inVariableSpace:[MBVariableSpace instance]
             defaultValue:nil
                    error:nil];
}

+ (id) asObject:(NSString*)expr error:(MBExpressionError**)errPtr
{
    return [self asObject:expr
          inVariableSpace:[MBVariableSpace instance]
             defaultValue:nil
                    error:errPtr];
}

+ (id) asObject:(NSString*)expr defaultValue:(id)def
{
    return [self asObject:expr
          inVariableSpace:[MBVariableSpace instance]
             defaultValue:def
                    error:nil];
}

+ (id) asObject:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(id)def error:(MBExpressionError**)errPtr
{
    debugTrace();

    if (!expr || expr.length == 0) {
        return def;
    }

    MBExpressionCache* cache = [MBExpressionCache instance];
    MBExpressionGrammar* grammar = [MBMLObjectExpressionGrammar instance];
    NSArray* tokens = [cache cachedTokensForExpression:expr usingGrammar:grammar];
    if (!tokens) {
        // we don't perform this optimization check until after the cache is
        // consulted; on-device testing shows the cache is more efficient
        if ([grammar canOptimizeAsConstantExpression:expr]) {
            return expr;
        }
    }

    MBExpressionError* err = nil;
    tokens = [cache tokensForExpression:expr inVariableSpace:space usingGrammar:grammar error:&err];
    if (err) {
        err.offendingExpression = expr;
        [err reportErrorTo:errPtr];
        return def;
    }

    id retVal = [self objectFromTokens:tokens inVariableSpace:space defaultValue:def error:&err];
    if (err) {
        err.offendingExpression = expr;
        [err reportErrorTo:errPtr];
        return def;
    }

    return retVal ?: def;
}

/******************************************************************************/
#pragma mark High-level expression evaluation API - returning NSString
/******************************************************************************/

+ (NSString*) asString:(NSString*)expr
{
    return [self asString:expr
          inVariableSpace:[MBVariableSpace instance]
             defaultValue:nil
                    error:nil];
}

+ (NSString*) asString:(NSString*)expr error:(MBExpressionError**)errPtr
{
    return [self asString:expr
          inVariableSpace:[MBVariableSpace instance]
             defaultValue:nil
                    error:errPtr];
}

+ (NSString*) asString:(NSString*)expr defaultValue:(NSString*)def
{
    return [self asString:expr
          inVariableSpace:[MBVariableSpace instance]
             defaultValue:def
                    error:nil];
}

+ (NSString*) asString:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(NSString*)def error:(MBExpressionError**)errPtr
{
    debugTrace();

    if (!expr || expr.length == 0) {
        return def;
    }

    MBExpressionCache* cache = [MBExpressionCache instance];
    MBExpressionGrammar* grammar = [MBMLObjectExpressionGrammar instance];
    NSArray* tokens = [cache cachedTokensForExpression:expr usingGrammar:grammar];
    if (!tokens) {
        // we don't perform this optimization check until after the cache is
        // consulted; on-device testing shows the cache is more efficient
        if ([grammar canOptimizeAsConstantExpression:expr]) {
            return expr;
        }
    }

    MBExpressionError* err = nil;
    tokens = [cache tokensForExpression:expr inVariableSpace:space usingGrammar:grammar error:&err];
    if (err) {
        err.offendingExpression = expr;
        [err reportErrorTo:errPtr];
        return def;
    }

    NSString* retVal = [self stringFromTokens:tokens inVariableSpace:space defaultValue:def error:&err];
    if (err) {
        err.offendingExpression = expr;
        [err reportErrorTo:errPtr];
        return def;
    }

    return retVal ?: def;
}

/******************************************************************************/
#pragma mark High-level expression evaluation API - returning NSDecimalNumber
/******************************************************************************/

+ (NSDecimalNumber*) asNumber:(NSString*)expr
{
    return [self asNumber:expr
          inVariableSpace:[MBVariableSpace instance]
             defaultValue:nil
                    error:nil];
}

+ (NSDecimalNumber*) asNumber:(NSString*)expr error:(MBExpressionError**)errPtr
{
    return [self asNumber:expr
          inVariableSpace:[MBVariableSpace instance]
             defaultValue:nil
                    error:errPtr];
}

+ (NSDecimalNumber*) asNumber:(NSString*)expr defaultValue:(NSDecimalNumber*)def
{
    return [self asNumber:expr
          inVariableSpace:[MBVariableSpace instance]
             defaultValue:def
                    error:nil];
}

+ (NSDecimalNumber*) asNumber:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(NSDecimalNumber*)def error:(MBExpressionError**)errPtr
{
    debugTrace();

    if (!expr || expr.length == 0) {
        return def;
    }

    MBExpressionCache* cache = [MBExpressionCache instance];
    MBExpressionGrammar* grammar = [MBMLMathExpressionGrammar instance];
    NSArray* tokens = [cache cachedTokensForExpression:expr usingGrammar:grammar];
    if (!tokens) {
        // we don't perform this optimization check until after the cache is
        // consulted; on-device testing shows the cache is more efficient
        if ([grammar canOptimizeAsConstantExpression:expr]) {
            return [MBExpression numberFromValue:expr];
        }
    }

    MBExpressionError* err = nil;
    tokens = [cache tokensForExpression:expr inVariableSpace:space usingGrammar:grammar error:&err];
    if (err) {
        err.offendingExpression = expr;
        [err reportErrorTo:errPtr];
        return def;
    }

    id val = [self objectFromTokens:tokens inVariableSpace:space defaultValue:def error:&err];
    if (err) {
        err.offendingExpression = expr;
        [err reportErrorTo:errPtr];
        return def;
    }

    if (val) {
        NSDecimalNumber* retVal = [MBExpression numberFromValue:val];
        if (retVal) {
            return retVal;
        }
        else {
            err = [MBEvaluationError errorWithFormat:@"expression result could not be interpreted as an %@", [NSNumber class]];
            err.offendingExpression = expr;
            [err reportErrorTo:errPtr];
            return def;
        }
    }

    return def;
}

/******************************************************************************/
#pragma mark High-level expression evaluation API - returning BOOL
/******************************************************************************/

+ (BOOL) asBoolean:(NSString*)expr
{
    return [self asBoolean:expr
           inVariableSpace:[MBVariableSpace instance]
              defaultValue:NO
                     error:nil];
}

+ (BOOL) asBoolean:(NSString*)expr error:(MBExpressionError**)errPtr
{
    return [self asBoolean:expr
           inVariableSpace:[MBVariableSpace instance]
              defaultValue:NO
                     error:errPtr];
}

+ (BOOL) asBoolean:(NSString*)expr defaultValue:(BOOL)def
{
    return [self asBoolean:expr
           inVariableSpace:[MBVariableSpace instance]
              defaultValue:def
                     error:nil];
}

+ (BOOL) asBoolean:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(BOOL)def error:(MBExpressionError**)errPtr
{
    debugTrace();

    if (!expr || expr.length == 0) {
        return def;
    }

    MBExpressionCache* cache = [MBExpressionCache instance];
    MBExpressionGrammar* grammar = [MBMLBooleanExpressionGrammar instance];
    NSArray* tokens = [cache cachedTokensForExpression:expr usingGrammar:grammar];
    if (!tokens) {
        // we don't perform this optimization check until after the cache is
        // consulted; on-device testing shows the cache is more efficient
        if ([grammar canOptimizeAsConstantExpression:expr]) {
            return [MBExpression booleanFromValue:expr];
        }
    }

    MBExpressionError* err = nil;
    tokens = [cache tokensForExpression:expr inVariableSpace:space usingGrammar:grammar error:&err];
    if (err) {
        err.offendingExpression = expr;
        [err reportErrorTo:errPtr];
        return def;
    }

    BOOL retVal = [self booleanFromTokens:tokens inVariableSpace:space defaultValue:def error:&err];
    if (err) {
        err.offendingExpression = expr;
        [err reportErrorTo:errPtr];
        return def;
    }

    return retVal;
}

/******************************************************************************/
#pragma mark Mid-level token evaluation API
/******************************************************************************/

+ (id) objectFromTokens:(NSArray*)tokens error:(MBExpressionError**)errPtr
{
    return [self objectFromTokens:tokens
                  inVariableSpace:[MBVariableSpace instance]
                     defaultValue:nil
                            error:errPtr];
}

+ (id) objectFromTokens:(NSArray*)tokens inVariableSpace:(MBVariableSpace*)space defaultValue:(id)def error:(MBExpressionError**)errPtr
{
    debugTrace();

    NSArray* values = [self evaluateTokens:tokens inVariableSpace:space error:errPtr];
    if (!values) {
        return def;
    }

    if (values.count == 1) {
        id val = values[0];
        if (val == [NSNull null]) {
            return def;
        }
        return val;
    }

    NSMutableString* buffer = [NSMutableString string];
    for (id val in values) {
        if ([val isKindOfClass:[NSString class]]) {
            [buffer appendString:val];
        }
        else if (val != [NSNull null]) {
            [buffer appendString:[val description]];
        }
    }
    return buffer;
}

+ (NSString*) stringFromTokens:(NSArray*)tokens error:(MBExpressionError**)errPtr
{
    return [self stringFromTokens:tokens
                  inVariableSpace:[MBVariableSpace instance]
                     defaultValue:nil
                            error:errPtr];
}

+ (NSString*) stringFromTokens:(NSArray*)tokens inVariableSpace:(MBVariableSpace*)space defaultValue:(NSString*)def error:(MBExpressionError**)errPtr
{
    debugTrace();

    MBExpressionError* currentErr = nil;
    id obj = [self objectFromTokens:tokens inVariableSpace:space defaultValue:def error:&currentErr];
    if (currentErr) {
        [currentErr reportErrorTo:errPtr];
        return def;
    }

    NSString* strVal = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        strVal = (NSString*) obj;
    }
    else {
        strVal = [obj description];
    }
    return strVal;
}

+ (BOOL) booleanFromTokens:(NSArray*)tokens error:(MBExpressionError**)errPtr
{
    return [self booleanFromTokens:tokens
                   inVariableSpace:[MBVariableSpace instance]
                      defaultValue:NO
                             error:errPtr];
}

+ (BOOL) booleanFromTokens:(NSArray*)tokens
           inVariableSpace:(MBVariableSpace*)space
              defaultValue:(BOOL)def
                     error:(MBExpressionError**)errPtr
{
    debugTrace();

    NSArray* values = [self evaluateTokens:tokens inVariableSpace:space error:errPtr];
    if (!values) {
        return def;
    }

    NSUInteger tokCount = values.count;
    if (tokCount == 1) {
        return [MBExpression booleanFromValue:values[0]];
    }
    else {
        MBEvaluationError* err = [MBEvaluationError errorWithMessage:@"expecting one and only one value here"];
        err.offendingToken = tokens[1];
        [err reportErrorTo:errPtr];
    }

    return def;
}

/******************************************************************************/
#pragma mark Low-level token evaluation API
/******************************************************************************/

+ (NSArray*) evaluateTokens:(NSArray*)origTokens error:(MBExpressionError**)errPtr
{
    return [self evaluateTokens:origTokens
                inVariableSpace:[MBVariableSpace instance]
                          error:errPtr];
}

+ (NSArray*) evaluateTokens:(NSArray*)origTokens inVariableSpace:(MBVariableSpace*)space error:(MBExpressionError**)errPtr
{
    NSInteger tokCount = origTokens.count;
    if (tokCount < 1) {
        return nil;
    }

    MBExpressionError* err = nil;
    if (!space) {
        err = [MBEvaluationError errorWithMessage:@"evaluation requires MBVariableSpace parameter to be non-nil"];
        [err reportErrorTo:errPtr];
        return nil;
    }

    NSMutableArray* mutableTokens = nil;
    NSArray* curTokens = origTokens;
    @autoreleasepool {
        for (NSUInteger i=0; i<tokCount; i++) {
            MBMLParseToken* tok = curTokens[i];

            id replaceVal = [tok evaluateInVariableSpace:space error:&err];
            if (err) {
                err.offendingToken = tok;
                curTokens = nil;
                break;
            }

            if (!mutableTokens) {
                mutableTokens = [origTokens mutableCopy];
                curTokens = mutableTokens;
            }

            mutableTokens[i] = (replaceVal ?: [NSNull null]);
        }
    }

    if (err) {
        [err reportErrorTo:errPtr];
    }
    
    return curTokens;
}

@end
