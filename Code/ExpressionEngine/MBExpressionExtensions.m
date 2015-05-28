//
//  MBExpressionExtensions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/6/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBModuleLogMacros.h>

#import "MBExpressionExtensions.h"
#import "MBMLVariableReferenceToken.h"

#define DEBUG_LOCAL             0

/******************************************************************************/
#pragma mark -
#pragma mark MBExpression NSString extensions
/******************************************************************************/

@implementation NSString (MBExpression)

- (nullable id) evaluateAsObject
{
    MBLogDebugTrace();
    
    return [MBExpression asObject:self];
}

- (nullable NSString*) evaluateAsString
{
    MBLogDebugTrace();
    
    return [MBExpression asString:self];
}

- (nullable NSDecimalNumber*) evaluateAsNumber
{
    MBLogDebugTrace();
    
    return [MBExpression asNumber:self];
}

- (BOOL) evaluateAsBoolean
{
    MBLogDebugTrace();
    
    return [MBExpression asBoolean:self];
}

- (nonnull NSString*) asVariableExpression
{
    return [MBMLVariableReferenceToken expressionForReferencingVariableNamed:self];
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBExpression NSDictionary extensions
/******************************************************************************/

@implementation NSDictionary (MBExpression)

- (nullable id) evaluateAsObject:(nonnull NSString*)key
{
    return [self evaluateAsObject:key defaultValue:nil];
}

- (nullable id) evaluateAsObject:(nonnull NSString*)key defaultValue:(nullable id)def
{
    MBLogDebugTrace();
    
    if (key) {
        id val = self[key];
        if (val) {
            return [MBExpression asObject:[val description]
                             defaultValue:def];
        }
    }
    return def;
}

- (nullable NSString*) evaluateAsString:(nonnull NSString*)key
{
    return [self evaluateAsString:key defaultValue:nil];
}

- (nullable NSString*) evaluateAsString:(nonnull NSString*)key defaultValue:(nullable NSString*)def
{
    MBLogDebugTrace();
    
    if (key) {
        id val = self[key];
        if (val) {
            return [MBExpression asString:[val description]
                             defaultValue:def];
        }
    }
    return def;
}

- (nullable NSDecimalNumber*) evaluateAsNumber:(nonnull NSString*)key
{
    return [self evaluateAsNumber:key defaultValue:nil];
}

- (nullable NSDecimalNumber*) evaluateAsNumber:(nonnull NSString*)key defaultValue:(nullable NSDecimalNumber*)def
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

- (BOOL) evaluateAsBoolean:(nonnull NSString*)key
{
    return [self evaluateAsBoolean:key defaultValue:NO];
}

- (BOOL) evaluateAsBoolean:(nonnull NSString*)key defaultValue:(BOOL)def
{
    MBLogDebugTrace();
    
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
