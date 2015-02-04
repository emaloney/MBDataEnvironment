//
//  MBMLCollectionFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MBDataEnvironmentTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLCollectionFunctionTests class
/******************************************************************************/

@interface MBMLCollectionFunctionTests : MBDataEnvironmentTestSuite
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
    <Function class="MBMLCollectionFunctions" name="set" input="pipedObjects"/>
    <Function class="MBMLCollectionFunctions" name="setWithArray" input="object"/>
    <Function class="MBMLCollectionFunctions" name="removeObject" input="pipedObjects"/>
    <Function class="MBMLCollectionFunctions" name="removeObjectAtIndex" input="pipedObjects"/>
    <Function class="MBMLCollectionFunctions" name="removeLastObject" input="object"/>
    <Function class="MBMLCollectionFunctions" name="lastObject" input="object"/>
    <Function class="MBMLCollectionFunctions" name="indexOf" input="pipedExpressions"/>
    <Function class="MBMLCollectionFunctions" name="copy" method="copyOf" input="object"/>
    <Function class="MBMLCollectionFunctions" name="mutableCopy" method="mutableCopyOf" input="object"/>
    <Function class="MBMLCollectionFunctions" name="valueForKey" method="getValueForKey" input="pipedObjects"/>
*/

- (void) testIsCollection
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    XCTAssertTrue( [MBExpression asBoolean:@"^isCollection($testSet)"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isCollection($testMap)"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isCollection($testValues)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isCollection(string)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isCollection(#(1))"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isCollection(^dictionary())"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isCollection(^array())"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isCollection(^set())"]);
}

- (void) testIsSet
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    XCTAssertTrue( [MBExpression asBoolean:@"^isSet($testSet)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isSet($testMap)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isSet($testValues)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isSet(string)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isSet(#(1))"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isSet(^dictionary())"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isSet(^array())"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isSet(^set())"]);
}

- (void) testIsDictionary
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    XCTAssertFalse([MBExpression asBoolean:@"^isDictionary($testSet)"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isDictionary($testMap)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isDictionary($testValues)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isDictionary(string)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isDictionary(#(1))"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isDictionary(^dictionary())"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isDictionary(^array())"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isDictionary(^set())"]);
}

- (void) testIsArray
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    XCTAssertFalse([MBExpression asBoolean:@"^isArray($testSet)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isArray($testMap)"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isArray($testValues)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isArray(string)"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isArray(#(1))"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isArray(^dictionary())"]);
    XCTAssertTrue( [MBExpression asBoolean:@"^isArray(^array())"]);
    XCTAssertFalse([MBExpression asBoolean:@"^isArray(^set())"]);
}

- (void) testCount
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSArray* testMap = [MBExpression asObject:@"$testMap"];
    NSArray* testSet = [MBExpression asObject:@"$testSet"];
    NSArray* testArray = [MBExpression asObject:@"$testValues"];

    NSUInteger count = [[MBExpression asNumber:@"^count($testMap)"] unsignedIntegerValue];
    XCTAssertEqual(count, testMap.count);

    count = [[MBExpression asNumber:@"^count($testSet)"] unsignedIntegerValue];
    XCTAssertEqual(count, testSet.count);

    count = [[MBExpression asNumber:@"^count($testValues)"] unsignedIntegerValue];
    XCTAssertEqual(count, testArray.count);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asNumber:@"^count(string)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^count()" error:&err];
    expectError(err);
}

- (void) testKeys
{
    consoleTrace();

    //
    // test expected successes
    //
    NSArray* testKeys = [MBExpression asObject:@"$testKeys"];
    NSArray* extractedKeys = [MBExpression asObject:@"^keys($testMap)"];
    XCTAssertEqualObjects([NSSet setWithArray:extractedKeys], [NSSet setWithArray:testKeys]);       // convert to set since array order is nondeterministic with ^keys()

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^keys($testValues)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^keys(I have no keys)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^keys()" error:&err];
    expectError(err);
}

- (void) testValues
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSArray* testValues = [MBExpression asObject:@"$testValues"];
    NSArray* extractedValues = [MBExpression asObject:@"^values($testMap)"];
    XCTAssertEqualObjects([NSSet setWithArray:extractedValues], [NSSet setWithArray:testValues]);   // convert to set since array order is nondeterministic with ^values()

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^values($testValues)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^values(I have no values)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^values()" error:&err];
    expectError(err);
}

- (void) testAppendObject
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSArray* testValues = [MBExpression asObject:@"$testValues"];
    NSArray* testList1 = [MBExpression asObject:@"^appendObject(^appendObject(^appendObject(^appendObject($emptyList|$testValues[0])|$testValues[1])|$testValues[2])|$testValues[3])"];
    XCTAssertEqualObjects(testValues, testList1);

    NSArray* testList2 = [MBExpression asObject:@"^appendObject($emptyList|$testValues[0]|$testValues[1]|$testValues[2]|$testValues[3])"];
    XCTAssertEqualObjects(testValues, testList2);
    
    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^appendObject(hello|this should not work)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^appendObject()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^appendObject($emptyList)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^appendObject(|)" error:&err];
    expectError(err);
}

- (void) testInsertObjectAtIndex
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSMutableArray* testInsertAgainst = [NSMutableArray arrayWithObjects:@"One", @"1.5", @"Two", @"2.5", @"Three", @"3.5", @"Four", nil];
    NSArray* testInsert = [MBExpression asObject:@"^insertObjectAtIndex(^insertObjectAtIndex(^insertObjectAtIndex($testValues|1.5|1)|2.5|3)|3.5|5)"];
    XCTAssertEqualObjects(testInsert, testInsertAgainst);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex(not an array|insert this object|0)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex($emptyList|added|3)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex($emptyList)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex($emptyList|insert)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex($emptyList|insert|0|extra!)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex(|)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^insertObjectAtIndex(||)" error:&err];
    expectError(err);
}

- (void) testArray
{
    consoleTrace();
    
    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSArray* emptyArray = [MBExpression asObject:@"^array()"];
    XCTAssertTrue([emptyArray isKindOfClass:[NSArray class]]);
    XCTAssertTrue(emptyArray.count == 0);

    NSArray* otherArray = [MBExpression asObject:@"^array(1|2|3)"];
    XCTAssertTrue([otherArray isKindOfClass:[NSArray class]]);
    XCTAssertTrue(otherArray.count == 3);
    XCTAssertEqualObjects(otherArray[0], @"1");
    XCTAssertEqualObjects(otherArray[1], @"2");
    XCTAssertEqualObjects(otherArray[2], @"3");

    [MBVariableSpace instance][@"one"] = [NSNumber numberWithInteger:1];
    [MBVariableSpace instance][@"two"] = @"2";
    [MBVariableSpace instance][@"free"] = @"three";
    [MBVariableSpace instance][@"four"] = @"fore";
    otherArray = [MBExpression asObject:@"^array($one|$two|$free|$four)"];
    XCTAssertTrue([otherArray isKindOfClass:[NSArray class]]);
    XCTAssertTrue(otherArray.count == 4);
    XCTAssertEqualObjects(otherArray[0], [NSNumber numberWithInteger:1]);
    XCTAssertEqualObjects(otherArray[1], @"2");
    XCTAssertEqualObjects(otherArray[2], @"three");
    XCTAssertEqualObjects(otherArray[3], @"fore");
}

- (void) testDictionary
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSDictionary* emptyDict = [MBExpression asObject:@"^dictionary()"];
    XCTAssertTrue([emptyDict isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(emptyDict.count == 0);

    NSDictionary* otherDict = [MBExpression asObject:@"^dictionary(one|1|two|2)"];
    XCTAssertTrue([otherDict isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(otherDict.count == 2);
    XCTAssertEqualObjects([otherDict objectForKey:@"one"], @"1");
    XCTAssertEqualObjects([otherDict objectForKey:@"two"], @"2");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^dictionary(one)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^dictionary(one|1|two)" error:&err];
    expectError(err);
}

- (void) testSet
{
    consoleTrace();
    
    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSSet* emptySet = [MBExpression asObject:@"^set()"];
    XCTAssertTrue([emptySet isKindOfClass:[NSSet class]]);
    XCTAssertTrue(emptySet.count == 0);

    NSSet* set1 = [MBExpression asObject:@"^set(one|two|three)"];
    XCTAssertTrue([set1 isKindOfClass:[NSSet class]]);
    XCTAssertTrue(set1.count == 3);
    XCTAssertTrue([set1 containsObject:@"one"]);
    XCTAssertTrue([set1 containsObject:@"two"]);
    XCTAssertTrue([set1 containsObject:@"three"]);

    NSSet* set2 = [MBExpression asObject:@"^set($testMap[Key 1]|$testMap[Key 2]|$testMap[Key 3]|$testMap[Key 4])"];
    XCTAssertTrue([set2 isKindOfClass:[NSSet class]]);
    XCTAssertTrue(set2.count == 4);
    XCTAssertTrue([set2 containsObject:@"One"]);
    XCTAssertTrue([set2 containsObject:@"Two"]);
    XCTAssertTrue([set2 containsObject:@"Three"]);
    XCTAssertTrue([set2 containsObject:@"Four"]);
}

- (void) testSetWithArray
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSArray* valuesArray = [MBExpression asObject:@"$testValues"];
    NSSet* valuesSet = [NSSet setWithArray:valuesArray];
    NSSet* testSet = [MBExpression asObject:@"^setWithArray($testValues)"];
    XCTAssertEqualObjects(valuesSet, testSet);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^setWithArray($testMap)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^setWithArray()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^setWithArray($NULL)" error:&err];
    expectError(err);
}

- (void) testRemoveObject
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSArray* testAgainst = @[@"1.5", @"2.5", @"3.5"];
    NSArray* testRemoveObject = [MBExpression asObject:@"^removeObject(^removeObject(^removeObject(^removeObject($testInsertRemove|One)|Two)|Three)|Four)"];
    XCTAssertEqualObjects(testRemoveObject, testAgainst);
    testRemoveObject = [MBExpression asObject:@"^removeObject($testInsertRemove|One|Two|Three|Four)"];
    XCTAssertEqualObjects(testRemoveObject, testAgainst);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^removeObject($testMap|theObject)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^removeObject()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^removeObject($emptyList)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^removeObject(|)" error:&err];
    expectError(err);
}

- (void) testRemoveObjectAtIndex
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSArray* testAgainst = @[@"1.5", @"2.5", @"3.5"];
    NSArray* testRemoveAtIndex = [MBExpression asObject:@"^removeObjectAtIndex(^removeObjectAtIndex(^removeObjectAtIndex(^removeObjectAtIndex($testInsertRemove|6)|4)|2)|0)"];
    XCTAssertEqualObjects(testRemoveAtIndex, testAgainst);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex(not an array|0)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex($emptyList|5)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex($emptyList)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex($emptyList|0|what?)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^removeObjectAtIndex(|)" error:&err];
    expectError(err);
}

- (void) testRemoveLastObject
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSMutableArray* removeLast = [[MBExpression asObject:@"$testArray"] mutableCopy];
    [removeLast removeLastObject];
    NSArray* testRemoveLast = [MBExpression asObject:@"^removeLastObject($testArray)"];
    XCTAssertEqualObjects(removeLast, testRemoveLast);

    NSArray* emptyArray = [MBExpression asObject:@"$emptyList"];
    NSArray* testRemoveFromEmpty = [MBExpression asObject:@"^removeLastObject($emptyList)"];
    XCTAssertEqualObjects(testRemoveFromEmpty, emptyArray);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^removeLastObject(not an array)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^removeLastObject($NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^removeLastObject()" error:&err];
    expectError(err);
}

- (void) testLastObject
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSString* four = [MBExpression asObject:@"^lastObject(^array(one|two|free|four))"];
    XCTAssertEqualObjects(four, @"four");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asNumber:@"^lastObject()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"^lastObject($NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"^lastObject(notAnArray)" error:&err];
    expectError(err);
}

- (void) testIndexOf
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSInteger index = [[MBExpression asNumber:@"^indexOf(^array(one|two|free|four)|free)"] integerValue];
    XCTAssertEqual(index, (NSInteger)2);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asNumber:@"^indexOf($NULL|foo)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^indexOf()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^indexOf(^array(one|two|free|four))" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^indexOf(^array(one|two|free|four)|free|foo)" error:&err];
    expectError(err);
}

- (void) testCopy
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSArray* emptyList = [MBExpression asObject:@"$emptyList"];
    NSArray* copyEmptyList = [MBExpression asObject:@"^copy($emptyList)"];
    XCTAssertEqualObjects(copyEmptyList, emptyList);

    NSDictionary* emptyMap = [MBExpression asObject:@"$emptyMap"];
    NSDictionary* copyEmptyMap = [MBExpression asObject:@"^copy($emptyMap)"];
    XCTAssertEqualObjects(copyEmptyMap, emptyMap);

    NSArray* namesList = [MBExpression asObject:@"$namesList"];
    NSArray* copyNamesList = [MBExpression asObject:@"^copy($namesList)"];
    XCTAssertEqualObjects(copyNamesList, namesList);

    NSDictionary* testMapAgain = [MBExpression asObject:@"$testMap"];
    NSDictionary* copyTestMapAgain = [MBExpression asObject:@"^copy($testMap)"];
    XCTAssertEqualObjects(copyTestMapAgain, testMapAgain);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^copy($UIDevice)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^copy()" error:&err];
    expectError(err);
}

- (void) testMutableCopy
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSMutableArray* emptyList = [MBExpression asObject:@"$emptyList"];
    NSMutableArray* copyEmptyList = [MBExpression asObject:@"^mutableCopy($emptyList)"];
    XCTAssertTrue([copyEmptyList isKindOfClass:[NSMutableArray class]]);
    XCTAssertEqualObjects(copyEmptyList, emptyList);

    NSMutableDictionary* emptyMap = [MBExpression asObject:@"$emptyMap"];
    NSMutableDictionary* copyEmptyMap = [MBExpression asObject:@"^mutableCopy($emptyMap)"];
    XCTAssertTrue([copyEmptyMap isKindOfClass:[NSMutableDictionary class]]);
    XCTAssertEqualObjects(copyEmptyMap, emptyMap);

    NSMutableDictionary* testMap = [MBExpression asObject:@"$testMap"];
    NSMutableDictionary* copyTestMap = [MBExpression asObject:@"^mutableCopy($testMap)"];
    XCTAssertTrue([copyTestMap isKindOfClass:[NSMutableDictionary class]]);
    XCTAssertEqualObjects(testMap, copyTestMap);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^mutableCopy($UIDevice)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^mutableCopy()" error:&err];
    expectError(err);
}

- (void) testValueForKey
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSString* item3 = [MBExpression asObject:@"^valueForKey($testMap|Key 3)"];
    XCTAssertEqualObjects(item3, @"Three");
    NSUInteger len = [[MBExpression asNumber:@"^valueForKey(myString|length)"] unsignedIntegerValue];
    XCTAssertTrue(len == 8);
    NSString* def = [MBExpression asString:@"^valueForKey(myString|apple|default)"];
    XCTAssertEqualObjects(def, @"default");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^valueForKey()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^valueForKey($UIDevice)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^valueForKey($UIDevice|systemName|foo|bar)" error:&err];
    expectError(err);
}

@end
