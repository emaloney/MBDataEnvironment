//
//  MBMLRuntimeFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/30/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLRuntimeFunctionTests class
/******************************************************************************/

@interface MBMLRuntimeFunctionTests : MockingbirdTestSuite
@end

@implementation MBMLRuntimeFunctionTests

/*
    <Function class="MBMLRuntimeFunctions" name="classExists" input="string"/>
    <Function class="MBMLRuntimeFunctions" name="class" method="getClass" input="string"/>
    <Function class="MBMLRuntimeFunctions" name="singleton" input="object"/>
    <Function class="MBMLRuntimeFunctions" name="inheritanceHierarchyForClass" input="object"/>
    <Function class="MBMLRuntimeFunctions" name="respondsToSelector" method="objectRespondsToSelector" input="pipedObjects"/>
    <Function class="MBMLRuntimeFunctions" name="instancesRespondToSelector" method="classRespondsToSelector" input="pipedObjects"/>
 */

/******************************************************************************/
#pragma mark Tests
/******************************************************************************/

- (void) testClassExists
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    BOOL exists = [MBExpression asBoolean:@"^classExists(NSString)"];
    XCTAssertTrue(exists);
    exists = [MBExpression asBoolean:@"^classExists(MBEnvironment)"];
    XCTAssertTrue(exists);
    exists = [MBExpression asBoolean:@"^classExists(thisClassShouldNotExistInTheRuntime)"];
    XCTAssertFalse(exists);
}

- (void) testClass
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    Class cls = [MBExpression asObject:@"^class(NSString)"];
    XCTAssertNotNil(cls);
    XCTAssertTrue(cls == [NSString class]);
    cls = [MBExpression asObject:@"^class(MBEnvironment)"];
    XCTAssertNotNil(cls);
    XCTAssertTrue(cls == [MBEnvironment class]);
    cls = [MBExpression asObject:@"^class(thisClassShouldNotExistInTheRuntime)"];
    XCTAssertNil(cls);
}

- (void) testSingleton
{
    consoleTrace();

    //
    // test expected successes
    //
    MBServiceManager* svcMgr = [MBExpression asObject:@"^singleton(MBServiceManager)"];
    XCTAssertTrue([svcMgr isKindOfClass:[MBServiceManager class]]);
    svcMgr = [MBExpression asObject:@"^singleton(^class(MBServiceManager))"];
    XCTAssertTrue([svcMgr isKindOfClass:[MBServiceManager class]]);
    NSString* shouldFail = [MBExpression asObject:@"^singleton(^class(NSString))"];
    XCTAssertNil(shouldFail);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^singleton()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^singleton(thisClassShouldNotExistInTheRuntime)" error:&err];
    expectError(err);
}

- (void) testInheritanceHierarchyForClass
{
    consoleTrace();

    //
    // test expected successes
    //
    NSArray* hier1 = [MBExpression asObject:@"^inheritanceHierarchyForClass(NSMutableString)"];
    XCTAssertTrue([hier1 isKindOfClass:[NSArray class]]);
    XCTAssertTrue(hier1.count == 3);
    XCTAssertTrue(hier1[0] == [NSMutableString class]);
    XCTAssertTrue(hier1[1] == [NSString class]);
    XCTAssertTrue(hier1[2] == [NSObject class]);
    NSArray* hier2 = [MBExpression asObject:@"^inheritanceHierarchyForClass(^class(NSMutableString))"];
    XCTAssertEqualObjects(hier1, hier2);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^inheritanceHierarchyForClass()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^inheritanceHierarchyForClass(thisClassShouldNotExistInTheRuntime)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^inheritanceHierarchyForClass($NULL)" error:&err];
    expectError(err);
}

- (void) testRespondsToSelector
{
    consoleTrace();

    //
    // test expected successes
    //
    BOOL responds = [MBExpression asBoolean:@"^respondsToSelector(aLiteralString|isEqualToString:)"];
    XCTAssertTrue(responds);
    responds = [MBExpression asBoolean:@"^respondsToSelector(aLiteralString|isEqualToProgRockAlbum:)"];
    XCTAssertFalse(responds);
    responds = [MBExpression asBoolean:@"^respondsToSelector($testSet|containsObject:)"];
    XCTAssertTrue(responds);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^respondsToSelector()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^respondsToSelector(aLiteralString)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^respondsToSelector($testSet|containsObject:|aLiteral)" error:&err];
    expectError(err);
}

- (void) testInstancesRespondToSelector
{
    consoleTrace();

    //
    // test expected successes
    //
    BOOL responds = [MBExpression asBoolean:@"^instancesRespondToSelector(NSString|availableStringEncodings)"];
    XCTAssertTrue(responds);
    responds = [MBExpression asBoolean:@"^instancesRespondToSelector(^class(NSString)|availableStringEncodings)"];
    XCTAssertTrue(responds);
    responds = [MBExpression asBoolean:@"^instancesRespondToSelector(NSString|didComeFromAnotherPlanet:)"];
    XCTAssertFalse(responds);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^instancesRespondToSelector()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^instancesRespondToSelector(aLiteralString)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^instancesRespondToSelector(NSString|availableStringEncodings|extraneous)" error:&err];
    expectError(err);
}

@end
