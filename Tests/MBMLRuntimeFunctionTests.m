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

- (void) testClass
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

- (void) testSingleton
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

- (void) testInheritanceHierarchyForClass
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

- (void) testRespondsToSelector
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

- (void) testInstancesRespondToSelector
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
