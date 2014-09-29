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

@interface MBMLDebugFunctions : NSObject

/*!
 Evaluates the passed-in template expression, takes the resulting
 object and logs the result to the console. The object that results
 from evaluating the expression is returned by the function. This
 function must be declared input="raw" in the template XML.
 */
+ (id) log:(NSString*)expr;

/*!
 Evaluates the passed-in boolean template expression, takes the 
 result and logs the result to the console. The boolean value that 
 results from evaluating the expression is returned by the function.
 This function must be declared input="raw" and output="boolean"
 in the template XML.
 */
+ (NSNumber*) test:(NSString*)expr;

/*!
 Evaluates the passed-in template expression, takes the resulting
 object and logs the result to the console. A string description
 of the object is returned by the function. This function 
 must be declared input="raw" in the template XML.
 */
+ (NSString*) dump:(NSString*)expr;

/*!
 When evaluated in a debug build, this expression will trigger
 a debug breakpoint, allowing the developer to trap execution
 at a specific point. This function must be declared input="raw"
 in the template XML.
 */
+ (NSString*) debugBreak:(NSString*)input;

/*!
 Tokenizes a variable expansion expression and logs the resulting tokens
 to the console. The input expression is returned, allowing the function 
 to be used as a pass-through. This function must be declared input="raw"
 in the template XML.
 */
+ (NSString*) tok:(NSString*)expr;

/*!
 Tokenizes a boolean expression and logs the resulting tokens to the console.
 The input expression is returned, allowing the function to be used as a
 pass-through. This function must be declared input="raw" in the template
 XML.
 */
+ (NSString*) tokBool:(NSString*)expr;

/*!
 Performs a benchmark of a variable expansion expression by measuring the
 time it takes to evaluate the expression, and logging the resulting time to
 the console. The input expression is returned, allowing the function
 to be used as a pass-through. This function must be declared input="raw"
 in the template XML.
 */
+ (id) bench:(NSString*)expr;

/*!
 Performs a benchmark of a boolean expression by measuring the time it takes to
 evaluate the expression, and logging the resulting time to the console. The 
 input expression is returned, allowing the function to be used as a
 pass-through. This function must be declared input="raw"
 in the template XML.
 */
+ (id) benchBool:(NSString*)expr;

/*!
 Repeatedly evaluates a variable expansion expression a given number of times.
 This function takes two parameters: the first being the number of
 repetitions to perform, and the second being the expression that will be
 repeatedly evaluated. The result of the final evaluation of the evaluation
 expression (i.e., the second parameter) is returned. This function must be
 declared input="pipedExpressions" in the template XML.
 */
+ (id) repeat:(NSArray*)params;

/*!
 Repeatedly evaluates a boolean expression a given number of times.
 This function takes two parameters: the first being the number of
 repetitions to perform, and the second being the expression that will be
 repeatedly evaluated. The result of the final evaluation of the evaluation
 expression (i.e., the second parameter) is returned. This function must be
 declared input="pipedExpressions" in the template XML.
 */
+ (id) repeatBool:(NSArray*)params;

+ (id) deprecateVariableInFavorOf:(NSArray*)params;

@end
