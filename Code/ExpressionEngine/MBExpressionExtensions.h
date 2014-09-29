//
//  MBExpressionExtensions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/6/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBExpression.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBExpression NSString extensions
/******************************************************************************/

@interface NSString (MBExpression)

/*!
 Evaluates the receiver as an expression returning an object.
 
 Equivalent to calling `[MBExpression asObject:]` with the receiver as the 
 parameter.
 
 @return        The result of evaluating the receiver as an object expression.
 */
- (id) evaluateAsObject;

/*! Evaluates the receiver as an expression returning a string. */


/*!
 Evaluates the receiver as an expression returning a string.

 Equivalent to calling `[MBExpression asString:]` with the receiver as the
 parameter.

 @return        The result of evaluating the receiver as a string expression.
 */
- (NSString*) evaluateAsString;

/*! Evaluates the receiver as an expression returning a numeric value. */

/*!
 Evaluates the receiver as an expression returning a number.

 Equivalent to calling `[MBExpression asNumber:]` with the receiver as the
 parameter.

 @return        The result of evaluating the receiver as a numeric expression.
 */
- (NSDecimalNumber*) evaluateAsNumber;

/*!
 Evaluates the receiver as an expression returning a boolean value.

 Equivalent to calling `[MBExpression asBoolean:]` with the receiver as the
 parameter.

 @return        The result of evaluating the receiver as a boolean expression.
 */
- (BOOL) evaluateAsBoolean;

/*!
 Returns a string expression usable for referencing the MBML variable whose
 name is contained in the receiver.
 
 @return        An expression referencing the variable named by the receiver.
 */
- (NSString*) asVariableExpression;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBExpression NSDictionary extensions
/******************************************************************************/

@interface NSDictionary (MBExpression)

// takes the dictionary's value for the given key and use the
// MBExpression to evaluate it as an object expression
- (id) evaluateAsObject:(NSString*)key;
- (id) evaluateAsObject:(NSString*)key defaultValue:(id)def;

// takes the dictionary's value for the given key and use the
// MBExpression to evaluate it as a string expression
- (NSString*) evaluateAsString:(NSString*)key;
- (NSString*) evaluateAsString:(NSString*)key defaultValue:(NSString*)def;

// takes the dictionary's value for the given key and use the
// MBExpression to evaluate it as a numeric expression
- (NSDecimalNumber*) evaluateAsNumber:(NSString*)key;
- (NSDecimalNumber*) evaluateAsNumber:(NSString*)key defaultValue:(NSDecimalNumber*)def;

// takes the dictionary's value for the given key and use the
// MBExpression to evaluate it as a boolean expression
- (BOOL) evaluateAsBoolean:(NSString*)key;
- (BOOL) evaluateAsBoolean:(NSString*)key defaultValue:(BOOL)def;

@end
