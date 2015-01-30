//
//  MBMLMathFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/9/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathFunctions class
/******************************************************************************/

/*!
 This class implements MBML functions for performing mathematical operations.
 
 **Note:** Simple math operations are available using the math expression
 notation.

 These functions are exposed to the Mockingbird environment via 
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.
 
 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLMathFunctions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Modulo operations
/*!    @name Modulo operations                                                */
/*----------------------------------------------------------------------------*/

/*!
 Performs an integer modulo operation on a *dividend* and a *divisor*.

 The modulo operation returns the *remainder* of dividing the *dividend* by
 the *divisor*.
 
 This Mockingbird function accepts two pipe-separated parameters:

 * The *dividend*, a numeric expression that will be interpreted as an
   integer value
 
 * The *divisor*, a numeric expression that will be interpreted as an
   integer value

 #### Expression usage

    ^mod(7|4)

 The expression above yields the value `3`.

 @param     params The function's input parameters.

 @return    An `NSNumber` containing the result.
 */
+ (id) mod:(NSArray*)params;

/*!
 Performs a floating-point modulo operation on a *dividend* and a *divisor*.

 The modulo operation returns the *remainder* of dividing the *dividend* by
 the *divisor*.
 
 This Mockingbird function accepts two pipe-separated parameters:

 * The *dividend*, a numeric expression that will be interpreted as a
   floating-point value
 
 * The *divisor*, a numeric expression that will be interpreted as an
   floating-point value

 #### Expression usage

    ^modFloat(10.25|.5)

 The expression above yields the value `0.25`.

 @param     params The function's input parameters.

 @return    An `NSNumber` containing the result.
 */
+ (id) modFloat:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Rounding numbers
/*!    @name Rounding numbers                                                 */
/*----------------------------------------------------------------------------*/

/*!
 Formats a string to display a human-readable percentage.

 This Mockingbird function accepts two or three pipe-separated parameters:

 * An optional *format string*, a string expression containing a `printf`-style
   formatting sequence. If *format string* is omitted, the format string
   defaults to "`%.0f%%`".

 * The *dividend*, a numeric expression
 
 * The *divisor*, a numeric expression that's expected to be greater than
   the *dividend*
 
 The percent string is constructed by dividing the *dividend* by the 
 *divisor* and formatting the resulting floating-point number using
 the *format string*.

 #### Expression usage

    ^percent(32|78)

 The expression above yields the string "`41%`".

    ^percent(%.2f percent|13|38)

 The expression above yields the string "`34.21 percent`".

 @param     params The function's input parameters.

 @return    An `NSString` containing the result.
 */
+ (id) percent:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Rounding numbers
/*!    @name Rounding numbers                                                 */
/*----------------------------------------------------------------------------*/

/*!
 Returns the *ceiling* of a numeric value; that is, the smallest integral value
 greater than or equal to the specified value. This can be thought of as
 "rounding up."
 
 This Mockingbird function accepts one parameter, a numeric expression for
 which the ceiling should be returned.
 
 #### Expression usage

    ^ceil(10.26)

 The expression above yields the value `11`.

    ^ceil(-10.26)
 
 The expression above yields the value `-10`.

 @param     number The input value.
 
 @return    The ceiling of the input value.
 */
+ (id) ceil:(id)number;

/*!
 Returns the *floor* of a numeric value; that is, the largest integral value
 less than or equal to the specified value. This can be thought of as "rounding
 down."
 
 This Mockingbird function accepts one parameter, a numeric expression for
 which the floor should be returned.
 
 #### Expression usage

    ^floor(10.26)

 The expression above yields the value `10`.
 
    ^floor(-10.26)
 
 The expression above yields the value `-11`.

 @param     number The input value.
 
 @return    The floor of the input value.
 */
+ (id) floor:(id)number;

/*!
 Rounds a numeric value to the nearest integral value. Values halfway between
 the nearest integrals are rounded away from zero.

 This Mockingbird function accepts one parameter, a numeric expression for
 which the rounded value should be returned.
 
 #### Expression usage

    ^round(10.26)

 The expression above yields the value `10`.

    ^round(10.5)

 The expression above yields the value `11`.

    ^round(10.72)

 The expression above yields the value `11`.

    ^round(-10.26)

 The expression above yields the value `-10`.

    ^round(-10.5)

 The expression above yields the value `-11`.

    ^round(-10.72)

 The expression above yields the value `-11`.

 @param     number The input value.
 
 @return    The floor of the input value.
 */
+ (id) round:(id)number;

/*----------------------------------------------------------------------------*/
#pragma mark Comparing numbers
/*!    @name Comparing numbers                                                */
/*----------------------------------------------------------------------------*/

/*!
 Returns the greater of two numeric values.
 
 This Mockingbird function accepts two pipe-separated parameters:
 
 * *a*, a numeric expression representing the first value, and
 * *b*, a numeric expression representing the second value
 
 If *a* is greater than *b*, the function returns *a*; if *a* is less than
 *b*, the function returns *b*.

 #### Expression usage

    ^max(5|10)
 
 The expression above yields the numeric value `10`.

 @param     params The function's input parameters.

 @return    The lesser value of the two input parameters.
 */
+ (id) max:(NSArray*)params;

/*!
 Returns the lesser of two numeric values.
 
 This Mockingbird function accepts two pipe-separated parameters:
 
 * *a*, a numeric expression representing the first value, and
 * *b*, a numeric expression representing the second value
 
 If *a* is less than *b*, the function returns *a*; if *a* is greater than
 *b*, the function returns *b*.

 #### Expression usage

    ^min(5|10)
 
 The expression above yields the numeric value `5`.

 @param     params The function's input parameters.

 @return    The lesser value of the two input parameters.
 */
+ (id) min:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Random number generation
/*!    @name Random number generation                                         */
/*----------------------------------------------------------------------------*/

/*!
 Returns a random percentage. Possible values range from `0.0` to `1.0`, 
 inclusive.
 
 This Mockingbird function accepts no parameters, and returns an `NSNumber`.
 
 #### Expression usage

    ^randomPercent()
 
 One run of the expression above resulted in the value `0.3335955009486505`.
 Other runs will produce different results.

 @return    An `NSNumber` containing a random percentage.
 */
+ (id) randomPercent;

/*!
 Returns a random integer within a specified range.
 
 This Mockingbird function accepts one or two pipe-separated parameters, 
 depending on how it being used:
 
 * An optional *minimum value*, a numeric expression specifying the minimum
   value to be returned by the function. If this value is not specified, `0`
   will be used as the minimum value.
 
 * The *maximum value*, a numeric expression specifying the maximum value
   to be returned by the function. 

 #### Expression usage

    ^random(1|52)
 
 One run of the expression above resulted in the value `27`.
 Other runs will produce different results.

  @param     params The function's input parameters.

  @return    An `NSNumber` containing a random integer value between
             *minimum value* and *maximum value*, inclusive.
 */
+ (id) random:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Creating sequences of numbers
/*!    @name Creating sequences of numbers                                    */
/*----------------------------------------------------------------------------*/

/*!
 Creates an array filled with `NSNumber`s containing integers created 
 according to a simple step pattern.
 
 This Mockingbird function accepts two or three pipe-separated parameters:
 
 * The *starting number*, a numeric expression that yields the value for the
   first element in the returned array
 
 * The *maximum number*, a numeric expression. The returned array will contain
   no values greater than the *maximum number*.
 
 * An optional *step increment*, a numeric expression indicating the amount
   by which *starting number* will increase in each step towards the *maximum
   number*. If this parameter is omitted, the step increment will be `1`.
 
 The return value will be an array of integers beginning with *starting number*
 and increasing by the *step increment* until the *maximum number* is reached.
 
 #### Expression usage
 
    ^arrayFilledWithIntegers(1|10)

 The expression above would return an array containing the elements
 [`1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`].
 
 @param     params The function's input parameters.

 @return    The function result.
 */
+ (id) arrayFilledWithIntegers:(NSArray*)params;

@end
