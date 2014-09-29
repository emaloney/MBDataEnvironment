//
//  MBMLGeometryFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 7/6/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

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

+ (CGRect) _validateParameterIsRect:(id)param
                              error:(MBMLFunctionError**)errPtr
{
    if ([param isKindOfClass:[NSString class]]) {
        NSError* parseErr = nil;
        CGRect rect = [MBStringConversions rectFromString:(NSString*)param error:&parseErr];
        if (!parseErr) {
            return rect;
        }
        [[MBMLFunctionError errorWithFormat:@"%@ encountered an error trying to convert value of class %@ into a CGRect: %@", self, [param class], parseErr] reportErrorTo:errPtr];
    }
    else if ([param isKindOfClass:[NSValue class]]) {
        return [(NSValue*)param CGRectValue];
    }
    else {
        [[MBMLFunctionError errorWithFormat:@"%@ can't convert value of class %@ into a CGRect", self, [param class]] reportErrorTo:errPtr];
    }
    return CGRectZero;
}

+ (CGRect) _validateParameter:(NSArray*)params
                isRectAtIndex:(NSUInteger)index
                        error:(MBMLFunctionError**)errPtr
{
    id param = params[index];
    if ([param isKindOfClass:[NSString class]]) {
        NSError* parseErr = nil;
        CGRect rect = [MBStringConversions rectFromString:(NSString*)param error:&parseErr];
        if (!parseErr) {
            return rect;
        }
        [[MBMLFunctionError errorWithFormat:@"%@ encountered an error trying to convert value of class %@ (parameter %@) into a CGRect: %@", self, index, [param class], parseErr] reportErrorTo:errPtr];
    }
    else if ([param isKindOfClass:[NSValue class]]) {
        return [(NSValue*)param CGRectValue];
    }
    else {
        [[MBMLFunctionError errorWithFormat:@"%@ can't convert value of class %@ (parameter %@) into a CGRect", self, index, [param class]] reportErrorTo:errPtr];
    }
    return CGRectZero;
}

+ (CGSize) _validateParameterIsSize:(id)param
                              error:(MBMLFunctionError**)errPtr
{
    if ([param isKindOfClass:[NSString class]]) {
        NSError* parseErr = nil;
        CGSize size = [MBStringConversions sizeFromString:(NSString*)param error:&parseErr];
        if (!parseErr) {
            return size;
        }
        MBMLFunctionError* err = [MBMLFunctionError errorWithFormat:@"%@ encountered an error trying to convert value of class %@ into a CGSize: %@", self, [param class], parseErr];
        [err reportErrorTo:errPtr];
    }
    else if ([param isKindOfClass:[NSValue class]]) {
        return [(NSValue*)param CGSizeValue];
    }
    else {
        [[MBMLFunctionError errorWithFormat:@"%@ can't convert value of class %@ into a CGSize", self, [param class]] reportErrorTo:errPtr];
    }
    return CGSizeZero;
}

+ (CGPoint) _validateParameterIsPoint:(id)param
                                error:(MBMLFunctionError**)errPtr
{
    if ([param isKindOfClass:[NSString class]]) {
        NSError* parseErr = nil;
        CGPoint point = [MBStringConversions pointFromString:(NSString*)param error:&parseErr];
        if (!parseErr) {
            return point;
        }
        
        [[MBMLFunctionError errorWithFormat:@"%@ encountered an error trying to convert value of class %@ into a CGPoint: %@", self, [param class], parseErr] reportErrorTo:errPtr];
    }
    else if ([param isKindOfClass:[NSValue class]]) {
        return [(NSValue*)param CGPointValue];
    }
    else {
        [[MBMLFunctionError errorWithFormat:@"%@ can't convert value of class %@ into a CGPoint", self, [param class]] reportErrorTo:errPtr];
    }
    return CGPointZero;
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
    NSString* insetStr = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;

    NSError* parseErr = nil;
    UIEdgeInsets insets = [MBStringConversions edgeInsetsFromString:insetStr error:&parseErr];
    if (parseErr) {
        return [MBExpressionError errorWithError:parseErr];
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

+ (id) rectOrigin:(NSString*)param
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    CGRect rect = [self _validateParameterIsRect:param error:&err];
    if (err) return err;

    return [MBStringConversions stringFromPoint:rect.origin];
}

+ (id) rectSize:(NSString*)param
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    CGRect rect = [self _validateParameterIsRect:param error:&err];
    if (err) return err;

    return [MBStringConversions stringFromSize:rect.size];
}

+ (id) rectX:(NSString*)param
{
    debugTrace();

    MBMLFunctionError* err = nil;
    CGRect rect = [self _validateParameterIsRect:param error:&err];
    if (err) return err;

    return @(rect.origin.x);
}

+ (id) rectY:(NSString*)param
{
    debugTrace();

    MBMLFunctionError* err = nil;
    CGRect rect = [self _validateParameterIsRect:param error:&err];
    if (err) return err;

    return @(rect.origin.y);
}

+ (id) rectWidth:(NSString*)param
{
    debugTrace();

    MBMLFunctionError* err = nil;
    CGRect rect = [self _validateParameterIsRect:param error:&err];
    if (err) return err;

    return @(rect.size.width);
}

+ (id) rectHeight:(NSString*)param
{
    debugTrace();

    MBMLFunctionError* err = nil;
    CGRect rect = [self _validateParameterIsRect:param error:&err];
    if (err) return err;
    
    return @(rect.size.height);
}

/******************************************************************************/
#pragma mark Working with sizes
/******************************************************************************/

+ (id) sizeWidth:(NSString*)param
{
    debugTrace();

    MBMLFunctionError* err = nil;
    CGSize size = [self _validateParameterIsSize:param error:&err];
    if (err) return err;

    return @(size.width);
}

+ (id) sizeHeight:(NSString*)param
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    CGSize size = [self _validateParameterIsSize:param error:&err];
    if (err) return err;

    return @(size.height);
}

/******************************************************************************/
#pragma mark Working with points
/******************************************************************************/

+ (id) pointX:(NSString*)param
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    CGPoint pt = [self _validateParameterIsPoint:param error:&err];
    if (err) return err;

    return @(pt.x);
}

+ (id) pointY:(NSString*)param
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    CGPoint pt = [self _validateParameterIsPoint:param error:&err];
    if (err) return err;

    return @(pt.y);
}

@end
