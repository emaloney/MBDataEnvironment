//
//  MBMLMathFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MBDataEnvironmentTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathFunctionTests class
/******************************************************************************/

@interface MBMLMathFunctionTests : MBDataEnvironmentTestSuite
@end

@implementation MBMLMathFunctionTests

/*
    <Function class="MBMLMathFunctions" name="mod" input="pipedMath"/>
    <Function class="MBMLMathFunctions" name="modFloat" input="pipedMath"/>
    <Function class="MBMLMathFunctions" name="percent" input="pipedExpressions"/>
    <Function class="MBMLMathFunctions" name="ceil" input="math"/>
    <Function class="MBMLMathFunctions" name="floor" input="math"/>
    <Function class="MBMLMathFunctions" name="round" input="math"/>
    <Function class="MBMLMathFunctions" name="min" input="pipedMath"/>
    <Function class="MBMLMathFunctions" name="max" input="pipedMath"/>
    <Function class="MBMLMathFunctions" name="randomPercent" input="none"/>
    <Function class="MBMLMathFunctions" name="random" input="pipedMath"/>
    <Function class="MBMLMathFunctions" name="arrayFilledWithIntegers" input="pipedMath"/>
 */

/******************************************************************************/
#pragma mark Tests
/******************************************************************************/

- (void) testMod
{
    consoleTrace();

    //
    // test expected successes
    //
    NSNumber* modTest1 = [MBExpression asNumber:@"^mod(21|5)"];
    XCTAssertEqual([modTest1 integerValue], 1);
    NSNumber* modTest2 = [MBExpression asNumber:@"^mod(21|4)"];
    XCTAssertEqual([modTest2 integerValue], 1);
    NSNumber* modTest3 = [MBExpression asNumber:@"^mod(21|7)"];
    XCTAssertEqual([modTest3 integerValue], 0);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^mod()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^mod(21)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^mod(21|7|0)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^mod(21|0)" error:&err];
    expectError(err);
}

- (void) testModFloat
{
    consoleTrace();

    //
    // test expected successes
    //
    NSNumber* modTest1 = [MBExpression asNumber:@"^modFloat(21|5)"];
    XCTAssertEqual([modTest1 doubleValue], 1.0);
    NSNumber* modTest2 = [MBExpression asNumber:@"^modFloat(21|4)"];
    XCTAssertEqual([modTest2 doubleValue], 1.0);
    NSNumber* modTest3 = [MBExpression asNumber:@"^modFloat(21|7)"];
    XCTAssertEqual([modTest3 doubleValue], 0.0);
    NSNumber* modTest4 = [MBExpression asNumber:@"^modFloat(10.75|.5)"];
    XCTAssertEqual([modTest4 doubleValue], 0.25);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^modFloat()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^modFloat(21)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^modFloat(21|7|0)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"#(21 / 0)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^modFloat(21|0)" error:&err];
    expectError(err);
}

- (void) testPercent
{
    consoleTrace();

    //
    // test expected successes
    //
    for (NSUInteger i=0; i<=10; i++) {
        NSString* expr = [NSString stringWithFormat:@"^percent(%f|1.0)", (i/10.0)];
        NSString* pctStr = [NSString stringWithFormat:@"%u%%", (unsigned int)(i * 10)];
        NSString* pct = [MBExpression asObject:expr];
        XCTAssertTrue([pct isKindOfClass:[NSString class]], @"expected result of %@ to be an NSString", expr);
        XCTAssertEqualObjects(pct, pctStr, @"expected result of %@ to equal %@", expr, pctStr);
    }

    NSString* formatString = @"%3.1f%%";
    for (NSUInteger i=0; i<=10; i++) {
        NSString* expr = [NSString stringWithFormat:@"^percent(%@|%f|1.0)", formatString, (i/10.0)];
        NSString* pctStr = [NSString stringWithFormat:formatString, (i * 10.0)];
        NSString* pct = [MBExpression asObject:expr];
        XCTAssertTrue([pct isKindOfClass:[NSString class]], @"expected result of %@ to be an NSString", expr);
        XCTAssertEqualObjects(pct, pctStr, @"expected result of %@ to equal %@", expr, pctStr);
    }

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^percent()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^percent(%3.1f%%)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^percent(1.0)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^percent(|)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^percent(||)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^percent(1.0|string)" error:&err];
    expectError(err);
}

- (void) testCeil
{
    consoleTrace();

    //
    // test expected successes
    //
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^ceil(1.0)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:2], [MBExpression asObject:@"^ceil(1.1)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:2], [MBExpression asObject:@"^ceil(1.5)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:2], [MBExpression asObject:@"^ceil(1.9)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-1.0)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-1.1)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-1.5)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-1.9)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-2.9 + 1.0)"]);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^ceil()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^ceil(string)" error:&err];
    expectError(err);
}

- (void) testFloor
{
    //
    // test expected successes
    //
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^floor(1.0)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^floor(1.1)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^floor(1.5)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^floor(1.9)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^floor(-1.0)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^floor(-1.1)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^floor(-1.5)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^floor(-1.9)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^floor(-2.9 + 1.0)"]);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^floor()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^floor(string)" error:&err];
    expectError(err);
}

- (void) testRound
{
    //
    // test expected successes
    //
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^round(1.0)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^round(1.1)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^round(1.49)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:2], [MBExpression asObject:@"^round(1.5)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:2], [MBExpression asObject:@"^round(1.51)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:2], [MBExpression asObject:@"^round(1.9)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^round(-1.0)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^round(-1.1)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^round(-1.49)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^round(-1.5)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^round(-1.51)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^round(-1.9)"]);
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^round(-2.9 + 1.0)"]);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^round()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^round(string)" error:&err];
    expectError(err);
}

- (void) testMin
{
    //
    // test expected successes
    //
    XCTAssertEqualObjects(@0, [MBExpression asObject:@"^min(0|1)"]);
    XCTAssertEqualObjects(@0.0, [MBExpression asObject:@"^min(0.0|1.0)"]);
    XCTAssertEqualObjects(@0.001, [MBExpression asObject:@"^min(0.001|0.002)"]);
    XCTAssertEqualObjects(@(-1), [MBExpression asObject:@"^min(-1|0)"]);
    XCTAssertEqualObjects(@(-2), [MBExpression asObject:@"^min(-1|-2)"]);
    XCTAssertEqualObjects(@(-2), [MBExpression asObject:@"^min(-1 + 1|-2)"]);

    NSUInteger testResult1 = [[MBExpression asNumber:@"^min(100 | (20 * 10))"] unsignedIntegerValue];
    XCTAssertEqual((NSUInteger)100, testResult1);
    NSUInteger testResult2 = [[MBExpression asNumber:@"^min(100 | #(20 * 10))"] unsignedIntegerValue];
    XCTAssertEqual((NSUInteger)100, testResult2);
    NSUInteger testResult3 = [[MBExpression asNumber:@"^min(#(50 + 50) | #(20 * 10))"] unsignedIntegerValue];
    XCTAssertEqual((NSUInteger)100, testResult3);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^min()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^min(50)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^min(50|string)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^min(50|100|200)" error:&err];
    expectError(err);
}

- (void) testMax
{
    //
    // test expected successes
    //
    XCTAssertEqualObjects(@1, [MBExpression asObject:@"^max(0|1)"]);
    XCTAssertEqualObjects(@1.0, [MBExpression asObject:@"^max(0.0|1.0)"]);
    XCTAssertEqualObjects(@0.002, [MBExpression asObject:@"^max(0.001|0.002)"]);
    XCTAssertEqualObjects(@0, [MBExpression asObject:@"^max(-1|0)"]);
    XCTAssertEqualObjects(@0, [MBExpression asObject:@"^max(-1 + 1|-2)"]);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^max()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^max(50)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^max(50|string)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^max(50|100|200)" error:&err];
    expectError(err);
}

- (void) testRandomPercent
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    for (NSUInteger i=0; i<1000; i++) {
        NSNumber* random = [MBExpression asNumber:@"^randomPercent()"];
        XCTAssertGreaterThanOrEqual([random doubleValue], 0.0);
        XCTAssertLessThanOrEqual([random doubleValue], 1.0);
    }
}

- (void) testRandom
{
    consoleTrace();

    //
    // test expected successes
    //
    for (NSUInteger i=0; i<100; i++) {
        NSNumber* random = [MBExpression asNumber:@"^random(10)"];
        XCTAssertGreaterThanOrEqual([random integerValue], 0);
        XCTAssertLessThanOrEqual([random integerValue], 10);
    }
    for (NSUInteger i=0; i<100; i++) {
        NSNumber* random = [MBExpression asNumber:@"^random(90|100)"];
        XCTAssertGreaterThanOrEqual([random integerValue], 90);
        XCTAssertLessThanOrEqual([random integerValue], 100);
    }

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^random()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^random(num)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^random(num|ber)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^random(0|1|2)" error:&err];
    expectError(err);
}

- (void) testArrayFilledWithIntegers
{
    //
    // test expected successes
    //
    NSArray* testIntegers1 = @[@(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10)];
    NSArray* integers1 = [MBExpression asObject:@"^arrayFilledWithIntegers(1|10)"];
    XCTAssertTrue([integers1 isKindOfClass:[NSArray class]]);
    XCTAssertEqualObjects(integers1, testIntegers1);

    NSArray* testIntegers2 = @[@(0), @(2), @(4), @(6), @(8), @(10)];
    NSArray* integers2 = [MBExpression asObject:@"^arrayFilledWithIntegers(0|10|2)"];
    XCTAssertTrue([integers2 isKindOfClass:[NSArray class]]);
    XCTAssertEqualObjects(integers2, testIntegers2);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^arrayFilledWithIntegers()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^arrayFilledWithIntegers(10)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^arrayFilledWithIntegers(0|10|2|4)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^arrayFilledWithIntegers(string|10)" error:&err];
    expectError(err);
}

@end
