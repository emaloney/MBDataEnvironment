//
//  MBMLRegexFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBMLRegexFunctions class
/******************************************************************************/

/*!
 This class implements MBML functions providing regular expression support.

 These functions are exposed to the Mockingbird environment via
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.

 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLRegexFunctions : NSObject

/*!
 Matches one or more regular expressions against an input string, and returns
 a new string with all matches removed from the input string.
 
 This Mockingbird function accepts two or more pipe-separated string expressions
 as parameters:
 
 * The *input string* against which the *regular expressions* will be matched
 
 * One or more *regular expressions* to be matched against the *input string*
 
 All characters in the *input string* matching any of the *regular expressions*
 will be removed, and the resulting string will be returned.

 #### Expression usage
 
    ^stripRegex(ThisIsAStringThatWillBeStripped|[TIASWB]|[a-e]|ripp)

 The expression above would result in the string "`hisstringhtillt`".

 #### Quoting regular expressions

 It is sometimes necessary to quote the regular expression string to prevent it
 from being incorrectly interpreted.

 For example, the Mockingbird expression engine will normally recognize a pipe
 character (`|`) within the parentheses of a function call as being a parameter 
 separator. If you want to use the pipe character within a regular expression, 
 you will need to quote it.

 If you want to apply the regular expression `(send |don't )`, you would use the
 quoted form `^q((send |don't ))`, as in:

    ^stripRegex(send now, don't send later|^q((send |don't )))

 The expression above returns the string "`now, later`".

 @param     params The function's input parameters.

 @return    The function result.
 */
+ (id) stripRegex:(NSArray*)params;

/*!
 Performs a regular expression match against an input string and replaces
 all matches with a given a replacement string.
 
 This Mockingbird function accepts three pipe-separated string expressions as
 parameters:
 
 * The *input string* against which the *regular expressions* will be matched
 
 * The *regular expression* to be matched against the *input string*
 
 * The *replacement string*

 All matches of *regular expression* in the *input string* will be replaced
 by the *replacement string*, and the resulting string will be returned.

 #### Expression usage
 
    ^replaceRegex(Release Me, Release Me|Release|Replace)

 The expression above would result in the string "`Replace Me, Replace Me`".

 #### Quoting regular expressions

 It is sometimes necessary to quote the regular expression string to prevent it
 from being incorrectly interpreted.

 For example, the Mockingbird expression engine will normally recognize a pipe
 character (`|`) within the parentheses of a function call as being a parameter
 separator. If you want to use the pipe character within a regular expression,
 you will need to quote it.

 If you want to apply the regular expression `([A-Z]ets|, )`, you would use
 the quoted form `^q(([A-Z]ets|, ))`, as in:

    ^replaceRegex(Yankees, Mets, Jets, Nets|^q(([A-Z]ets|, ))|!)

 The expression above results in the string "`Yankees!!!!!!`".

 @param     params The function's input parameters.

 @return    The function result.
 */
+ (id) replaceRegex:(NSArray*)params;

/*!
 Determines whether one or more regular expressions match a given input string
 at least once.
 
 This Mockingbird function accepts two or more pipe-separated string expressions
 as parameters:
 
 * The *input string* against which the *regular expressions* will be matched

 * One or more *regular expressions* to be matched against the *input string*

 #### Expression usage
 
    ^matchesRegex(212-555-1212|[0-9]{3}-[0-9]{3}-[0-9]{4})

 The expression above results in the value `@YES`.

 #### Quoting regular expressions

 It is sometimes necessary to quote the regular expression string to prevent it
 from being incorrectly interpreted.

 For example, the Mockingbird expression engine will normally recognize a pipe
 character (`|`) within the parentheses of a function call as being a parameter
 separator. If you want to use the pipe character within a regular expression,
 you will need to quote it.

 If you want to apply the regular expression `(^212-|^718-|^917-|^646-)`, you
 would use the quoted form `^q((^212-|^718-|^917-|^646-))`, as in:

    ^matchesRegex(516-555-1212|^q(^212-|^718-|^917-|^646-))

 The expression above results in the value `@NO`.

 @param     params The function's input parameters.

 @return    The function result.
 */
+ (id) matchesRegex:(NSArray*)params;

@end
