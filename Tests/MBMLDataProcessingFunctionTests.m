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
 NEED TO ADD:
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


 FULL LIST:
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

- (void) testDataProcessingFunctionFailures
{
    
}

@end
