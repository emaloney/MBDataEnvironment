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

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

- (void) testMbmlLoadedFiles
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

- (void) testMbmlPathIsLoaded
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

- (void) testMbmlFileIsLoaded
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

@end
