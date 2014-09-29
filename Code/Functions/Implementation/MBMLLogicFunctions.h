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

@interface MBMLLogicFunctions : NSObject

/*!
 Implements an if operator.
 
 This function accepts between one and three input expressions:
 
 <ul>
 <li>The first parameter is the <i>conditional expression</i>, a template
 expression that will be evaluated in a boolean context. If only this parameter
 is provided, its object value is returned if the expression evaluates to true,
 while <code>nil</code> is returned if the single parameter evaluates to false.
 
 <li>An optional <i>true return value</i>, which is returned by the function
 if the conditional evaluates to <code>YES</code>.
 
 <li>An optional <i>false return value</i>, which is returned if the conditional
 evaluates to <code>NO</code>. If this parameter is omitted and the conditional
 evaluates to <code>NO</code>, <code>nil</code> is returned.
 </ul>
 
 <b>Template example:</b>
 
 <pre>^if($year -LT 2012|Past|This Year)</pre>
 
 The expression above would return the string "<code>Past</code>" if the
 conditional expression <code>$year -LT 2012</code> evaluates to
 <code>YES</code>; otherwise, the string "<code>This Year</code>" is returned.
 
 @note      This function is exposed to the MBML environment as `^if()`.
 
 @param     params an array containing the input parameters for the function
 
 @return    The result of performing the evaluations described above.
 */
+ (id) ifOperator:(NSArray*)params;

/*!
 Accepts two or more template expressions as input parameters, and returns
 the first one that evaluates to a non-<code>nil</code> (and 
 non-<code>NSNull</code>) value.
  
 <b>Template example:</b>
 
 <pre>^selectFirstValue($dataSource|^array())</pre>
 
 The expression above would return the value of <code>$dataSource</code>
 if it a non-<code>nil</code>/non-<code>NSNull</code> value; otherwise,
 an empty array is returned.
 
 @param     params an array containing the input parameters for the function
 
 @return    The result of performing the evaluations described above.
 */
+ (id) selectFirstValue:(NSArray*)params;

@end
