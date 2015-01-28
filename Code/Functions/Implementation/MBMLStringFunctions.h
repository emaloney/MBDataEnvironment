//
//  MBMLStringFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 9/15/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 This class implements MBML functions for manipulating strings.
 
 These functions are exposed to the Mockingbird environment via 
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.
 
 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLStringFunctions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark String quoting
/*!    @name String quoting                                                   */
/*----------------------------------------------------------------------------*/

/*!
 Quotes a string, ensuring that it is not interpreted by the Mockingbird
 expression evaluator.
 
 This function can be used to ensure that some or all of an expression
 is left untouched by the expression evaluator.

 This is required, for example, to preserve space characters at the beginning 
 or end of a text literal. (Normally, the expression evaluator ignores
 whitespace at the beginning or end of text literals.)

 This Mockingbird function accepts one parameter, the string to be quoted.
 
 #### Expression usage

    ^q(   -- Please leave spaces intact --   )
 
 The Mockingbird expression above quotes the string so that the spaces at
 the beginning and end of the string are preserved. The return value is:
 "&nbsp;&nbsp;&nbsp;`-- Please leave spaces intact --`&nbsp;&nbsp;&nbsp;".

    ^q(Ke$ha)
 
 The expression above would return the string "`Ke$ha`".

 Normally, the expression evaluator interprets a dollar sign (`$`) as the
 beginning of a variable reference. By itself, the string "`Ke$ha`" would
 be recognized as: *the text literal "`Ke`" followed by a reference to the
 Mockingbird variable "`ha`"*. Assuming there is no value for "`$ha`", without
 quoting, the expression "`Ke$ha`" would actually result in the string "`Ke`",
 which is probably not the desired result.
 
 Quoting the string ensures that it is left intact and not misinterpreted as
 containing a variable reference.

 @param     toQuote The string being quoted.
 
 @return    The quoted string.
 */
+ (id) q:(NSString*)toQuote;

/*----------------------------------------------------------------------------*/
#pragma mark Expression evaluation
/*!    @name Expression evaluation                                            */
/*----------------------------------------------------------------------------*/

/*!
 Returns the result of evaluating the given string as an object expression.
 
 This Mockingbird function accepts a single parameter, a string containing the
 expression to be evaluated.
 
 #### Expression usage

 Assume the variable `$user` has a value:

    ^eval(^q($)user)
 
 The expression above would return the object referenced by the variable
 `$user`.
 
 @param     evalStr The string containing the expression to evaluate.

 @return    The result of evaluating `evalStr` in the object context.
 */
+ (id) eval:(NSString*)evalStr;

/*!
 Returns the result of evaluating the given string as a boolean expression.
 
 This Mockingbird function accepts a single parameter, a string containing the
 expression to be evaluated.
 
 #### Expression usage

    ^evalBool(T)
 
 The expression above returns an `NSNumber` instance containing the
 boolean value `YES`.
  
 @param     evalStr The string containing the expression to evaluate.

 @return    The result of evaluating `evalStr` in the boolean context.
 */
+ (id) evalBool:(NSString*)evalStr;

/*----------------------------------------------------------------------------*/
#pragma mark String stripping & trimming
/*!    @name String stripping & trimming                                      */
/*----------------------------------------------------------------------------*/

/*!
 Removes any leading and trailing whitespace from the given string.
 
 This Mockingbird function accepts a single parameter, an expression
 representing the string to be trimmed.
 
 #### Expression usage

    ^trimSpaces(  Hi, how are you? )
 
 The expression above would result in the value "`Hi, how are you?`".
 
 @param     toTransform The function's input parameter, the string being 
            trimmed.

 @return    The trimmed string.
 */
+ (id) trimSpaces:(NSString*)toTransform;

/*!
 Removes all space characters from the given string.
 
 Note that this removes only space characters, not all whitespace.
 
 This Mockingbird function accepts a single parameter, an expression
 representing the string to be stripped.
 
 #### Expression usage

    ^stripSpaces(  Hi, how are you? )
 
 The expression above would result in the value "`Hi,howareyou?`".
 
 @param     toTransform The function's input parameter, the string being 
            stripped.

 @return    The string, stripped of spaces.
 */
+ (id) stripSpaces:(NSString*)toTransform;

/*!
 Removes the query string from a string containing a URL.
 
 This Mockingbird function accepts a single parameter, a string expression
 yielding the URL string from which the query string should be removed.
 
 #### Expression usage

    ^stripQueryString(http://www.gilt.com/?utm_campaign=claris)
 
 The expression above would return the string "`http://www.gilt.com/`".
 
 @param     toTransform The function's input parameter, the URL string from 
            which the query string will be stripped.

 @return    The URL with the query string removed.
 */
+ (id) stripQueryString:(NSString*)toTransform;

/*----------------------------------------------------------------------------*/
#pragma mark String indentation & prefixing
/*!    @name String indentation & prefixing                                   */
/*----------------------------------------------------------------------------*/

/*!
 Indents each line in a given string with a tab character.

 This Mockingbird function accepts a single input parameter: an expression that
 will be evaluated as a string.

 #### Expression usage

    ^indentLines($emailBody)

 The expression above will interpret the `emailBody` Mockingbird variable as
 a string, and will then prefix each line of the result with a tab character.
 
 The implementation attempts to be platform-agnostic with respect to the
 exact sequence of characters that signal line endings.

 @param     toIndent The function's input parameter, the string being indented.
 
 @return    The result of performing the indentation.
 */
+ (id) indentLines:(NSString*)toIndent;

/*!
 Indents each line in a given string with a specific number of tab characters.

 This Mockingbird function accepts two pipe-separated input parameters:
 
 * The *string to indent*, a string expression representing the string whose
   inidividual lines will be indented
 
 * The *number of tabs*, a numeric expression indicating the number of tabs
   that should be used to indent *string to indent*

 #### Expression usage

    ^indentLinesToDepth($emailBody|2)

 The expression above will interpret the `emailBody` Mockingbird variable as
 a string, and will then prefix each line of the result with two tab characters.
 
 The implementation attempts to be platform-agnostic with respect to the
 exact sequence of characters that signal line endings.

 @param     params The function's input parameters.
 
 @return    The result of performing the indentation.
 */
+ (id) indentLinesToDepth:(NSArray*)params;

/*!
 Prefixes each line in a given string with another string.

 This Mockingbird function accepts two pipe-separated input parameters:
 
 * The *string to indent*, a string expression representing the string being
   indented
 
 * The *number of tabs*, a numeric expression indicating the number of tabs
   that should be used to indent *string to indent*

 #### Expression usage

    ^prefixLinesWith($emailBody|> )

 The expression above will interpret the `emailBody` Mockingbird variable as
 a string, and will then prefix each line of the result with the text 
 "`>`&nbsp;".
 
 The implementation attempts to be platform-agnostic with respect to the
 exact sequence of characters that signal line endings.

 @param     params The function's input parameters.

 @return    The result of performing the prefixing.
 */
+ (id) prefixLinesWith:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Pluralizing terms
/*!    @name Pluralizing terms                                                */
/*----------------------------------------------------------------------------*/

/*!
 Selects a properly pluralized form of a term based on a count of items.

 Pluralization allows multiple variants of a *term* to be supplied, and based
 on a *count*, the grammatically-correct form of *term* will be returned.

 For example, if you are displaying a message to a user and you want to
 reference a number of discounts accrued by the user, you might want to
 construct a slightly different message based on the number of discounts:
 
 * "`You have no discounts`" if there are `0` discounts
 * "`You have one discount`" if there is `1` discount
 * "`You have`&nbsp;*`number`*&nbsp;`discounts`" if there is more than `1` 
   discount (where *`number`* represents the exact value of *count*)

 Sometimes, you might not need a zero-count form:
 
 * "`Welcome to our application!`" if the user has launched your app only once
 * "`We're glad to have you back!`" if the user has launched your app more than
    once

 When used with the zero-count form, this Mockingbird function accepts
 four pipe-separated input parameters:
 
 * The *count*, a numeric expression indicating the number of items
   involved in the pluralization
 * The *zero-count term*, a string expression representing the value to
   be returned if *count* is `0`
 * The *one-count term*, a string expression representing the value to be
   returned if *count* is `1`
 * The *multiple-count term*, a string expression representing the value to be
   returned if *count* is greater than `1`

 The zero-count form can also be omitted, in which case this function accepts
 three pipe-separated input parameters:

 * The *count*, a numeric expression indicating the number of items
   involved in the pluralization
 * The *one-count term*, a string expression representing the value to be
   returned if *count* is `1`
 * The *not-one-count term*, a string expression representing the value to be
   returned if *count* is `0` or greater than `1`

 #### Expression usage

 Here's an example of pluralization involving a zero-count form:

    ^pluralize($user.discounts.count
        |You have no discounts
        |You have one discount
        |You have $user.discounts.count discounts)

 If `$user.discounts.count == 2`, the expression above would yield the string
 "`You have 2 discounts`".

 Pluralization without a zero-count form looks like:

    ^pluralize($launchCount
        |Welcome to our application!
        |We're glad to have you back!)

 When `$launchCount` is `1`, the expression above yields "`Welcome to our
 application!`" For any other value, "`We're glad to have you back!`" is
 returned.

 @param     params The function's input parameters.

 @return    The appropriate pluralization, based on the value of *count*.
 */
+ (id) pluralize:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Manipulating the case of characters in a string
/*!    @name Manipulating the case of characters in a string                  */
/*----------------------------------------------------------------------------*/

/*!
 Returns a version of the input string that contains only lowercase
 characters.
 
 This Mockingbird function accepts a single input parameter: an expression
 yielding the string whose case is to be changed.
 
 #### Expression usage

    ^lowercase(STOP SHOUTING! start whispering.)

 The expression above returns the string "`stop shouting! start whispering.`".
 
 @param     toTransform The function's input parameter, the string whose
            case is to be changed.
 
 @return    The result of changing the input parameter's case.
 */
+ (id) lowercase:(NSString*)toTransform;

/*!
 Returns a version of the input string that contains only uppercase
 characters.
 
 This Mockingbird function accepts a single input parameter: an expression
 yielding the string whose case is to be changed.
 
 #### Expression usage

    ^uppercase(stop whispering. START SHOUTING!)

 The expression above returns the string "`STOP WHISPERING. START SHOUTING!`".
 
 @param     toTransform The function's input parameter, the string whose
            case is to be changed.
 
 @return    The result of changing the input parameter's case.
 */
+ (id) uppercase:(NSString*)toTransform;

/*!
 Returns a title-case version of the input string.
 
 This Mockingbird function accepts a single input parameter: an expression
 yielding the string whose case is to be changed.

 #### Expression usage

    ^titleCase(e. e. cummings)

 The expression above returns the string "`E. E. Cummings`".
 
 @param     toTransform The function's input parameter, the string whose
            case is to be changed.
 
 @return    The result of changing the input parameter's case.
 */
+ (id) titleCase:(NSString*)toTransform;

/*!
 Returns a title-case version of the input string if the letters in the input
 string are all capitals. If the input string contains any lowercase
 characters, the input string will be returned unchanged.
 
 This Mockingbird function accepts a single input parameter: an expression
 yielding the string whose case is to be changed.

 #### Expression usage

    ^titleCaseIfAllCaps(e. e. cummings)

 The expression above returns the string "`e. e. cummings`".

    ^titleCaseIfAllCaps(E. E. CUMMINGS)

 The expression above returns the string "`E. E. Cummings`".

 @param     toTransform The function's input parameter, the string whose
            case is to be changed.
 
 @return    The result of changing the input parameter's case.
 */
+ (id) titleCaseIfAllCaps:(NSString*)toTransform;

/*----------------------------------------------------------------------------*/
#pragma mark Combining multiple field label/value pairs into a single string
/*!    @name Combining multiple field label/value pairs into a single string  */
/*----------------------------------------------------------------------------*/

/*!
 Constructs a string by concatenating an arbitrary set of *fields* using
 a *field separator*.
 
 Each *field* is comprised of two components: a *field label* and a *field
 value*.
 
 For each field with a non-`nil` value, the *field label* is added to the
 string, followed by the *field value*. If multiple fields are provided, 
 the *field separator* is included between each *field label/field value* pair.
 
 This Mockingbird function accepts two or more pipe-separated input parameters:
 
 * An optional *field separator*, a string expression specifying the separator
   to be used between each label/value pair added to the output string. If the
   field separator parameter is not explicitly specified, the separator string
   "`; `" (a semicolon followed by a space) is used.

 * A *field label*, a string expression
 
 * A *field value*, a string expression
 
 * An optional set of additional label/value pairs.
 
 Note that if the field separator parameter is specified, the function will
 always expect an odd number of parameters, whereas if the field separator
 is omitted, the function will always expect an even number of parameters.
 
 #### Expression usage
 
 Assume that `$item.size` yields the string "`42R`" and `$item.color` yields
 "`navy blue`"

    ^concatenateFields(Size: |$item.size|Color: |^titleCase($item.size))
 
 The expression above would return the string "`Size: 42R; Color: Navy Blue`".

 @param     params The function's input parameters.

 @return    The function result.
 */
+ (id) concatenateFields:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark String stripping & trimming
/*!    @name String stripping & trimming                                      */
/*----------------------------------------------------------------------------*/

/*!
 Given a set of expressions, returns the value of the first expression
 that returns a non-`nil`, non-empty string.
 
 This Mockingbird function accepts an arbitrary list of pipe-separated
 parameters, where each parameter is an expression that will be evaluated
 in the string context.
 
 The function will return the value of the first expression that yields a
 non-empty string. If there are no such values, `nil` is returned.
 
 #### Expression usage
 
 Assume `$firstName` is "`Lon`" and `$nickname` has no value:

    ^firstNonemptyString($nickname|$firstName|Valued Customer)
 
 The expression above would yield the string "`Lon`".
 
 If `$firstName` were undefined, the return value would be "`Valued Customer`".
 
 @param     params The function's input parameters.

 @return    The function result.
 */
+ (id) firstNonemptyString:(NSArray*)params;

/*!
 Given a set of expressions, returns a trimmed version of the value of the
 first expression that returns a non-`nil`, non-empty string. Leading and
 trailing whitespace is removed from the result before it is returned.

 This Mockingbird function accepts an arbitrary list of pipe-separated
 parameters, where each parameter is an expression that will be evaluated
 in the string context.
 
 The function will return the value of the first expression that yields a
 non-empty string *after* whitespace trimming. If there are no such values,
 `nil` is returned.

 #### Expression usage
 
 Assume that the expression `$user.salutation` yields `nil`:

    ^firstNonemptyTrimmedString($user.salutation|Dear )

 The expression above would yield the string "`Dear`" (with no trailing space)
 even though the second parameter consists of a string ("`Dear`&nbsp;")
 containing a trailing space.

 @param     params The function's input parameters.

 @return    The function result.
 */
+ (id) firstNonemptyTrimmedString:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark String truncation
/*!    @name String truncation                                                */
/*----------------------------------------------------------------------------*/

/*!
 Truncates a string if it is longer than a given length, and appends a
 *truncation marker* if truncation has occurred.

 This Mockingbird function accepts 2 or 3 pipe-separated input parameters:

 * The *truncation length*, a numeric expression. If *input string*'s length
   is greater than *truncation length*, *input string* will be shortened to exactly
   *truncation length*, and then the *truncation marker* will be appended.
 
 * An optional *truncation marker*, a string expression representing the
   string to append to the end of *input string* after truncation occurs. 
   If this parameter is omitted, the ellipses character (`…`) will be used as
   the truncation string.

 * The *input string*, an expression yielding the string to be truncated.
 
 Note that the truncation marker is appended *after* the input string is
 truncated. As a result, the string returned by this function may be as
 long as *truncation length* plus the length of *truncation marker*.

 #### Expression usage

    ^truncate(10|This is your chance!)
 
 The expression above yields the string "`This is yo…`".

    ^truncate(5|!|Hello, Newman.)
 
 The expression above results in "`Hello!`".
 
 @param     params The function's input parameters.

 @return    The function result.
 */
+ (id) truncate:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Handling numbers
/*!    @name Handling numbers                                                 */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to parse a string into an `NSNumber` instance containing an
 arbitrary numeric value.
 
 This Mockingbird function accepts a single input parameter: an expression
 yielding the string to be parsed as a number.
 
 #### Expression usage

 Assume the variable `$foo` contains the string "`5`" and the variable
 `$bar` contains the string "`25`", the following expression:

    ^parseNumber(${foo}.${bar})

 returns an `NSNumber` containing the floating-point value `5.25`.
 
 @param     toParse The function's input parameter, the string being parsed.
 
 @return    The result of parsing the input parameter.
 */
+ (id) parseNumber:(NSString*)toParse;

/*!
 Attempts to parse a string into an `NSNumber` instance containing an
 `NSInteger` value.
 
 This Mockingbird function accepts a single input parameter: an expression
 yielding the string to be parsed as an integer.
 
 #### Expression usage

 Assume the variable `$foo` contains the string "`5`" and the variable
 `$bar` contains the string "`25`", the following expression:

    ^parseInteger(-${foo}.${bar})

 returns an `NSNumber` containing the value `-5`.
 
 @param     toParse The function's input parameter, the string being parsed.
 
 @return    The result of parsing the input parameter.
 */
+ (id) parseInteger:(NSString*)toParse;

/*!
 Attempts to parse a string into an `NSNumber` instance containing a
 `double` value.
 
 This Mockingbird function accepts a single input parameter: an expression
 yielding the string to be parsed as a `double`.
 
 #### Expression usage

 Assume the variable `$foo` contains the string "`5`" and the variable
 `$bar` contains the string "`25`", the following expression:

    ^parseDouble(-${foo}.${bar})

 returns an `NSNumber` containing the value `-5.25`.
 
 @param     toParse The function's input parameter, the string being parsed.
 
 @return    The result of parsing the input parameter.
 */
+ (id) parseDouble:(NSString*)toParse;

/*!
 Formats a number as an integer string using a `NSNumberFormatter` with a
 `numberStyle` of `NSNumberFormatterDecimalStyle`.
 
 This Mockingbird function accepts a single input parameter: a numeric
 expression yielding the number to format as an integer string.
 
 #### Expression usage

    ^formatInteger(11 / 2)

 The expression above yields an `NSString` containing the value "`5`".
 
 @param     toFormat The function's input parameter, the number being formatted.
 
 @return    The result of formatting the input parameter.
 */
+ (id) formatInteger:(NSNumber*)toFormat;

/*----------------------------------------------------------------------------*/
#pragma mark Finding substrings
/*!    @name Finding substrings                                               */
/*----------------------------------------------------------------------------*/

/*!
 Determines if a string has a given prefix.

 This Mockingbird function accepts two parameters:
 
 * The *string to test*, a string expression that will be tested to see if it
   has the given prefix.
 
 * The *prefix*, a string expression yielding the prefix to test against
   *string to test*.

 #### Expression usage

    ^hasPrefix($name|Coop)
 
 The expression above evaluates to `true` if string value of the expression 
 `$name` begins with "`Coop`".
 
 @param     params The function's input parameters.

 @return    `@YES` if *string to test* has the given *prefix*; `@NO` otherwise.
 */
+ (id) hasPrefix:(NSArray*)params;

/*!
 Determines if a string has a given suffix.

 This Mockingbird function accepts two input parameters:

 * The *string to test*, a string expression that will be tested to see if it
   has the given suffix.
 
 * The *suffix*, a string expression yielding the suffix to test against
   *string to test*.

 #### Expression usage

    ^hasSuffix($dayOfWeek|day)
 
 The expression above evaluates to `true` if string value of the expression
 `$dayOfWeek` ends with "`day`".
 
 @param     params The function's input parameters.

 @return    `@YES` if *string to test* has the given *suffix*; `@NO` otherwise.
*/
+ (id) hasSuffix:(NSArray*)params;
    
/*!
 Determines if a string contains a given substring.
 
 This Mockingbird function accepts two input parameters:

 * The *string to test*, a string expression that will be tested to see if it
   contains the substring.
 
 * The *substring*, a string expression yielding the substring to be found
   within *string to test*.

 #### Expression usage
 
    ^containsString($dayOfWeek|ues)
 
 The Mockingbird expression above returns `YES` if the string value of the
 expression `$dayOfWeek` contains the string "`ues`".
 
 If `$dayOfWeek` yields the string "`Tuesday`", the expression will return
 `YES`. For any other day of the week, the expression returns `NO`.
 
 @param     params The function's input parameters.

 @return    An `NSNumber` containing the boolean result.
 */
+ (id) containsString:(NSArray*)params;

/*!
 Attempts to locate the first instance of a substring within another string.
 
 This Mockingbird function accepts two input parameters:

 * The *string to test*, a string expression that will be tested to see if it
   contains the substring.
 
 * The *substring*, a string expression yielding the substring to be found
   within *string to test*.
 
 The function returns a two-element array containing `NSNumber`s holding 
 the members of the `NSRange` specifying the location of *substring* within
 *string to test*.
 
 The first element of the returned array will contain the value of the
 `NSRange`'s `location` member. The location indicates the index of the first
 character of *substring* found within *string to test*. If *substring* is
 not found, the first element will contain a value equivalent to `NSNotFound`.
 
 The second element of the returned array contains the `length` of the
 `NSRange`. If *substring* is found within *string to test*, this will be
 the same as the length of *substring*. If *substring* is not found, this
 value will be `0`.

 #### Expression usage
 
    ^rangeOfString(Today is not your day.|not)
 
 The expression above would return the array [`9`, `3`].
 
 @param     params The function's input parameters.

 @return    The range of *substring* within *string to test*.
 */
+ (id) rangeOfString:(NSArray*)params;

@end
