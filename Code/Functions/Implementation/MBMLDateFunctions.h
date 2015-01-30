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
 This class contains a set of MBML functions and supporting methods that provide
 date manipulation tools.

 These functions are exposed to the Mockingbird environment via
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.

 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLDateFunctions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Supporting methods
/*!    @name Supporting methods                                               */
/*----------------------------------------------------------------------------*/

/*!
 Returns the date parsing format used by default.
 
 First, the string expression `$MBMLDateFunctions:dateParsingFormat` is checked
 for a value; if a value is present, it is returned.
 
 Otherwise, the value of the constant `kRFC1123DateStringFormat` is returned.
  
 @return    The default date parsing format string.
 
 @note      This method is not exposed to the Mockingbird environment as a
            an MBML function.
 */
+ (NSString*) defaultDateParsingFormat;

/*!
 Returns the date parsing locale used by default.
 
 First, the string expression `$MBMLDateFunctions:dateParsingLocale` is checked
 for a value; if a value is present, it is used as the locale identifier.
 
 Otherwise, the value of the constant `kMBDateParsingLocaleVariableName` is
 used to construct the locale.

 If all else fails, the device's current locale is used.
  
 @return    The default date parsing locale.
 
 @note      This method is not exposed to the Mockingbird environment as a
            an MBML function.
 */
+ (NSLocale*) defaultDateParsingLocale;

/*!
 Returns a date-formatted string using the specified formatter style.
 
 @param     d8 The `NSDate` to format.
 
 @param     style The `NSDateFormatterStyle` to use for formatting the date.
 
 @param     timeZone The `NSTimeZone` to use for the output.
 
 @return    A string containing the formatted date.
 
 @note      This method is not exposed to the Mockingbird environment as a
            an MBML function.
 */
+ (NSString*) formatDate:(NSDate*)d8 withStyle:(NSDateFormatterStyle)style usingTimeZone:(NSTimeZone*)timeZone;

/*!
 Returns a time-formatted string using the specified formatter style.
 
 @param     d8 The `NSDate` to format.
 
 @param     style The `NSDateFormatterStyle` to use for formatting the time.
 
 @return    A string containing the formatted time.
 
 @note      This method is not exposed to the Mockingbird environment as a
            an MBML function.
 */
+ (NSString*) formatTime:(NSDate*)d8 withStyle:(NSDateFormatterStyle)style;

/*!
 Returns a date/time-formatted string using the specified formatter style.
 
 @param     d8 The `NSDate` to format.
 
 @param     style The `NSDateFormatterStyle` to use for formatting the
            date/time.
 
 @return    A string containing the formatted date/time.
 
 @note      This method is not exposed to the Mockingbird environment as a
            an MBML function.
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
 
 @note      This method is not exposed to the Mockingbird environment as a
            an MBML function. The `mbmlParseDate:` method implements the 
            `^parseDate()` MBML function.
 */
+ (NSDate*) parseDate:(NSString*)str
           fromLocale:(NSLocale*)locale
          usingFormat:(NSString*)dateFormat;

/*!
 Attempts to parse an `NSDate` from a string in the locale 
 `defaultDateParsingLocale` using the date format returned by the 
 method `defaultDateParsingFormat`.
 
 @param     str The date string to parse.
 
 @return    An `NSDate` representing the parsed date string, or `nil` if there
            was an error parsing the string.
 
 @note      This method is not exposed to the Mockingbird environment as a
            an MBML function. The `mbmlParseDate:` method implements the 
            `^parseDate()` MBML function.
 */
+ (NSDate*) parseDate:(NSString*)str;

/*----------------------------------------------------------------------------*/
#pragma mark Getting the current time
/*!    @name Getting the current time                                         */
/*----------------------------------------------------------------------------*/

/*!
 Returns an `NSDate` representing the current date and time.
 
 This Mockingbird function accepts no input parameters.
 
 #### Expression usage
 
 The expression:
 
    ^currentTime()
 
 returns an `NSDate` containing the current date and time.
 
 @return    An `NSDate` instance representing the present time.
 */
+ (NSDate*) currentTime;

/*----------------------------------------------------------------------------*/
#pragma mark Calculating time deltas to the present
/*!    @name Calculating time deltas to the present                           */
/*----------------------------------------------------------------------------*/

/*!
 Returns the number of seconds that have elapsed since the given time in
 the past.
 
 This Mockingbird function accepts a single object expression parameter
 yielding an `NSDate` instance.
 
 #### Expression usage
 
 The expression:
 
    ^secondsSince($referenceDate)
 
 would return the number of seconds elapsed since `$referenceDate`.
 
 @param     date The function's input parameter.
 
 @return    An `NSNumber` instance containing the number of seconds since
            the input date; if the input date is in the future, the return
            value will be negative.

 @see       secondsUntil:
 */
+ (id) secondsSince:(NSDate*)date;

/*!
 Returns the number of seconds between the present time and the given time
 in the future.
 
 This Mockingbird function accepts a single parameter: an object expression
 expected to yield an `NSDate` instance.

 #### Expression usage
 
 The expression:
 
    ^secondsUntil($referenceDate)
 
 would return the number of seconds until `$referenceDate`.
 
 @param     date The function's input parameter.
 
 @return    An `NSNumber` instance containing the number of seconds until
            the input date; if the input date is in the past, the return
            value will be negative.

 @see       secondsSince:
 */
+ (id) secondsUntil:(NSDate*)date;

/*----------------------------------------------------------------------------*/
#pragma mark Converting to and from UNIX timestamps
/*!    @name Converting to and from UNIX timestamps                           */
/*----------------------------------------------------------------------------*/

/*!
 Converts a UNIX timestamp into an `NSDate`.

 This Mockingbird function accepts a single numeric expression as an input
 parameter: the UNIX timestamp.
 
 #### Expression usage
 
 The expression:
 
    ^unixTimestampToDate(1355283900)

 would return an `NSDate` representing 10:45PM ET on December 11, 2012.

 @param     timestamp The function's input parameter.
 
 @return    An `NSDate` instance containing the date representation of given 
            timestamp.
 
 @see       dateToUnixTimestamp:
 */
+ (id) unixTimestampToDate:(id)timestamp;

/*!
 Returns the UNIX timestamp representation of a given `NSDate`.
 
 This Mockingbird function accepts a single input parameter: an object
 expression yielding an `NSDate` instance.
 
 #### Expression usage
 
 The expression:
 
    ^dateToUnixTimestamp(^currentTime())
 
 would return the UNIX timestamp representation of the present time.
 
 @param     date The function's input parameter.
 
 @return    An `NSNumber` instance containing the UNIX timestamp
            representation of the input date.
 
 @see       unixTimestampToDate:
 */
+ (id) dateToUnixTimestamp:(NSDate*)date;

/*----------------------------------------------------------------------------*/
#pragma mark Date/time addition
/*!    @name Date/time addition                                               */
/*----------------------------------------------------------------------------*/

/*!
 Returns an `NSDate` representing the given date plus the specified number
 of seconds.

 This Mockingbird function accepts two expressions as input parameters:

 * *seconds*, a numeric expression specifying the number of seconds add
    to the *input date*

 * the *input date*, an object expression yielding an `NSDate` or date-formatted
   `NSString` containing the date to which *seconds* will be added

 #### Expression usage

 The following expression:

    ^addSecondsToDate(30|^currentTime())

 would result in an `NSDate` 30 seconds from the present time.

 @param     params The function's input parameters.

 @return    The adjusted date.
  */
+ (id) addSecondsToDate:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Date/time formatting
/*!    @name Date/time formatting                                             */
/*----------------------------------------------------------------------------*/

/*!
 Returns a string representation of the time remaining until the given date.

 This Mockingbird function accepts a single parameter: an object expression
 expected to yield an `NSDate` instance.

 #### Expression usage

 The expression:

    ^formatTimeUntil(^addSecondsToDate(300|^currentTime()))

 would return the string "`5:00`", indicating that there are 5 minutes until
 the time that's 300 seconds in the future.

 @param     date The function's input parameter.

 @return    An `NSString` instance containing the time until the input date.
 */
+ (id) formatTimeUntil:(NSDate*)date;

/*!
 Accepts a date and a format string, and returns a string representation of the
 date in the specified format.

 This Mockingbird function accepts two expressions as input parameters:

 * the *input date*, an `NSDate` or date-formatted `NSString`

 * the *output format* specifying the date format used to create the returned
   date string

 #### Expression usage

 The following expression:

    ^formatDate(^currentTime()|MM/dd/yy)

 would result in the string "`12/12/13`" if called on December 12th, 2013.

 @param     params The function's input parameters.

 @return    A date-formatted string.
 */
+ (id) formatDate:(NSArray*)params;

/*!
 Accepts a date and returns a date string formatted using the format
 "`YYYY-MM-dd HH:mm:ss`". This format ensures allows dates to be sorted using
 simple string sorting.

 This Mockingbird function accepts a single input parameter, an object
 expression yielding either an `NSDate` or a date-formatted `NSString`
 containing the date to format.

 #### Expression usage

 The following expression:

    ^formatSortableDate(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))

 would result in the string "`1986-10-26 00:02:00`".

 @param     input The function's input parameter.

 @return    The date-formatted string.

 @note      The time in the returned string will be in 24-hour format.
 */
+ (id) formatSortableDate:(id)input;

/*!
 Accepts a date and returns a date string formatted using the
 `NSDateFormatterShortStyle` format.
 
 This Mockingbird function accepts one of two expressions as input parameters:
 
 * the *input date*, an `NSDate` or `NSString` that contains the date to format
 
 * an optional *timezone string*, specifying the timezone to use when
 formatting the *input date* parameter (if this parameter is omitted, the local
 timezone is used)
 
 #### Expression usage
 
 The following expression:
 
    ^formatShortDate(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))

 would result in the string "`10/26/86`".
 
 @param     input The function's input parameter.
 
 @return    The date-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatShortDate:(id)input;

/*!
 Accepts a date and returns a date string formatted using the
 `NSDateFormatterMediumStyle` format.
 
 This Mockingbird function accepts one of two expressions as input parameters:
 
 * the *input date*, an `NSDate` or `NSString` that contains the date to format
 
 * an optional *timezone string*, specifying the timezone to use when
 formatting the *input date* parameter (if this parameter is omitted, the local
 timezone is used)
 
 #### Expression usage
 
 The following expression:
 
    ^formatMediumDate(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))

 would result in the string "`Oct 26, 1986`".
 
 @param     input The function's input parameter.
 
 @return    The date-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatMediumDate:(id)input;

/*!
 Accepts a date and returns a date string formatted using the
 `NSDateFormatterLongStyle` format.
 
 This Mockingbird function accepts one of two expressions as input parameters:
 
 * the *input date*, an `NSDate` or `NSString` that contains the date to format
 
 * an optional *timezone string*, specifying the timezone to use when
 formatting the *input date* parameter (if this parameter is omitted, the local
 timezone is used)
 
 #### Expression usage
 
 The following expression:
 
    ^formatLongDate(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))

 would result in the string "`October 26, 1986`".
 
 @param     input The function's input parameter.
 
 @return    The date-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatLongDate:(id)input;

/*!
 Accepts a date and returns a date string formatted using the
 `NSDateFormatterFullStyle` format.
 
 This Mockingbird function accepts one of two expressions as input parameters:
 
 * the *input date*, an `NSDate` or `NSString` that contains the date to format
 
 * an optional *timezone string*, specifying the timezone to use when
 formatting the *input date* parameter (if this parameter is omitted, the local
 timezone is used)

 #### Expression usage
 
 The following expression:
 
    ^formatFullDate(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))

 would result in the string "`Sunday, October 26, 1986`".
 
 @param     input The function's input parameter.
 
 @return    The date-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatFullDate:(id)input;

/*!
 Accepts a date and returns a date string formatted using the
 `NSDateFormatterShortStyle` format.
 
 This Mockingbird function accepts a single input parameter, an object
 expression yielding either an `NSDate` or a date-formatted `NSString`
 containing the date to format.

 #### Expression usage
 
 The following expression:
 
    ^formatShortTime(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))
 
 would result in the string "`12:02 AM`".
 
 @param     input The function's input parameter.
 
 @return    The time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatShortTime:(id)input;

/*!
 Accepts a date and returns a date string formatted using the
 `NSDateFormatterMediumStyle` format.
 
 This Mockingbird function accepts a single input parameter, an object
 expression yielding either an `NSDate` or a date-formatted `NSString`
 containing the date to format.

 #### Expression usage
 
 The following expression:
 
    ^formatMediumTime(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))
 
 would result in the string "`12:02:00 AM`".
 
 @param     input The function's input parameter.
 
 @return    The time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatMediumTime:(id)input;

/*!
 Accepts a date and returns a date string formatted using the
 `NSDateFormatterLongStyle` format.
 
 This Mockingbird function accepts a single input parameter, an object
 expression yielding either an `NSDate` or a date-formatted `NSString`
 containing the date to format.

 #### Expression usage
 
 The following expression:
 
    ^formatLongTime(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))
 
 would result in the string "`12:02:00 AM EDT`".
 
 @param     input The function's input parameter.
 
 @return    The time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatLongTime:(id)input;

/*!
 Accepts a date and returns a date string formatted using the
 `NSDateFormatterFullStyle` format.
 
 This Mockingbird function accepts a single input parameter, an object
 expression yielding either an `NSDate` or a date-formatted `NSString`
 containing the date to format.

 #### Expression usage
 
 The following expression:
 
    ^formatFullTime(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))
 
 would result in the string "`12:02:00 AM Eastern Daylight Time`".
 
 @param     input The function's input parameter.
 
 @return    The time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatFullTime:(id)input;

/*!
 Accepts a date and returns a date string formatted using the
 `NSDateFormatterShortStyle` format.
 
 This Mockingbird function accepts a single input parameter, an object
 expression yielding either an `NSDate` or a date-formatted `NSString`
 containing the date to format.

 #### Expression usage
 
 The following expression:
 
    ^formatShortDateTime(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))
 
 would result in the string "`10/26/86, 12:02 AM`".
 
 @param     input The function's input parameter.
 
 @return    The date/time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatShortDateTime:(id)input;

/*!
 Accepts a date and returns a date string formatted using the
 `NSDateFormatterMediumStyle` format.
 
 This Mockingbird function accepts a single input parameter, an object
 expression yielding either an `NSDate` or a date-formatted `NSString`
 containing the date to format.

 #### Expression usage
 
 The following expression:
 
    ^formatMediumDateTime(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))
 
 would result in the string "`Oct 26, 1986, 12:02:00 AM`".
 
 @param     input The function's input parameter.
 
 @return    The date/time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatMediumDateTime:(id)input;

/*!
 Accepts a date and returns a date string formatted using the
 `NSDateFormatterLongStyle` format.
 
 This Mockingbird function accepts a single input parameter, an object
 expression yielding either an `NSDate` or a date-formatted `NSString`
 containing the date to format.

 #### Expression usage
 
 The following expression:
 
    ^formatLongDateTime(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))
 
 would result in the string "`October 26, 1986 at 12:02:00 AM EDT`".
 
 @param     input The function's input parameter.
 
 @return    The date/time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatLongDateTime:(id)input;

/*!
 Accepts a date and returns a date string formatted using the
 `NSDateFormatterLongStyle` format.
 
 This Mockingbird function accepts a single input parameter, an object
 expression yielding either an `NSDate` or a date-formatted `NSString`
 containing the date to format.

 #### Expression usage
 
 The following expression:
 
    ^formatFullDateTime(^parseDate(Sun, 26 Oct 1986 00:02:00 EDT))
 
 would result in the string "`Sunday, October 26, 1986 at 12:02:00 AM Eastern 
 Daylight Time`".
 
 @param     input The function's input parameter.
 
 @return    The date/time-formatted string.
 
 @note      The string returned depends on the device's locale settings
            and may not match the example above.
 */
+ (id) formatFullDateTime:(id)input;

/*----------------------------------------------------------------------------*/
#pragma mark Converting from one string format to another
/*!    @name Converting from one string format to another                     */
/*----------------------------------------------------------------------------*/

/*!
 Accepts a date-formatted string and converts it into a date string of
 another format.
 
 This Mockingbird function accepts two or three pipe-separated expressions as
 input parameters:
 
 * the *input date*, a date-formatted string to be parsed
 
 * an optional *input format*, specifying the date format used by the
 *input date* parameter (if this parameter is omitted, the default format
 used is the one specified by the `defaultDateParsingFormat` method)
 
 * an *output format*, specifying the date format to be used for creating the
 returned date string
 
 #### Expression usage
 
 The following expression:
 
    ^reformatDate(26 Oct 1986|dd MMM yyyy|MM/dd/yy)

 would result in the string "`10/26/86`".
 
 @param     params The function's input parameters.
 
 @return    A date-formatted string.
 
 @see       reformatDateWithLocale:
 */
+ (id) reformatDate:(NSArray*)params;

/*!
 Accepts a date-formatted input string—along with a locale specification for
 that input string—and converts the input into a date string of another format.
 
 This Mockingbird function accepts three or four pipe-separated expressions as
 input parameters:
 
 * the *input date*, a date-formatted string to be parsed
 
 * the *input date locale*, a string specifying the locale identifier of the
 *input date*'s locale

 * an optional *input format*, specifying the date format used by the
 *input date* parameter (if this parameter is omitted, the default format
 used is the one specified by the `defaultDateParsingFormat` method)
 
 * an *output format*, specifying the date format to be used for creating the
 returned date string
 
 #### Expression usage
 
 The following expression:
 
    ^reformatDateWithLocale(26 Oct 1986|en_US|dd MMM yyyy|MM/dd/yy)

 would result in the string "`10/26/86`".
 
 @param     params The function's input parameters.
 
 @return    A date-formatted string.

 @see       reformatDate:
 */
+ (id) reformatDateWithLocale:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Parsing date strings
/*!    @name Parsing date strings                                             */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to construct an `NSDate` instance by parsing a string.
 
 This Mockingbird function accepts two or three pipe-separated expressions
 as input parameters:
 
 * the *date*, a string to be parsed
 
 * an optional *format string*, a string in the format that would be used
 by a `NSDateFormatter`. If this parameter is omitted, the value returned
 by the method `defaultDateParsingFormat` is used as the format string.
  
 #### Expression usage

 **Note:** This function is exposed to the Mockingbird environment with a
 name that differs from that of its implementing method.

 Assuming the default date parsing format hasn't been overridden by the 
 `$MBMLDateFunctions:dateParsingFormat` variable, this expression:
 
    ^parseDate(Thu, 26 Jan 2012 15:58:19 UTC)
 
 would return an `NSDate` instance representing a date equivalent to
 Thursday, January 26th, 2012 at 10:58:19AM in New York City (eastern standard 
 time, or the `America/New_York` timezone).
 
 @param     params The function's input parameters.
 
 @return    An `NSDate` representing the parsed date.
 */
+ (id) mbmlParseDate:(NSArray*)params;

/*----------------------------------------------------------------------------*/
#pragma mark Time zone information
/*!    @name Time zone information                                            */
/*----------------------------------------------------------------------------*/

/*!
 Returns the offset, in minutes, between the current time zone and UTC.
 
 This Mockingbird function accepts no input.
 
 #### Expression usage
 
 The expression:
 
    ^timeZoneOffset()
 
 would return an `NSNumber` instance containing the time zone offset, in
 minutes.
 
 @return    The time zone offset.
 */
+ (NSNumber*) timeZoneOffset;

@end
