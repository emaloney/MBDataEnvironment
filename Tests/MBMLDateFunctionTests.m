//
//  MBMLDateFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBAvailability.h>
#import "MBDataEnvironmentTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLDateFunctionTests class
/******************************************************************************/

@interface MBMLDateFunctionTests : MBDataEnvironmentTestSuite
@end

//
// IMPORTANT NOTE: These tests may fail if run on a system
// with different localization settings. These tests should
// succeed on a system with US English in the Eastern timezone.
//

@implementation MBMLDateFunctionTests

/*
    <Function class="MBMLDateFunctions" name="currentTime" input="none"/>
    <Function class="MBMLDateFunctions" name="timeZoneOffset" input="none"/>
    <Function class="MBMLDateFunctions" name="secondsSince"/>
    <Function class="MBMLDateFunctions" name="secondsUntil"/>
    <Function class="MBMLDateFunctions" name="unixTimestampToDate"/>
    <Function class="MBMLDateFunctions" name="dateToUnixTimestamp"/>
    <Function class="MBMLDateFunctions" name="addSecondsToDate" input="pipedObjects"/>
    <Function class="MBMLDateFunctions" name="formatTimeUntil"/>
    <Function class="MBMLDateFunctions" name="formatDate" input="pipedObjects"/>
    <Function class="MBMLDateFunctions" name="formatSortableDate" input="object"/>
    <Function class="MBMLDateFunctions" name="formatShortDate" input="pipedObjects"/>
    <Function class="MBMLDateFunctions" name="formatMediumDate" input="pipedObjects"/>
    <Function class="MBMLDateFunctions" name="formatLongDate" input="pipedObjects"/>
    <Function class="MBMLDateFunctions" name="formatFullDate" input="pipedObjects"/>
    <Function class="MBMLDateFunctions" name="formatShortTime" input="object"/>
    <Function class="MBMLDateFunctions" name="formatMediumTime" input="object"/>
    <Function class="MBMLDateFunctions" name="formatLongTime" input="object"/>
    <Function class="MBMLDateFunctions" name="formatFullTime" input="object"/>
    <Function class="MBMLDateFunctions" name="formatShortDateTime" input="object"/>
    <Function class="MBMLDateFunctions" name="formatMediumDateTime" input="object"/>
    <Function class="MBMLDateFunctions" name="formatLongDateTime" input="object"/>
    <Function class="MBMLDateFunctions" name="formatFullDateTime" input="object"/>
    <Function class="MBMLDateFunctions" name="reformatDate" input="pipedStrings"/>
    <Function class="MBMLDateFunctions" name="reformatDateWithLocale" input="pipedStrings"/>
    <Function class="MBMLDateFunctions" name="parseDate" method="mbmlParseDate" input="pipedStrings"/>
 */

/******************************************************************************/
#pragma mark Setup / Teardown
/******************************************************************************/

- (void) setUpVariableSpace:(MBVariableSpace*)vars
{
    MBLogInfoTrace();

    [super setUpVariableSpace:vars];

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    NSDate* date = [MBExpression asObject:@"^parseDate(Sun, 26 Oct 1986 00:02:00 EDT)"];
    scope[@"testDate"] = date;
    scope[@"testTimestamp"] = @([date timeIntervalSince1970]);
}

- (void) tearDown
{
    MBLogInfoTrace();

    [MBScopedVariables exitVariableScope];

    [super tearDown];
}

/******************************************************************************/
#pragma mark Helper methods
/******************************************************************************/

- (void) _performDateFormatTest:(NSString*)functionName
                          input:(NSString*)input
                      expecting:(NSString*)expectedResult
{
    NSString* expr = [NSString stringWithFormat:@"^%@(%@)", functionName, input];
    NSString* dateStr = [MBExpression asString:expr];
    XCTAssertEqualObjects(dateStr, expectedResult, @"Test of %@ failed (note, date tests may only work in US locale in EST timezone)", expr);
}

- (void) _performDateFormatFailureTest:(NSString*)functionName
{
    MBExpressionError* err = nil;
    NSString* expr = [NSString stringWithFormat:@"^%@()", functionName];
    [MBExpression asString:expr error:&err];
    expectError(err);

    err = nil;
    expr = [NSString stringWithFormat:@"^%@(this should not parse)", functionName];
    [MBExpression asString:expr error:&err];
    expectError(err);
}

/******************************************************************************/
#pragma mark Tests
/******************************************************************************/

- (void) testCurrentTime
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSDate* date = [MBExpression asObject:@"^currentTime()"];
    XCTAssertTrue([date isKindOfClass:[NSDate class]]);
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    XCTAssertTrue(interval < 1);
}

- (void) testTimeZoneOffset
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSNumber* testOffset = @([[NSTimeZone localTimeZone] secondsFromGMT] / 60);
    NSNumber* offset = [MBExpression asNumber:@"^timeZoneOffset()"];
    XCTAssertTrue([offset isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(offset, testOffset);
}

- (void) testSecondsSince
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSDate* date = [@"$testDate" evaluateAsObject];
    NSTimeInterval secondsSince = [[NSDate date] timeIntervalSinceDate:date];
    NSTimeInterval testSecondsSince = [[MBExpression asString:@"^secondsSince($testDate)"] doubleValue];
    NSTimeInterval diff = secondsSince - testSecondsSince;
    XCTAssertTrue(diff < 1);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^secondsSince()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^secondsSince(this is not my beautiful house)" error:&err];
    expectError(err);
}

- (void) testSecondsUntil
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSDate* date = [@"$testDate" evaluateAsObject];
    NSTimeInterval secondsUntil = [date timeIntervalSinceNow];
    NSTimeInterval testSecondsUntil = [[MBExpression asString:@"^secondsUntil($testDate)"] doubleValue];
    NSTimeInterval diff = secondsUntil - testSecondsUntil;
    XCTAssertTrue(diff < 1);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^secondsUntil()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^secondsUntil($NULL)" error:&err];
    expectError(err);
}

- (void) testUnixTimestampToDate
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSNumber* unixTimestampNum = [@"$testTimestamp" evaluateAsNumber];
    NSDate* date = [MBExpression asObject:@"^unixTimestampToDate($testTimestamp)"];
    NSTimeInterval testUnixTimestamp = [date timeIntervalSince1970];
    XCTAssertEqual([unixTimestampNum doubleValue], testUnixTimestamp);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^unixTimestampToDate()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^unixTimestampToDate($NULL)" error:&err];
    expectError(err);
}

- (void) testDateToUnixTimestamp
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSDate* date = [@"$testDate" evaluateAsObject];
    NSNumber* unixTimestampNum = [MBExpression asNumber:@"^dateToUnixTimestamp($testDate)"];
    NSTimeInterval testUnixTimestamp = [date timeIntervalSince1970];
    XCTAssertEqual([unixTimestampNum doubleValue], testUnixTimestamp);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^dateToUnixTimestamp()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^dateToUnixTimestamp($NULL)" error:&err];
    expectError(err);
}

- (void) testAddSecondsToDate
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSDate* date = [@"$testDate" evaluateAsObject];
    NSDate* testInTheFutureBy5mins = [date dateByAddingTimeInterval:300];
    NSDate* inTheFutureBy5mins = [MBExpression asObject:@"^addSecondsToDate(300|$testDate)"];
    XCTAssertEqualObjects(inTheFutureBy5mins, testInTheFutureBy5mins);
    
    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^addSecondsToDate()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^addSecondsToDate($testDate)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^addSecondsToDate(300|$testDate|5)" error:&err];
    expectError(err);
}

- (void) testFormatTimeUntil
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSString* time = [MBExpression asString:@"^formatTimeUntil(^addSecondsToDate(300|^currentTime()))"];
    XCTAssertEqualObjects(time, @"5:00");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^formatTimeUntil()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^formatTimeUntil($NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^formatTimeUntil(string)" error:&err];
    expectError(err);
}

- (void) testFormatDate
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSString* dateStr = [MBExpression asString:@"^formatDate($testDate|MM/dd/yy)"];
    XCTAssertEqualObjects(dateStr, @"10/26/86");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^formatDate()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^formatDate($testDate)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^formatDate($testDate|MM/dd/yy|huh?)" error:&err];
    expectError(err);
}

- (void) testFormatSortableDate
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSString* sortable = [MBExpression asString:@"^formatSortableDate($testDate)"];
    XCTAssertEqualObjects(sortable, @"1986-10-26 00:02:00");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^formatSortableDate()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^formatSortableDate($NULL)" error:&err];
    expectError(err);
}

- (void) testFormatShortDate
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    [self _performDateFormatTest:@"formatShortDate"
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"1/26/12"];

    //
    // test expected failures
    //
    [self _performDateFormatFailureTest:@"formatShortDate"];
}

- (void) testFormatMediumDate
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    [self _performDateFormatTest:@"formatMediumDate"
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"Jan 26, 2012"];

    //
    // test expected failures
    //
    [self _performDateFormatFailureTest:@"formatMediumDate"];
}

- (void) testFormatLongDate
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    [self _performDateFormatTest:@"formatLongDate"
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"January 26, 2012"];

    //
    // test expected failures
    //
    [self _performDateFormatFailureTest:@"formatLongDate"];
}

- (void) testFormatFullDate
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    [self _performDateFormatTest:@"formatFullDate"
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"Thursday, January 26, 2012"];

    //
    // test expected failures
    //
    [self _performDateFormatFailureTest:@"formatFullDate"];
}

- (void) testFormatShortTime
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    [self _performDateFormatTest:@"formatShortTime"
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"10:58 AM"];

    //
    // test expected failures
    //
    [self _performDateFormatFailureTest:@"formatShortTime"];
}

- (void) testFormatMediumTime
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    [self _performDateFormatTest:@"formatMediumTime"
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"10:58:19 AM"];

    //
    // test expected failures
    //
    [self _performDateFormatFailureTest:@"formatMediumTime"];
}

- (void) testFormatLongTime
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    [self _performDateFormatTest:@"formatLongTime"
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"10:58:19 AM EST"];

    //
    // test expected failures
    //
    [self _performDateFormatFailureTest:@"formatLongTime"];
}

- (void) testFormatFullTime
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    [self _performDateFormatTest:@"formatFullTime"
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"10:58:19 AM Eastern Standard Time"];

    //
    // test expected failures
    //
    [self _performDateFormatFailureTest:@"formatFullTime"];
}

- (void) testFormatShortDateTime
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    [self _performDateFormatTest:@"formatShortDateTime"
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"1/26/12, 10:58 AM"];

    //
    // test expected failures
    //
    [self _performDateFormatFailureTest:@"formatShortDateTime"];
}

- (void) testFormatMediumDateTime
{
    MBLogInfoTrace();

    //
    // I am not really sure why we can get either ', ' or ' at ' as the
    // date/time separator on some platforms, but we do, so accept both
    //
    NSArray<NSString*>* acceptedResults = @[@"Jan 26, 2012, 10:58:19 AM",
                                            @"Jan 26, 2012 at 10:58:19 AM"];

    //
    // test expected successes
    //
    NSString* dateStr = [MBExpression asString:@"^formatMediumDateTime(Thu, 26 Jan 2012 15:58:19 UTC)"];
    XCTAssert([acceptedResults containsObject:dateStr], @"Test of formatMediumDateTime failed (note, date tests may only work in US locale in EST timezone)");

    //
    // test expected failures
    //
    [self _performDateFormatFailureTest:@"formatMediumDateTime"];
}

- (void) testFormatLongDateTime
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    [self _performDateFormatTest:@"formatLongDateTime"
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"January 26, 2012 at 10:58:19 AM EST"];

    //
    // test expected failures
    //
    [self _performDateFormatFailureTest:@"formatLongDateTime"];
}

- (void) testFormatFullDateTime
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    [self _performDateFormatTest:@"formatFullDateTime"
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"Thursday, January 26, 2012 at 10:58:19 AM Eastern Standard Time"];

    //
    // test expected failures
    //
    [self _performDateFormatFailureTest:@"formatFullDateTime"];
}

- (void) testReformatDate
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSString* dateStr = [MBExpression asString:@"^reformatDate(26 Oct 1986|dd MMM yyyy|MM/dd/yy)"];
    XCTAssertEqualObjects(dateStr, @"10/26/86");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^reformatDate()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^reformatDate($testDate)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^reformatDate($testDate|MM/dd/yy|huh?|who?)" error:&err];
    expectError(err);
}

- (void) testReformatDateWithLocale
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSString* dateStr = [MBExpression asString:@"^reformatDateWithLocale(26 Oct 1986|en_US|dd MMM yyyy|MM/dd/yy)"];
    XCTAssertEqualObjects(dateStr, @"10/26/86");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^reformatDateWithLocale()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^reformatDateWithLocale($testDate|MM/dd/yy)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^reformatDateWithLocale($testDate|MM/dd/yy|huh?|who?)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^reformatDateWithLocale($testDate|MM/dd/yy|huh?|who?|hey?)" error:&err];
    expectError(err);
}

- (void) testParseDate
{
    MBLogInfoTrace();
    
    //
    // test expected successes
    //
    NSDate* date = [MBExpression asObject:@"^parseDate(Thu, 26 Jan 2012 15:58:19 UTC)"];
    XCTAssertTrue([date isKindOfClass:[NSDate class]]);
    NSDate* testDate = [NSDate dateWithTimeIntervalSince1970:1327593499];
    XCTAssertEqualObjects(date, testDate);
    date = [MBExpression asObject:@"^parseDate(Fri, Jan 20, 2012 01:00PM EST|EEE, MMM d, yyyy hh:mma z)"];
    testDate = [NSDate dateWithTimeIntervalSince1970:1327082400];
    XCTAssertEqualObjects(date, testDate);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^parseDate()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^parseDate(Thu, 26 Jan 2012 15:58:19 UTC|EEE, MMM d, yyyy hh:mma z|why is this here?)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^parseDate(this will not parse as a date, will it? of course not!)" error:&err];
    expectError(err);
}

@end
