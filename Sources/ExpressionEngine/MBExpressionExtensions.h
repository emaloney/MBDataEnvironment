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

/*!
 This `NSString` class category adds methods for evaluating expressions
 directly from `NSString` instances.
 */
@interface NSString (MBExpression)

/*!
 Evaluates the receiver as an expression returning an object.
 
 Equivalent to calling `[MBExpression asObject:]` with the receiver as the 
 parameter.
 
 @return        The result of evaluating the receiver as an object expression.
 */
- (nullable id) evaluateAsObject;

/*!
 Evaluates the receiver as an expression returning a string.

 Equivalent to calling `[MBExpression asString:]` with the receiver as the
 parameter.

 @return        The result of evaluating the receiver as a string expression.
 */
- (nullable NSString*) evaluateAsString;

/*!
 Evaluates the receiver as an expression returning a numeric value.

 Equivalent to calling `[MBExpression asNumber:]` with the receiver as the
 parameter.

 @return        The result of evaluating the receiver as a numeric expression.
 */
- (nullable NSDecimalNumber*) evaluateAsNumber;

/*!
 Evaluates the receiver as an expression returning a boolean value.

 Equivalent to calling `[MBExpression asBoolean:]` with the receiver as the
 parameter.

 @return        The result of evaluating the receiver as a boolean expression.
 */
- (BOOL) evaluateAsBoolean;

/*!
 Returns an expression usable for referencing the MBML variable whose
 name is contained in the receiver.
 
 If the receiver contains the text "`user`", this method will return the
 value "`$user`".
 
 More complicated variable names will be returned in the correct form. For
 example, if the receiver contains the text "`total$`", this method will 
 return "`$[total$]`".

 @return        A Mockingbird expression usable for referencing the variable 
                named by the receiver.
 */
- (nonnull NSString*) asVariableExpression;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBExpression NSDictionary extensions
/******************************************************************************/

/*!
 This `NSDictionary` class category adds method for evaluating expressions
 using values contained in an `NSDictionary`.
 */
@interface NSDictionary (MBExpression)

/*!
 Takes the value associated with the receiver's `key` and attempts to
 evaluate that value as an object expression.
 
 If the value associated with `key` is not an `NSString`, the value's 
 `description` method will be invoked to convert it into a string before it is
 evaluated as an expression.

 Equivalent to passing the value associated with `key` as the parameter to
 the `[MBExpression asObject:]` method.

 @param     key The key in the receiving dictionary whose associated
            value should be evaluated as an expression.
 
 @return    The result of evaluating the value associated with `key` as
            an expression.
 */
- (nullable id) evaluateAsObject:(nonnull NSString*)key;

/*!
 Takes the value associated with the receiver's `key` and attempts to
 evaluate that value as an object expression.
 
 If the value associated with `key` is not an `NSString`, the value's 
 `description` method will be invoked to convert it into a string before it is
 evaluated as an expression.

 Equivalent to passing the value associated with `key` as the parameter to
 the `[MBExpression asObject:defaultValue:]` method.

 @param     key The key in the receiving dictionary whose associated
            value should be evaluated as an expression.
 
 @param     def A default value to be returned if expression evaluation would
            otherwise return `nil`.
 
 @return    The result of evaluating the value associated with `key` as 
            an expression, or `def` if `nil` would otherwise be returned.
 */
- (nullable id) evaluateAsObject:(nonnull NSString*)key defaultValue:(nullable id)def;

/*!
 Takes the value associated with the receiver's `key` and attempts to
 evaluate that value as a string expression.
 
 If the value associated with `key` is not an `NSString`, the value's 
 `description` method will be invoked to convert it into a string before it is
 evaluated as an expression.

 Equivalent to passing the value associated with `key` as the parameter to
 the `[MBExpression asString:]` method.

 @param     key The key in the receiving dictionary whose associated
            value should be evaluated as an expression.
 
 @return    The result of evaluating the value associated with `key` as
            an expression.
 */
- (nullable NSString*) evaluateAsString:(nonnull NSString*)key;

/*!
 Takes the value associated with the receiver's `key` and attempts to
 evaluate that value as a string expression.
 
 If the value associated with `key` is not an `NSString`, the value's 
 `description` method will be invoked to convert it into a string before it is
 evaluated as an expression.

 Equivalent to passing the value associated with `key` as the parameter to
 the `[MBExpression asString:defaultValue:]` method.

 @param     key The key in the receiving dictionary whose associated
            value should be evaluated as an expression.
 
 @param     def A default value to be returned if expression evaluation would
            otherwise return `nil`.
 
 @return    The result of evaluating the value associated with `key` as 
            an expression, or `def` if `nil` would otherwise be returned.
 */
- (nullable NSString*) evaluateAsString:(nonnull NSString*)key defaultValue:(nullable NSString*)def;

/*!
 Takes the value associated with the receiver's `key` and attempts to
 evaluate that value as a numeric expression.
 
 If the value associated with `key` is not an `NSString`, the value's 
 `description` method will be invoked to convert it into a string before it is
 evaluated as an expression.

 Equivalent to passing the value associated with `key` as the parameter to
 the `[MBExpression asNumber:]` method.

 @param     key The key in the receiving dictionary whose associated
            value should be evaluated as an expression.
 
 @return    The result of evaluating the value associated with `key` as
            an expression.
 */
- (nullable NSDecimalNumber*) evaluateAsNumber:(nonnull NSString*)key;

/*!
 Takes the value associated with the receiver's `key` and attempts to
 evaluate that value as a numeric expression.
 
 If the value associated with `key` is not an `NSString`, the value's 
 `description` method will be invoked to convert it into a string before it is
 evaluated as an expression.

 Equivalent to passing the value associated with `key` as the parameter to
 the `[MBExpression asNumber:defaultValue:]` method.

 @param     key The key in the receiving dictionary whose associated
            value should be evaluated as an expression.
 
 @param     def A default value to be returned if expression evaluation would
            otherwise return `nil`.
 
 @return    The result of evaluating the value associated with `key` as 
            an expression, or `def` if `nil` would otherwise be returned.
 */
- (nullable NSDecimalNumber*) evaluateAsNumber:(nonnull NSString*)key defaultValue:(nullable NSDecimalNumber*)def;

/*!
 Takes the value associated with the receiver's `key` and attempts to
 evaluate that value as a boolean expression.
 
 If the value associated with `key` is not an `NSString`, the value's 
 `description` method will be invoked to convert it into a string before it is
 evaluated as an expression.

 Equivalent to passing the value associated with `key` as the parameter to
 the `[MBExpression asBoolean:]` method.

 @param     key The key in the receiving dictionary whose associated
            value should be evaluated as an expression.
 
 @return    The result of evaluating the value associated with `key` as
            an expression.
 */
- (BOOL) evaluateAsBoolean:(nonnull NSString*)key;

/*!
 Takes the value associated with the receiver's `key` and attempts to
 evaluate that value as a boolean expression.
 
 If the value associated with `key` is not an `NSString`, the value's 
 `description` method will be invoked to convert it into a string before it is
 evaluated as an expression.

 Equivalent to passing the value associated with `key` as the parameter to
 the `[MBExpression asBoolean:defaultValue:]` method.

 @param     key The key in the receiving dictionary whose associated
            value should be evaluated as an expression.
 
 @param     def A default value to be returned if expression evaluation would
            otherwise return `nil`.
 
 @return    The result of evaluating the value associated with `key` as 
            an expression, or `def` if `nil` would otherwise be returned.
 */
- (BOOL) evaluateAsBoolean:(nonnull NSString*)key defaultValue:(BOOL)def;

@end
