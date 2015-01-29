//
//  MBMLDataProcessingFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLDataProcessingFunctionTests class
/******************************************************************************/

@interface MBMLDataProcessingFunctionTests : MockingbirdTestSuite
@end

@implementation MBMLDataProcessingFunctionTests

/*
    <Function class="MBMLDataProcessingFunctions" name="collectionPassesTest" input="pipedExpressions"/>
    <Function class="MBMLDataProcessingFunctions" name="containsValue" input="pipedObjects"/>
    <Function class="MBMLDataProcessingFunctions" name="setContains" input="pipedExpressions"/>
    <Function class="MBMLDataProcessingFunctions" name="valuesPassingTest" input="pipedExpressions"/>
    <Function class="MBMLDataProcessingFunctions" name="valuesIntersect" input="pipedObjects"/>
    <Function class="MBMLDataProcessingFunctions" name="join" input="pipedObjects"/>
    <Function class="MBMLDataProcessingFunctions" name="split" input="pipedStrings"/>
    <Function class="MBMLDataProcessingFunctions" name="splitLines" input="string"/>
    <Function class="MBMLDataProcessingFunctions" name="appendArrays" input="pipedObjects"/>
    <Function class="MBMLDataProcessingFunctions" name="flattenArrays" input="pipedObjects"/>
    <Function class="MBMLDataProcessingFunctions" name="filter" input="pipedExpressions"/>
    <Function class="MBMLDataProcessingFunctions" name="list" input="pipedExpressions"/>
    <Function class="MBMLDataProcessingFunctions" name="pruneMatchingLeaves" input="pipedExpressions"/>
    <Function class="MBMLDataProcessingFunctions" name="pruneNonmatchingLeaves" input="pipedExpressions"/>
    <Function class="MBMLDataProcessingFunctions" name="associate" input="pipedExpressions"/>
    <Function class="MBMLDataProcessingFunctions" name="associateWithSingleValue" input="pipedExpressions"/>
    <Function class="MBMLDataProcessingFunctions" name="associateWithArray" input="pipedExpressions"/>
    <Function class="MBMLDataProcessingFunctions" name="sort" input="pipedExpressions"/>
    <Function class="MBMLDataProcessingFunctions" name="mergeDictionaries" input="pipedExpressions"/>
    <Function class="MBMLDataProcessingFunctions" name="unique" input="object"/>
    <Function class="MBMLDataProcessingFunctions" name="distributeArrayElements" input="pipedObjects"/>
    <Function class="MBMLDataProcessingFunctions" name="groupArrayElements" input="pipedObjects"/>
    <Function class="MBMLDataProcessingFunctions" name="reduce" input="pipedExpressions"/>
*/

- (void) testCollectionPassesTest
{
    consoleTrace();

    //
    // test expected successes
    //
    BOOL passes = [MBExpression asBoolean:@"^collectionPassesTest($nameList|$item.firstName.length -GT 0)"];
    XCTAssertTrue(passes);

    passes = [MBExpression asBoolean:@"^collectionPassesTest($nameList|$item.firstName == Debbie)"];
    XCTAssertFalse(passes);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^collectionPassesTest()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^collectionPassesTest($nameList)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^collectionPassesTest($nameList|$item.firstName.length -GT 0|foo)" error:&err];
    expectError(err);
}

- (void) testContainsValue
{
    consoleTrace();

    //
    // test expected successes
    //
    BOOL contains = [MBExpression asBoolean:@"^containsValue($nameList|$(Jill Test))"];
    XCTAssertTrue(contains);

    contains = [MBExpression asBoolean:@"^containsValue($nameList|$newYorkTeams)"];
    XCTAssertFalse(contains);

    contains = [MBExpression asBoolean:@"^containsValue($nameList|$newYorkTeams|$(Debbie Test))"];
    XCTAssertTrue(contains);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^containsValue(string|foo)" error:&err];
    expectError(err);
}

- (void) testSetContains
{
    consoleTrace();

    //
    // test expected successes
    //
    BOOL contains = [MBExpression asBoolean:@"^setContains($testSet|$(Jill Test))"];
    XCTAssertTrue(contains);
    contains = [MBExpression asBoolean:@"^setContains($testSet|something nonexistent)"];
    XCTAssertFalse(contains);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^setContains()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^setContains($testSet)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^setContains($NULL|item)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^setContains($testSet|$(Jill Test)|$(Barrett Test))" error:&err];
    expectError(err);
}

- (void) testValuesPassingTest
{
    consoleTrace();

    //
    // test expected successes
    //
    NSArray* values1 = [MBExpression asObject:@"^valuesPassingTest($testSet|$item.firstName == Jill)"];
    XCTAssertTrue([values1 isKindOfClass:[NSArray class]]);
    XCTAssertTrue(values1.count == 1);
    id jill = [MBExpression asObject:@"$(Jill Test)"];
    XCTAssertEqualObjects(values1[0], jill);

    NSArray* values2 = [MBExpression asObject:@"^valuesPassingTest($testMap|!^hasPrefix($item|T))"];
    XCTAssertTrue([values2 isKindOfClass:[NSArray class]]);
    XCTAssertTrue(values2.count == 2);
    NSSet* set = [NSSet setWithArray:values2];
    XCTAssertTrue([set containsObject:@"One"]);
    XCTAssertTrue([set containsObject:@"Four"]);

    NSArray* values3 = [MBExpression asObject:@"^valuesPassingTest($testSet|$testMap|$item == Two -OR (^isDictionary($item) -AND $item.species == cat))"];
    XCTAssertTrue([values3 isKindOfClass:[NSArray class]]);
    XCTAssertTrue(values3.count == 2);
    id barrett = [MBExpression asObject:@"$(Barrett Test)"];
    set = [NSSet setWithArray:values3];
    XCTAssertTrue([set containsObject:barrett]);
    XCTAssertTrue([set containsObject:@"Two"]);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^valuesPassingTest()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^valuesPassingTest($testMap)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^valuesPassingTest($NULL|T)" error:&err];
    expectError(err);
}

- (void) testValuesIntersect
{
    consoleTrace();

    //
    // test expected successes
    //
    BOOL result = [MBExpression asBoolean:@"^valuesIntersect($testMap|$testValues)"];
    XCTAssertTrue(result);
    result = [MBExpression asBoolean:@"^valuesIntersect($testKeys|$testValues)"];
    XCTAssertFalse(result);
    result = [MBExpression asBoolean:@"^valuesIntersect(^setWithArray($testKeys)|^array(Key 2))"];
    XCTAssertTrue(result);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^valuesIntersect($testMap|$NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^valuesIntersect($testMap)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^valuesIntersect($testMap|$testValues|$testValues)" error:&err];
    expectError(err);
}

- (void) testJoin
{
    consoleTrace();

    //
    // test expected successes
    //
    NSString* joined = [MBExpression asString:@"^join($testKeys|; )"];
    XCTAssertNotNil(joined);
    XCTAssertEqualObjects(joined, @"Key 1; Key 2; Key 3; Key 4");

    joined = [MBExpression asString:@"^join($testKeys|$testValues|, )"];
    XCTAssertNotNil(joined);
    XCTAssertEqualObjects(joined, @"Key 1, Key 2, Key 3, Key 4, One, Two, Three, Four");
    consoleObj(joined);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^join($testKeys)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^join(, |$testKeys)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^join($testKeys|$testValues)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^join($testKeys|not a collection|, )" error:&err];
    expectError(err);
}

- (void) testSplit
{
    consoleTrace();

    //
    // test expected successes
    //
    NSArray* testArray1 = [MBExpression asObject:@"$testKeys"];
    NSArray* array1 = [MBExpression asObject:@"^split(, |Key 1, Key 2, Key 3, Key 4)"];
    XCTAssertTrue([array1 isKindOfClass:[NSArray class]]);
    XCTAssertEqualObjects(array1, testArray1);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^split(, )" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^split(, |Split, Me|But, Not, Me!)" error:&err];
    expectError(err);
}

- (void) testSplitLines
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSArray* testSplit = [MBExpression asObject:@"$testValues"];
    NSArray* split = [MBExpression asObject:@"^splitLines($splitLines)"];
    XCTAssertTrue([split isKindOfClass:[NSArray class]]);
    XCTAssertEqualObjects(split, testSplit);

    split = [MBExpression asObject:@"^splitLines(One\nTwo\nThree\nFour)"];
    XCTAssertTrue([split isKindOfClass:[NSArray class]]);
    XCTAssertEqualObjects(split, testSplit);
}

- (void) testAppendArrays
{
    consoleTrace();

    //
    // test expected successes
    //
    NSArray* testKeys = [MBExpression asObject:@"$testKeys"];
    NSArray* testValues = [MBExpression asObject:@"$testValues"];
    NSArray* newYorkTeams = [MBExpression asObject:@"$newYorkTeams"];
    NSArray* testArray = [testKeys arrayByAddingObjectsFromArray:[testValues arrayByAddingObjectsFromArray:newYorkTeams]];
    consoleObj(testArray);

    NSArray* array = [MBExpression asObject:@"^appendArrays($testKeys|$testValues|$newYorkTeams)"];
    XCTAssertTrue([array isKindOfClass:[NSArray class]]);
    XCTAssertEqualObjects(array, testArray);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^appendArrays()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^appendArrays($testKeys)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^appendArrays($testKeys|notAnArray)" error:&err];
    expectError(err);
}

- (void) testFlattenArrays
{
    consoleTrace();

    //
    // test expected successes
    //
    NSArray* testAgainst = [MBExpression asObject:@"^appendArrays($testKeys|$testValues|$newYorkTeams)"];
    NSArray* flattened = [MBExpression asObject:@"^flattenArrays($toFlatten)"];
    XCTAssertTrue([flattened isKindOfClass:[NSArray class]]);
    XCTAssertEqualObjects(flattened, testAgainst);
    flattened = [MBExpression asObject:@"^flattenArrays($toFlatten|$toFlatten)"];
    XCTAssertTrue([flattened isKindOfClass:[NSArray class]]);
    XCTAssertEqualObjects(flattened, [testAgainst arrayByAddingObjectsFromArray:testAgainst]);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^flattenArrays()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^flattenArrays($NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^flattenArrays($toFlatten|$NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^flattenArrays($toFlatten|string)" error:&err];
    expectError(err);
}

- (void) testFilter
{
    consoleTrace();


    //
    // test expected successes
    //
    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];

    // filter an array
    NSArray* humansArray = [MBExpression asObject:@"^filter($nameList|$item.species == human|matchAll)"];
    XCTAssertTrue([humansArray isKindOfClass:[NSArray class]]);
    XCTAssertTrue(humansArray.count == 4);
    scope[@"humansArray"] = humansArray;
    NSArray* testHumans = [MBExpression asObject:@"^array($(Jill Test)|$(Evan Test)|$(Debbie Test)|$(Lauren Test))"];
    XCTAssertEqualObjects(humansArray, testHumans);

    NSArray* humansWithNiecesArray = [MBExpression asObject:@"^filter($humansArray|$item[nieces]|matchAll)"];
    XCTAssertTrue([humansWithNiecesArray isKindOfClass:[NSArray class]]);
    XCTAssertTrue(humansWithNiecesArray.count == 2);
    NSArray* testHumansWithNiecesArray = [MBExpression asObject:@"^array($(Jill Test)|$(Debbie Test))"];
    XCTAssertEqualObjects(humansWithNiecesArray, testHumansWithNiecesArray);

    // filter a dictionary
    NSDictionary* humansMap = [MBExpression asObject:@"^filter($nameMap|$item.species == human|matchAll)"];
    XCTAssertTrue([humansMap isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(humansMap.count == 4);
    scope[@"humansMap"] = humansMap;
    NSDictionary* testHumansMap = [MBExpression asObject:@"^dictionary(Jill|$(Jill Test)|Evan|$(Evan Test)|Debbie|$(Debbie Test)|Lauren|$(Lauren Test))"];
    XCTAssertEqualObjects(humansMap, testHumansMap);

    NSDictionary* humansWithNiecesMap = [MBExpression asObject:@"^filter($humansMap|$item[nieces]|matchAll)"];
    XCTAssertTrue([humansWithNiecesMap isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(humansWithNiecesMap.count == 2);
    NSDictionary* testHumansWithNiecesMap = [MBExpression asObject:@"^dictionary(Jill|$(Jill Test)|Debbie|$(Debbie Test))"];
    XCTAssertEqualObjects(humansWithNiecesMap, testHumansWithNiecesMap);

    // filter a set
    NSSet* humansSet = [MBExpression asObject:@"^filter(^setWithArray($nameList)|$item.species == human|matchAll)"];
    XCTAssertTrue([humansSet isKindOfClass:[NSSet class]]);
    XCTAssertTrue(humansSet.count == 4);
    scope[@"humansSet"] = humansSet;
    NSSet* testHumansSet = [MBExpression asObject:@"^set($(Jill Test)|$(Evan Test)|$(Debbie Test)|$(Lauren Test))"];
    XCTAssertEqualObjects(humansSet, testHumansSet);

    NSSet* humansWithNiecesSet = [MBExpression asObject:@"^filter($humansSet|$item[nieces]|matchAll)"];
    XCTAssertTrue([humansWithNiecesSet isKindOfClass:[NSSet class]]);
    XCTAssertTrue(humansWithNiecesSet.count == 2);
    NSSet* testHumansWithNiecesSet = [MBExpression asObject:@"^set($(Jill Test)|$(Debbie Test))"];
    XCTAssertEqualObjects(humansWithNiecesSet, testHumansWithNiecesSet);

    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^filter()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^filter($nameList)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^filter($NULL|$item)" error:&err];
    expectError(err);
}

- (void) testList
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
//    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
//    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);
}

- (void) testPruneMatchingLeaves
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
//    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
//    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);
}

- (void) testPruneNonmatchingLeaves
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
//    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
//    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);
}

- (void) testAssociate
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
//    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
//    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);
}

- (void) testAssociateWithSingleValue
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
//    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
//    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);
}

- (void) testAssociateWithArray
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
//    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
//    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);
}

- (void) testSort
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
//    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
//    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);
}

- (void) testMergeDictionaries
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
//    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
//    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);
}

- (void) testUnique
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
//    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
//    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);
}

- (void) testDistributeArrayElements
{
    consoleTrace();
    
    //
    // test expected successes
    //
    NSArray* distributed = [MBExpression asObject:@"^distributeArrayElements($newYorkTeams|2)"];
    XCTAssertTrue([distributed isKindOfClass:[NSArray class]]);
    XCTAssertTrue(distributed.count == 2);
    NSArray* expectedArray1 = [NSArray arrayWithObjects:@"Yankees", @"Knicks", @"Islanders", nil];
    NSArray* expectedArray2 = [NSArray arrayWithObjects:@"Mets", @"Rangers", nil];
    XCTAssertEqualObjects(expectedArray1, distributed[0]);
    XCTAssertEqualObjects(expectedArray2, distributed[1]);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
//    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
//    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);
}

- (void) testGroupArrayElements
{
    consoleTrace();

    //
    // test expected successes
    //
    NSArray* grouped = [MBExpression asObject:@"^groupArrayElements($newYorkTeams|2)"];
    XCTAssertTrue([grouped isKindOfClass:[NSArray class]]);
    XCTAssertTrue(grouped.count == 3);
    NSArray* expectedArray1 = [NSArray arrayWithObjects:@"Yankees", @"Mets", nil];
    NSArray* expectedArray2 = [NSArray arrayWithObjects:@"Knicks", @"Rangers", nil];
    NSArray* expectedArray3 = [NSArray arrayWithObjects:@"Islanders", nil];
    XCTAssertEqualObjects(expectedArray1, grouped[0]);
    XCTAssertEqualObjects(expectedArray2, grouped[1]);
    XCTAssertEqualObjects(expectedArray3, grouped[2]);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
//    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
//    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);
}

- (void) testReduce
{
    consoleTrace();

    //
    // test expected successes
    //
    NSObject* reduced = [MBExpression asObject:@"^reduce($newYorkTeams|na|$item)"];
    XCTAssertEqualObjects(@"Islanders", reduced);
    
    reduced = [MBExpression asObject:@"^reduce($newYorkTeams|0|#($currentValue + $item.length))"];
    XCTAssertEqualObjects([NSNumber numberWithInt:33], reduced);
    
    reduced = [MBExpression asObject:@"^reduce(^array()|#(0)|#($currentValue + $item.length))"];
    XCTAssertEqualObjects([NSNumber numberWithInt:0], reduced);
    
    reduced = [MBExpression asObject:@"^reduce(^array(test)|0|#($currentValue + $item.length))"];
    XCTAssertEqualObjects([NSNumber numberWithInt:4], reduced);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
//    [MBExpression asBoolean:@"^containsValue()" error:&err];
    expectError(err);

    err = nil;
//    [MBExpression asBoolean:@"^containsValue($nameList)" error:&err];
    expectError(err);
}

@end
