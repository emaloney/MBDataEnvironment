//
//  MBMLStringFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 9/15/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>

#import "MBMLStringFunctions.h"
#import "MBExpression.h"
#import "MBMLFunction.h"

#define DEBUG_LOCAL     0

@implementation MBMLStringFunctions

+ (id) q:(NSString*)toQuote
{
    MBLogDebugTrace();
    
    return [toQuote description];
}

+ (id) eval:(NSString*)evalStr
{
    MBExpressionError* err = nil;
    id result = [MBExpression asObject:evalStr error:&err];
    return err ?: result;
}

+ (id) evalBool:(NSString*)evalStr
{
    MBExpressionError* err = nil;
    BOOL result = [MBExpression asBoolean:evalStr error:&err];
    return err ?: @(result);
}

+ (id) stripQueryString:(NSString*)toTransform
{
    MBLogDebugTrace();

    if (toTransform) {
        NSURL* url = [NSURL URLWithString:toTransform];
        NSString* query = [url query];
        if (query) {
            query = [NSString stringWithFormat:@"?%@", query];
        }
        if ([toTransform hasSuffix:query]) {
            toTransform = [toTransform substringToIndex:toTransform.length - query.length];
        }
    }
    return toTransform;
}

+ (id) stripSpaces:(NSString*)toTransform 
{
    MBLogDebugTrace();
    
    return [toTransform stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (id) trimSpaces:(NSString*)toTransform 
{
    MBLogDebugTrace();
    
    return [toTransform stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (id) indentLines:(NSString*)toIndent
{
    MBLogDebugTrace();

    return [toIndent stringByIndentingEachLineWithTab];
}

+ (id) indentLinesToDepth:(NSArray*)params
{
    MBLogDebugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    NSString* toIndent = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    NSNumber* countNum = [MBMLFunction validateParameter:params containsNumberAtIndex:1 error:&err];
    if (err) return err;

    return [toIndent stringByIndentingEachLineWithTabs:[countNum unsignedIntegerValue]];
}

+ (id) prefixLinesWith:(NSArray*)params
{
    MBLogDebugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    NSString* toIndent = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    NSString* prefix = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;

    return [toIndent stringByIndentingEachLineWithPrefix:prefix];
}

+ (id) pluralize:(NSArray*)params
{
    MBLogDebugTrace();
    
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:3 andAtMost:4 error:&err];
    NSNumber* countNum = [MBMLFunction validateParameter:params containsNumberAtIndex:0 error:&err];
    if (err) return err;
    
    NSInteger count = [countNum integerValue];
    if (paramCnt == 4) {
        switch (count) {
            case 0:
                return params[1];
            
            case 1:
                return params[2];
                
            default:
                return params[3];
        }
    } else {
        switch (count) {
            case 1:
                return params[1];
                
            default:
                return params[2];
        }
    }
}

+ (id) lowercase:(NSString*)toTransform
{
    MBLogDebugTrace();
    
    return [toTransform lowercaseString];
}

+ (id) uppercase:(NSString*)toTransform
{
    MBLogDebugTrace();
    
    return [toTransform uppercaseString];
}

+ (id) titleCase:(NSString*)toTransform
{
    MBLogDebugTrace();
    
    return [toTransform capitalizedString];
}

+ (id) titleCaseIfAllCaps:(NSString*)toTransform
{
    MBLogDebugTrace();
    
    NSCharacterSet* letters = [NSCharacterSet letterCharacterSet];
    NSCharacterSet* uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    
    unichar ch;
    NSUInteger strLen = [toTransform length];
    for (NSUInteger i=0; i<strLen; i++) {
        ch = [toTransform characterAtIndex:i];
        if ([letters characterIsMember:ch] && ![uppercase characterIsMember:ch]) {
            return toTransform;
        }
    }
    return [toTransform capitalizedString];
}

+ (id) concatenateFields:(NSArray*)params
{
    MBLogDebugTrace();
    
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    if (err) return err;

    NSInteger startIndex = 0;
    NSString* separator = nil;
    if (paramCnt % 2 == 0) {
        separator = @"; ";
    }
    else {
        separator = params[0];
        startIndex++;
    }
    
    NSMutableString* retVal = [NSMutableString string];
    for (NSInteger i=startIndex; i<paramCnt-1; i+=2) {
        NSString* label = params[i];
        NSString* value = params[i+1];
        if (value != (id)[NSNull null]) {
            if (![value isKindOfClass:[NSString class]]) {
                value = [value description];
            }
            if ([value length] > 0) {
                if (i>startIndex) {
                    [retVal appendString:separator];
                }
                [retVal appendString:label];
                [retVal appendString:value];
            }
        }
    }
    return retVal;
}

+ (id) firstNonemptyString:(NSArray*)params
{
    MBLogDebugTrace();
    
    MBMLFunctionError* err = nil;
    for (__strong NSString* param in params) {
        param = [MBExpression asString:param error:&err];
        if (err) return err;
        
        if (param.length > 0) {
            return param;
        }
    }
    return nil;
}

+ (id) firstNonemptyTrimmedString:(NSArray*)params
{
    MBLogDebugTrace();
    
    MBMLFunctionError* err = nil;
    for (__strong NSString* param in params) {
        param = [MBExpression asString:param error:&err];
        if (err) return err;

        if (param.length > 0) {
            NSString* trimmed = [param stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (trimmed.length > 0) {
                return trimmed;
            }
        }
    }
    return nil;
}

+ (id) truncate:(NSArray*)params
{
    MBLogDebugTrace();
    
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 andAtMost:3 error:&err];
    NSNumber* truncLenNum = [MBMLFunction validateParameter:params containsNumberAtIndex:0 error:&err];
    if (err) return err;
    
    NSUInteger truncLen = [truncLenNum integerValue];
    NSString* truncMarker = @"…";
    if (paramCnt == 3) {
        truncMarker = params[1];
    }
    NSString* truncStr = params[paramCnt-1];
    
    if (truncStr.length > truncLen) {
        NSString* trimmed = [[truncStr substringToIndex:truncLen] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return [NSString stringWithFormat:@"%@%@", trimmed, truncMarker];
    }
    return truncStr;
}

+ (id) parseNumber:(NSString*)toParse
{
    MBLogDebugTrace();
    
    MBMLFunctionError* err = nil;
    NSNumber* num = [MBMLFunction validateParameterContainsNumber:toParse error:&err];
    if (err) return err;
    
    return num;
}

+ (id) parseInteger:(NSString*)toParse
{
    MBLogDebugTrace();

    MBMLFunctionError* err = nil;
    NSNumber* num = [MBMLFunction validateParameterContainsNumber:toParse error:&err];
    if (err) return err;

    return @([num integerValue]);
}

+ (id) parseDouble:(NSString*)toParse
{
    MBLogDebugTrace();

    MBMLFunctionError* err = nil;
    NSNumber* num = [MBMLFunction validateParameterContainsNumber:toParse error:&err];
    if (err) return err;

    return @([num doubleValue]);
}

+ (id) rangeOfString:(NSArray*)params
{
    MBLogDebugTrace();
    
    MBMLFunctionError *err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    NSString *string = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    NSString *substring = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;
    
    NSRange range = [string rangeOfString:substring];
    
    return @[@(range.location), @(range.length)];
}

+ (id) formatInteger:(NSNumber*)toFormat
{
    MBLogDebugTrace();
    
    MBMLFunctionError* err = nil;
    NSNumber* num = [MBMLFunction validateParameterContainsNumber:toFormat error:&err];
    if (err) return err;
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter stringFromNumber:@([num integerValue])];
}

+ (id) hasPrefix:(NSArray*)params
{
    MBLogDebugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    NSString* string = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    NSString* prefix = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;

    return @([string hasPrefix:prefix]);
}

+ (id) hasSuffix:(NSArray*)params
{
    MBLogDebugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    NSString* string = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    NSString* suffix = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;
    
    return @([string hasSuffix:suffix]);
}

+ (id) containsString:(NSArray*)params
{
    MBLogDebugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    NSString* string = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    NSString* contains = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;
    
    NSRange range = [string rangeOfString:contains];
    return (range.location != NSNotFound) ? @YES : @NO;
}

@end
