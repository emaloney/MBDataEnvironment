//
//  MBExpression.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/25/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBExpressionExtensions.h"
#import "MBExpressionError.h"

@class MBExpressionGrammar;
@class MBVariableSpace;

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

extern NSString* const kMBMLBooleanStringTrue;   //!< "T", the string used to represent the boolean true/YES value in MBML
extern NSString* const kMBMLBooleanStringFalse;  //!< "F", the string used to represent the boolean false/NO value in MBML

/******************************************************************************/
#pragma mark -
#pragma mark MBExpression class
/******************************************************************************/

/*!
 This class is responsible for evaluating Mockingbird expressions.
 
 See the documentation for the Mockingbird Data Environment for information
 on how to construct valid expressions.
 */
@interface MBExpression : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Evaluating expressions as strings
/*!    @name Evaluating expressions as strings                                */
/*----------------------------------------------------------------------------*/

/*!
 Evaluates the given expression in the *string context*.
 
 @param     expr The expression to evaluate.
 
 @return    The result of evaluating the expression `expr` as a string.
 */
+ (NSString*) asString:(NSString*)expr;

/*!
 Evaluates the given expression in the *string context*.

 @param     expr The expression to evaluate.
 
 @param     errPtr An optional pointer to a memory location for storing an
            `MBExpressionError` instance. If this parameter is non-`nil`
            and an error occurs during evaluation, `*errPtr` will be updated
            to point to an `MBExpressionError` instance describing the error.

 @return    The result of evaluating the expression `expr` as a string.
 */
+ (NSString*) asString:(NSString*)expr error:(inout MBExpressionError**)errPtr;

/*!
 Evaluates the given expression in the *string context*.

 @param     expr The expression to evaluate.

 @param     def A default return value to use if the method would
            otherwise return `nil`.

 @return    The result of evaluating the expression `expr` as a string.
 */
+ (NSString*) asString:(NSString*)expr defaultValue:(NSString*)def;

/*!
 Evaluates the given expression in the *string context*.

 @param     expr The expression to evaluate.
 
 @param     space The `MBVariableSpace` instance to use for evaluating the
            expression. This allows the use of variable spaces other than
            the instance associated with the active `MBEnvironment`. Must not
            be `nil`.

 @param     def A default return value to use if the method would
            otherwise return `nil`.

 @param     errPtr An optional pointer to a memory location for storing an
            `MBExpressionError` instance. If this parameter is non-`nil`
            and an error occurs during evaluation, `*errPtr` will be updated
            to point to an `MBExpressionError` instance describing the error.

 @return    The result of evaluating the expression `expr` as a string.
 */
+ (NSString*) asString:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(NSString*)def error:(inout MBExpressionError**)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Evaluating expressions as objects with string interpolation
/*!    @name Evaluating expressions as objects with string interpolation      */
/*----------------------------------------------------------------------------*/

/*!
 Evaluates the given expression in the *object context*. String interpolation
 may be used if the expression references more than one value.

 If an expression contains a reference to only a single value (and does not
 also contain any text literals), the return value will be whatever `NSObject`
 instance is referenced by the expression.

 String interpolation only applies when an expression references more than one
 value, eg. "`Hello $firstName! I haven't seen you since $lastTime.`"

 With string interpolation, if an expression contains references to multiple
 discrete values or if it contains one or more text literals, those values are
 coerced into strings and concatenated before being returned as a single
 `NSString` instance.

 If you know you'll be using an object expression that will result in string
 interpolation being used, consider using the `asString:` method variants
 instead.

 You can also use one of the `asArray:` method variants to retrieve multiple
 values from within an expression without them being concatenated into a
 single string.

 @param     expr The expression to evaluate.

 @return    The result of evaluating the expression `expr` as an object.
 */
+ (id) asObject:(NSString*)expr;

/*!
 Evaluates the given expression in the *object context*. String interpolation
 may be used if the expression references more than one value.

 If an expression contains a reference to only a single value (and does not
 also contain any text literals), the return value will be whatever `NSObject`
 instance is referenced by the expression.

 String interpolation only applies when an expression references more than one
 value, eg. "`Hello $firstName! I haven't seen you since $lastTime.`"

 With string interpolation, if an expression contains references to multiple
 discrete values or if it contains one or more text literals, those values are
 coerced into strings and concatenated before being returned as a single
 `NSString` instance.
 
 If you know you'll be using an object expression that will result in string
 interpolation being used, consider using the `asString:` method variants
 instead.

 You can also use one of the `asArray:` method variants to retrieve multiple
 values from within an expression without them being concatenated into a
 single string.

 @param     expr The expression to evaluate.

 @param     errPtr An optional pointer to a memory location for storing an
            `MBExpressionError` instance. If this parameter is non-`nil`
            and an error occurs during evaluation, `*errPtr` will be updated
            to point to an `MBExpressionError` instance describing the error.

 @return    The result of evaluating the expression `expr` as an object.
 */
+ (id) asObject:(NSString*)expr error:(inout MBExpressionError**)errPtr;

/*!
 Evaluates the given expression in the *object context*. String interpolation
 may be used if the expression references more than one value.

 If an expression contains a reference to only a single value (and does not
 also contain any text literals), the return value will be whatever `NSObject`
 instance is referenced by the expression.

 String interpolation only applies when an expression references more than one
 value, eg. "`Hello $firstName! I haven't seen you since $lastTime.`"

 With string interpolation, if an expression contains references to multiple
 discrete values or if it contains one or more text literals, those values are
 coerced into strings and concatenated before being returned as a single
 `NSString` instance.

 If you know you'll be using an object expression that will result in string
 interpolation being used, consider using the `asString:` method variants
 instead.

 You can also use one of the `asArray:` method variants to retrieve multiple
 values from within an expression without them being concatenated into a
 single string.

 @param     expr The expression to evaluate.

 @param     def A default return value to use if the method would
            otherwise return `nil`.

 @return    The result of evaluating the expression `expr` as an object.
 */
+ (id) asObject:(NSString*)expr defaultValue:(id)def;

/*!
 Evaluates the given expression in the *object context*. String interpolation
 may be used if the expression references more than one value.

 If an expression contains a reference to only a single value (and does not
 also contain any text literals), the return value will be whatever `NSObject`
 instance is referenced by the expression.

 String interpolation only applies when an expression references more than one
 value, eg. "`Hello $firstName! I haven't seen you since $lastTime.`"

 With string interpolation, if an expression contains references to multiple
 discrete values or if it contains one or more text literals, those values are
 coerced into strings and concatenated before being returned as a single
 `NSString` instance.

 If you know you'll be using an object expression that will result in string
 interpolation being used, consider using the `asString:` method variants
 instead.

 You can also use one of the `asArray:` method variants to retrieve multiple
 values from within an expression without them being concatenated into a
 single string.

 @param     expr The expression to evaluate.
 
 @param     space The `MBVariableSpace` instance to use for evaluating the
            expression. This allows the use of variable spaces other than
            the instance associated with the active `MBEnvironment`. Must not
            be `nil`.

 @param     def A default return value to use if the method would
            otherwise return `nil`.

 @param     errPtr An optional pointer to a memory location for storing an
            `MBExpressionError` instance. If this parameter is non-`nil`
            and an error occurs during evaluation, `*errPtr` will be updated
            to point to an `MBExpressionError` instance describing the error.

 @return    The result of evaluating the expression `expr` as an object.
 */
+ (id) asObject:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(id)def error:(inout MBExpressionError**)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Evaluating expressions as objects without string interpolation
/*!    @name Evaluating expressions as objects without string interpolation   */
/*----------------------------------------------------------------------------*/

/*!
 Evaluates the given expression in the *object context* without using string
 interpolation. Discrete values within the expression are returned as items in
 an array.

 An expression may contain zero or more literal values and inner expressions;
 this method gathers any individual literals and inner expression values
 encountered while evaluating the passed-in expression, and returns an 
 `NSArray` containing the results.

 @param     expr The expression to evaluate.

 @return    The result of evaluating the expression `expr` as an array of
            objects.
 */
+ (NSArray*) asArray:(NSString*)expr;

/*!
 Evaluates the given expression in the *object context* without using string
 interpolation. Discrete values within the expression are returned as items in
 an array.

 An expression may contain zero or more literal values and inner expressions;
 this method gathers any individual literals and inner expression values
 encountered while evaluating the passed-in expression, and returns an
 `NSArray` containing the results.

 @param     expr The expression to evaluate.

 @param     errPtr An optional pointer to a memory location for storing an
            `MBExpressionError` instance. If this parameter is non-`nil`
            and an error occurs during evaluation, `*errPtr` will be updated
            to point to an `MBExpressionError` instance describing the error.

 @return    The result of evaluating the expression `expr` as an array of
            objects.
 */
+ (NSArray*) asArray:(NSString*)expr error:(inout MBExpressionError**)errPtr;

/*!
 Evaluates the given expression in the *object context* without using string
 interpolation. Discrete values within the expression are returned as items in
 an array.

 An expression may contain zero or more literal values and inner expressions;
 this method gathers any individual literals and inner expression values
 encountered while evaluating the passed-in expression, and returns an
 `NSArray` containing the results.

 @param     expr The expression to evaluate.
 
 @param     space The `MBVariableSpace` instance to use for evaluating the
            expression. This allows the use of variable spaces other than
            the instance associated with the active `MBEnvironment`. Must not
            be `nil`.

 @param     errPtr An optional pointer to a memory location for storing an
            `MBExpressionError` instance. If this parameter is non-`nil`
            and an error occurs during evaluation, `*errPtr` will be updated
            to point to an `MBExpressionError` instance describing the error.

 @return    The result of evaluating the expression `expr` as an array of
            objects.
 */
+ (NSArray*) asArray:(NSString*)expr inVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Evaluating expressions as numeric values
/*!    @name Evaluating expressions as numeric values                         */
/*----------------------------------------------------------------------------*/

/*!
 Evaluates the given expression in the *numeric context*, coercing the result
 into a number if necessary (and possible).
 
 Mathematical expressions may be used in the numeric context.

 @param     expr The expression to evaluate.

 @return    The result of evaluating the expression `expr` as a numeric
            expression.
 */
+ (NSDecimalNumber*) asNumber:(NSString*)expr;

/*!
 Evaluates the given expression in the *numeric context*, coercing the result
 into a number if necessary (and possible).
 
 Mathematical expressions may be used in the numeric context.

 @param     expr The expression to evaluate.
 
 @param     errPtr An optional pointer to a memory location for storing an
            `MBExpressionError` instance. If this parameter is non-`nil`
            and an error occurs during evaluation, `*errPtr` will be updated
            to point to an `MBExpressionError` instance describing the error.

 @return    The result of evaluating the expression `expr` as a numeric
            expression.
 */
+ (NSDecimalNumber*) asNumber:(NSString*)expr error:(inout MBExpressionError**)errPtr;

/*!
 Evaluates the given expression in the *numeric context*, coercing the result
 into a number if necessary (and possible).

 Mathematical expressions may be used in the numeric context.

 @param     expr The expression to evaluate.
 
 @param     def A default return value to use if the method would
            otherwise return `nil`.

 @return    The result of evaluating the expression `expr` as a numeric
            expression.
 */
+ (NSDecimalNumber*) asNumber:(NSString*)expr defaultValue:(NSDecimalNumber*)def;

/*!
 Evaluates the given expression in the *numeric context*, coercing the result
 into a number if necessary (and possible).

 Mathematical expressions may be used in the numeric context.

 @param     expr The expression to evaluate.
 
 @param     space The `MBVariableSpace` instance to use for evaluating the
            expression. This allows the use of variable spaces other than
            the instance associated with the active `MBEnvironment`. Must not
            be `nil`.

 @param     def A default return value to use if the method would
            otherwise return `nil`.

 @param     errPtr An optional pointer to a memory location for storing an
            `MBExpressionError` instance. If this parameter is non-`nil`
            and an error occurs during evaluation, `*errPtr` will be updated
            to point to an `MBExpressionError` instance describing the error.

 @return    The result of evaluating the expression `expr` as a numeric
            expression.
 */
+ (NSDecimalNumber*) asNumber:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(NSDecimalNumber*)def error:(inout MBExpressionError**)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Evaluating expressions as boolean values
/*!    @name Evaluating expressions as boolean values                         */
/*----------------------------------------------------------------------------*/

/*!
 Evaluates the given expression in the *boolean context*.

 @param     expr The expression to evaluate.

 @return    The result of evaluating the expression `expr` as a boolean 
            expression.
 */
+ (BOOL) asBoolean:(NSString*)expr;

/*!
 Evaluates the given expression in the *boolean context*.

 @param     expr The expression to evaluate.
 
 @param     errPtr An optional pointer to a memory location for storing an
            `MBExpressionError` instance. If this parameter is non-`nil`
            and an error occurs during evaluation, `*errPtr` will be updated
            to point to an `MBExpressionError` instance describing the error.

 @return    The result of evaluating the expression `expr` as a boolean 
            expression.
 */
+ (BOOL) asBoolean:(NSString*)expr error:(inout MBExpressionError**)errPtr;

/*!
 Evaluates the given expression in the *boolean context*.

 @param     expr The expression to evaluate.

 @param     def A default return value to use if there was a problem evaluating
            `expr`.

 @return    The result of evaluating the expression `expr` as a boolean 
            expression.
 */
+ (BOOL) asBoolean:(NSString*)expr defaultValue:(BOOL)def;

/*!
 Evaluates the given expression in the *boolean context*.

 @param     expr The expression to evaluate.
 
 @param     space The `MBVariableSpace` instance to use for evaluating the
            expression. This allows the use of variable spaces other than
            the instance associated with the active `MBEnvironment`. Must not
            be `nil`.

 @param     def A default return value to use if there was a problem evaluating
            `expr`.

 @param     errPtr An optional pointer to a memory location for storing an
            `MBExpressionError` instance. If this parameter is non-`nil`
            and an error occurs during evaluation, `*errPtr` will be updated
            to point to an `MBExpressionError` instance describing the error.

 @return    The result of evaluating the expression `expr` as a boolean 
            expression.
 */
+ (BOOL) asBoolean:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(BOOL)def error:(inout MBExpressionError**)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Value type coercion
/*!    @name Value type coercion                                              */
/*----------------------------------------------------------------------------*/

/*!
 Exposes the mechanism the expression evaluator uses for coercing arbitrary
 object values into booleans.
 
 @param     val The object to interpret as a boolean
 
 @return    The boolean representation of `val`
 */
+ (BOOL) booleanFromValue:(id)val;

/*!
 Exposes the mechanism the expression evaluator uses for representing boolean
 values as strings.

 @param     val The boolean value
 
 @return    The string representation of `val`; either `kMBMLBooleanStringTrue`
            or `kMBMLBooleanStringFalse`.
 */
+ (NSString*) stringFromBoolean:(BOOL)val;

/*!
 Exposes the mechanism the expression evaluator uses for coercing arbitrary
 object values into numbers.
 
 @param     val The object to interpret as a number
 
 @return    If `val` can be interpreted as a number, the return value is an
            `NSDecimalNumber` containing that number. If `val` cannot be 
            interpreted as a number, or if the resulting number is equal to
            `[`<code>NSNumber notANumber</code>`]`, `nil` will be returned.
 */
+ (NSDecimalNumber*) numberFromValue:(id)val;

/*----------------------------------------------------------------------------*/
#pragma mark Comparing values
/*!    @name Comparing values                                                 */
/*----------------------------------------------------------------------------*/

/*!
 Exposes the mechanism the expression evaluator uses for determining if two
 objects have equal values.
 
 @param     lValue The left value of the comparison
 
 @param     rValue The right value of the comparison

 @return    The return value of `[`<code>lValue isEqual:rValue</code>`]` if
            `lValue` and `rValue` are of the same type. Otherwise, falls back on
            `[MBExpression compareLeftValue:lValue againstRightValue:rValue]`.
 */
+ (BOOL) value:(id)lValue isEqualTo:(id)rValue;

/*!
 Exposes the mechanism the expression evaluator uses to determine the relative
 order of two object values.
 
 @param     lValue The left value of the comparison
 
 @param     rValue The right value of the comparison
 
 @return    `NSOrderedAscending` if `lValue` is less than `rValue`;
            `NSOrderedDescending` if `lValue` is greater than `rValue`;
            `NSOrderedSame` if `lValue` is equal to `rValue`.
 */
+ (NSComparisonResult) compareLeftValue:(id)lValue againstRightValue:(id)rValue;

@end
