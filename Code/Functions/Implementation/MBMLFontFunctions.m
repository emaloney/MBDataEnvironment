//
//  MBMLFontFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 5/2/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBMLFontFunctions.h"
#import "MBExpressionError.h"
#import "MBMLFunction.h"
#import "MBStringConversions.h"

#define DEBUG_LOCAL             0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFontFunctions implementation
/******************************************************************************/

@implementation MBMLFontFunctions

/******************************************************************************/
#pragma mark MBML function API
/******************************************************************************/

+ (id) fontFamilyNames
{
    debugTrace();

    return [UIFont familyNames];
}

+ (id) fontNamesForFamilyName:(NSString*)input
{
    debugTrace();

    return [UIFont fontNamesForFamilyName:input];
}

+ (UIFont*) _fontWithNameAndSizeFromParameters:(NSArray*)params
                               startingAtIndex:(NSUInteger)index
                                         error:(inout MBMLFunctionError**)errPtr
{
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIsAtLeast:(index + 2) error:&err];
    if (!err) {
        NSString* fontName = [MBMLFunction validateParameter:params isStringAtIndex:index error:&err];
        NSNumber* fontSizeNum = [MBMLFunction validateParameter:params containsNumberAtIndex:index + 1 error:&err];

        if (!err) {
            CGFloat fontSize = [fontSizeNum doubleValue];
            if (fontSize > 0.0) {
                UIFont* font = [UIFont fontWithName:fontName size:fontSize];
                if (font) {
                    return font;
                }
                err = [MBMLFunctionError errorWithFormat:@"Couldn't find a font named \"%@\"", fontName];
            }
            else {
                err = [MBMLFunctionError errorWithFormat:@"Font sizes need to be positive, greater-than-zero values; got %@", fontSizeNum];
            }
        }
    }

    [err reportErrorTo:errPtr];
    return nil;
}

+ (id) fontWithNameAndSize:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;

    UIFont* font = [self _fontWithNameAndSizeFromParameters:params
                                            startingAtIndex:0
                                                      error:&err];
    if (err) return err;

    return font;
}

+ (id) stringWidth:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError *err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 andAtMost:3 error:&err];
    NSString* text = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    if (err) return err;

    UIFont* font = nil;
    if (paramCnt == 2) {
        font = [MBMLFunction validateParameter:params objectAtIndex:1 isKindOfClass:[UIFont class] error:&err];
    }
    else {
        font = [self _fontWithNameAndSizeFromParameters:params startingAtIndex:1 error:&err];
    }
    if (err) return err;

    if (!font) {
        return [MBMLFunctionError errorWithMessage:@"Couldn't determine UIFont to use"];
    }

    CGFloat width = [text sizeWithAttributes:@{NSFontAttributeName:font}].width;
    return @(width);
}

+ (id) sizeOfTextWithFont:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 andAtMost:3 error:&err];
    NSString* text = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    if (err) return err;

    UIFont* font = nil;
    if (paramCnt == 2) {
        font = [MBMLFunction validateParameter:params objectAtIndex:1 isKindOfClass:[UIFont class] error:&err];
    }
    else {
        font = [self _fontWithNameAndSizeFromParameters:params startingAtIndex:1 error:&err];
    }
    if (err) return err;

    if (!font) {
        return [MBMLFunctionError errorWithMessage:@"Couldn't determine UIFont to use"];
    }

    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    return [MBStringConversions stringFromSize:size];
}

+ (id) linesNeededToDrawText:(NSArray*)params
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:3 andAtMost:4 error:&err];
    NSString* text = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    NSNumber* rectWidthNum = [MBMLFunction validateParameter:params containsNumberAtIndex:(paramCnt - 1) error:&err];
    if (err) return err;

    UIFont* font = nil;
    if (paramCnt == 3) {
        font = [MBMLFunction validateParameter:params objectAtIndex:1 isKindOfClass:[UIFont class] error:&err];
    }
    else {
        font = [self _fontWithNameAndSizeFromParameters:params startingAtIndex:1 error:&err];
    }
    if (err) return err;

    if (!font) {
        return [MBMLFunctionError errorWithMessage:@"Couldn't determine UIFont to use"];
    }

    return @(ceil([font sizeString:text maxWidth:[rectWidthNum doubleValue] fractional:YES].height / font.lineHeight));
}

@end
