//
//  MBMLDateFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/11/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBMLDateFunctions.h"
#import "MBMLFunction.h"
#import "MBVariableSpace.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

NSString* const kMBDateRFC1123StringFormat          = @"EEE, dd MMM yyyy HH:mm:ss zzz";
NSString* const kMBDateSortableStringFormat         = @"YYYY-MM-dd HH:mm:ss";
NSString* const kMBDateParsingFormatVariableName    = @"MBMLDateFunctions:dateParsingFormat";
NSString* const kMBDateParsingLocaleVariableName    = @"MBMLDateFunctions:dateParsingLocale";
NSString* const kMBDateDefaultParsingLocale         = @"en_US_POSIX";

/******************************************************************************/
#pragma mark -
#pragma mark MBMLDateFunctions implementation
/******************************************************************************/

@implementation MBMLDateFunctions

/******************************************************************************/
#pragma mark Getting the current time
/******************************************************************************/

+ (NSDate*) currentTime
{
    return [NSDate date];
}

/******************************************************************************/
#pragma mark Getting the time zone offset
/******************************************************************************/

+ (NSNumber*) timeZoneOffset
{
    return @([[NSTimeZone localTimeZone] secondsFromGMT] / 60);
}

/******************************************************************************/
#pragma mark Date arithmetic
/******************************************************************************/

+ (MBMLFunctionError*) _validateIsDate:(id)test
{
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:test isKindOfClass:[NSDate class] error:&err];
    return err;
}

+ (id) secondsSince:(NSDate*)date
{
    debugTrace();
    
    MBMLFunctionError* err = [self _validateIsDate:date];
    if (err) return err;
    
    return @((NSInteger)[date timeIntervalSinceNow] * -1);
}

+ (id) secondsUntil:(NSDate*)date
{
    debugTrace();
    
    MBMLFunctionError* err = [self _validateIsDate:date];
    if (err) return err;

    return @((NSInteger)[date timeIntervalSinceNow]);
}

+ (id)unixTimestampToDate:(id)timestamp
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSNumber* timestampNumber = [MBMLFunction validateParameterContainsNumber:timestamp error:&err];
    if (err) {
        return err;
    }
    return [NSDate dateWithTimeIntervalSince1970:[timestampNumber doubleValue]];
}

+ (id)dateToUnixTimestamp:(NSDate *)date
{
    debugTrace();
    
    MBMLFunctionError* err = [self _validateIsDate:date];
    if (err) return err;
    
    return @((NSInteger)[date timeIntervalSince1970]);
}

+ (id) addSecondsToDate:(NSArray *)input
{
    debugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:input countIs:2 error:&err];

    NSTimeInterval interval = [input[0] doubleValue];
    
    NSDate* d8 = [self _dateFromObject:input[1] error:&err];
    if (err) return err;

    return [d8 dateByAddingTimeInterval:interval];
}

+ (id) formatTimeUntil:(NSDate*)date
{
    debugTrace();

    MBMLFunctionError* err = [self _validateIsDate:date];
    if (err) return err;

    int secondsNow    = (int)[[NSDate date] timeIntervalSince1970];
    int targetSeconds = (int)[date timeIntervalSince1970];
    int diffSeconds   = targetSeconds - secondsNow;
    int days          = (int)((double)diffSeconds / (3600.00 * 24.00));
    int diffDay       = diffSeconds - (days * 3600 * 24);
    int hours         = (int)((double)diffDay / 3600.00);
    int diffMin       = diffDay - (hours * 3600);
    int minutes       = (int)(diffMin / 60.0);
    int seconds       = diffMin - (minutes * 60);

    NSString* formattedStr = (hours > 0) ? [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds] : [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];

    return formattedStr.length > 1 && [formattedStr characterAtIndex:0] == '0' ? [formattedStr substringFromIndex:1] : formattedStr;
}

/******************************************************************************/
#pragma mark Determining parsing formats
/******************************************************************************/

+ (NSString*) defaultDateParsingFormat
{
    return [[MBVariableSpace instance] variableAsString:kMBDateParsingFormatVariableName
                                           defaultValue:kMBDateRFC1123StringFormat];
}

+ (NSLocale*) defaultDateParsingLocale
{
    NSLocale* locale = nil;
    NSString* localeStr = [[MBVariableSpace instance] variableAsString:kMBDateParsingLocaleVariableName
                                                          defaultValue:kMBDateDefaultParsingLocale];
    if (localeStr) {
        locale = [NSLocale localeWithLocaleIdentifier:localeStr];
    }
    if (!locale) {
        locale = [NSLocale currentLocale];
    }
    return locale;
}

/******************************************************************************/
#pragma mark Parsing date/time strings into NSDate objects
/******************************************************************************/

+ (NSDate*) parseDate:(NSString*)str
           fromLocale:(NSLocale*)locale
          usingFormat:(NSString*)dateFormat
{
    if (str && dateFormat) {
        NSDateFormatter* df = [NSDateFormatter new];
        [df setDateFormat:dateFormat];
        if (locale) {
            [df setLocale:locale];
        }

        return [df dateFromString:str];
    }
    return nil;
}

+ (NSDate*) parseDate:(NSString*)str
{
    return [self parseDate:str
                fromLocale:[self defaultDateParsingLocale]
               usingFormat:[self defaultDateParsingFormat]];
}

+ (MBMLFunctionError*) errorForFailingToParseDate:(NSString*)dateStr
                                       fromLocale:(NSLocale*)locale
                                       withFormat:(NSString*)format
{
    return [MBMLFunctionError errorWithFormat:@"couldn't parse date from input \"%@\" in locale \"%@\" using format \"%@\"", dateStr, locale.localeIdentifier, format];
}

+ (MBMLFunctionError*) errorForFailingToParseDate:(NSString*)dateStr
{
    return [self errorForFailingToParseDate:dateStr
                                 fromLocale:[self defaultDateParsingLocale]
                                 withFormat:[self defaultDateParsingFormat]];
}

+ (id) mbmlParseDate:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params 
                                           countIsAtLeast:1
                                                andAtMost:2
                                                    error:&err];
    if (paramCnt > 0) {
        [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
        if (paramCnt > 1) {
            [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
        }
    }
    if (err) return err;
    
    NSString* parse = params[0];
    NSString* format = nil;
    if (paramCnt > 1) {
        format = params[1];
    }
    else {
        format = [self defaultDateParsingFormat];
    }

    NSLocale* locale = [self defaultDateParsingLocale];
    
    NSDate* d8 = [self parseDate:parse
                      fromLocale:locale
                     usingFormat:format];
    if (d8) return d8;
    
    return [self errorForFailingToParseDate:parse
                                 fromLocale:locale
                                 withFormat:format];
}

/******************************************************************************/
#pragma mark Converting NSDates to strings
/******************************************************************************/

+ (NSString*) formatDate:(NSDate*)d8 withStyle:(NSDateFormatterStyle)style usingTimeZone:(NSTimeZone *)timeZone
{
    NSDateFormatter* df = [NSDateFormatter new];
    [df setTimeZone:timeZone];
    [df setDateStyle:style];
    [df setTimeStyle:NSDateFormatterNoStyle];
    NSString* formatted = [df stringFromDate:d8];
    
    return formatted;
}

+ (NSString*) formatTime:(NSDate*)d8 withStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter* df = [NSDateFormatter new];
    [df setDateStyle:NSDateFormatterNoStyle];
    [df setTimeStyle:style];
    NSString* formatted = [df stringFromDate:d8];
    
    return formatted;
}

+ (NSString*) formatDateTime:(NSDate*)d8 withStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter* df = [NSDateFormatter new];
    [df setDateStyle:style];
    [df setTimeStyle:style];
    NSString* formatted = [df stringFromDate:d8];
    
    return formatted;
}

/******************************************************************************/
#pragma mark Formatting dates and date strings
/******************************************************************************/

+ (NSDate*) _dateFromObject:(id)obj error:(MBMLFunctionError**)errPtr
{
    if (![MBMLFunction validateParameter:obj
                        isOneKindOfClass:@[(id)[NSString class], (id)[NSDate class]]
                                   error:errPtr])
    {
        return nil;
    }
    
    if ([obj isKindOfClass:[NSDate class]]) {
        return (NSDate*)obj;
    }
    else {
        NSString* dateStr = (NSString*)obj;
        NSDate* d8 = [self parseDate:dateStr];
        if (!d8) {
            [[self errorForFailingToParseDate:dateStr] reportErrorTo:errPtr];
        }
        return d8;
    }
}

+ (id) formatDate:(NSArray*)input
{
    debugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:input countIs:2 error:&err];
    if (err) return err;
    
    NSDate* d8 = [self _dateFromObject:input[0] error:&err];
    if (err) return err;

    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:input[1]];

    return [formatter stringFromDate:d8];
}

+ (id) formatSortableDate:(id)input
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSDate* d8 = [self _dateFromObject:input error:&err];
    if (err) return err;

    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:kMBDateSortableStringFormat];

    return [formatter stringFromDate:d8];
}

+ (id) formatShortDate:(id)input
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:input
                                           countIsAtLeast:1
                                                andAtMost:2
                                                    error:&err];
    if (err) return err;
    
    NSDate* d8 = [self _dateFromObject:input[0] error:&err];
    NSTimeZone* timeZone = paramCnt == 2 ? [NSTimeZone timeZoneWithAbbreviation:input[1]] : [NSTimeZone localTimeZone];
    if (err) return err;

    return [self formatDate:d8 withStyle:NSDateFormatterShortStyle usingTimeZone:timeZone];
}

+ (id) formatMediumDate:(id)input
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:input
                                           countIsAtLeast:1
                                                andAtMost:2
                                                    error:&err];
    if (err) return err;
    
    NSDate* d8 = [self _dateFromObject:input[0] error:&err];
    NSTimeZone* timeZone = paramCnt == 2 ? [NSTimeZone timeZoneWithAbbreviation:input[1]] : [NSTimeZone localTimeZone];
    if (err) return err;

    return [self formatDate:d8 withStyle:NSDateFormatterMediumStyle usingTimeZone:timeZone];
}

+ (id) formatLongDate:(id)input
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:input
                                           countIsAtLeast:1
                                                andAtMost:2
                                                    error:&err];
    if (err) return err;
    
    NSDate* d8 = [self _dateFromObject:input[0] error:&err];
    NSTimeZone* timeZone = paramCnt == 2 ? [NSTimeZone timeZoneWithAbbreviation:input[1]] : [NSTimeZone localTimeZone];
    if (err) return err;

    return [self formatDate:d8 withStyle:NSDateFormatterLongStyle usingTimeZone:timeZone];
}

+ (id) formatFullDate:(id)input
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:input
                                           countIsAtLeast:1
                                                andAtMost:2
                                                    error:&err];
    if (err) return err;
    
    NSDate* d8 = [self _dateFromObject:input[0] error:&err];
    NSTimeZone* timeZone = paramCnt == 2 ? [NSTimeZone timeZoneWithAbbreviation:input[1]] : [NSTimeZone localTimeZone];
    if (err) return err;

    return [self formatDate:d8 withStyle:NSDateFormatterFullStyle usingTimeZone:timeZone];
}

+ (id) formatShortTime:(id)input
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSDate* d8 = [self _dateFromObject:input error:&err];
    if (err) return err;

    return [self formatTime:d8 withStyle:NSDateFormatterShortStyle];
}

+ (id) formatMediumTime:(id)input
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSDate* d8 = [self _dateFromObject:input error:&err];
    if (err) return err;

    return [self formatTime:d8 withStyle:NSDateFormatterMediumStyle];
}

+ (id) formatLongTime:(id)input
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSDate* d8 = [self _dateFromObject:input error:&err];
    if (err) return err;

    return [self formatTime:d8 withStyle:NSDateFormatterLongStyle];
}

+ (id) formatFullTime:(id)input
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSDate* d8 = [self _dateFromObject:input error:&err];
    if (err) return err;

    return [self formatTime:d8 withStyle:NSDateFormatterFullStyle];
}

+ (id) formatShortDateTime:(id)input
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSDate* d8 = [self _dateFromObject:input error:&err];
    if (err) return err;

    return [self formatDateTime:d8 withStyle:NSDateFormatterShortStyle];
}

+ (id) formatMediumDateTime:(id)input
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSDate* d8 = [self _dateFromObject:input error:&err];
    if (err) return err;

    return [self formatDateTime:d8 withStyle:NSDateFormatterMediumStyle];
}

+ (id) formatLongDateTime:(id)input
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSDate* d8 = [self _dateFromObject:input error:&err];
    if (err) return err;

    return [self formatDateTime:d8 withStyle:NSDateFormatterLongStyle];
}

+ (id) formatFullDateTime:(id)input
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSDate* d8 = [self _dateFromObject:input error:&err];
    if (err) return err;

    return [self formatDateTime:d8 withStyle:NSDateFormatterFullStyle];
}

/******************************************************************************/
#pragma mark Date string reformatting
/******************************************************************************/

+ (id) reformatDate:(NSArray*)input
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:input
                                           countIsAtLeast:2
                                                andAtMost:3
                                                    error:&err];
    if (err) return err;

    NSString* dateStr = input[0];
    NSString* fmtIn = (paramCnt == 3 ? input[1] : [self defaultDateParsingFormat]);
    NSString* fmtOut = input[paramCnt-1];

    NSLocale* locale = [self defaultDateParsingLocale];

    NSDate* d8 = [self parseDate:dateStr
                      fromLocale:locale
                     usingFormat:fmtIn];
    if (!d8) {
        return [self errorForFailingToParseDate:dateStr
                                     fromLocale:locale
                                     withFormat:fmtIn];
    }

    NSDateFormatter* df = [NSDateFormatter new];
    [df setDateFormat:fmtOut];
    NSString* formatted = [df stringFromDate:d8];
    
    return formatted;
}

+ (id) reformatDateWithLocale:(NSArray*)input
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:input
                                           countIsAtLeast:3
                                                andAtMost:4
                                                    error:&err];
    if (err) return err;

    NSString* dateStr = input[0];
    NSLocale* locale = [NSLocale localeWithLocaleIdentifier:input[1]];
    NSString* fmtIn = (paramCnt == 4 ? input[2] : [self defaultDateParsingFormat]);
    NSString* fmtOut = input[paramCnt-1];

    NSDate* d8 = [self parseDate:dateStr
                      fromLocale:locale
                     usingFormat:fmtIn];
    if (!d8) {
        return [self errorForFailingToParseDate:dateStr
                                     fromLocale:locale
                                     withFormat:fmtIn];
    }

    NSDateFormatter* df = [NSDateFormatter new];
    [df setDateFormat:fmtOut];
    NSString* formatted = [df stringFromDate:d8];

    return formatted;
}

@end
