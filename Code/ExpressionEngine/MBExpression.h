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
 This class is responsible for evaluating MBML expressions.
 
 MBML expressions are string-based expressions that, when evaluated, can result
 in one of the following types:
 
 - arbitrary Objective-C objects (via the `asObject:` method variants),
 - strings (via the `asString:` method variants),
 - numbers (via the `asNumber:` method variants),
 - boolean values (via the `asBoolean:` method variants), and
 - arrays (via the `asArray:` method variants).
 
 Although this class provides an Objective-C interface for evaluating MBML
 expressions, typically, expressions are used to perform string replacement
 within attributes of MBML tags. For example, in this tag:
 
    <Label text="Hello, $userName" ... />
 
 the `text` attribute contains an MBML expression. This particular expression 
 consists of two parts: a string literal ("`Hello, `") followed by a reference
 to an MBML variable called `userName`.
  
 When this label is displayed onscreen, the `text` attribute is evaluated as
 an MBML expression, and the text "`$userName`" is replaced by the value of
 the `userName` MBML variable. If the value of `userName` is "Cooper", then the
 label would display the text "Hello, Cooper".
 
 **MBML Expression Evaluation Contexts**
 
 Depending on where an expression appears within MBML, it may be evaluated in a
 different context. The context determines how the expression is evaluated and
 what type of value will be returned.
 
 There are three evaluation contexts supported:
 
 - _object context_ — An Objective-C object is returned as a result of
 evaluating the expression. For expressions that occur within MBML
 attributes that end up displayed onscreen, objects are converted to strings
 prior to display.
 
 - _boolean context_ — A boolean value is returned as the result of evaluating
 the expression.
 
 - _numeric context_ — An `NSNumber` is returned as a result of evaluating the
 expression.
 
 Most expression evaluations occur within the object context. However,
 expressions found within the MBML `if=""` attribute are evaluated in a
 boolean context.
 
 **MBML Functions**
 
 In addition to referencing variables, MBML expressions can also cause native
 Objective-C code to be executed. (See the class `MBMLFunction` for more
 information.) A variety of MBML functions ship with Mockingbird, which can be
 embedded within expressions. In this example:

    <Label text="The time now is ^currentTime()" ... />

 the text "`The time now is `" is a string literal, and "`^currentTime()`"
 is a call to an MBML function. When this expression is evaluated, the
 MBML function named `currentTime` is executed, and the text
 "`^currentTime()`" is replaced with the result of calling that function.
 
 When placed onscreen, such a label might look like:
 
    The time now is 2013-07-22 19:26:54 +0000
 
 Many functions take one or more parameters; when multiple parameters are
 passed to a function, the pipe character ("`|`") is used as the parameter
 separator.
 
 Parameters may consist of literals, variable references, or other function
 calls. For example, the label:
 
    <Label text="The time now is ^formatMediumDateTime(^currentTime())" ... />

 would display:
 
    The time now is Jul 22, 2013, 3:26:54 PM
 
 (The exact output of the example above depends on the user's locale settings
 and, of course, the actual date and time.)
 
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
 
    $[total $]
 
 would yield the current value of an MBML variable named `total $`.
 
 Using the bracket notation allows subreferences after the closing bracket.
 Assuming the MBML variable `total $` is a string, the following expression
 would yield the length of the string:
 
    $[total $].length
 
 **Parentheses Quoted Variable References**

 As with bracket quoted references, parentheses quoted references allow
 access to MBML variables whose names are not valid MBML identifiers. And 
 like curly-brace quoted references, parentheses quoted references allow
 variable references to be embedded within text literals that would otherwise
 be interpreted as part of the variable reference.
 
 For example, consider these two expressions:
 
    $[favorite color].length
    $(favorite color).length
 
 The top expression uses the bracket quoted notation, which allows 
 subreferences after the closing bracket. The bottom expression uses
 the parentheses quoted notation, which does not allow subreferences.
 
 Because subreferences are not allowed by the parentheses notation, any
 text that appears after the closing parenthesis will be considered the
 start of a new statement. In this case, since "`.length`" is not a valid
 variable reference, function call, or math expression, it is interpreted
 as a text literal by the expression evaluator.
 
 So while `$[favorite color].length` will return the length of the MBML
 variable called `favorite color`, `$(favorite color).length` will return
 the value of the MBML variable `favorite color` followed by the string
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

/*******************************************************************************
 @name Evaluating expressions as strings
 ******************************************************************************/

// returns an NSString by expanding the references in the expression
+ (NSString*) asString:(NSString*)expr;
+ (NSString*) asString:(NSString*)expr error:(MBExpressionError**)errPtr;
+ (NSString*) asString:(NSString*)expr defaultValue:(NSString*)def;
+ (NSString*) asString:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(NSString*)def error:(MBExpressionError**)errPtr;

/*******************************************************************************
 @name Evaluating expressions as objects
 ******************************************************************************/

// if the expression refers to a single object, it is returned; if the
// expression refers to multiple objects, the objects are converted to
// strings and concatenated, and the resulting string is returned
+ (id) asObject:(NSString*)expr;
+ (id) asObject:(NSString*)expr error:(MBExpressionError**)errPtr;
+ (id) asObject:(NSString*)expr defaultValue:(id)def;
+ (id) asObject:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(id)def error:(MBExpressionError**)errPtr;

/*******************************************************************************
 @name Evaluating expressions as numeric values
 ******************************************************************************/

// returns an NSDecimalNumber by expanding the references in the expression and
// attempting to interpret the result as a number
+ (NSDecimalNumber*) asNumber:(NSString*)expr;
+ (NSDecimalNumber*) asNumber:(NSString*)expr error:(MBExpressionError**)errPtr;
+ (NSDecimalNumber*) asNumber:(NSString*)expr defaultValue:(NSDecimalNumber*)def;
+ (NSDecimalNumber*) asNumber:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(NSDecimalNumber*)def error:(MBExpressionError**)errPtr;

/*******************************************************************************
 @name Evaluating expressions as boolean values
 ******************************************************************************/

// interprets the expression in a boolean context and returns the result
+ (BOOL) asBoolean:(NSString*)expr;
+ (BOOL) asBoolean:(NSString*)expr error:(MBExpressionError**)errPtr;
+ (BOOL) asBoolean:(NSString*)expr defaultValue:(BOOL)def;
+ (BOOL) asBoolean:(NSString*)expr inVariableSpace:(MBVariableSpace*)space defaultValue:(BOOL)def error:(MBExpressionError**)errPtr;

/*******************************************************************************
 @name Evaluating expressions as arrays
 ******************************************************************************/

// returns an array containing the objects referred to by an expression. similar
// to asObject:, except that each distinct variable references and
// literal expression is represented as a separate item in the returned array 
+ (NSArray*) asArray:(NSString*)expr;
+ (NSArray*) asArray:(NSString*)expr error:(MBExpressionError**)errPtr;
+ (NSArray*) asArray:(NSString*)expr inVariableSpace:(MBVariableSpace*)space error:(MBExpressionError**)errPtr;

/*******************************************************************************
 @name Coercing and comparing values
 ******************************************************************************/

/*!
 Exposes the mechanism the expression evaluator engine uses for
 converting arbitrary object values into booleans.
 
 @param     val the object being evaluated as a boolean
 
 @return    the boolean value of <code>val</code>
 */
+ (BOOL) booleanFromValue:(id)val;

/*!
 Exposes the mechanism the expression evaluator engine uses for
 converting boolean values into strings.
 
 @param     val the boolean value
 
 @return    the string representing the boolean value passed in; will be
            either <code>kMBMLBooleanStringTrue</code> or
            <code>kMBMLBooleanStringFalse</code>.
 */
+ (NSString*) stringFromBoolean:(BOOL)val;

/*!
 Exposes the mechanism the expression evaluator engine uses for
 converting arbitrary object values into NSDecimalNumber instances.
 
 @param     val the object being evaluated as an NSDecimalNumber
 
 @return    if <code>val</code> can be interpreted as a number,
            the return value is an <code>NSDecimalNumber</code> 
            instance representing that number. If the value could
            not be interpreted as a decimal number, or if the
            resulting <code>NSDecimalNumber</code> is equal to
            <code>[NSNumber notANumber]</code>, <code>nil</code>
            is returned.
 */
+ (NSDecimalNumber*) numberFromValue:(id)val;

/*!
 Exposes the mechanism the expression evaluator engine uses for
 comparing two objects for equality.
 
 @param     lValue the left value of the comparison
 
 @param     rValue the right value of the comparison
 
 @return    <code>[lValue isEqual:rValue];</code> if <code>lValue</code>
 and <code>rValue</code> are of the same types. Otherwise this method
 falls back on
 <code>[MBExpression compareLeftValue:lValue againstRightValue:rValue] 
 == NSOrderedSame;</code>
 */
+ (BOOL) value:(id)lValue isEqualTo:(id)rValue;

/*!
 Exposes the mechanism the expression evaluator engine uses for
 comparing two objects.
 
 @param     lValue the left value of the comparison
 
 @param     rValue the right value of the comparison
 
 @return    <code>NSOrderedAscending</code> if <code>lValue</code>
            is considered less than <code>rValue</code>;
            <code>NSOrderedDescending</code> if <code>lValue</code>
            is considered greater than <code>rValue</code>;
            <code>NSOrderedSame</code> if <code>lValue</code>
            is considered equal to <code>rValue</code>.
 */
+ (NSComparisonResult) compareLeftValue:(id)lValue againstRightValue:(id)rValue;

/*******************************************************************************
 @name Representing expressions as objects
 ******************************************************************************/

+ (instancetype) expression:(NSString*)exprStr
               usingGrammar:(MBExpressionGrammar*)grammar
                      error:(MBExpressionError**)errPtr;

+ (instancetype) expression:(NSString*)exprStr
            inVariableSpace:(MBVariableSpace*)space
               usingGrammar:(MBExpressionGrammar*)grammar
                      error:(MBExpressionError**)errPtr;

@property(nonatomic, readonly) NSString* expression;

@property(nonatomic, readonly) MBVariableSpace* variableSpace;

@property(nonatomic, readonly) NSArray* tokens;

@property(nonatomic, readonly) MBExpressionGrammar* grammar;

/*******************************************************************************
 @name Mid-level token evaluation API
 ******************************************************************************/

+ (id) objectFromTokens:(NSArray*)tokens error:(MBExpressionError**)errPtr;
+ (id) objectFromTokens:(NSArray*)tokens inVariableSpace:(MBVariableSpace*)space defaultValue:(id)def error:(MBExpressionError**)errPtr;

+ (NSString*) stringFromTokens:(NSArray*)tokens error:(MBExpressionError**)errPtr;
+ (NSString*) stringFromTokens:(NSArray*)tokens inVariableSpace:(MBVariableSpace*)space defaultValue:(NSString*)def error:(MBExpressionError**)errPtr;

+ (BOOL) booleanFromTokens:(NSArray*)tokens error:(MBExpressionError**)errPtr;
+ (BOOL) booleanFromTokens:(NSArray*)tokens inVariableSpace:(MBVariableSpace*)space defaultValue:(BOOL)def error:(MBExpressionError**)errPtr;

/*******************************************************************************
 @name Low-level token evaluation API
 ******************************************************************************/

+ (NSArray*) evaluateTokens:(NSArray*)tokens error:(MBExpressionError**)errPtr;
+ (NSArray*) evaluateTokens:(NSArray*)tokens inVariableSpace:(MBVariableSpace*)space error:(MBExpressionError**)errPtr;

@end
