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
 
 Mockingbird expressions are strings that can contain:
 
 - string literals
 - numeric literals
 - references to variables, which can be of any Objective-C type
 - simple mathematical expressions
 - logical

 are string-based expressions that, when evaluated, can
 result in one of the following types:
 
 - arbitrary Objective-C objects (via the `asObject:` method variants)
 - strings (via the `asString:` method variants)
 - numbers (via the `asNumber:` method variants)
 - boolean values (via the `asBoolean:` method variants), and
 - arrays of Objective-C objects (via the `asArray:` method variants)
 
 One use of a Mockingbird expression might be to perform string replacement 
 when populating user interface views, such as `UILabel`s.
 
 For example:
 
    UILabel* greeting = // created elsewhere
    greeting.text = [MBExpression asString:@"Hello, $userName!"];

 In the code above, the `text` property of the `greeting` label will be set
 to the result of the expression "`Hello, $userName!`".

 This particular expression consists of three parts: a string literal 
 ("`Hello, `") followed by a reference to a Mockingbird variable called 
 `userName`, followed by another string literal ("`!`").

 When the expression is evaluated, the "`$userName`" portion of the expression
 is replaced by the value of the `userName` *variable*.
 
 If the value of `userName` is "`Cooper`", then the label would display the
 text "`Hello, Cooper!`".
 
 Notice that the portions of the expression that consist of literals are not
 evaluated; they are included in the result in the same form that they
 appear in the original expression.

 ### MBML Functions
 
 In addition to referencing variables, expressions can also cause native
 Objective-C code to be executed.
 
 For example:
 
    UILabel* time = // created elsewhere
    time.text = [MBExpression asString:@"The time now is ^currentTime()"];

 In the expression shown above, the `text` property of the `time` label
 is set using a string literal and the value yielded by the *MBML function* 
 called `^currentTime()`.

 When placed onscreen, such a label might look like:
 
    The time now is 2015-01-26 21:45:40 +0000

 Many functions take one or more parameters; when multiple parameters are
 passed to a function, the pipe character ("`|`") is used as the parameter
 separator.
 
 Parameters may consist of literals, variable references, or other function
 calls. For example, if the label's `text` were set using the expression:
 
    The time now is ^formatMediumDateTime(^currentTime())

 The label's content might look like:

    The time now is Jan 26, 2015, 4:45:40 PM

 (The exact output of the example above depends on the user's locale settings
 and, of course, the actual date and time.)
 
 For more information on MBML functions, see the documentation for the
 `MBMLFunction` class.
 
 **MBML Identifiers**
 
 When parsing a string of text, the expression evaluator looks for certain
 text patterns to identify variable references and function calls.
 
 MBML identifiers are names that begin with either an alphabetical character 
 or an underscore ("`_`"), followed by zero or more characters that may also
 include digits and colons. Alphabetical identifier characters may be either
 uppercase or lowercase. Identifiers may contain a mix of cases.
 
 Variable references always start with a dollar sign ("`$`") and must
 include an MBML variable name. Usually—but not always—MBML variable
 names adhere to the MBML identifier format. (The quoting mechanisms listed
 below allow access to variables whose names don't adhere to the MBML
 identifier format.)
 
 Function calls always start with a caret ("`^`"), followed by an MBML
 identifier, followed by an open parenthesis ("`(`"), a list of zero or more
 parameters separated by the pipe character ("`|`"), followed by a close
 parenthesis ("`)`").
 
 **Escaping Special Characters**
 
 Within an expression, you may sometimes want to use characters within a
 string literal that would otherwise be interpreted as part of an expression.
 
 The following escape sequences can be used:
 
 - `$$` — Yields a single dollar sign
 - `^^` — Yields a single caret
 - `##` — Yields a single hash mark (aka pound sign)
 - `\n` — Yields a newline
 
 **Variable Reference Syntax**

 MBML variable names can be arbitrary strings, although using the simplest 
 variable reference notation requires the variable name to be a valid
 MBML identifier.
 
 Variable references may also contain _subreferences_. A subreference is
 a reference to a value within a container object. Typical containers include
 arrays and dictionaries, but subreferences can also be used to access 
 properties of any Objective-C object through key value coding.
 
 For example, if an MBML variable exists called `daysOfWeek`, and that
 variable is an array containing the names of the days of the week starting
 with Monday, the following expression would yield the value "Wednesday":
 
    $daysOfWeek[2]
 
 Similarly, if an MBML variable exists called `monthNamesToNumbers`, and that
 variable is a dictionary containing a mapping of month names to the 
 corresponding number of the month, the following expression would result
 in the number `10`:
 
    $monthNamesToNumbers[October]
 
 Lastly, any Objective-C property value can be accessed using the dot
 notation:
 
    $userName.length
 
 would result in the length of the string contained in the MBML variable
 `userName`.
 
 Bracket subreferences can be used for accessing values within an array or
 dictionary. Dot subreferences can be used to access values stored within a
 dictionary or made available through Objective-C properties and key value
 coding.
 
 **Variable Reference Quoting**
 
 The `$userName` variable reference shown above is an example of the most basic
 notation, called the _unquoted variable notation_, wherein `userName` is
 an MBML identifier.
 
 Alternate _quoted_ forms of variable references make use of delimiters 
 surrounding the variable name to provide different behavior. There are three
 quoted variable notations:
 
 - _curly-brace quoted_, which prevents characters after the closing curly 
 brace from being interpreted as part of the variable reference
 
 - _bracket quoted_, which allows the use of variable names that aren't
 valid MBML identifiers
 
 - _parentheses quoted_, which is similar to bracket-quoted in that it allows
 the use of variable names that aren't valid MBML identifiers, but that like
 the curly-brace quoted notation, prevents characters after the closing
 delimiter from being interpreted as part of the variable reference
 
 **Curly-Brace Quoted Variable References**
 
 The expressions `$userName` and `${userName}` are equivalent, but they can
 behave differently if embedded within string literals.
 
 Let's say you have an MBML variable called `lastName` that contained a person's
 surname, and you want to construct a message such as "How are the Maloneys
 doing?" that refers to the surname in the plural form.

 You couldn't use the unquoted notation (eg., "`How are the $lastNames doing?`")
 because the "`s`" at the end of `$lastName` would be interpreted as part of
 the variable name. Instead of referencing the variable `lastName` followed by
 the text character "`s`", you're actually referencing an entirely different 
 variable called `lastNames`, which is not what you want.
 
 Using the curly-brace notation allows you to separate the variable reference
 from any surrounding text that you want to remain a literal string. So, the
 expression:
 
    How are the ${lastName}s doing?
 
 is interpreted as the text literal "`How are the `" followed by a reference
 to the MBML variable `lastName`, followed by another text literal,
 "`s doing?`".
 
 Note that the variable name contained within the curly-brace quoted notation
 must be a valid MBML identifier.
 
 **Bracket Quoted Variable References**
 
 Bracket quoted variable references allow you to access MBML variables whose
 names are not valid MBML identifiers.
 
 For example, spaces are not valid MBML identifier characters. When the
 expression evaluator encounters a space while interpreting a variable name,
 it assumes that the space signals the end of the variable name.
 
 But because MBML variables can be set programmatically within Objective-C or 
 can be introduced by external backend systems that don't conform to MBML
 variable naming syntax, the bracket quoted notation provides a mechanism for
 accessing these variables.
 
 When evaluated, the expression:
 
    $[total$]

 would yield the current value of an MBML variable named `total$`.
 
 Using the bracket notation allows subreferences after the closing bracket.
 Assuming the MBML variable `total$` is a string, the following expression
 would yield the length of the string:
 
    $[total$].length
 
 **Parentheses Quoted Variable References**

 As with bracket quoted references, parentheses quoted references allow
 access to MBML variables whose names are not valid MBML identifiers. And 
 like curly-brace quoted references, parentheses quoted references allow
 variable references to be embedded within text literals that would otherwise
 be interpreted as part of the variable reference.
 
 For example, consider these two expressions:
 
    $[total$].length
    $(total$).length
 
 The top expression uses the bracket quoted notation, which allows 
 subreferences after the closing bracket. The bottom expression uses
 the parentheses quoted notation, which does not allow subreferences.
 
 Because subreferences are not allowed by the parentheses notation, any
 text that appears after the closing parenthesis will be considered the
 start of a new statement. In this case, since "`.length`" is not a valid
 variable reference, function call, or math expression, it is interpreted
 as a text literal by the expression evaluator.
 
 So while `$[total$].length` will return the length of the MBML
 variable called `total$`, `$(total$).length` will return
 the value of the MBML variable `total$` followed by the string
 literal "`.length`".
 
 **Math Notation**
 
 MBML allows a simple math expressions. The addition ("`+`"), subtraction
 ("`-`"), multiplication ("`*`") and division ("`/`") operators are supported.
 In addition, the MBML math notation allows parenthetical grouping within
 expressions. Unless parentheses are used to change the order of evaluation
 of math operators, C language operator precedence is used.
 
 Math expressions can be embedded in a string or object evaluation context
 by placing the expression within `#(` ... `)`. In a numeric context, the
 opening `#(` and closing `)` can be omitted.
 
 For example, suppose the MBML variable `states` is an array containing the
 name of each state in the United States. The label:
 
    <Label text="There are #($states.count * 2) U.S. Senators" ... />

 would output "There are 100 U.S. Senators".
 
 **Important:** Within math expressions, operators **must** be surrounded by
 whitespace.
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
+ (NSString*) asString:(NSString*)expr error:(out MBExpressionError**)errPtr;

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
+ (NSString*) asString:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(NSString*)def error:(out MBExpressionError**)errPtr;

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
+ (id) asObject:(NSString*)expr error:(out MBExpressionError**)errPtr;

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
+ (id) asObject:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(id)def error:(out MBExpressionError**)errPtr;

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
+ (NSArray*) asArray:(NSString*)expr error:(out MBExpressionError**)errPtr;

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
+ (NSArray*) asArray:(NSString*)expr inVariableSpace:(MBVariableSpace*)space error:(out MBExpressionError**)errPtr;

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
+ (NSDecimalNumber*) asNumber:(NSString*)expr error:(out MBExpressionError**)errPtr;

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
+ (NSDecimalNumber*) asNumber:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(NSDecimalNumber*)def error:(out MBExpressionError**)errPtr;

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
+ (BOOL) asBoolean:(NSString*)expr error:(out MBExpressionError**)errPtr;

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
+ (BOOL) asBoolean:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(BOOL)def error:(out MBExpressionError**)errPtr;

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
