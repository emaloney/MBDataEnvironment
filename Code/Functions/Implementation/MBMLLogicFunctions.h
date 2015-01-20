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
 Implements an if operator.
 
 This Mockingbird function accepts between one and three input expressions:
 
 * The first parameter is the *conditional expression*, a template
 expression that will be evaluated in a boolean context. If only this parameter
 is provided, its object value is returned if the expression evaluates to true,
 while `nil` is returned if the single parameter evaluates to false.
 
 * An optional *true return value*, which is returned by the function
 if the conditional evaluates to `YES`.
 
 * An optional *false return value*, which is returned if the conditional
 evaluates to `NO`. If this parameter is omitted and the conditional
 evaluates to `NO`, `nil` is returned.

 #### Expression usage

 **Note:** This function is exposed to the Mockingbird environment with a
 name that differs from that of its implementing method:

     ^if($year -LT 2015|Past|This Year)
 
 The expression above would return the string "`Past`" if the
 conditional expression `$year -LT 2015` evaluates to
 `YES`; otherwise, the string "`This Year`" is returned.

 @param     params an array containing the input parameters for the function
 
 @return    The result of performing the evaluations described above.
 */
+ (id) ifOperator:(NSArray*)params;

/*!
 Selects the first non-`nil` (and non-`NSNull`) value from among two or
 more parameters.

 This Mockingbird function accepts two or more object expressions as input
 parameters and returns the result of the first expression returning a valid 
 value.

 #### Expression usage

     ^selectFirstValue($dataSource|^array())

 The expression above would return the value of `$dataSource`
 if it a non-`nil`/non-`NSNull` value; otherwise, an empty array is returned.
 
 @param     params an array containing the input parameters for the function
 
 @return    The result of performing the evaluations described above.
 */
+ (id) selectFirstValue:(NSArray*)params;

@end
