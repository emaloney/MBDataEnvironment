//
//  MBMLFunctionTests.m
//  MockingbirdTests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFunctionTests class
/******************************************************************************/

@interface MBMLFunctionTests : MockingbirdTestSuite
@end

@implementation MBMLFunctionTests

/******************************************************************************/
#pragma mark MBMLCollectionFunctions tests
/******************************************************************************/

/*
 <Function class="MBMLCollectionFunctions" name="count" input="object"/>
 <Function class="MBMLCollectionFunctions" name="keys" input="object"/>
 <Function class="MBMLCollectionFunctions" name="values" input="object"/>
 <Function class="MBMLCollectionFunctions" name="appendObject" input="pipedObjects"/>
 <Function class="MBMLCollectionFunctions" name="insertObjectAtIndex" input="pipedObjects"/>
 <Function class="MBMLCollectionFunctions" name="array" input="pipedObjects"/>
 <Function class="MBMLCollectionFunctions" name="dictionary" input="pipedExpressions"/>
 <Function class="MBMLCollectionFunctions" name="removeObject" input="pipedObjects"/>
 <Function class="MBMLCollectionFunctions" name="removeObjectAtIndex" input="pipedObjects"/>
 <Function class="MBMLCollectionFunctions" name="removeLastObject" input="object"/>
 <Function class="MBMLCollectionFunctions" name="lastObject" input="object"/>
 <Function class="MBMLCollectionFunctions" name="indexOf" input="pipedExpressions"/>
 <Function class="MBMLCollectionFunctions" name="copy" method="copyOf" input="object"/>
 <Function class="MBMLCollectionFunctions" name="mutableCopy" method="mutableCopyOf" input="object"/>
 <Function class="MBMLCollectionFunctions" name="valueForKey" method="getValueForKey" input="pipedObjects"/>
*/

- (void) testCollectionFunctions
{
    consoleTrace();
    
    NSDictionary* testMap = [MBExpression asObject:@"$testMap"];
    NSArray* testKeys = [testMap allKeys];
    NSArray* testValues = [testMap allValues];
    
    //
    // test of ^count()
    //
    NSUInteger count = [[MBExpression asNumber:@"^count($testMap)"] unsignedIntegerValue];
    XCTAssertEqual(count, testMap.count, @"Test of ^count() MBML function failed");
    
    //
    // test of ^keys()
    //
    NSArray* extractedKeys = [MBExpression asObject:@"^keys($testMap)"];
    XCTAssertEqualObjects(extractedKeys, testKeys, @"Test of ^keys() MBML function failed");
    
    //
    // test of ^values()
    //
    NSArray* extractedValues = [MBExpression asObject:@"^values($testMap)"];
    XCTAssertEqualObjects(extractedValues, testValues, @"Test of ^values() MBML function failed");
  
    //
    // test of ^appendObject()
    //
    testValues = [MBExpression asObject:@"$testValues"];

    NSArray* testList1 = [MBExpression asObject:@"^appendObject(^appendObject(^appendObject(^appendObject($emptyList|$testValues[0])|$testValues[1])|$testValues[2])|$testValues[3])"];
    XCTAssertEqualObjects(testValues, testList1, @"Nested parameter test of ^appendObject() MBML function failed");

    NSArray* testList2 = [MBExpression asObject:@"^appendObject($emptyList|$testValues[0]|$testValues[1]|$testValues[2]|$testValues[3])"];
    XCTAssertEqualObjects(testValues, testList2, @"Parameter list test of ^appendObject() MBML function failed");

    //
    // test of ^insertObjectAtIndex() 
    //
    [[MBVariableSpace instance] setVariable:@"testInsertArray" value:testList1];
    NSMutableArray* testInsertAgainst = [NSMutableArray arrayWithObjects:@"One", @"1.5", @"Two", @"2.5", @"Three", @"3.5", @"Four", nil];
    NSArray* testInsert = [MBExpression asObject:@"^insertObjectAtIndex(^insertObjectAtIndex(^insertObjectAtIndex($testInsertArray|1.5|1)|2.5|3)|3.5|5)"];
    XCTAssertEqualObjects(testInsert, testInsertAgainst, @"Test of ^insertObjectAtIndex() MBML function failed");

    //
    // test of ^removeObjectAtIndex() 
    //
    [[MBVariableSpace instance] setVariable:@"testRemoveArray" value:testInsertAgainst];
    NSMutableArray* testRemoveAgainst = [NSMutableArray arrayWithObjects:@"1.5", @"2.5", @"3.5", nil];
    NSArray* testRemoveAtIndex = [MBExpression asObject:@"^removeObjectAtIndex(^removeObjectAtIndex(^removeObjectAtIndex(^removeObjectAtIndex($testRemoveArray|6)|4)|2)|0)"];
    XCTAssertEqualObjects(testRemoveAtIndex, testRemoveAgainst, @"Test of ^removeObjectAtIndex() MBML function failed");

    //
    // test of ^removeObject()
    //
    NSArray* testRemoveObject = [MBExpression asObject:@"^removeObject(^removeObject(^removeObject(^removeObject($testRemoveArray|One)|Two)|Three)|Four)"];
    XCTAssertEqualObjects(testRemoveObject, testRemoveAgainst, @"Test of ^removeObject() MBML function failed");
    testRemoveObject = [MBExpression asObject:@"^removeObject($testRemoveArray|One|Two|Three|Four)"];
    XCTAssertEqualObjects(testRemoveObject, testRemoveAgainst, @"Test of ^removeObject() MBML function failed");
    
    //
    // test of ^array()
    //
    NSArray* emptyArray = [MBExpression asObject:@"^array()"];
    XCTAssertTrue([emptyArray isKindOfClass:[NSArray class]], @"expected ^array() to return an NSArray instance");
    XCTAssertTrue(emptyArray.count == 0, @"expected a zero-count array from ^array()");
    
    NSArray* otherArray = [MBExpression asObject:@"^array(1|2|3)"];
    XCTAssertTrue([otherArray isKindOfClass:[NSArray class]], @"expected ^array() to return an NSArray instance");
    XCTAssertTrue(otherArray.count == 3, @"expected three items in the array from ^array(1|2|3)");
    XCTAssertEqualObjects([otherArray objectAtIndex:0], @"1", @"unexpected item in return value from ^array()");
    XCTAssertEqualObjects([otherArray objectAtIndex:1], @"2", @"unexpected item in return value from ^array()");
    XCTAssertEqualObjects([otherArray objectAtIndex:2], @"3", @"unexpected item in return value from ^array()");
    
    [[MBVariableSpace instance] setVariable:@"one" value:[NSNumber numberWithInteger:1]];
    [[MBVariableSpace instance] setVariable:@"two" value:@"2"];
    [[MBVariableSpace instance] setVariable:@"free" value:@"three"];
    [[MBVariableSpace instance] setVariable:@"four" value:@"fore"];
    otherArray = [MBExpression asObject:@"^array($one|$two|$free|$four)"];
    XCTAssertTrue([otherArray isKindOfClass:[NSArray class]], @"expected ^array() to return an NSArray instance");
    XCTAssertTrue(otherArray.count == 4, @"expected four items in the array from ^array($one|$two|$free|$four)");
    XCTAssertEqualObjects([otherArray objectAtIndex:0], [NSNumber numberWithInteger:1], @"unexpected item in return value from ^array()");
    XCTAssertEqualObjects([otherArray objectAtIndex:1], @"2", @"unexpected item in return value from ^array()");
    XCTAssertEqualObjects([otherArray objectAtIndex:2], @"three", @"unexpected item in return value from ^array()");
    XCTAssertEqualObjects([otherArray objectAtIndex:3], @"fore", @"unexpected item in return value from ^array()");
    
    //
    // test of ^indexOf()
    //
    [[MBVariableSpace instance] setVariable:@"testArray" value:otherArray];
    NSInteger index = [[MBExpression asNumber:@"^indexOf($testArray|fore)"] integerValue];
    XCTAssertEqual(index, (NSInteger)3, @"Test of ^indexOf() MBML function failed");
    
    //
    // test of ^dictionary()
    //
    NSDictionary* emptyDict = [MBExpression asObject:@"^dictionary()"];
    XCTAssertTrue([emptyDict isKindOfClass:[NSDictionary class]], @"expected ^dictionary() to return an NSDictionary instance");
    XCTAssertTrue(emptyDict.count == 0, @"expected a zero-count dictionary from ^dictionary()");
    
    NSDictionary* otherDict = [MBExpression asObject:@"^dictionary(one|1|two|2)"];
    XCTAssertTrue([otherDict isKindOfClass:[NSDictionary class]], @"expected ^dictionary() to return an NSDictionary instance");
    XCTAssertTrue(otherDict.count == 2, @"expected two key/value pairs in the dictionary from dictionary(one|1|two|2)");
    XCTAssertEqualObjects([otherDict objectForKey:@"one"], @"1", @"unexpected item in return value from ^dictionary()");
    XCTAssertEqualObjects([otherDict objectForKey:@"two"], @"2", @"unexpected item in return value from ^dictionary()");
    
    //
    // test of ^copy()
    //
    NSArray* emptyList = [MBExpression asObject:@"$emptyList"];
    NSArray* copyEmptyList = [MBExpression asObject:@"^copy($emptyList)"];
    XCTAssertEqualObjects(copyEmptyList, emptyList, @"expected copy to be the same as the original");
    
    NSDictionary* emptyMap = [MBExpression asObject:@"$emptyMap"];
    NSDictionary* copyEmptyMap = [MBExpression asObject:@"^copy($emptyMap)"];
    XCTAssertEqualObjects(copyEmptyMap, emptyMap, @"expected copy to be the same as the original");
    
    NSArray* namesList = [MBExpression asObject:@"$namesList"];
    NSArray* copyNamesList = [MBExpression asObject:@"^copy($namesList)"];
    XCTAssertEqualObjects(copyNamesList, namesList, @"expected copy to be the same as the original");
    
    NSDictionary* testMapAgain = [MBExpression asObject:@"$testMap"];
    NSDictionary* copyTestMapAgain = [MBExpression asObject:@"^copy($testMap)"];
    XCTAssertEqualObjects(copyTestMapAgain, testMapAgain, @"expected copy to be the same as the original");
    
    //
    // test of ^mutableCopy()
    //
    copyEmptyList = [MBExpression asObject:@"^mutableCopy($emptyList)"];
    XCTAssertEqualObjects(copyEmptyList, emptyList, @"expected copy to be the same as the original");
    XCTAssertTrue([copyEmptyList isKindOfClass:[NSMutableArray class]], @"expected mutable array");
    
    copyEmptyMap = [MBExpression asObject:@"^mutableCopy($emptyMap)"];
    XCTAssertEqualObjects(copyEmptyMap, emptyMap, @"expected copy to be the same as the original");
    XCTAssertTrue([copyEmptyMap isKindOfClass:[NSMutableDictionary class]], @"expected mutable dictionary");

    testMapAgain = [MBExpression asObject:@"$testMap"];
    copyTestMapAgain = [MBExpression asObject:@"^mutableCopy($testMap)"];
    XCTAssertEqualObjects(copyTestMapAgain, testMapAgain, @"expected copy to be the same as the original");
    XCTAssertTrue([copyTestMapAgain isKindOfClass:[NSMutableDictionary class]], @"expected mutable dictionary");

    //
    // test of ^valueForKey()
    //
    NSString* item3 = [MBExpression asObject:@"^valueForKey($testMap|Key 3)"];
    XCTAssertEqualObjects(item3, @"Three",  @"Test of ^valueForKey() failed");
    NSUInteger len = [[MBExpression asNumber:@"^valueForKey(myString|length)"] unsignedIntegerValue];
    XCTAssertTrue(len == 8, @"Test of ^valueForKey() failed");
    
    //
    // test of ^lastObject()
    //
    NSString* fore = [MBExpression asObject:@"^lastObject($testArray)"];
    XCTAssertEqualObjects(fore, @"fore",  @"Test of ^lastObject() failed");

    //
    // test of ^removeLastObject()
    //
    NSMutableArray* removeLast = [[MBExpression asObject:@"$testArray"] mutableCopy];
    [removeLast removeLastObject];
    NSArray* testRemoveLast = [MBExpression asObject:@"^removeLastObject($testArray)"];
    XCTAssertEqualObjects(removeLast, testRemoveLast,  @"Test of ^removeLastObject() failed");
}

#if TEST_EXPECTED_FAILURES
- (void) testCollectionFunctionFailures
{
    consoleTrace();
        
    //
    // test of ^keys()
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^keys($testArray)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for trying to get ^keys() for something that isn't a map");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^keys()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^keys() with no parameters");
    logExpectedError(err);
    
    //
    // test of ^values()
    //
    err = nil;
    [MBExpression asObject:@"^values(I have no values)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for trying to get ^values() for something that isn't a map");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^values()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^values() with no parameters");
    logExpectedError(err);
    
    //
    // test of ^appendObject()
    //
    err = nil;
    [MBExpression asObject:@"^appendObject(hello|this should not work)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for trying to ^appendObject() to something that isn't an array");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^appendObject()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^appendObject() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^appendObject($emptyList)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^appendObject($emptyList) with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^appendObject(|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^appendObject() with two empty parameters");
    logExpectedError(err);

    //
    // test of ^insertObjectAtIndex() 
    //
    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex(not an array|insert this object|0)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for trying to ^insertObjectAtIndex() to something that isn't an array");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex($emptyList|added|3)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for trying to ^insertObjectAtIndex() using an index larger than the array allows");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^insertObjectAtIndex() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex($emptyList)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^insertObjectAtIndex() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex($emptyList|insert)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^insertObjectAtIndex() with two parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex($emptyList|insert|0|extra!)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^insertObjectAtIndex() with four parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex(|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^insertObjectAtIndex() with two empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex(||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^insertObjectAtIndex() with three empty parameters");
    logExpectedError(err);

    //
    // test of ^removeObjectAtIndex() 
    //
    err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex(not an array|0)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for trying to ^removeObjectAtIndex() from something that isn't an array");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex($emptyList|5)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for trying to ^removeObjectAtIndex() using an index larger than the array allows");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^removeObjectAtIndex() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex($emptyList)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^removeObjectAtIndex() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex($emptyList|0|what?)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^removeObjectAtIndex() with three parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex(|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^removeObjectAtIndex() with two empty parameters");
    logExpectedError(err);
    
    //
    // test of ^removeObject()
    //
    err = nil;
    [MBExpression asObject:@"^removeObject($testMap|theObject)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for trying to ^removeObject() from something that isn't an array");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^removeObject()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^removeObject() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^removeObject($emptyList)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^removeObject() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex(|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^removeObjectAtIndex() with two empty parameters");
    logExpectedError(err);
    
    //
    // note: ^array() has no failure conditions, since it accepts all input;
    //       therefore, we are not testing it here
    //
    
    //
    // test of ^dictionary()
    //
    err = nil;
    [MBExpression asObject:@"^dictionary(one)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^dictionary() with an odd number of parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^dictionary(one|1|two)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^dictionary() with an odd number of parameters");
    logExpectedError(err);
}
#endif

/******************************************************************************/
#pragma mark MBMLDateFunctions tests
/******************************************************************************/

/*
 <Function class="MBMLDateFunctions" name="currentTime" input="none"/>
 <Function class="MBMLDateFunctions" name="secondsSince"/>
 <Function class="MBMLDateFunctions" name="secondsUntil"/>
 <Function class="MBMLDateFunctions" name="formatShortDate" input="string"/>
 <Function class="MBMLDateFunctions" name="formatMediumDate" input="string"/>
 <Function class="MBMLDateFunctions" name="formatLongDate" input="string"/>
 <Function class="MBMLDateFunctions" name="formatFullDate" input="string"/>
 <Function class="MBMLDateFunctions" name="formatShortTime" input="string"/>
 <Function class="MBMLDateFunctions" name="formatMediumTime" input="string"/>
 <Function class="MBMLDateFunctions" name="formatLongTime" input="string"/>
 <Function class="MBMLDateFunctions" name="formatFullTime" input="string"/>
 <Function class="MBMLDateFunctions" name="formatShortDateTime" input="string"/>
 <Function class="MBMLDateFunctions" name="formatMediumDateTime" input="string"/>
 <Function class="MBMLDateFunctions" name="formatLongDateTime" input="string"/>
 <Function class="MBMLDateFunctions" name="formatFullDateTime" input="string"/>
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

#if TEST_EXPECTED_FAILURES
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
#endif

/******************************************************************************/
#pragma mark MBMLLogicFunctions tests
/******************************************************************************/

/*
<Function class="MBMLLogicFunctions" name="if" method="ifOperator" input="pipedExpressions"/>
*/

- (void) testLogicFunctions
{
    //
    // test of ^if()
    //
    NSNumber* testNum = [NSNumber numberWithInteger:102772];
    [[MBVariableSpace instance] setVariable:@"ifTestNumber" value:testNum];
    id result = [MBExpression asObject:@"^if($ifTestNumber)"];
    XCTAssertTrue([result isKindOfClass:[NSNumber class]], @"expected result of ^if($ifTestNumber) to return a number");
    XCTAssertEqualObjects(result, [NSNumber numberWithInteger:102772], @"expected result of ^if($ifTestNumber) to be the number 102772");
    
    result = [MBExpression asObject:@"^if($thisVariableDoesNotExist)"];
    XCTAssertNil(result, @"expected result of ^if($thisVariableDoesNotExist) to be nil");

    result = [MBExpression asObject:@"^if(T|true)"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected result of ^if(T|true) to return an NSString");
    XCTAssertEqualObjects(result, @"true", @"expected result of ^if(T|true) to be the string \"true\"");
    
    result = [MBExpression asObject:@"^if(F|true)"];
    XCTAssertTrue(result == nil, @"expected result of ^if(F|true) to return nil");
    
    result = [MBExpression asObject:@"^if(T|true|false)"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected result of ^if(T|true|false) to return an NSString");
    XCTAssertEqualObjects(result, @"true", @"expected result of ^if(T|true|false) to be the string \"true\"");

    result = [MBExpression asObject:@"^if(F|true|false)"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected result of ^if(F|true|false) to return an NSString");
    XCTAssertEqualObjects(result, @"false", @"expected result of ^if(F|true|false) to be the string \"false\"");
}

#if TEST_EXPECTED_FAILURES
- (void) testLogicFunctionFailures
{
    //
    // test of ^if()
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^if()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^if() with no parameters");
    logExpectedError(err);

    err = nil;
    [MBExpression asString:@"^if(T|true|false|quantum superposition)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^if() with four parameters");
    logExpectedError(err);
}
#endif

/******************************************************************************/
#pragma mark MBMLMathFunctions tests
/******************************************************************************/

/*
<Function class="MBMLMathFunctions" name="multiply" input="pipedObjects"/>
<Function class="MBMLMathFunctions" name="subtract" input="pipedObjects"/>
<Function class="MBMLMathFunctions" name="divide" input="pipedObjects"/>
<Function class="MBMLMathFunctions" name="percent" input="pipedObjects"/>
<Function class="MBMLMathFunctions" name="ceil" input="object"/>
<Function class="MBMLMathFunctions" name="floor" input="object"/>
 <Function class="MBMLMathFunctions" name="min" input="pipedObjects"/>
 <Function class="MBMLMathFunctions" name="max" input="pipedObjects"/>
 */

- (void) _setupMathVariableWithPrefix:(NSString*)prefix
                               value1:(NSNumber*)num1
                               value2:(NSNumber*)num2
{
    NSDecimalNumber* dec1 = [NSDecimalNumber decimalNumberWithDecimal:[num1 decimalValue]];
    NSDecimalNumber* dec2 = [NSDecimalNumber decimalNumberWithDecimal:[num2 decimalValue]];
    
    MBVariableSpace* vars = [MBVariableSpace instance];
    [vars setVariable:[NSString stringWithFormat:@"%@%@", prefix, @"Value1"] value:dec1];
    [vars setVariable:[NSString stringWithFormat:@"%@%@", prefix, @"Value2"] value:dec2];
    [vars setVariable:[NSString stringWithFormat:@"%@%@", prefix, @"Sum"] value:[dec1 decimalNumberByAdding:dec2]];
    [vars setVariable:[NSString stringWithFormat:@"%@%@", prefix, @"Mult"] value:[dec1 decimalNumberByMultiplyingBy:dec2]];
    [vars setVariable:[NSString stringWithFormat:@"%@%@", prefix, @"Div"] value:[dec1 decimalNumberByDividingBy:dec2]];
    [vars setVariable:[NSString stringWithFormat:@"%@%@", prefix, @"Subt"] value:[dec1 decimalNumberBySubtracting:dec2]];
}

- (void) _setupMathVariables
{
    [self _setupMathVariableWithPrefix:@"short" 
                                value1:[NSNumber numberWithShort:32] 
                                value2:[NSNumber numberWithShort:64]];
    
    [self _setupMathVariableWithPrefix:@"int" 
                                value1:[NSNumber numberWithInteger:-32000] 
                                value2:[NSNumber numberWithInteger:64000]];
    
    [self _setupMathVariableWithPrefix:@"long" 
                                value1:[NSNumber numberWithLong:-32000] 
                                value2:[NSNumber numberWithLong:64000]];
    
    [self _setupMathVariableWithPrefix:@"longLong" 
                                value1:[NSNumber numberWithLongLong:-320000000000] 
                                value2:[NSNumber numberWithLongLong:640000000000]];
    
    [self _setupMathVariableWithPrefix:@"float" 
                                value1:[NSNumber numberWithFloat:-32.001] 
                                value2:[NSNumber numberWithFloat:64.999]];
    
    [self _setupMathVariableWithPrefix:@"double" 
                                value1:[NSNumber numberWithFloat:-3200000.00001] 
                                value2:[NSNumber numberWithFloat:6400000.99999]];
}

- (void) testMathFunctions
{
    [self _setupMathVariables];
    
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^ceil(1.0)"], @"expected ^ceil(1.0) == 1");
    XCTAssertEqualObjects([NSNumber numberWithInt:2], [MBExpression asObject:@"^ceil(1.1)"], @"expected ^ceil(1.1) == 2");
    XCTAssertEqualObjects([NSNumber numberWithInt:2], [MBExpression asObject:@"^ceil(1.5)"], @"expected ^ceil(1.5) == 2");
    XCTAssertEqualObjects([NSNumber numberWithInt:2], [MBExpression asObject:@"^ceil(1.9)"], @"expected ^ceil(1.9) == 2");
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-1.0)"], @"expected ^ceil(-1.0) == -1");
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-1.1)"], @"expected ^ceil(-1.1) == -1");
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-1.5)"], @"expected ^ceil(-1.5) == -1");
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-1.9)"], @"expected ^ceil(-1.9) == -1");
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-2.9 + 1.0)"], @"expected ^ceil(-2.9 + 1.0) == -1");
    
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^floor(1.0)"], @"expected ^floor(1.0) == 1");
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^floor(1.1)"], @"expected ^floor(1.1) == 1");
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^floor(1.5)"], @"expected ^floor(1.5) == 1");
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^floor(1.9)"], @"expected ^floor(1.9) == 1");
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^floor(-1.0)"], @"expected ^floor(-1.0) == -1");
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^floor(-1.1)"], @"expected ^floor(-1.1) == -2");
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^floor(-1.5)"], @"expected ^floor(-1.5) == -2");
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^floor(-1.9)"], @"expected ^floor(-1.9) == -2");
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^floor(-2.9 + 1.0)"], @"expected ^floor(-2.9 + 1.0) == -2");

    //test ^min(a,b)
    XCTAssertEqualObjects(@0, [MBExpression asObject:@"^min(0|1)"], @"expected ^min(0|1) == 0");
    XCTAssertEqualObjects(@0.0, [MBExpression asObject:@"^min(0.0|1.0)"], @"expected ^min(0.0|1.0) == 0.0");
    XCTAssertEqualObjects(@0.001, [MBExpression asObject:@"^min(0.001|0.002)"], @"expected ^min(0.001|0.002) == 0.001");
    XCTAssertEqualObjects(@(-1), [MBExpression asObject:@"^min(-1|0)"], @"expected ^min(-1|0) == -1");
    XCTAssertEqualObjects(@(-2), [MBExpression asObject:@"^min(-1|-2)"], @"expected ^min(-1|-2) == -2");
    XCTAssertEqualObjects(@(-2), [MBExpression asObject:@"^min(-1 + 1|-2)"], @"expected ^min(-1 + 0|-2) == -2");
    
    //test ^max(a,b)
    XCTAssertEqualObjects(@1, [MBExpression asObject:@"^max(0|1)"], @"expected ^max(0|1) == 1");
    XCTAssertEqualObjects(@1.0, [MBExpression asObject:@"^max(0.0|1.0)"], @"expected ^max(0.0|1.0) == 1.0");
    XCTAssertEqualObjects(@0.002, [MBExpression asObject:@"^max(0.001|0.002)"], @"expected ^max(0.001|0.002) == 0.002");
    XCTAssertEqualObjects(@0, [MBExpression asObject:@"^max(-1|0)"], @"expected ^max(-1|0) == 0");
    XCTAssertEqualObjects(@0, [MBExpression asObject:@"^max(-1 + 1|-2)"], @"expected ^max(-1 + 1|-2) == 0");
    
}

#if TEST_EXPECTED_FAILURES
- (void) testMathFunctionFailures
{
    //
    // test of ^sum()
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^sum()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^sum() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^sum(|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^sum() with two empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^sum(||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^sum() with three empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^sum(2.5)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^sum() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^sum(this|that)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^sum() with non-numeric parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^sum(2.5|five)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^sum() with one non-numeric parameter");
    logExpectedError(err);

}
#endif

- (void) testMathFunctionPercent
{
    for (NSUInteger i=0; i<=10; i++) {
        NSString* expr = [NSString stringWithFormat:@"^percent(%f|1.0)", (i/10.0)];
        NSString* pctStr = [NSString stringWithFormat:@"%u%%", (unsigned int)(i * 10)];
        NSString* pct = [MBExpression asObject:expr];
        XCTAssertTrue([pct isKindOfClass:[NSString class]], @"expected result of %@ to be an NSString", expr);
        XCTAssertEqualObjects(pct, pctStr, @"expected result of %@ to equal %@", expr, pctStr);
    }

    NSString* formatString = @"%3.1f%%";
    for (NSUInteger i=0; i<=10; i++) {
        NSString* expr = [NSString stringWithFormat:@"^percent(%@|%f|1.0)", formatString, (i/10.0)];
        NSString* pctStr = [NSString stringWithFormat:formatString, (i * 10.0)];
        NSString* pct = [MBExpression asObject:expr];
        XCTAssertTrue([pct isKindOfClass:[NSString class]], @"expected result of %@ to be an NSString", expr);
        XCTAssertEqualObjects(pct, pctStr, @"expected result of %@ to equal %@", expr, pctStr);
    }
}

#if TEST_EXPECTED_FAILURES
- (void) testMathFunctionPercentFailures
{
    //
    // test of ^percent()
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^percent()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^percent() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^percent(%3.1f%%)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^percent() with a format string and no numeric parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^percent(1.0)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^percent() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^percent(|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^percent() with two empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^percent(||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^percent() with three empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^percent(1.0|string)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^percent() with an expected numeric parameter provided as a string");
    logExpectedError(err);
}
#endif 

/******************************************************************************/
#pragma mark MBMLRegexFunctions tests
/******************************************************************************/

/*
<Function class="MBMLRegexFunctions" name="stripRegex" input="pipedStrings"/>
<Function class="MBMLRegexFunctions" name="replaceRegex" input="pipedStrings"/>
<Function class="MBMLRegexFunctions" name="matchesRegex" input="pipedStrings"/>
 */

- (void) testRegexFunctions
{
    //
    // note: the purpose here is not to test every possible regex, but
    //       to ensure that the correct parameters are passed to the regex 
    //       engine, resulting in expected return values
    //
    
    //
    // test of ^stripRegex()
    //
    NSString* regexResult = [MBExpression asObject:@"^stripRegex(ThisIsAStringThatWillBeStripped|[TIASWB])"];
    XCTAssertTrue([regexResult isKindOfClass:[NSString class]], @"expected result of ^stripRegex() to be an NSString");
    XCTAssertEqualObjects(regexResult, @"hisstringhatilletripped", @"unexpected result from ^stripRegex()");
    regexResult = [MBExpression asObject:@"^stripRegex(ThisIsAStringThatWillBeStripped|[TIASWB]|[aeiou])"];
    XCTAssertTrue([regexResult isKindOfClass:[NSString class]], @"expected result of ^stripRegex() to be an NSString");
    XCTAssertEqualObjects(regexResult, @"hsstrnghtlltrppd", @"unexpected result from ^stripRegex()");
    regexResult = [MBExpression asObject:@"^stripRegex(ThisIsAStringThatWillBeStripped|[TIASWB]|[a-e]|ripp)"];
    XCTAssertTrue([regexResult isKindOfClass:[NSString class]], @"expected result of ^stripRegex() to be an NSString");
    XCTAssertEqualObjects(regexResult, @"hisstringhtillt", @"unexpected result from ^stripRegex()");

    //
    // test of ^replaceRegex()
    //
    regexResult = [MBExpression asObject:@"^replaceRegex(Replace Me, Replace Me| Me|)"];
    XCTAssertTrue([regexResult isKindOfClass:[NSString class]], @"expected result of ^replaceRegex() to be an NSString");
    XCTAssertEqualObjects(regexResult, @"Replace, Replace", @"unexpected result from ^replaceRegex()");
    regexResult = [MBExpression asObject:@"^replaceRegex(This is my string. There are many like it, but this one is mine.|string|gun)"];
    XCTAssertTrue([regexResult isKindOfClass:[NSString class]], @"expected result of ^replaceRegex() to be an NSString");
    XCTAssertEqualObjects(regexResult, @"This is my gun. There are many like it, but this one is mine.", @"unexpected result from ^replaceRegex()");

    //
    // test of ^matchesRegex()
    //
    NSNumber* boolResult = [MBExpression asObject:@"^matchesRegex(212-452-2510|[0-9]{3}-[0-9]{3}-[0-9]{4})"];
    XCTAssertTrue([boolResult isKindOfClass:[NSNumber class]], @"expected result of ^matchesRegex() to be an NSNumber");
    XCTAssertTrue([boolResult boolValue], @"unexpected result from ^matchesRegex()");
    boolResult = [MBExpression asObject:@"^matchesRegex(212-452-2510|[0-9]{3}-[0-9]{3}-[0-9]{4}|.*-452-.*|^212-|2510$)"];
    XCTAssertTrue([boolResult isKindOfClass:[NSNumber class]], @"expected result of ^matchesRegex() to be an NSNumber");
    XCTAssertTrue([boolResult boolValue], @"unexpected result from ^matchesRegex()");
    boolResult = [MBExpression asObject:@"^matchesRegex(unknown|[0-9]{3}-[0-9]{3}-[0-9]{4}|unknown)"];
    XCTAssertTrue([boolResult isKindOfClass:[NSNumber class]], @"expected result of ^matchesRegex() to be an NSNumber");
    XCTAssertTrue([boolResult boolValue] == NO, @"unexpected result from ^matchesRegex()");
    boolResult = [MBExpression asObject:@"^matchesRegex(match|match)"];
    XCTAssertTrue([boolResult isKindOfClass:[NSNumber class]], @"expected result of ^matchesRegex() to be an NSNumber");
    XCTAssertTrue([boolResult boolValue], @"unexpected result from ^matchesRegex()");
}

#if TEST_EXPECTED_FAILURES
- (void) testRegexFunctionFailures
{
    //
    // test of ^stripRegex()
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^stripRegex()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^stripRegex() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^stripRegex(stripFromString)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^stripRegex() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^stripRegex(stripFromString|[)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^stripRegex() with an invalid regular expression");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^stripRegex(|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^stripRegex() with two empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^stripRegex(||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^stripRegex() with three empty parameters");
    logExpectedError(err);
    
    //
    // test of ^replaceRegex()
    //
    err = nil;
    [MBExpression asString:@"^replaceRegex()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^replaceRegex() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^replaceRegex(replace)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^replaceRegex() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^replaceRegex(replace|replace)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^replaceRegex() with two parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^replaceRegex(stringToReplaceIn|Replace|Fit|extra)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^replaceRegex() with four parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^replaceRegex(||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^replaceRegex() with three empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^replaceRegex(string[To]ReplaceIn|[|-)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^replaceRegex() with an invalid regular expression");
    logExpectedError(err);

    //
    // test of ^matchesRegex()
    //
    err = nil;
    [MBExpression asObject:@"^matchesRegex()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^matchesRegex() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^matchesRegex(match)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^matchesRegex() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^matchesRegex(match|[)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^matchesRegex() with an invalid regular expression");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^matchesRegex(match|at|[)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^matchesRegex() with one valid regex and one invalid regex");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^matchesRegex(|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^matchesRegex() with two empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^matchesRegex(||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^matchesRegex() with three empty parameters");
    logExpectedError(err);
}
#endif

/******************************************************************************/
#pragma mark MBMLStringFunctions tests
/******************************************************************************/

/*
<Function class="MBMLStringFunctions" name="q" input="string"/>
<Function class="MBMLStringFunctions" name="stripQueryString" input="string"/>
<Function class="MBMLStringFunctions" name="lowercase" input="string"/>
<Function class="MBMLStringFunctions" name="uppercase" input="string"/>
<Function class="MBMLStringFunctions" name="titleCase" input="string"/>
<Function class="MBMLStringFunctions" name="titleCaseIfAllCaps" input="string"/>
<Function class="MBMLStringFunctions" name="pluralize" input="pipedStrings"/>
<Function class="MBMLStringFunctions" name="concatenateFields" input="pipedStrings"/>
<Function class="MBMLStringFunctions" name="firstNonemptyString" input="pipedExpressions"/>
<Function class="MBMLStringFunctions" name="firstNonemptyTrimmedString" input="pipedExpressions"/>
<Function class="MBMLStringFunctions" name="truncate" input="pipedStrings"/>
<Function class="MBMLStringFunctions" name="stripSpaces" input="string"/>
<Function class="MBMLStringFunctions" name="parseInteger" input="string"/>
<Function class="MBMLStringFunctions" name="parseDouble" input="string"/>
<Function class="MBMLStringFunctions" name="parseNumber" input="string"/>
<Function class="MBMLStringFunctions" name="rangeOfString" input="pipedObjects"/>
*/

- (void) testStringFunctions
{
    //
    // test of ^q()
    //
    NSString* test = [MBExpression asObject:@"^q(    -- THIS IS A TEST --    )"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^q() to be an NSString");
    XCTAssertEqualObjects(test, @"    -- THIS IS A TEST --    ", @"unexpected result for ^q()");
    
    //
    // test of ^stripQueryString()
    //
    test = [MBExpression asObject:@"^stripQueryString(http://m.gilt.com/testapps?platform=iphone)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^stripQueryString() to be an NSString");
    XCTAssertEqualObjects(test, @"http://m.gilt.com/testapps", @"unexpected result for ^stripQueryString()");
    
    //
    // test of ^lowercase()
    //
    test = [MBExpression asObject:@"^lowercase(This is ALL upperCASE!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^lowercase() to be an NSString");
    XCTAssertEqualObjects(test, @"this is all uppercase!", @"unexpected result for ^lowercase()");
    
    //
    // test of ^uppercase()
    //
    test = [MBExpression asObject:@"^uppercase(This is NOT all lowercase!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^uppercase() to be an NSString");
    XCTAssertEqualObjects(test, @"THIS IS NOT ALL LOWERCASE!", @"unexpected result for ^uppercase()");
    
    //
    // test of ^titleCase()
    //
    test = [MBExpression asObject:@"^titleCase(dark side of the moon)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^titleCase() to be an NSString");
    XCTAssertEqualObjects(test, @"Dark Side Of The Moon", @"unexpected result for ^titleCase()");
    
    //
    // test of ^titleCaseIfAllCaps()
    //
    test = [MBExpression asObject:@"^titleCaseIfAllCaps(IBM)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^titleCaseIfAllCaps() to be an NSString");
    XCTAssertEqualObjects(test, @"Ibm", @"unexpected result for ^titleCaseIfAllCaps()");
    
    //
    // test of ^pluralize()
    //
    MBVariableSpace* vars = [MBVariableSpace instance];
    [vars setVariable:@"zero" value:[NSNumber numberWithInt:0]];
    [vars setVariable:@"one" value:[NSNumber numberWithInt:1]];
    [vars setVariable:@"two" value:[NSNumber numberWithInt:2]];
    test = [MBExpression asObject:@"^pluralize(1|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"one", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize(2|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"some", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize($one|one|not one)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"one", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize($two|one|not one)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"not one", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize(0|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"none", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize(1|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"one", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize(2|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"some", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize($zero|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"none", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize($one|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"one", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize($two|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"some", @"unexpected result for ^pluralize()");

    //
    // test of ^concatenateFields()
    //
    test = [MBExpression asObject:@"^concatenateFields(One: |value 1|Two: |value 2)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^concatenateFields() to be an NSString");
    XCTAssertEqualObjects(test, @"One: value 1; Two: value 2", @"unexpected result for ^concatenateFields()");
    test = [MBExpression asObject:@"^concatenateFields(One: |value 1|Two: |value 2|Three: |value 3)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^concatenateFields() to be an NSString");
    XCTAssertEqualObjects(test, @"One: value 1; Two: value 2; Three: value 3", @"unexpected result for ^concatenateFields()");
    test = [MBExpression asObject:@"^concatenateFields(/|One: |value 1|Two: |value 2)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^concatenateFields() to be an NSString");
    XCTAssertEqualObjects(test, @"One: value 1/Two: value 2", @"unexpected result for ^concatenateFields()");
    test = [MBExpression asObject:@"^concatenateFields(/|One: |value 1|Two: |value 2|Three: |value 3)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^concatenateFields() to be an NSString");
    XCTAssertEqualObjects(test, @"One: value 1/Two: value 2/Three: value 3", @"unexpected result for ^concatenateFields()");

    //
    // test of ^firstNonemptyString()
    //
    [vars setVariable:@"emptyString" value:@""];
    [vars setVariable:@"null" value:[NSNull null]];
    test = [MBExpression asObject:@"^firstNonemptyString($emptyString|$null|$nonexistentVariable|value 1| value 2|ignore this)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^firstNonemptyString() to be an NSString");
    XCTAssertEqualObjects(test, @"value 1", @"unexpected result for ^firstNonemptyString()");
    
    //
    // test of ^firstNonemptyTrimmedString()
    //
    [vars setVariable:@"nonEmptyString" value:@"     but... but... this has spaces!!! OH NO!!!     "];
    test = [MBExpression asObject:@"^firstNonemptyTrimmedString($emptyString|$null|$nonexistentVariable|$nonEmptyString| ignore this )"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^firstNonemptyTrimmedString() to be an NSString");
    XCTAssertEqualObjects(test, @"but... but... this has spaces!!! OH NO!!!", @"unexpected result for ^firstNonemptyTrimmedString()");

    //
    // test of ^truncate()
    //
    test = [MBExpression asObject:@"^truncate(10|This is your chance!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^truncate() to be an NSString");
    XCTAssertEqualObjects(test, @"This is yo…", @"unexpected result for ^truncate()");
    test = [MBExpression asObject:@"^truncate(10|…|This is your chance!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^truncate() to be an NSString");
    XCTAssertEqualObjects(test, @"This is yo…", @"unexpected result for ^truncate()");
    test = [MBExpression asObject:@"^truncate(10|...|This is your chance!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^truncate() to be an NSString");
    XCTAssertEqualObjects(test, @"This is yo...", @"unexpected result for ^truncate()");
    
    //
    // test of ^stripSpaces()
    //
    test = [MBExpression asObject:@"^stripSpaces(    -- THIS IS A TEST --    )"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^stripSpaces() to be an NSString");
    XCTAssertEqualObjects(test, @"--THISISATEST--", @"unexpected result for ^stripSpaces()");
    
    //
    // test of ^parseInteger()
    //
    NSNumber* num = [MBExpression asObject:@"^parseInteger(123)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]], @"expected result of ^parseInteger() to be an NSNumber");
    XCTAssertEqualObjects(num, [NSNumber numberWithInt:123], @"unexpected result for ^parseInteger()");
    num = [MBExpression asObject:@"^parseInteger(1.3)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]], @"expected result of ^parseInteger() to be an NSNumber");
    XCTAssertEqualObjects(num, [NSNumber numberWithInt:1], @"unexpected result for ^parseInteger()");

    //
    // test of ^parseDouble()
    //
    num = [MBExpression asObject:@"^parseDouble(123)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]], @"expected result of ^parseDouble() to be an NSNumber");
    XCTAssertEqualObjects(num, [NSNumber numberWithFloat:123], @"unexpected result for ^parseDouble()");
    num = [MBExpression asObject:@"^parseDouble(1.3)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]], @"expected result of ^parseDouble() to be an NSNumber");
    XCTAssertEqualObjects(num, [NSNumber numberWithDouble:1.3], @"unexpected result for ^parseDouble()");
    
    //
    // test of ^parseNumber()
    //
    num = [MBExpression asObject:@"^parseNumber(123)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]], @"expected result of ^parseNumber() to be an NSNumber");
    XCTAssertEqualObjects(num, [NSNumber numberWithInteger:123], @"unexpected result for ^parseNumber()");
    num = [MBExpression asObject:@"^parseNumber(1.3)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]], @"expected result of ^parseNumber() to be an NSNumber");
    XCTAssertEqualObjects(num, [NSNumber numberWithDouble:1.3], @"unexpected result for ^parseNumber()");
    
    //
    // test of ^rangeOfString()
    //
    NSArray * range = [MBExpression asObject:@"^rangeOfString(test123|test)"];
    NSArray * expected = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:0],[NSNumber numberWithUnsignedInteger:4], nil];
    XCTAssertTrue([range isKindOfClass:[NSArray class]], @"expected result of ^rangeOfString() to be an NSArray");
    XCTAssertEqualObjects(range, expected, @"unexpected result for ^rangeOfString()");
    range = [MBExpression asObject:@"^rangeOfString(test123|123)"];
    expected = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:4],[NSNumber numberWithUnsignedInteger:3], nil];
    XCTAssertTrue([range isKindOfClass:[NSArray class]], @"expected result of ^rangeOfString() to be an NSArray");
    XCTAssertEqualObjects(range, expected, @"unexpected result for ^rangeOfString()");
    range = [MBExpression asObject:@"^rangeOfString(test123|1)"];
    expected = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:4],[NSNumber numberWithUnsignedInteger:1], nil];
    XCTAssertTrue([range isKindOfClass:[NSArray class]], @"expected result of ^rangeOfString() to be an NSArray");
    XCTAssertEqualObjects(range, expected, @"unexpected result for ^rangeOfString()");
    range = [MBExpression asObject:@"^rangeOfString(test123|nope)"];
    expected = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:NSNotFound],[NSNumber numberWithUnsignedInteger:0], nil];
    XCTAssertTrue([range isKindOfClass:[NSArray class]], @"expected result of ^rangeOfString() to be an NSArray");
    XCTAssertEqualObjects(range, expected, @"unexpected result for ^rangeOfString()");
}

#if TEST_EXPECTED_FAILURES
- (void) testStringFunctionFailures
{
    // note: not every string function reports errors;
    // functions that take simple strings and only perform
    // string operations typically don't. so, you'll notice
    // that we're not testing ALL MBMLStringFunctions below...
    
    //
    // test of ^pluralize()
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^pluralize()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^pluralize() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^pluralize(1)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^pluralize() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^pluralize(1|one)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^pluralize() with two parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^pluralize(one|pony|ponies)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^pluralize() with non-numeric first parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^pluralize(|||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^pluralize() with four empty parameters");
    logExpectedError(err);

    //
    // test of ^concatenateFields()
    //
    err = nil;
    [MBExpression asString:@"^concatenateFields()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^concatenateFields() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^concatenateFields(Field:)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^concatenateFields() with one parameter");
    logExpectedError(err);
    
    //
    // test of ^truncate()
    //
    err = nil;
    [MBExpression asString:@"^truncate()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^truncate() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^truncate(10)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^truncate() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^truncate(ten|truncate me at the tenth character, yo)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^truncate() with non-numeric first parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^truncate(ten|...|truncate me at ten)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^truncate() with non-numeric first parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^truncate(10|...|truncate me at ten|extra param)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^truncate() with four parameters");
    logExpectedError(err);
    
    //
    // test of ^parseInteger()
    //
    err = nil;
    [MBExpression asString:@"^parseInteger()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseInteger() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^parseInteger(string)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseInteger() with non-numeric parameter");
    logExpectedError(err);

    //
    // test of ^parseDouble()
    //
    err = nil;
    [MBExpression asString:@"^parseDouble()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseDouble() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^parseDouble(string)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseDouble() with non-numeric parameter");
    logExpectedError(err);
    
    //
    // test of ^parseNumber()
    //
    err = nil;
    [MBExpression asString:@"^parseNumber()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseNumber() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^parseNumber(string)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseNumber() with non-numeric parameter");
    logExpectedError(err);
    
    //
    // test of ^rangeOfString()
    //
    err = nil;
    [MBExpression asString:@"^rangeOfString()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^rangeOfString() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^rangeOfString(string)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^rangeOfString() with 1 parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^rangeOfString(|string)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^rangeOfString() with nil 1st parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^rangeOfString(string|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^rangeOfString() with nil 2nd parameter");
    logExpectedError(err);
}
#endif

/******************************************************************************/
#pragma mark MBMLDataProcessingFunctions tests
/******************************************************************************/

/*
<Function class="MBMLDataProcessingFunctions" name="collectionPassesTest" input="pipedExpressions"/>
<Function class="MBMLDataProcessingFunctions" name="containsValue" input="pipedObjects"/>
<Function class="MBMLDataProcessingFunctions" name="valuesPassingTest" input="pipedExpressions"/>
<Function class="MBMLDataProcessingFunctions" name="join" input="pipedObjects"/>
<Function class="MBMLDataProcessingFunctions" name="split" input="pipedStrings"/>
<Function class="MBMLDataProcessingFunctions" name="splitLines" input="string"/>
<Function class="MBMLDataProcessingFunctions" name="appendArrays" input="pipedObjects"/>
<Function class="MBMLDataProcessingFunctions" name="flattenArrays" input="pipedObjects"/>
<Function class="MBMLDataProcessingFunctions" name="filter" input="pipedExpressions"/>
<Function class="MBMLDataProcessingFunctions" name="list" input="pipedExpressions"/>
<Function class="MBMLDataProcessingFunctions" name="map" input="pipedExpressions"/>
<Function class="MBMLDataProcessingFunctions" name="mapToSingleValue" input="pipedExpressions"/>
<Function class="MBMLDataProcessingFunctions" name="mapToArray" input="pipedExpressions"/>
<Function class="MBMLDataProcessingFunctions" name="sort" input="pipedExpressions"/>
<Function class="MBMLDataProcessingFunctions" name="merge" input="pipedExpressions"/>
<Function class="MBMLDataProcessingFunctions" name="unique" input="object"/>
<Function class="MBMLDataProcessingFunctions" name="distributeArrayElements" input="pipedObjects"/>
<Function class="MBMLDataProcessingFunctions" name="groupArrayElements" input="pipedObjects"/>
 <Function class="MBMLDataProcessingFunctions" name="reduce" input="pipedExpressions"/>
*/

/*
 <!-- test data for data processing functions -->
 <Var name="Daisy Test" type="map" mutable="F">
 <Var name="firstName" literal="Daisy"/>
 <Var name="lastName" literal="Test"/>
 <Var name="species" literal="dog"/>
 <Var name="gender" literal="female"/>
 <Var name="age" literal="7"/>
 <Var name="owners" type="list">
 <Var literal="Jill Test"/>
 </Var>
 </Var>
 
 <Var name="Barrett Test" type="map" mutable="F">
 <Var name="firstName" literal="Barrett"/>
 <Var name="lastName" literal="Test"/>
 <Var name="species" literal="cat"/>
 <Var name="gender" literal="female"/>
 <Var name="age" literal="3"/>
 <Var name="owners" type="list">
 <Var literal="Jill Test"/>
 <Var literal="Evan Test"/>
 </Var>
 </Var>
 
 <Var name="Jill Test" type="map" mutable="F">
 <Var name="firstName" literal="Jill"/>
 <Var name="lastName" literal="Test"/>
 <Var name="species" literal="human"/>
 <Var name="gender" literal="female"/>
 <Var name="age" literal="35"/>
 <Var name="aunts" type="list">
 <Var literal="Debbie Test"/>
 </Var>
 <Var name="nieces" type="list">
 <Var literal="Lauren Test"/>
 </Var>
 </Var>
 
 <Var name="Evan Test" type="map" mutable="F">
 <Var name="firstName" literal="Evan"/>
 <Var name="lastName" literal="Test"/>
 <Var name="gender" literal="male"/>
 <Var name="species" literal="human"/>
 <Var name="age" literal="39"/>
 </Var>
 
 <Var name="Debbie Test" type="map" mutable="F">
 <Var name="firstName" literal="Debbie"/>
 <Var name="lastName" literal="Test"/>
 <Var name="species" literal="human"/>
 <Var name="gender" literal="female"/>
 <Var name="age" literal="55"/>
 <Var name="nieces" type="list">
 <Var literal="Jill Test"/>
 </Var>
 </Var>
 
 <Var name="Lauren Test" type="map" mutable="F">
 <Var name="firstName" literal="Debbie"/>
 <Var name="lastName" literal="Test"/>
 <Var name="species" literal="human"/>
 <Var name="gender" literal="female"/>
 <Var name="age" literal="11"/>
 </Var>
 
 <Var name="nameList" type="list" mutable="F">
 <Var value="${Jill Test}"/>
 <Var value="${Evan Test}"/>
 <Var value="${Debbie Test}"/>
 <Var value="${Lauren Test}"/>
 <Var value="${Daisy Test}"/>
 <Var value="${Barrett Test}"/>
 </Var>
 */
- (void) testDataProcessingFunctions
{
    //
    // test of ^distributeArrayElements()
    //
    NSArray* teams = [NSArray arrayWithObjects:@"Yankees", @"Mets", @"Knicks", @"Rangers", @"Islanders", nil];
    [[MBVariableSpace instance] setVariable:@"newYorkTeams" value:teams];
    
    NSArray* distributed = [MBExpression asObject:@"^distributeArrayElements($newYorkTeams|2)"];
    XCTAssertTrue([distributed isKindOfClass:[NSArray class]], @"expected result of ^distributeArrayElements() to be an NSArray");
    XCTAssertTrue(distributed.count == 2, @"expected array result of ^distributeArrayElements() to contain 2 elements");
    NSArray* expectedArray1 = [NSArray arrayWithObjects:@"Yankees", @"Knicks", @"Islanders", nil];
    NSArray* expectedArray2 = [NSArray arrayWithObjects:@"Mets", @"Rangers", nil];
    XCTAssertEqualObjects(expectedArray1, [distributed objectAtIndex:0], @"unexpected item at index 0 in result for ^distributeArrayElements()");
    XCTAssertEqualObjects(expectedArray2, [distributed objectAtIndex:1], @"unexpected item at index 1 in result for ^distributeArrayElements()");

    NSArray* grouped = [MBExpression asObject:@"^groupArrayElements($newYorkTeams|2)"];
    XCTAssertTrue([grouped isKindOfClass:[NSArray class]], @"expected result of ^groupArrayElements() to be an NSArray");
    XCTAssertTrue(grouped.count == 3, @"expected array result of ^groupArrayElements() to contain 3 elements");
    expectedArray1 = [NSArray arrayWithObjects:@"Yankees", @"Mets", nil];
    expectedArray2 = [NSArray arrayWithObjects:@"Knicks", @"Rangers", nil];
    NSArray* expectedArray3 = [NSArray arrayWithObjects:@"Islanders", nil];
    XCTAssertEqualObjects(expectedArray1, [grouped objectAtIndex:0], @"unexpected item at index 0 in result for ^groupArrayElements()");
    XCTAssertEqualObjects(expectedArray2, [grouped objectAtIndex:1], @"unexpected item at index 1 in result for ^groupArrayElements()");
    XCTAssertEqualObjects(expectedArray3, [grouped objectAtIndex:2], @"unexpected item at index 1 in result for ^groupArrayElements()");
    
    NSObject* reduced = [MBExpression asObject:@"^reduce($newYorkTeams|na|$item)"];
    XCTAssertEqualObjects(@"Islanders", reduced, @"expected the result to be the last item in the list");
    
    reduced = [MBExpression asObject:@"^reduce($newYorkTeams|0|#($currentValue + $item.length))"];
    XCTAssertEqualObjects([NSNumber numberWithInt:33], reduced, @"expected the result to be the sum of the lengths of the strings");
    
    reduced = [MBExpression asObject:@"^reduce(^array()|#(0)|#($currentValue + $item.length))"];
    XCTAssertEqualObjects([NSNumber numberWithInt:0], reduced, @"expected the result of an empty array to be the initial value");
    
    reduced = [MBExpression asObject:@"^reduce(^array(test)|0|#($currentValue + $item.length))"];
    XCTAssertEqualObjects([NSNumber numberWithInt:4], reduced, @"expected the result to be the sum of the lengths of the strings");
}

#if TEST_EXPECTED_FAILURES
- (void) testDataProcessingFunctionFailures
{
    
}
#endif

/******************************************************************************/
#pragma mark Regression tests
/******************************************************************************/

- (void) testMathExpressionParameters
{
    NSUInteger testResult1 = [[MBExpression asNumber:@"^min(100 | (20 * 10))"] unsignedIntegerValue];
    XCTAssertEqual((NSUInteger)100, testResult1, @"Math expression parameter test 1 failed");
    NSUInteger testResult2 = [[MBExpression asNumber:@"^min(100 | #(20 * 10))"] unsignedIntegerValue];
    XCTAssertEqual((NSUInteger)100, testResult2, @"Math expression parameter test 2 failed");
    NSUInteger testResult3 = [[MBExpression asNumber:@"^min(#(50 + 50) | #(20 * 10))"] unsignedIntegerValue];
    XCTAssertEqual((NSUInteger)100, testResult3, @"Math expression parameter test 3 failed");
}

@end
