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

+ (id) mod:(NSArray*)params;

+ (id) modFloat:(NSArray*)params;

// must be declared input="pipedMath" in <Function> tag
+ (id) percent:(NSArray*)params;

// must be declared input="math" in <Function> tag
+ (id) ceil:(id)number;

// must be declared input="math" in <Function> tag
+ (id) floor:(id)number;

// must be declared input="math" in <Function> tag
+ (id) round:(id)number;

// must be declared input="pipedMath" in <Function> tag
+ (id) max:(NSArray*)params;

// must be declared input="pipedMath" in <Function> tag
+ (id) min:(NSArray*)params;

+ (id) randomPercent;

+ (id) random:(NSArray*)params;

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
