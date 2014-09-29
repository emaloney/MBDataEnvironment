//
//  MBMLStringFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 9/15/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBMLStringFunctions : NSObject

/*!
 Allows for quoting a string in the template language. This is required, for
 example, to preserve space characters at the beginning or end of a string
 literal. (Normally, the expression evaluator ignores whitespace at the
 beginning or end of string literals.)
 
 This function accepts one parameter, the string to be quoted.
 
 <b>Template example:</b>
 
 <pre>^q(   -- Please leave spaces intact --   )</pre>
 
 The template expression above quotes the string so that the space characters
 at the beginning and end of the string are preserved.
 
 @param     toQuote the string
 
 @return    <code>toQuote</code>
 */
+ (id) q:(NSString*)toQuote;

+ (id) eval:(NSString*)toQuote;

+ (id) evalBool:(NSString*)toQuote;

+ (id) stripQueryString:(NSString*)toTransform;

+ (id) stripSpaces:(NSString*)toTransform;

+ (id) trimSpaces:(NSString*)toTransform;

+ (id) indentLines:(NSString*)toIndent;

+ (id) indentLinesToDepth:(NSArray*)params;

+ (id) prefixLinesWith:(NSArray*)params;

+ (id) pluralize:(NSArray*)params;

+ (id) lowercase:(NSString*)toTransform;

+ (id) uppercase:(NSString*)toTransform;

+ (id) titleCase:(NSString*)toTransform;

+ (id) titleCaseIfAllCaps:(NSString*)toTransform;

+ (id) concatenateFields:(NSArray*)params;

+ (id) firstNonemptyString:(NSArray*)params;

+ (id) firstNonemptyTrimmedString:(NSArray*)params;

+ (id) truncate:(NSArray*)params;

+ (id) parseNumber:(NSString*)toParse;

+ (id) parseInteger:(NSString*)toInt;

+ (id) parseDouble:(NSString*)toFloat;

/*!
 Computes the width size for a string. Useful for dynamic sizing.
 
 @param firstComponent   String for which to compute width
 @param secondComponent  Name of font used
 @param thirdComponent   Size of font used
 
 @return  [firstComponent sizeWithFont:font].width
 */
+ (id) stringWidth:(NSArray*)params;

/*!
 Computes the number of lines for a string with specified width.
 
 @param firstComponent   String for which to compute number of lines
 @param secondComponent  Name of font used
 @param thirdComponent   Size of font used
 @param fourthComponent  Specified width for string
 
 @return  An NSNumber containing the number of lines.
 */
+ (id) linesNeededToDrawText:(NSArray*)params;

+ (id) rangeOfString:(NSArray*)params;

+ (id) formatInteger:(NSString*)toParse;

/*!
 Determines if the string specified by the first expression parameter
 has the prefix indicated by the second expression parameter.
 
 This function accepts two parameters:
 
 The first parameter a string expression whose prefix is to be tested.
 
 The second parameter is a string expression containing the prefix to
 test.
 
 <b>Template example:</b>
 
 <pre>^hasPrefix($name|Coop)</pre>
 
 The template expression above returns YES if the string value of the
 expression $name begins with the string "Coop".
 
 @param     params - the input parameters
 
 @return    An NSNumber containing the boolean result.
 */
+ (id) hasPrefix:(NSArray*)params;

/*!
 Determines if the string specified by the first expression parameter
 has the suffix indicated by the second expression parameter.
 
 This function accepts two parameters:
 
 The first parameter a string expression whose suffix is to be tested.
 
 The second parameter is a string expression containing the suffix to
 test.
 
 <b>Template example:</b>
 
 <pre>^hasSuffix($dayOfWeek|day)</pre>
 
 The template expression above returns YES if the string value of the
 expression $dayOfWeek ends with the string "day".
 
 @param     params - the input parameters
 
 @return    An NSNumber containing the boolean result.
*/
+ (id) hasSuffix:(NSArray*)params;

/*!
 Determines if the string specified by the first expression parameter
 contains the string indicated by the second expression parameter.
 
 This function accepts two parameters:
 
 The first parameter a string expression that will be tested to see
 if it contains the substring.
 
 The second parameter is a string expression containing the substring.
 
 <b>Template example:</b>
 
 <pre>^containsString($dayOfWeek|ues)</pre>
 
 The template expression above returns YES if the string value of the
 expression $dayOfWeek contains the string "ues".
 
 @param     params - the input parameters
 
 @return    An NSNumber containing the boolean result.
 */
+ (id) containsString:(NSArray*)params;

@end
