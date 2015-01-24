//
//  MBMLCollectionFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLCollectionFunctionTests class
/******************************************************************************/

@interface MBMLCollectionFunctionTests : MockingbirdTestSuite
@end

@implementation MBMLCollectionFunctionTests

/*
    <Function class="MBMLCollectionFunctions" name="isCollection" input="object"/>
    <Function class="MBMLCollectionFunctions" name="isSet" input="object"/>
    <Function class="MBMLCollectionFunctions" name="isDictionary" input="object"/>
    <Function class="MBMLCollectionFunctions" name="isArray" input="object"/>
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
    // test of ^isCollection(), ^isSet(), ^isDictionary(), and ^isArray()
    //
    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"testSet"] = [NSSet setWithArray:testValues];

    XCTAssertTrue( [MBExpression asBoolean:@"^isCollection($testSet)"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isCollection($testMap)"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isCollection($testValues)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isCollection(string)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isCollection(#(1))"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isCollection(^dictionary())"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isCollection(^array())"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isCollection(^set())"]);

    XCTAssertTrue( [MBExpression asBoolean:@"^isSet($testSet)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isSet($testMap)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isSet($testValues)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isSet(string)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isSet(#(1))"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isSet(^dictionary())"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isSet(^array())"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isSet(^set())"]);

    XCTAssertFalse([MBExpression asBoolean:@"^isDictionary($testSet)"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isDictionary($testMap)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isDictionary($testValues)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isDictionary(string)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isDictionary(#(1))"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isDictionary(^dictionary())"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isDictionary(^array())"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isDictionary(^set())"]);

    XCTAssertFalse([MBExpression asBoolean:@"^isArray($testSet)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isArray($testMap)"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isArray($testValues)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isArray(string)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isArray(#(1))"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isArray(^dictionary())"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isArray(^array())"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isArray(^set())"]);

    [MBScopedVariables exitVariableScope];

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

@end
