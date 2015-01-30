//
//  MBMLDebugFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/10/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBMLDebugFunctions class
/******************************************************************************/

/*!
 This class implements MBML functions useful for debugging.
 
 These functions are exposed to the Mockingbird environment via 
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.
 
 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLDebugFunctions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Inspecting values within expressions
/*!    @name Inspecting values within expressions                             */
/*----------------------------------------------------------------------------*/

/*!
 Evaluates the passed-in expression in the object context, logs the result
 to the console, and then returns the result.
 
 You can use this to inspect object expressions (or portions thereof) to see
 what values are being returned within them. This can be handy when debugging 
 a complex expression that isn't returning the result you expect.

 This Mockingbird function accepts one parameter, the expression to evaluate.

 #### Expression usage
 
 Assume the variable `$cart` is an array containing five items:

    You have ^log($cart).count items in your cart.
 
 The expression "`$cart`" would be logged to the console, along with the
 result of calling the `description` method on underlying the `NSArray`.
 The array would then be returned by the function.

 The expression as a whole would yield the string "`You have 5 items in your
 cart.`"

 @param     expr The expression to be evaluated. Both `expr` and the result of
            evaluating `expr` will be logged to the console.

 @return    The result of evaluating `expr`.
 */
+ (id) log:(NSString*)expr;

/*!
 Evaluates the passed-in expression in the boolean context, logs the result
 to the console, and then returns the result.

 You can use this to inspect boolean expressions (or portions thereof) to see
 what values are being returned within them. This can be handy when debugging 
 a complex expression that isn't returning the result you expect.

 This Mockingbird function accepts one parameter, the expression to evaluate.

 #### Expression usage
 
 Assume the variable `$foo` contains the string "`cromulent`":

    ^test($foo.length -GT 5)
 
 The expression "`$foo.length -GT 5`" would be logged to the console,
 along with the boolean result, which is `YES`. The result `YES` would then
 be returned by the function.

 @param     expr The expression to be evaluated. Both `expr` and the result of
            evaluating `expr` will be logged to the console.
 
 @return    The result of evaluating `expr`.
 */
+ (id) test:(NSString*)expr;

/*!
 Evaluates the passed-in expression in the object context, logs the result
 to the console, and then returns the string description of the result.

 This Mockingbird function accepts one parameter, the expression to evaluate.

 #### Expression usage

 Assume the variable `$Window` contains a reference to the application's
 `UIWindow`:
 
    ^dump($Window)

 The expression above might result in a value such as:
 
    <UIWindow: 0x7f811c3036e0; frame = (0 0; 375 667); layer = <UIWindowLayer: 0x7f811c300ed0>>

 @param     expr The expression to be evaluated. Both `expr` and the result of
            evaluating `expr` will be logged to the console.

 @return    The result of evaluating `expr.
 */
+ (id) dump:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark Triggering a debug breakpoint
/*!    @name Triggering a debug breakpoint                                    */
/*----------------------------------------------------------------------------*/

/*!
 Triggers a debug breakpoint when called in a debug build. This allows the
 developer to trap execution at a specific point during expression
 evaluation.

 **Note:** This function does nothing unless the `DEBUG` preprocessor macro is
 defined.

 This Mockingbird function accepts one parameter as input, an expression that
 will be returned by the function when it is called, allowing the function
 to be used as a pass-through.
 
 #### Expression usage

    ^debugBreak(Here is the first problem)

 In a debug build, the expression above would result in the string 
 "`Here is the first problem`", and then a breakpoint would be triggered
 in the Xcode debugger.
 
 In non-debug builds, nothing happens.
 
 @param     input An arbitrary expression to be logged to the console before
            the breakpoint is triggered.
 
 @return    The `input`.
 */
+ (NSString*) debugBreak:(NSString*)input;

/*----------------------------------------------------------------------------*/
#pragma mark Inspecting expression tokenization
/*!    @name Inspecting expression tokenization                               */
/*----------------------------------------------------------------------------*/

/*!
 Tokenizes an object expression and logs the resulting parse tokens to
 the console.

 When experiencing trouble with a complex expression giving unexpected results,
 seeing the parse tokens lets you understand how the expression evaluator is
 interpreting your expression.

 This Mockingbird function accepts a single parameter, the expression to
 tokenize. The input expression is returned, allowing the function to be
 used as a pass-through.

 #### Expression usage

    ^tokenize(This $aint.no ^party())

 The expression above would result in console output similar to the following:

    --> Tokens for object expression "This $aint.no ^party()":
    <MBMLLiteralToken@0x7f8ac03aaea0: "This " {0, 5}>
    <MBMLVariableReferenceToken@0x7f8abce042a0: "$aint" {5, 5}> containing 1 token:
        0: <MBMLObjectSubreferenceToken@0x7f8ac0670a00: ".no" {10, 3}>
    <MBMLLiteralToken@0x7f8ac036f4a0: " " {13, 1}>
    <MBMLFunctionCallToken@0x7f8ac0645bb0: "^party()" {14, 8}>
 
 @param     expr The expression to tokenize.
 
 @return    The expression `expr`.
 */
+ (NSString*) tokenize:(NSString*)expr;

/*!
 Tokenizes a boolean expression and logs the resulting parse tokens to
 the console.

 When experiencing trouble with a complex expression giving unexpected results,
 seeing the parse tokens lets you understand how the expression evaluator is
 interpreting your expression.

 This Mockingbird function accepts a single parameter, the expression to
 tokenize. The input expression is returned, allowing the function to be
 used as a pass-through.

 #### Expression usage

    ^tokenizeBoolean(This != ^party())

 The expression above would result in console output similar to the following:

    --> Tokens for boolean expression "This != ^party()":
    <MBMLInequalityTestToken@0x7fa93fb5fbe0: "!=" {5, 2}> containing 2 tokens:
        0: <MBMLLiteralToken@0x7fa93fb45970: "This" {0, 4}>
        1: <MBMLFunctionCallToken@0x7fa93fb4af80: "^party()" {8, 8}>

 @param     expr The expression to tokenize.
 
 @return    The expression `expr`.
 */
+ (NSString*) tokenizeBoolean:(NSString*)expr;

/*!
 Tokenizes a math expression and logs the resulting parse tokens to
 the console.

 When experiencing trouble with a complex expression giving unexpected results,
 seeing the parse tokens lets you understand how the expression evaluator is
 interpreting your expression.

 This Mockingbird function accepts a single parameter, the expression to
 tokenize. The input expression is returned, allowing the function to be
 used as a pass-through.

 #### Expression usage

    ^tokenizeMath(($user.firstName.length + $user.lastName.length) + 1)

 The expression above would result in console output similar to the following:

    --> Tokens for math expression "($user.firstName.length + $user.lastName.length) + 1":
    <MBMLAdditionOperatorToken@0x7fa940048b70: "+" {49, 1}> containing 2 tokens:
        0: <MBMLMathGroupingToken@0x7fa9400a87d0: "($user.firstName.length + $user.lastName.length)" {0, 48}> containing 1 token:
            0: <MBMLAdditionOperatorToken@0x7fa93ae86fd0: "+" {23, 1}> containing 2 tokens:
                0: <MBMLVariableReferenceToken@0x7fa93faf9400: "$user" {0, 5}> containing 2 tokens:
                    0: <MBMLObjectSubreferenceToken@0x7fa940049ac0: ".firstName" {5, 10}>
                    1: <MBMLObjectSubreferenceToken@0x7fa93fae4340: ".length" {15, 7}>
                1: <MBMLVariableReferenceToken@0x7fa93aeb8f70: "$user" {25, 5}> containing 2 tokens:
                    0: <MBMLObjectSubreferenceToken@0x7fa93aea8d90: ".lastName" {30, 9}>
                    1: <MBMLObjectSubreferenceToken@0x7fa93fa52f60: ".length" {39, 7}>
        1: <MBMLNumericLiteralToken@0x7fa94007d100: "1" {51, 1}>

 @param     expr The expression to tokenize.
 
 @return    The expression `expr`.
 */
+ (NSString*) tokenizeMath:(NSString*)expr;

/*----------------------------------------------------------------------------*/
#pragma mark Benchmarking
/*!    @name Benchmarking                                                     */
/*----------------------------------------------------------------------------*/

/*!
 Benchmarks an object expression by measuring the time it takes to evaluate
 and logging the resulting time to the console.

 This Mockingbird function accepts a single parameter, the expression being
 benchmarked. The input expression is also returned by the function, allowing 
 it to be used as a pass-through.
 
 #### Expression usage
 
 In this example, the MBML function `^currentTime()` is benchmarked:
 
    ^bench(^currentTime())
 
 One run of this benchmark resulted in the console output:

    --> Evaluated variable expansion expression "^currentTime()" in 1.90139e-05 seconds

 @param     expr The expression to benchmark.
 
 @return    The expression `expr`.
 */
+ (id) bench:(NSString*)expr;

/*!
 Benchmarks a boolean expression by measuring the time it takes to evaluate
 and logging the resulting time to the console.

 This Mockingbird function accepts a single parameter, the expression being
 benchmarked. The input expression is also returned by the function, allowing 
 it to be used as a pass-through.
 
 #### Expression usage
 
 In this example, a boolean expression involving the MBML function 
 `^randomPercent()` is benchmarked:
 
    ^benchBool(^randomPercent() -GTE 0.5)

 One run of this benchmark resulted in the console output:

    --> Evaluated boolean expression "^randomPercent() -GTE 0.5" in 4.09484e-05 seconds

 @param     expr The expression to benchmark.
 
 @return    The expression `expr`.
 */
+ (id) benchBool:(NSString*)expr;

/*!
 Repeatedly evaluates an object expression a given number of times.

 This Mockingbird function accepts two pipe-separated parameters: 
 
 * The *number of repetitions* to perform, a numeric expression indicating
   how many times *expression* will be evaluated
 
 * The *expression* to evaluate
 
 The function returns the result of the final evaluation of *expression*.
 
 #### Expression usage
 
 When combined with benchmarking, this function is useful for evaluating the
 performance of MBML function implementations and other types of expressions.
 
     ^bench(^repeat(1000|^currentTime()))

 The expression above calls the `^currentTime()` function 1,000 times and then
 logs the result to the console.
 
 One run of this benchmark resulted in the console output:

    --> Successfully repeated object expression "^currentTime()" 1000 times
    --> Evaluated object expression "^repeat(1000|^currentTime())" in 0.010256 seconds

 @param     params The function's input parameters.

 @return    The function result.
 */
+ (id) repeat:(NSArray*)params;

/*!
 Repeatedly evaluates a boolean expression a given number of times.

 This Mockingbird function accepts two pipe-separated parameters:
 
 * The *number of repetitions* to perform, a numeric expression indicating
   how many times *expression* will be evaluated
 
 * The *expression* to evaluate
 
 The function returns the result of the final evaluation of *expression*.
 
 #### Expression usage
 
 When combined with benchmarking, this function is useful for evaluating the
 performance of MBML expressions.
 
     ^benchBool(^repeatBool(10000|^randomPercent() -GTE 0.5))

 In the example above, the boolean expression `^randomPercent() -GTE 0.5` is
 evaluated 10,000 times.

 One run of this benchmark resulted in the console output:

    --> Successfully repeated boolean expression "^randomPercent() -GTE 0.5" 1000 times
    --> Evaluated boolean expression "^repeatBool(10000|^randomPercent() -GTE 0.5)" in 0.013923 seconds

 @param     params The function's input parameters.

 @return    The function result.
 */
+ (id) repeatBool:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Deprecation
/*!    @name Deprecation                                                      */
/*----------------------------------------------------------------------------*/

/*!
 Issues a deprecation warning to the console for the MBML variable with the
 given name.
 
 This Mockingbird function accepts two or three pipe-separated parameters:
 
 * The *deprecated variable name*, a string expression yielding the name of
   the variable being deprecated.
 
 * The *preferred variable name*, a string expression yielding the variable
   name that should be used instead of *deprecated variable name*.

 * An optional *module class*, a string expression representing the name of a
   class implementing the `MBModule` protocol. If specified, the `MBModuleLog`
   associated with *module class* will be used to issue the deprecation
   warning. If this parameter is omitted, the deprecation warning will be
   issued using the `MBDataEnvironmentModule`'s log.

 This method returns *preferred variable name*, allowing it to be used as
 a pass-through.
 
 #### Expression usage

    ^deprecateVariableInFavorOf(place|location|MBGeolocationModule)
 
 The expression above would result in the following message

    DEPRECATION WARNING: Support will be dropped from a future version of the
    MBGeolocation module for Mockingbird:

        The MBML variable "place" has been deprecated; please update your code
        to use "location" instead

 @param     params The function's input parameters.

 @return    The *preferred variable name*.
 */
+ (id) deprecateVariableInFavorOf:(NSArray*)params;

@end
