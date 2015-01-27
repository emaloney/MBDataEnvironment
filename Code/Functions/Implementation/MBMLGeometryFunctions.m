//
//  MBMLGeometryFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 7/6/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBMLGeometryFunctions.h"
#import "MBMLFunction.h"
#import "MBExpressionError.h"
#import "MBStringConversions.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLGeometryFunctions implementation
/******************************************************************************/

@implementation MBMLGeometryFunctions

/******************************************************************************/
#pragma mark Private - value validation & extraction
/******************************************************************************/

+ (CGRect) _validateParameter:(NSArray*)params
                isRectAtIndex:(NSUInteger)index
                        error:(out MBMLFunctionError**)errPtr
{
    NSError* err = nil;
    CGRect rect = [MBStringConversions rectFromObject:params[index] error:&err];
    if (err) {
        [[MBMLFunctionError errorWithError:err] reportErrorTo:errPtr];
    }
    return rect;
}

/******************************************************************************/
#pragma mark Working with rectangles
/******************************************************************************/

+ (id) insetRect:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameterIsArray:params error:&err];
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    CGRect rect = [self _validateParameter:params isRectAtIndex:0 error:&err];
    if (err) return err;

    NSError* parseErr = nil;
    UIEdgeInsets insets = [MBStringConversions edgeInsetsFromObject:params[1] error:&parseErr];
    if (parseErr) {
        return [MBMLFunctionError errorWithError:parseErr];
    }
    
    CGRect insetRect = UIEdgeInsetsInsetRect(rect, insets);
    return [MBStringConversions stringFromRect:insetRect];
}

+ (id) insetRectTop:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameterIsArray:params error:&err];
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    CGRect rect = [self _validateParameter:params isRectAtIndex:0 error:&err];
    NSNumber* insetNum = [MBMLFunction validateParameter:params containsNumberAtIndex:1 error:&err];
    if (err) return err;
    
    UIEdgeInsets insets = UIEdgeInsetsMake([insetNum doubleValue], 0, 0, 0);
    CGRect insetRect = UIEdgeInsetsInsetRect(rect, insets);
    return [MBStringConversions stringFromRect:insetRect];
}

+ (id) insetRectLeft:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameterIsArray:params error:&err];
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    CGRect rect = [self _validateParameter:params isRectAtIndex:0 error:&err];
    NSNumber* insetNum = [MBMLFunction validateParameter:params containsNumberAtIndex:1 error:&err];
    if (err) return err;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, [insetNum doubleValue], 0, 0);
    CGRect insetRect = UIEdgeInsetsInsetRect(rect, insets);
    return [MBStringConversions stringFromRect:insetRect];
}

+ (id) insetRectBottom:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameterIsArray:params error:&err];
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    CGRect rect = [self _validateParameter:params isRectAtIndex:0 error:&err];
    NSNumber* insetNum = [MBMLFunction validateParameter:params containsNumberAtIndex:1 error:&err];
    if (err) return err;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, [insetNum doubleValue], 0);
    CGRect insetRect = UIEdgeInsetsInsetRect(rect, insets);
    return [MBStringConversions stringFromRect:insetRect];
}

+ (id) insetRectRight:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameterIsArray:params error:&err];
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    CGRect rect = [self _validateParameter:params isRectAtIndex:0 error:&err];
    NSNumber* insetNum = [MBMLFunction validateParameter:params containsNumberAtIndex:1 error:&err];
    if (err) return err;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, [insetNum doubleValue]);
    CGRect insetRect = UIEdgeInsetsInsetRect(rect, insets);
    return [MBStringConversions stringFromRect:insetRect];
}

+ (id) rectOrigin:(id)param
{
    debugTrace();
    
    NSError* err = nil;
    CGRect rect = [MBStringConversions rectFromObject:param error:&err];
    if (err) {
        return [MBMLFunctionError errorWithError:err];
    }
    return [MBStringConversions stringFromPoint:rect.origin];
}

+ (id) rectSize:(id)param
{
    debugTrace();
    
    NSError* err = nil;
    CGRect rect = [MBStringConversions rectFromObject:param error:&err];
    if (err) {
        return [MBMLFunctionError errorWithError:err];
    }

    return [MBStringConversions stringFromSize:rect.size];
}

+ (id) rectX:(id)param
{
    debugTrace();

    NSError* err = nil;
    CGRect rect = [MBStringConversions rectFromObject:param error:&err];
    if (err) {
        return [MBMLFunctionError errorWithError:err];
    }

    return @(rect.origin.x);
}

+ (id) rectY:(id)param
{
    debugTrace();

    NSError* err = nil;
    CGRect rect = [MBStringConversions rectFromObject:param error:&err];
    if (err) {
        return [MBMLFunctionError errorWithError:err];
    }

    return @(rect.origin.y);
}

+ (id) rectWidth:(id)param
{
    debugTrace();

    NSError* err = nil;
    CGRect rect = [MBStringConversions rectFromObject:param error:&err];
    if (err) {
        return [MBMLFunctionError errorWithError:err];
    }

    return @(rect.size.width);
}

+ (id) rectHeight:(id)param
{
    debugTrace();

    NSError* err = nil;
    CGRect rect = [MBStringConversions rectFromObject:param error:&err];
    if (err) {
        return [MBMLFunctionError errorWithError:err];
    }

    return @(rect.size.height);
}

/******************************************************************************/
#pragma mark Working with sizes
/******************************************************************************/

+ (id) sizeWidth:(id)param
{
    debugTrace();

    NSError* err = nil;
    CGSize size = [MBStringConversions sizeFromObject:param error:&err];
    if (err) {
        return [MBMLFunctionError errorWithError:err];
    }

    return @(size.width);
}

+ (id) sizeHeight:(id)param
{
    debugTrace();
    
    NSError* err = nil;
    CGSize size = [MBStringConversions sizeFromObject:param error:&err];
    if (err) {
        return [MBMLFunctionError errorWithError:err];
    }

    return @(size.height);
}

/******************************************************************************/
#pragma mark Working with points
/******************************************************************************/

+ (id) pointX:(id)param
{
    debugTrace();

    NSError* err = nil;
    CGPoint pt = [MBStringConversions pointFromObject:param error:&err];
    if (err) {
        return [MBMLFunctionError errorWithError:err];
    }

    return @(pt.x);
}

+ (id) pointY:(id)param
{
    debugTrace();
    
    NSError* err = nil;
    CGPoint pt = [MBStringConversions pointFromObject:param error:&err];
    if (err) {
        return [MBMLFunctionError errorWithError:err];
    }

    return @(pt.y);
}

@end
