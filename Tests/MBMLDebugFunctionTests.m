//
//  MBMLDebugFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/30/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLDebugFunctionTests class
/******************************************************************************/

@interface MBMLDebugFunctionTests : MockingbirdTestSuite
@end

@implementation MBMLDebugFunctionTests

/*
    <Function class="MBMLDebugFunctions" name="log" input="raw"/>
    <Function class="MBMLDebugFunctions" name="test" input="raw"/>
    <Function class="MBMLDebugFunctions" name="dump" input="raw"/>
    <Function class="MBMLDebugFunctions" name="debugBreak" input="raw"/>
    <Function class="MBMLDebugFunctions" name="tokenize" input="raw"/>
    <Function class="MBMLDebugFunctions" name="tokenizeBoolean" input="raw"/>
    <Function class="MBMLDebugFunctions" name="tokenizeMath" input="raw"/>
    <Function class="MBMLDebugFunctions" name="bench" input="raw"/>
    <Function class="MBMLDebugFunctions" name="benchBool" input="raw"/>
    <Function class="MBMLDebugFunctions" name="repeat" input="pipedExpressions"/>
    <Function class="MBMLDebugFunctions" name="repeatBool" input="pipedExpressions"/>
    <Function class="MBMLDebugFunctions" name="deprecateVariableInFavorOf" input="pipedExpressions"/>
 */

/******************************************************************************/
#pragma mark Tests
/******************************************************************************/

- (void) testLog
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

- (void) testTest
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

- (void) testDump
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

- (void) testDebugBreak
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

- (void) testTokenize
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

- (void) testTokenizeBoolean
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

- (void) testTokenizeMath
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

- (void) testBench
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

- (void) testBenchBool
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

- (void) testRepeat
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

- (void) testRepeatBool
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

- (void) testDeprecateVariableInFavorOf
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
