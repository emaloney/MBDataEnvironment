//
//  MBMLStringFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 9/15/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/NSString+MBIndentation.h>
#import <MBToolbox/UIFont+MBStringSizing.h>

#import "MBMLStringFunctions.h"
#import "MBExpression.h"
#import "MBMLFunction.h"

#define DEBUG_LOCAL     0

@implementation MBMLStringFunctions

+ (id) q:(NSString*)toQuote
{
    debugTrace();
    
    return [toQuote description];
}

+ (id) eval:(NSString*)evalStr
{
    return [evalStr evaluateAsObject];
}

+ (id) evalBool:(NSString*)evalStr
{
    return [NSNumber numberWithBool:[evalStr evaluateAsBoolean]];
}

+ (id) stripQueryString:(NSString*)toTransform
{
    debugTrace();

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
    debugTrace();
    
    return [toTransform stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (id) trimSpaces:(NSString*)toTransform 
{
    debugTrace();
    
    return [toTransform stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (id) indentLines:(NSString*)toIndent
{
    debugTrace();

    return [toIndent stringByIndentingEachLineWithTab];
}

+ (id) indentLinesToDepth:(NSArray*)params
{
    debugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    NSString* toIndent = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    NSNumber* countNum = [MBMLFunction validateParameter:params containsNumberAtIndex:1 error:&err];
    if (err) return err;

    return [toIndent stringByIndentingEachLineWithTabs:[countNum unsignedIntegerValue]];
}

+ (id) prefixLinesWith:(NSArray*)params
{
    debugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    NSString* toIndent = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    NSString* prefix = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;

    return [toIndent stringByIndentingEachLineWithPrefix:prefix];
}

+ (id) pluralize:(NSArray*)params
{
    debugTrace();
    
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
    debugTrace();
    
    return [toTransform lowercaseString];
}

+ (id) uppercase:(NSString*)toTransform
{
    debugTrace();
    
    return [toTransform uppercaseString];
}

+ (id) titleCase:(NSString*)toTransform
{
    debugTrace();
    
    return [toTransform capitalizedString];
}

+ (id) titleCaseIfAllCaps:(NSString*)toTransform
{
    debugTrace();
    
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
    debugTrace();
    
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
    debugTrace();
    
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
    debugTrace();
    
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
    debugTrace();
    
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
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSNumber* num = [MBMLFunction validateParameterContainsNumber:toParse error:&err];
    if (err) return err;
    
    return num;
}

+ (id) parseInteger:(NSString*)toParse
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSNumber* num = [MBMLFunction validateParameterContainsNumber:toParse error:&err];
    if (err) return err;

    return @([num integerValue]);
}

+ (id) parseDouble:(NSString*)toParse
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSNumber* num = [MBMLFunction validateParameterContainsNumber:toParse error:&err];
    if (err) return err;

    return @([num doubleValue]);
}

+ (id) stringWidth:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError *err = nil;
    [MBMLFunction validateParameter:params countIs:3 error:&err];
    if (err) return err;

    if (params[0] == [NSNull null])
        return @(0);

    [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    if (err) return err;
    
    NSString *textToCompute = [MBExpression asString:params[0]];
    NSString *fontName = [MBExpression asString:params[1]];
    CGFloat fontSize = [[MBExpression asNumber:params[2]] doubleValue];
    UIFont *textFont = [UIFont fontWithName:fontName size:fontSize];
    CGFloat width = [textToCompute sizeWithAttributes:@{NSFontAttributeName:textFont}].width;
    
    return @(width);
}

+ (id) linesNeededToDrawText:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError *err = nil;
    [MBMLFunction validateParameter:params countIs:4 error:&err];
    if (err) return err;
    
    if (params[0] == [NSNull null])
        return @(0);
    
    [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    if (err) return err;
    
    NSString *textToCompute = [MBExpression asString:params[0]];
    NSString *fontName = [MBExpression asString:params[1]];
    CGFloat fontSize = [[MBExpression asNumber:params[2]] doubleValue];
    CGFloat rectWidth = [[MBExpression asNumber:params[3]] doubleValue];
    UIFont *textFont = [UIFont fontWithName:fontName size:fontSize];
    
    return @(ceil([textFont sizeString:textToCompute maxWidth:rectWidth fractional:YES].height / textFont.lineHeight));
}

+ (id) rangeOfString:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError *err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    NSString *string = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    if (err) return err;
    NSString *substring = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;
    
    NSRange range = [string rangeOfString:substring];
    
    return @[@(range.location), @(range.length)];
}

+ (id) formatInteger:(NSString*)toParse
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSNumber* num = [MBMLFunction validateParameterContainsNumber:toParse error:&err];
    if (err) return err;
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter stringFromNumber:@([num integerValue])];
}

+ (id) hasPrefix:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    NSString* string = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    if (err) return err;
    NSString* prefix = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;

    return @([string hasPrefix:prefix]);
}

+ (id) hasSuffix:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    NSString* string = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    if (err) return err;
    NSString* suffix = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;
    
    return @([string hasSuffix:suffix]);
}

+ (id) containsString:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    NSString* string = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    if (err) return err;
    NSString* contains = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;
    
    NSRange range = [string rangeOfString:contains];
    return (range.location != NSNotFound) ? @YES : @NO;
}

@end
