//
//  MBMLDateFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLDateFunctionTests class
/******************************************************************************/

@interface MBMLDateFunctionTests : MockingbirdTestSuite
@end

@implementation MBMLDateFunctionTests

/*
 NEED TO ADD:
    <Function class="MBMLDateFunctions" name="timeZoneOffset" input="none"/>
    <Function class="MBMLDateFunctions" name="unixTimestampToDate"/>
    <Function class="MBMLDateFunctions" name="dateToUnixTimestamp"/>
    <Function class="MBMLDateFunctions" name="addSecondsToDate" input="pipedObjects"/>
    <Function class="MBMLDateFunctions" name="formatTimeUntil"/>
    <Function class="MBMLDateFunctions" name="formatDate" input="pipedObjects"/>
    <Function class="MBMLDateFunctions" name="formatSortableDate" input="object"/>
    <Function class="MBMLDateFunctions" name="reformatDate" input="pipedStrings"/>
    <Function class="MBMLDateFunctions" name="reformatDateWithLocale" input="pipedStrings"/>

 
 FULL LIST:
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

- (void) _performDateFormatTest:(NSString*)functionName
                          input:(NSString*)input
                      expecting:(NSString*)expectedResult
{
    NSString* expr = [NSString stringWithFormat:@"^%@(%@)", functionName, input];
    NSString* dateStr = [MBExpression asString:expr];
    XCTAssertEqualObjects(dateStr, expectedResult, @"Test of %@ failed (note, date tests may only work in US locale in EST timezone)", expr);
}

- (void) testDateFunctions
{
    //
    // test of ^currentTime()
    //
    NSDate* date = [MBExpression asObject:@"^currentTime()"];
    XCTAssertTrue([date isKindOfClass:[NSDate class]], @"expected ^currentTime() to return an NSDate");
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    XCTAssertTrue(interval < 1, @"wasn't expecting ^currentTime() to return such a stale date");
    
    //
    // test of ^parseDate()
    //
    date = [MBExpression asObject:@"^parseDate(Thu, 26 Jan 2012 15:58:19 UTC)"];
    XCTAssertTrue([date isKindOfClass:[NSDate class]], @"expected ^parseDate(Thu, 26 Jan 2012 15:58:19 UTC) to return an NSDate");
    NSDate* testDate = [NSDate dateWithTimeIntervalSince1970:1327593499];
    XCTAssertEqualObjects(date, testDate, @"expected ^parseDate(Thu, 26 Jan 2012 15:58:19 UTC) to return an NSDate equal to %@", testDate);
    date = [MBExpression asObject:@"^parseDate(Fri, Jan 20, 2012 01:00PM EST|EEE, MMM d, yyyy hh:mma z)"];
    testDate = [NSDate dateWithTimeIntervalSince1970:1327082400];
    XCTAssertEqualObjects(date, testDate, @"expected ^parseDate(Fri, Jan 20, 2012 01:00PM EST|EEE, MMM d, yyyy hh:mma z) to return an NSDate equal to %@", testDate);

    //
    // test of ^secondsSince()
    //
    date = [MBExpression asObject:@"^parseDate(Fri, 27 Oct 1972 10:52:00 EST)"];
    [[MBVariableSpace instance] setVariable:@"testDate" value:date];
    NSTimeInterval secondsSince = [[NSDate date] timeIntervalSinceDate:date];
    NSTimeInterval testSecondsSince = [[MBExpression asString:@"^secondsSince($testDate)"] doubleValue];
    NSTimeInterval diff = secondsSince - testSecondsSince;
    XCTAssertTrue(diff < 1, @"test of ^secondsSince() failed; time shift unexpectedly large");

    //
    // test of ^secondsUntil()
    //
    date = [MBExpression asObject:@"^parseDate(Thu, 27 Oct 2022 10:52:00 EST)"];
    [[MBVariableSpace instance] setVariable:@"testDate" value:date];
    NSTimeInterval secondsUntil = [date timeIntervalSinceNow];
    NSTimeInterval testSecondsUntil = [[MBExpression asString:@"^secondsUntil($testDate)"] doubleValue];
    diff = secondsUntil - testSecondsUntil;
    XCTAssertTrue(diff < 1, @"test of ^secondsUntil() failed; time shift unexpectedly large");

    //
    // IMPORTANT NOTE: These tests may fail if run on a system
    // with different localization settings. These tests should
    // succeed on a system with US English in the Eastern timezone.
    //
    
    //
    // test of ^formatShortDate()
    //
    [self _performDateFormatTest:@"formatShortDate"
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"1/26/12"];
    
    //
    // test of ^formatMediumDate()
    //
    [self _performDateFormatTest:@"formatMediumDate"    
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"Jan 26, 2012"];

    //
    // test of ^formatLongDate()
    //
    [self _performDateFormatTest:@"formatLongDate"      
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"  
                       expecting:@"January 26, 2012"];
    
    //
    // test of ^formatFullDate()
    //
    [self _performDateFormatTest:@"formatFullDate"          
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"  
                       expecting:@"Thursday, January 26, 2012"];
    
    //
    // test of ^formatShortTime()
    //
    [self _performDateFormatTest:@"formatShortTime"         
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"
                       expecting:@"10:58 AM"];
    
    //
    // test of ^formatMediumTime()
    //
    [self _performDateFormatTest:@"formatMediumTime"        
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"  
                       expecting:@"10:58:19 AM"];

    //
    // test of ^formatLongTime()
    //
    [self _performDateFormatTest:@"formatLongTime"          
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"  
                       expecting:@"10:58:19 AM EST"];
    
    //
    // test of ^formatFullTime()
    //
    [self _performDateFormatTest:@"formatFullTime"          
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"  
                       expecting:@"10:58:19 AM Eastern Standard Time"];
    
    //
    // test of ^formatShortDateTime()
    //
    [self _performDateFormatTest:@"formatShortDateTime"     
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"  
                       expecting:@"1/26/12, 10:58 AM"];
    
    //
    // test of ^formatMediumDateTime()
    //
    [self _performDateFormatTest:@"formatMediumDateTime"    
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"  
                       expecting:@"Jan 26, 2012, 10:58:19 AM"];

    //
    // test of ^formatLongDateTime()
    //
    [self _performDateFormatTest:@"formatLongDateTime"      
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"  
                       expecting:@"January 26, 2012 at 10:58:19 AM EST"];
    
    //
    // test of ^formatFullDateTime()
    //
    [self _performDateFormatTest:@"formatFullDateTime"      
                           input:@"Thu, 26 Jan 2012 15:58:19 UTC"  
                       expecting:@"Thursday, January 26, 2012 at 10:58:19 AM Eastern Standard Time"];
}

- (void) _performDateFormatFailureTest:(NSString*)functionName 
{
    MBExpressionError* err = nil;
    NSString* expr = [NSString stringWithFormat:@"^%@()", functionName];
    [MBExpression asString:expr error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^%@() with no parameters", functionName);
    logExpectedError(err);

    err = nil;
    expr = [NSString stringWithFormat:@"^%@(this should not parse)", functionName];
    [MBExpression asString:expr error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^%@() with with an unparseable string", functionName);
    logExpectedError(err);
}

- (void) testDateFunctionFailures
{
    //
    // test of ^parseDate()
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^parseDate()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseDate() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^parseDate(Thu, 26 Jan 2012 15:58:19 UTC|EEE, MMM d, yyyy hh:mma z|why is this here?)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseDate() with three parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^parseDate(this will not parse as a date, will it? of course not!)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseDate() with an unparseable date");
    logExpectedError(err);
    
    //
    // test of ^secondsSince()
    //
    err = nil;
    [MBExpression asObject:@"^secondsSince()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^secondsSince() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^secondsSince(this is not my beautiful house)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^secondsSince() with a parameter that isn't an NSDate");
    logExpectedError(err);
    
    //
    // test of ^secondsUntil()
    //
    err = nil;
    [MBExpression asObject:@"^secondsUntil()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^secondsUntil() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^secondsUntil($NULL)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^secondsUntil() with a parameter that isn't an NSDate");
    logExpectedError(err);
    
    //
    // test of ^formatShortDate()
    //
    [self _performDateFormatFailureTest:@"formatShortDate"];
    
    //
    // test of ^formatMediumDate()
    //
    [self _performDateFormatFailureTest:@"formatMediumDate"];
    
    //
    // test of ^formatLongDate()
    //
    [self _performDateFormatFailureTest:@"formatLongDate"];
    
    //
    // test of ^formatFullDate()
    //
    [self _performDateFormatFailureTest:@"formatFullDate"];
    
    //
    // test of ^formatShortTime()
    //
    [self _performDateFormatFailureTest:@"formatShortTime"];
    
    //
    // test of ^formatMediumTime()
    //
    [self _performDateFormatFailureTest:@"formatMediumTime"];
    
    //
    // test of ^formatLongTime()
    //
    [self _performDateFormatFailureTest:@"formatLongTime"];
    
    //
    // test of ^formatFullTime()
    //
    [self _performDateFormatFailureTest:@"formatFullTime"];
    
    //
    // test of ^formatShortDateTime()
    //
    [self _performDateFormatFailureTest:@"formatShortDateTime"];
    
    //
    // test of ^formatMediumDateTime()
    //
    [self _performDateFormatFailureTest:@"formatMediumDateTime"];
    
    //
    // test of ^formatLongDateTime()
    //
    [self _performDateFormatFailureTest:@"formatLongDateTime"];
    
    //
    // test of ^formatFullDateTime()
    //
    [self _performDateFormatFailureTest:@"formatFullDateTime"];
}

@end
