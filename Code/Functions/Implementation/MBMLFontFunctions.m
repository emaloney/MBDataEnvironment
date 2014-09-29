//
//  MBMLFontFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 5/2/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

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

+ (id) fontWithNameAndSize:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    NSString* fontName = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    NSNumber* fontSizeNum = [MBMLFunction validateParameter:params containsNumberAtIndex:1 error:&err];
    if (err) return err;
    
    CGFloat fontSize = [fontSizeNum doubleValue];
    if (fontSize <= 0.0) {
        return [MBMLFunctionError errorWithFormat:@"Font sizes need to be positive, greater-than-zero values; got %@", fontSizeNum];
    }
    
    UIFont* font = [UIFont fontWithName:fontName size:fontSize];
    if (!font) {
        return [MBMLFunctionError errorWithFormat:@"Couldn't find a font named \"%@\"", fontName];
    }
    return font;
}

+ (id) sizeOfTextWithFont:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    NSString* text = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    UIFont* font = [MBMLFunction validateParameter:params objectAtIndex:1 isKindOfClass:[UIFont class] error:&err];
    if (err) return err;

    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    return [MBStringConversions stringFromSize:size];
}

@end
