//
//  MBMLResourceFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/30/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MBDataEnvironmentTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLResourceFunctionTests class
/******************************************************************************/

@interface MBMLResourceFunctionTests : MBDataEnvironmentTestSuite
@end

@implementation MBMLResourceFunctionTests

/*
    <Function class="MBMLResourceFunctions" name="directoryForMainBundle" input="none"/>
    <Function class="MBMLResourceFunctions" name="directoryForBundleWithIdentifier" input="string"/>
    <Function class="MBMLResourceFunctions" name="directoryForClassBundle" input="string"/>
 */

/******************************************************************************/
#pragma mark Tests
/******************************************************************************/

- (void) testDirectoryForMainBundle
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* dir = [MBExpression asString:@"^directoryForMainBundle()"];
    XCTAssertEqualObjects(dir, [[NSBundle mainBundle] bundlePath]);
}

- (void) testDirectoryForBundleWithIdentifier
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* dir = [MBExpression asString:@"^directoryForBundleWithIdentifier(com.gilt.tests.MBDataEnvironment)"];
    XCTAssertEqualObjects(dir, [[NSBundle bundleWithIdentifier:@"com.gilt.tests.MBDataEnvironment"] resourcePath]);
}

- (void) testDirectoryForClassBundle
{
    consoleTrace();

    //
    // test expected successes
    //
    NSString* dir = [MBExpression asString:@"^directoryForClassBundle(MBEnvironment)"];
    XCTAssertEqualObjects(dir, [[NSBundle bundleForClass:[MBEnvironment class]] resourcePath]);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^directoryForClassBundle()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^directoryForClassBundle(AClassWithThisNameShouldNotExistAtRuntimeOrElseThisTestWillFail)" error:&err];
    expectError(err);
}

@end
