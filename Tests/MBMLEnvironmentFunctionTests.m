//
//  MBMLEnvironmentFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/30/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLEnvironmentFunctionTests class
/******************************************************************************/

@interface MBMLEnvironmentFunctionTests : MockingbirdTestSuite
@end

@implementation MBMLEnvironmentFunctionTests

/*
    <Function class="MBMLEnvironmentFunctions" name="mbmlLoadedPaths" input="none"/>
    <Function class="MBMLEnvironmentFunctions" name="mbmlLoadedFiles" input="none"/>
    <Function class="MBMLEnvironmentFunctions" name="mbmlPathIsLoaded" input="string"/>
    <Function class="MBMLEnvironmentFunctions" name="mbmlFileIsLoaded" input="string"/>
 */

/******************************************************************************/
#pragma mark Tests
/******************************************************************************/

- (void) testMbmlLoadedPaths
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSArray* paths = [MBExpression asObject:@"^mbmlLoadedPaths()"];
    XCTAssertTrue([paths isKindOfClass:[NSArray class]]);
    XCTAssertTrue(paths.count == 2);

    NSBundle* testBundle = [NSBundle bundleForClass:[self class]];
    NSString* testAppDataPath = [[testBundle resourcePath] stringByAppendingPathComponent:@"test-app-data.xml"];
    XCTAssertTrue([paths containsObject:testAppDataPath]);

    NSBundle* mbBundle = [NSBundle bundleForClass:[MBEnvironment class]];
    NSString* mbXmlPath = [[mbBundle resourcePath] stringByAppendingPathComponent:@"MBDataEnvironmentModule.xml"];
    XCTAssertTrue([paths containsObject:mbXmlPath]);
}

- (void) testMbmlLoadedFiles
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSArray* files = [MBExpression asObject:@"^mbmlLoadedFiles()"];
    XCTAssertTrue([files isKindOfClass:[NSArray class]]);
    XCTAssertTrue(files.count == 2);
    XCTAssertTrue([files containsObject:@"test-app-data.xml"]);
    XCTAssertTrue([files containsObject:@"MBDataEnvironmentModule.xml"]);
}

- (void) testMbmlPathIsLoaded
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSBundle* testBundle = [NSBundle bundleForClass:[self class]];
    NSString* testAppDataPath = [[testBundle resourcePath] stringByAppendingPathComponent:@"test-app-data.xml"];
    NSBundle* mbBundle = [NSBundle bundleForClass:[MBEnvironment class]];
    NSString* mbXmlPath = [[mbBundle resourcePath] stringByAppendingPathComponent:@"MBDataEnvironmentModule.xml"];

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"testAppDataPath"] = testAppDataPath;
    scope[@"testDataEnvironmentPath"] = mbXmlPath;

    BOOL isLoaded = [MBExpression asBoolean:@"^mbmlPathIsLoaded($testAppDataPath)"];
    XCTAssertTrue(isLoaded);
    isLoaded = [MBExpression asBoolean:@"^mbmlPathIsLoaded($testDataEnvironmentPath)"];
    XCTAssertTrue(isLoaded);
    isLoaded = [MBExpression asBoolean:@"^mbmlPathIsLoaded(/tmp/foo.xml)"];
    XCTAssertFalse(isLoaded);

    [MBScopedVariables exitVariableScope];
}

- (void) testMbmlFileIsLoaded
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    BOOL isLoaded = [MBExpression asBoolean:@"^mbmlFileIsLoaded(test-app-data.xml)"];
    XCTAssertTrue(isLoaded);
    isLoaded = [MBExpression asBoolean:@"^mbmlFileIsLoaded(MBDataEnvironmentModule.xml)"];
    XCTAssertTrue(isLoaded);
    isLoaded = [MBExpression asBoolean:@"^mbmlFileIsLoaded(foo.xml)"];
    XCTAssertFalse(isLoaded);

    [MBScopedVariables exitVariableScope];
}

@end
