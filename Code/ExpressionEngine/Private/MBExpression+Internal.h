//
//  MBExpression+Internal.h
//  Mockingbird Data Environment
//
//  Created by Evan Maloney on 1/15/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MBExpression.h"

@interface MBExpression (Private)

/*----------------------------------------------------------------------------*/
#pragma mark Mid-level token evaluation API
/*!    @name Mid-level token evaluation API                                   */
/*----------------------------------------------------------------------------*/

+ (id) objectFromTokens:(NSArray*)tokens error:(MBExpressionError**)errPtr;
+ (id) objectFromTokens:(NSArray*)tokens inVariableSpace:(MBVariableSpace*)space defaultValue:(id)def error:(MBExpressionError**)errPtr;

+ (NSString*) stringFromTokens:(NSArray*)tokens error:(MBExpressionError**)errPtr;
+ (NSString*) stringFromTokens:(NSArray*)tokens inVariableSpace:(MBVariableSpace*)space defaultValue:(NSString*)def error:(MBExpressionError**)errPtr;

+ (BOOL) booleanFromTokens:(NSArray*)tokens error:(MBExpressionError**)errPtr;
+ (BOOL) booleanFromTokens:(NSArray*)tokens inVariableSpace:(MBVariableSpace*)space defaultValue:(BOOL)def error:(MBExpressionError**)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Low-level token evaluation API
/*!    @name Low-level token evaluation API                                   */
/*----------------------------------------------------------------------------*/

+ (NSArray*) evaluateTokens:(NSArray*)tokens error:(MBExpressionError**)errPtr;
+ (NSArray*) evaluateTokens:(NSArray*)tokens inVariableSpace:(MBVariableSpace*)space error:(MBExpressionError**)errPtr;

@end
