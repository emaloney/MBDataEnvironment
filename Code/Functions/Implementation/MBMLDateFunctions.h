//
//  MBMLDateFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/11/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

extern NSString* const kMBDateRFC1123StringFormat;          // @"EEE, dd MMM yyyy HH:mm:ss zzz"
extern NSString* const kMBDateSortableStringFormat;         // @"YYYY-MM-dd HH:mm:ss"
extern NSString* const kMBDateParsingFormatVariableName;           // @"MBMLDateFunctions:dateParsingFormat"
extern NSString* const kMBDateParsingLocaleVariableName;    // @"MBMLDateFunctions:dateParsingLocale"
extern NSString* const kMBDateDefaultParsingLocale;         // @"en_US_POSIX"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLDateFunctions class
/******************************************************************************/

/*!
 A class containing a set of MBML functions and supporting methods that provide
 date manipulation tools.
 
 See `MBMLFunction` for more information on MBML functions and how they're used.
 */
@interface MBMLDateFunctions : NSObject

/******************************************************************************/
#pragma mark Supporting methods
/******************************************************************************/

/*!
 Returns the date parsing format used by default. First, the MBML expression
 `$MBMLDateFunctions:dateParsingFormat` is checked for a value; if a value is
 present, it is returned. Otherwise, the value of the constant 
 `kRFC1123DateStringFormat` is returned.
  
 @return    The default date parsing format string.
 
 @note      This method is not exposed to MBML as a function.
 */
+ (NSString*) defaultDateParsingFormat;

/*!
 Returns the date parsing locale used by default. First, the MBML expression
 `$MBMLDateFunctions:dateParsingLocale` is checked for a value; if a value is
 present, it is used as the locale identifier. Otherwise, the value of the
 constant `kMBDateParsingLocaleVariableName` is used to construct the locale.

 If all else fails, the device's current locale is used.
  
 @return    The default date parsing locale.
 
 @note      This method is not exposed to MBML as a function.
 */
+ (NSLocale*) defaultDateParsingLocale;

/*!
 Returns a date-formatted string using the specified formatter style.
 
 @param     d8 The `NSDate` to format.
 
 @param     style The `NSDateFormatterStyle` to use for formatting the date.
 
 @return    A string containing the formatted date.
 
 @note      This method is not exposed to MBML as a function.
 */
+ (NSString*) formatDate:(NSDate*)d8 withStyle:(NSDateFormatterStyle)style usingTimeZone:(NSTimeZone*)timeZone;

/*!
 Returns a time-formatted string using the specified formatter style.
 
 @param     d8 The `NSDate` to format.
 
 @param     style The `NSDateFormatterStyle` to use for formatting the time.
 
 @return    A string containing the formatted time.
 
 @note      This method is not exposed to MBML as a function.
 */
+ (NSString*) formatTime:(NSDate*)d8 withStyle:(NSDateFormatterStyle)style;

/*!
 Returns a date/time-formatted string using the specified formatter style.
 
 @param     d8 The `NSDate` to format.
 
 @param     style The `NSDateFormatterStyle` to use for formatting the
            date/time.
 
 @return    A string containing the formatted date/time.
 
 @note      This method is not exposed to MBML as a function.
 */
+ (NSString*) formatDateTime:(NSDate*)d8 withStyle:(NSDateFormatterStyle)style;

/*!
 Attempts to parse an `NSDate` from a string using the specified date format.
 
 @param     str The date string to parse.
 
 @param     locale The locale of the input string `str`. If `nil`, the value 
            `str` is assumed to be in the device's current locale.

 @param     dateFormat A date format string as accepted by `NSDateFormatter`.
 
 @return    An `NSDate` representing the parsed date string, or `nil` if there
            was an error parsing the string.
 
 @note      This method is not exposed to MBML as a function; instead, the
            `mbmlParseDate:` method implements the `^parseDate()` MBML function.
 */
+ (NSDate*) parseDate:(NSString*)str
           fromLocale:(NSLocale*)locale
          usingFormat:(NSString*)dateFormat;

/*!
 Attempts to parse an `NSDate` from a string in the locale 
 `defaultDateParsingLocale` using the date format returned
 by the method `defaultDateParsingFormat`.
 
 @param     str The date string to parse.
 
 @return    An `NSDate` representing the parsed date string, or `nil` if there
            was an error parsing the string.
 
 @note      This method is not exposed to MBML as a function; instead, the
            `mbmlParseDate:` method implements the `^parseDate()` MBML function.
 */
+ (NSDate*) parseDate:(NSString*)str;

/******************************************************************************/
#pragma mark MBML Functions
/******************************************************************************/

/*!
 An MBML function implementation that returns an `NSDate` instance representing
 the current date and time.
 
 This function accepts no input.
 
 **MBML Example**
 
 The expression:
 
    ^currentTime()
 
 would return the same value that would result from calling the Objective-C
 method `+[NSDate date]`.
 
 @return    An `NSDate` instance representing the current date and time.
 */
+ (NSDate*) currentTime;

/*!
 An MBML function implementation that returns the number of seconds that have
 elapsed since the given past date.
 
 This function accepts a single expression parameter that is expected to yield
 an `NSDate` instance.
 
 **MBML Example**
 
 The expression:
 
    ^secondsSince($referenceDate)
 
 would return the number of seconds elapsed since `$referenceDate`.
 
 @param     date The function's input parameter.
 
 @return    An `NSNumber` instance containing the number of seconds since
            the input date; if the input date is in the future, the return
            value will be negative.
 */
+ (id) secondsSince:(NSDate*)date;

/*!
 An MBML function implementation that returns the number of seconds
 between now and the given future date.
 
 This function accepts a single expression parameter that is expected to yield
 an `NSDate` instance.
 
 **MBML Example**
 
 The expression:
 
    ^secondsUntil($referenceDate)
 
 would return the number of seconds until `$referenceDate`.
 
 @param     date The function's input parameter.
 
 @return    An `NSNumber` instance containing the number of seconds until
            the input date; if the input date is in the past, the return
            value will be negative.
 */
+ (id) secondsUntil:(NSDate*)date;

/*!
 An MBML function implementation that returns a date representation of the
 unix timestamp.
 
 This function accepts a single expression parameter that is expected to yield
 a number.
 
 **MBML Example**
 
 The expression:
 
 ^unixTimestampToDate($timestamp)
 
 would return the `NSDate` representation of `$timestamp`.
 
 @param     timestamp The function's input parameter.
 
 @return    An `NSDate` instance containing the date representation of given 
 timestamp.
 */
+ (id) unixTimestampToDate:(id)timestamp;

/*!
 An MBML function implementation that returns a unix timestamp representation 
 of the given date.
 
 This function accepts a single expression parameter that is expected to yield
 an `NSDate` instance.
 
 **MBML Example**
 
 The expression:
 
 ^dateToUnixTimestamp($referenceDate)
 
 would return the unix timestamp representation of `$referenceDate`.
 
 @param     date The function's input parameter.
 
 @return    An `NSNumber` instance containing the unix timestamp
 representation of the input date.
 */
+ (id) dateToUnixTimestamp:(NSDate*)date;

/*!
 An MBML function implementation that returns a string representation of the
 time until the given date.

 This function accepts a single expression parameter that is expected to yield
 an `NSDate` instance.

 **MBML Example**

 The expression:

 ^formatTimeUntil($referenceDate)

 would return the time until `$referenceDate`.

 @param     date The function's input parameter.

 @return    An `NSString` instance containing the time until
 the input date; if the input date is in the past, the return
 value will be negative.
 */
+ (id) formatTimeUntil:(NSDate*)date;

/*!
 An MBML function implementation that accepts a date and a format string, and
 returns a string representation of the date in the specified format.

 This function accepts two expressions as input parameters:

 * the *input date*, an `NSDate` or `NSString` that contains the date to format

 * an *output format*, specifying the date format to be used for creating the
 returned date string

 **MBML Example**

 The following expression:

    ^formatDate(^currentTime()|MM/dd/yy)

 would result in the string "`12/12/13`" if called on December 12th, 2013.

 @param     params The function's input parameters.

 @return    A date-formatted string.
 */
+ (id) formatDate:(NSArray*)input;

/*!
 An MBML function implementation that accepts a date and returns a date string
 formatted using the format "`YYYY-MM-dd HH:mm:ss`". This format ensures allows
 dates to be sorted using simple string sorting.

 This function accepts one input parameter, the *input date*, an `NSDate` or
 `NSString` that contains the date to format.

 **MBML Example**

 The following expression:

    ^formatSortableDate(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))

 would result in the string "`1972-10-27 10:53:42`".

 @param     input The function's input parameter.

 @return    The date-formatted string.

 @note      The time in the returned string will be in 24-hour format.
 */
+ (id) formatSortableDate:(id)input;

/*!
 An MBML function implementation that accepts a date and returns a date string
 formatted using the `NSDateFormatterShortStyle` format.
 
 This function accepts one of two expressions as input parameters:
 
 * the *input date*, an `NSDate` or `NSString` that contains the date to format
 
 * an optional *timezone string*, specifying the timezone to use when
 formatting the *input date* parameter (if this parameter is omitted, the local
 timezone is used)
 
 **MBML Example**
 
 The following expression:
 
    ^formatShortDate(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))

 would result in the string "`10/27/72`".
 
 @param     input The function's input parameter.
 
 @return    The date-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatShortDate:(id)input;

/*!
 An MBML function implementation that accepts a date and returns a date string
 formatted using the `NSDateFormatterMediumStyle` format.
 
 This function accepts one of two expressions as input parameters:
 
 * the *input date*, an `NSDate` or `NSString` that contains the date to format
 
 * an optional *timezone string*, specifying the timezone to use when
 formatting the *input date* parameter (if this parameter is omitted, the local
 timezone is used)
 
 **MBML Example**
 
 The following expression:
 
    ^formatMediumDate(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))

 would result in the string "`Oct 27, 1972`".
 
 @param     input The function's input parameter.
 
 @return    The date-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatMediumDate:(id)input;

/*!
 An MBML function implementation that accepts a date and returns a date string
 formatted using the `NSDateFormatterLongStyle` format.
 
 This function accepts one of two expressions as input parameters:
 
 * the *input date*, an `NSDate` or `NSString` that contains the date to format
 
 * an optional *timezone string*, specifying the timezone to use when
 formatting the *input date* parameter (if this parameter is omitted, the local
 timezone is used)
 
 **MBML Example**
 
 The following expression:
 
    ^formatLongDate(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))

 would result in the string "`October 27, 1972`".
 
 @param     input The function's input parameter.
 
 @return    The date-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatLongDate:(id)input;

/*!
 An MBML function implementation that accepts a date and returns a date string
 formatted using the `NSDateFormatterFullStyle` format.
 
 This function accepts one of two expressions as input parameters:
 
 * the *input date*, an `NSDate` or `NSString` that contains the date to format
 
 * an optional *timezone string*, specifying the timezone to use when
 formatting the *input date* parameter (if this parameter is omitted, the local
 timezone is used)

 **MBML Example**
 
 The following expression:
 
    ^formatFullDate(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))

 would result in the string "`Friday, October 27, 1972`".
 
 @param     input The function's input parameter.
 
 @return    The date-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatFullDate:(id)input;

/*!
 An MBML function implementation that accepts a date and returns a time string
 formatted using the `NSDateFormatterShortStyle` format.
 
 This function accepts a single expressions as input, an `NSDate` or `NSString`
 that contains the date to format.
 
 **MBML Example**
 
 The following expression:
 
    ^formatShortTime(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))
 
 would result in the string "`10:53 AM`".
 
 @param     input The function's input parameter.
 
 @return    The time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatShortTime:(id)input;

/*!
 An MBML function implementation that accepts a date and returns a time string
 formatted using the `NSDateFormatterMediumStyle` format.
 
 This function accepts a single expressions as input, an `NSDate` or `NSString`
 that contains the date to format.
 
 **MBML Example**
 
 The following expression:
 
    ^formatMediumTime(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))
 
 would result in the string "`10:53:42 AM`".
 
 @param     input The function's input parameter.
 
 @return    The time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatMediumTime:(id)input;

/*!
 An MBML function implementation that accepts a date and returns a time string
 formatted using the `NSDateFormatterLongStyle` format.
 
 This function accepts a single expressions as input, an `NSDate` or `NSString`
 that contains the date to format.
 
 **MBML Example**
 
 The following expression:
 
    ^formatLongTime(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))
 
 would result in the string "`10:53:42 AM EDT`".
 
 @param     input The function's input parameter.
 
 @return    The time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatLongTime:(id)input;

/*!
 An MBML function implementation that accepts a date and returns a time string
 formatted using the `NSDateFormatterFullStyle` format.
 
 This function accepts a single expressions as input, an `NSDate` or `NSString`
 that contains the date to format.
 
 **MBML Example**
 
 The following expression:
 
    ^formatFullTime(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))
 
 would result in the string "`10:53:42 AM Eastern Daylight Time`".
 
 @param     input The function's input parameter.
 
 @return    The time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatFullTime:(id)input;

/*!
 An MBML function implementation that accepts a date and returns a date/time
 string formatted using the `NSDateFormatterShortStyle` format.
 
 This function accepts a single expressions as input, an `NSDate` or `NSString`
 that contains the date to format.
 
 **MBML Example**
 
 The following expression:
 
    ^formatShortDateTime(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))
 
 would result in the string "`10/27/72, 10:53 AM`".
 
 @param     input The function's input parameter.
 
 @return    The date/time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatShortDateTime:(id)input;

/*!
 An MBML function implementation that accepts a date and returns a date/time
 string formatted using the `NSDateFormatterMediumStyle` format.
 
 This function accepts a single expressions as input, an `NSDate` or `NSString`
 that contains the date to format.
 
 **MBML Example**
 
 The following expression:
 
    ^formatMediumDateTime(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))
 
 would result in the string "`Oct 27, 1972, 10:53:42 AM`".
 
 @param     input The function's input parameter.
 
 @return    The date/time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatMediumDateTime:(id)input;

/*!
 An MBML function implementation that accepts a date and returns a date/time
 string formatted using the `NSDateFormatterLongStyle` format.
 
 This function accepts a single expressions as input, an `NSDate` or `NSString`
 that contains the date to format.
 
 **MBML Example**
 
 The following expression:
 
    ^formatLongDateTime(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))
 
 would result in the string "`October 27, 1972, 10:53:42 AM EDT`".
 
 @param     input The function's input parameter.
 
 @return    The date/time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatLongDateTime:(id)input;

/*!
 An MBML function implementation that accepts a date and returns a date/time
 string formatted using the `NSDateFormatterLongStyle` format.
 
 This function accepts a single expressions as input, an `NSDate` or `NSString`
 that contains the date to format.
 
 **MBML Example**
 
 The following expression:
 
    ^formatFullDateTime(^parseDate(Fri, 27 Oct 1972 10:53:42 EDT))
 
 would result in the string "`Friday, October 27, 1972, 10:53:42 AM Eastern
 Daylight Time`".
 
 @param     input The function's input parameter.
 
 @return    The date/time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatFullDateTime:(id)input;

/*!
 An MBML function implementation that accepts a date-formatted string and
 converts it into a date string of another format.
 
 This function accepts two or three expressions as input parameters:
 
 * the *input date*, a date-formatted string to be parsed,
 
 * an optional *input format*, specifying the date format used by the
 *input date* parameter (if this parameter is omitted, the default format
 used is the one specified by the `defaultDateParsingFormat` method), and
 
 * an *output format*, specifying the date format to be used for creating the
 returned date string
 
 **MBML Example**
 
 The following expression:
 
    ^reformatDate(27 Oct 1972|dd MMM yyyy|MM/dd/yy)

 would result in the string "`10/27/72`".
 
 @param     params The function's input parameters.
 
 @return    A date-formatted string.
 */
+ (id) reformatDate:(NSArray*)input;

/*!
 An MBML function implementation that accepts a date-formatted input string--
 along with a locale specification for that input string--and converts the
 input into a date string of another format.
 
 This function accepts three or four expressions as input parameters:
 
 * the *input date*, a date-formatted string to be parsed,
 
 * the *input date locale*, a string specifying the locale identifier of the
 *input date*'s locale,

 * an optional *input format*, specifying the date format used by the
 *input date* parameter (if this parameter is omitted, the default format
 used is the one specified by the `defaultDateParsingFormat` method), and
 
 * an *output format*, specifying the date format to be used for creating the
 returned date string
 
 **MBML Example**
 
 The following expression:
 
    ^reformatDateWithLocale(27 Oct 1972|en_US|dd MMM yyyy|MM/dd/yy)

 would result in the string "`10/27/72`".
 
 @param     params The function's input parameters.
 
 @return    A date-formatted string.
 */
+ (id) reformatDateWithLocale:(NSArray*)input;

/*!
 An MBML function implementation that attempts to construct an `NSDate`
 instance by parsing a string.
 
 This function accepts two or three expressions as input parameters:
 
 * the *date*, a string to be parsed
 
 * an optional *format string*, a string in the format that would be used
 by a `NSDateFormatter`. If this parameter is omitted, the value returned
 by the method `defaultDateParsingFormat` is used as the format string.
  
 **MBML Example**

 Assuming the default date parsing format hasn't been overridden by the 
 `$MBMLDateFunctions:dateParsingFormat` variable, this expression:
 
    ^parseDate(Thu, 26 Jan 2012 15:58:19 UTC)
 
 would return an `NSDate` instance representing a date equivalent to
 Thursday, January 26th, 2012 at 10:58:19AM in New York City (eastern standard 
 time, or the `America/New_York` timezone).
 
 @param     params The function's input parameters.
 
 @return    An `NSDate` representing the parsed date.
 
 @note      This function is exposed to the MBML environment as
            `^parseDate()`.
 */
+ (id) mbmlParseDate:(NSArray*)params;

/*!
 An MBML function implementation that returns the offset, in minutes, 
 between the current time zone and UTC.
 
 This function accepts no input.
 
 **MBML Example**
 
 The expression:
 
    ^timeZoneOffset()
 
 would return an `NSNumber` instance containing the time zone offset, in
 minutes.
 
 @return    The time zone offset.
 */
+ (NSNumber*) timeZoneOffset;

@end
