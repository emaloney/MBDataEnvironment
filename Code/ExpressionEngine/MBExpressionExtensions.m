//
//  MBExpressionExtensions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/6/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBExpressionExtensions.h"
#import "MBMLVariableReferenceToken.h"

#define DEBUG_LOCAL             0

/******************************************************************************/
#pragma mark -
#pragma mark MBExpression NSString extensions
/******************************************************************************/

@implementation NSString (MBExpression)

- (id) evaluateAsObject
{
    debugTrace();
    
    return [MBExpression asObject:self];
}

- (NSString*) evaluateAsString
{
    debugTrace();
    
    return [MBExpression asString:self];
}

- (NSDecimalNumber*) evaluateAsNumber
{
    debugTrace();
    
    return [MBExpression asNumber:self];
}

- (BOOL) evaluateAsBoolean
{
    debugTrace();
    
    return [MBExpression asBoolean:self];
}

- (NSString*) asVariableExpression
{
    return [MBMLVariableReferenceToken expressionForReferencingVariableNamed:self];
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBExpression NSDictionary extensions
/******************************************************************************/

@implementation NSDictionary (MBExpression)

- (id) evaluateAsObject:(NSString*)key
{
    return [self evaluateAsObject:key defaultValue:nil];
}

- (id) evaluateAsObject:(NSString*)key defaultValue:(id)def
{
    debugTrace();
    
    if (key) {
        id val = self[key];
        if (val) {
            return [MBExpression asObject:[val description]
                             defaultValue:def];
        }
    }
    return def;
}

- (NSString*) evaluateAsString:(NSString*)key
{
    return [self evaluateAsString:key defaultValue:nil];
}

- (NSString*) evaluateAsString:(NSString*)key defaultValue:(NSString*)def
{
    debugTrace();
    
    if (key) {
        id val = self[key];
        if (val) {
            return [MBExpression asString:[val description]
                             defaultValue:def];
        }
    }
    return def;
}

- (NSNumber*) evaluateAsNumber:(NSString*)key
{
    return [self evaluateAsNumber:key defaultValue:nil];
}

- (NSNumber*) evaluateAsNumber:(NSString*)key defaultValue:(NSNumber*)def
{
    if (key) {
        id val = self[key];
        if (val) {
            id evaluated = [MBExpression asObject:[val description]
                                     defaultValue:def];
            
            return [MBExpression numberFromValue:evaluated];
        }
    }
    return def;
}

- (BOOL) evaluateAsBoolean:(NSString*)key
{
    return [self evaluateAsBoolean:key defaultValue:NO];
}

- (BOOL) evaluateAsBoolean:(NSString*)key defaultValue:(BOOL)def
{
    debugTrace();
    
    if (key) {
        id val = self[key];
        if (val) {
            return [MBExpression asBoolean:[val description]
                              defaultValue:def];
        }
    }
    return def;
}

@end
