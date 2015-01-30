//
//  MBMLLogicFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/20/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBMLLogicFunctions class
/******************************************************************************/

/*!
 This class implements MBML logic functions.
 
 These functions are exposed to the Mockingbird environment via
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.

 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLLogicFunctions : NSObject

/*!
 Implements an `if` operator usable within Mockingbird expressions.
 
 This Mockingbird function accepts between one and three input expressions:
 
 * The first parameter is the *conditional expression*, a Mockingbird
   expression that will be evaluated in a boolean context. If only this
   parameter is provided and it evaluates to `true`, the result of evaluating
   the *conditional expression* in the object context will be returned, while
  `nil` is returned if the single parameter evaluates to `false`.
 
 * An optional *true return value*, which is returned by the function
   if the conditional evaluates to `true`.
 
 * An optional *false return value*, which is returned if the conditional
   evaluates to `false`. If this parameter is omitted and the conditional
   evaluates to `false`, `nil` is returned.

 #### Expression usage

 **Note:** This function is exposed to the Mockingbird environment with a
 name that differs from that of its implementing method:

     ^if($year -LT 2015|Past|Present or future?)
 
 The expression above would return the string "`Past`" if the
 conditional expression `$year -LT 2015` evaluates to
 `true`; otherwise, the string "`Present or future?`" is returned.

 In the following expression:
 
     ^if($year -EQ 2015|This Year)

 the string "`This Year`" is returned if `$year` equals `2015`; if `$year`
 is any other value, `nil` is returned.
 
 Finally, assume `$cartItems` refers to an array:
 
     ^if($cartItems.count)

 if `$cartItems.count` evaluates to `true` in a boolean context (i.e., 
 if `$cartItems.count` is non-zero), the object value of `$cartItems.count` is
 returned. Otherwise, if `$cartItems.count` is `0`, `nil` is returned.

 So, if `$cartItems` contains `7` items, the expression `^if($cartItems.count)`
 would yield the result `7`. But if the array containeds no items, `nil` would
 be returned.

 @param     params an array containing the input parameters for the function
 
 @return    The result of the `if` operator.
 */
+ (id) ifOperator:(NSArray*)params;

@end
