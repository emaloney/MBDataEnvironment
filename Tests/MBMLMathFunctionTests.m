//
//  MBMLMathFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathFunctionTests class
/******************************************************************************/

@interface MBMLMathFunctionTests : MockingbirdTestSuite
@end

@implementation MBMLMathFunctionTests

/*
 NEED TO BE ADDED:
    <Function class="MBMLMathFunctions" name="mod" input="pipedMath"/>
    <Function class="MBMLMathFunctions" name="modFloat" input="pipedMath"/>
    <Function class="MBMLMathFunctions" name="round" input="math"/>
    <Function class="MBMLMathFunctions" name="randomPercent" input="none"/>
    <Function class="MBMLMathFunctions" name="random" input="pipedMath"/>
    <Function class="MBMLMathFunctions" name="arrayFilledWithIntegers" input="pipedMath"/>

 
 FULL LIST:
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

- (void) _setupMathVariableWithPrefix:(NSString*)prefix
                               value1:(NSNumber*)num1
                               value2:(NSNumber*)num2
{
    NSDecimalNumber* dec1 = [NSDecimalNumber decimalNumberWithDecimal:[num1 decimalValue]];
    NSDecimalNumber* dec2 = [NSDecimalNumber decimalNumberWithDecimal:[num2 decimalValue]];
    
    MBVariableSpace* vars = [MBVariableSpace instance];
    [vars setVariable:[NSString stringWithFormat:@"%@%@", prefix, @"Value1"] value:dec1];
    [vars setVariable:[NSString stringWithFormat:@"%@%@", prefix, @"Value2"] value:dec2];
    [vars setVariable:[NSString stringWithFormat:@"%@%@", prefix, @"Sum"] value:[dec1 decimalNumberByAdding:dec2]];
    [vars setVariable:[NSString stringWithFormat:@"%@%@", prefix, @"Mult"] value:[dec1 decimalNumberByMultiplyingBy:dec2]];
    [vars setVariable:[NSString stringWithFormat:@"%@%@", prefix, @"Div"] value:[dec1 decimalNumberByDividingBy:dec2]];
    [vars setVariable:[NSString stringWithFormat:@"%@%@", prefix, @"Subt"] value:[dec1 decimalNumberBySubtracting:dec2]];
}

- (void) _setupMathVariables
{
    [self _setupMathVariableWithPrefix:@"short" 
                                value1:[NSNumber numberWithShort:32] 
                                value2:[NSNumber numberWithShort:64]];
    
    [self _setupMathVariableWithPrefix:@"int" 
                                value1:[NSNumber numberWithInteger:-32000] 
                                value2:[NSNumber numberWithInteger:64000]];
    
    [self _setupMathVariableWithPrefix:@"long" 
                                value1:[NSNumber numberWithLong:-32000] 
                                value2:[NSNumber numberWithLong:64000]];
    
    [self _setupMathVariableWithPrefix:@"longLong" 
                                value1:[NSNumber numberWithLongLong:-320000000000] 
                                value2:[NSNumber numberWithLongLong:640000000000]];
    
    [self _setupMathVariableWithPrefix:@"float" 
                                value1:[NSNumber numberWithFloat:-32.001] 
                                value2:[NSNumber numberWithFloat:64.999]];
    
    [self _setupMathVariableWithPrefix:@"double" 
                                value1:[NSNumber numberWithFloat:-3200000.00001] 
                                value2:[NSNumber numberWithFloat:6400000.99999]];
}

- (void) testMathFunctions
{
    [self _setupMathVariables];
    
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^ceil(1.0)"], @"expected ^ceil(1.0) == 1");
    XCTAssertEqualObjects([NSNumber numberWithInt:2], [MBExpression asObject:@"^ceil(1.1)"], @"expected ^ceil(1.1) == 2");
    XCTAssertEqualObjects([NSNumber numberWithInt:2], [MBExpression asObject:@"^ceil(1.5)"], @"expected ^ceil(1.5) == 2");
    XCTAssertEqualObjects([NSNumber numberWithInt:2], [MBExpression asObject:@"^ceil(1.9)"], @"expected ^ceil(1.9) == 2");
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-1.0)"], @"expected ^ceil(-1.0) == -1");
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-1.1)"], @"expected ^ceil(-1.1) == -1");
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-1.5)"], @"expected ^ceil(-1.5) == -1");
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-1.9)"], @"expected ^ceil(-1.9) == -1");
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^ceil(-2.9 + 1.0)"], @"expected ^ceil(-2.9 + 1.0) == -1");
    
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^floor(1.0)"], @"expected ^floor(1.0) == 1");
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^floor(1.1)"], @"expected ^floor(1.1) == 1");
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^floor(1.5)"], @"expected ^floor(1.5) == 1");
    XCTAssertEqualObjects([NSNumber numberWithInt:1], [MBExpression asObject:@"^floor(1.9)"], @"expected ^floor(1.9) == 1");
    XCTAssertEqualObjects([NSNumber numberWithInt:-1], [MBExpression asObject:@"^floor(-1.0)"], @"expected ^floor(-1.0) == -1");
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^floor(-1.1)"], @"expected ^floor(-1.1) == -2");
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^floor(-1.5)"], @"expected ^floor(-1.5) == -2");
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^floor(-1.9)"], @"expected ^floor(-1.9) == -2");
    XCTAssertEqualObjects([NSNumber numberWithInt:-2], [MBExpression asObject:@"^floor(-2.9 + 1.0)"], @"expected ^floor(-2.9 + 1.0) == -2");

    //test ^min(a,b)
    XCTAssertEqualObjects(@0, [MBExpression asObject:@"^min(0|1)"], @"expected ^min(0|1) == 0");
    XCTAssertEqualObjects(@0.0, [MBExpression asObject:@"^min(0.0|1.0)"], @"expected ^min(0.0|1.0) == 0.0");
    XCTAssertEqualObjects(@0.001, [MBExpression asObject:@"^min(0.001|0.002)"], @"expected ^min(0.001|0.002) == 0.001");
    XCTAssertEqualObjects(@(-1), [MBExpression asObject:@"^min(-1|0)"], @"expected ^min(-1|0) == -1");
    XCTAssertEqualObjects(@(-2), [MBExpression asObject:@"^min(-1|-2)"], @"expected ^min(-1|-2) == -2");
    XCTAssertEqualObjects(@(-2), [MBExpression asObject:@"^min(-1 + 1|-2)"], @"expected ^min(-1 + 0|-2) == -2");
    
    //test ^max(a,b)
    XCTAssertEqualObjects(@1, [MBExpression asObject:@"^max(0|1)"], @"expected ^max(0|1) == 1");
    XCTAssertEqualObjects(@1.0, [MBExpression asObject:@"^max(0.0|1.0)"], @"expected ^max(0.0|1.0) == 1.0");
    XCTAssertEqualObjects(@0.002, [MBExpression asObject:@"^max(0.001|0.002)"], @"expected ^max(0.001|0.002) == 0.002");
    XCTAssertEqualObjects(@0, [MBExpression asObject:@"^max(-1|0)"], @"expected ^max(-1|0) == 0");
    XCTAssertEqualObjects(@0, [MBExpression asObject:@"^max(-1 + 1|-2)"], @"expected ^max(-1 + 1|-2) == 0");
    
}

- (void) testMathFunctionFailures
{
    //
    // test of ^sum()
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^sum()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^sum() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^sum(|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^sum() with two empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^sum(||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^sum() with three empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^sum(2.5)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^sum() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^sum(this|that)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^sum() with non-numeric parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^sum(2.5|five)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^sum() with one non-numeric parameter");
    logExpectedError(err);

}

- (void) testMathFunctionPercent
{
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
}

- (void) testMathFunctionPercentFailures
{
    //
    // test of ^percent()
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^percent()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^percent() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^percent(%3.1f%%)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^percent() with a format string and no numeric parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^percent(1.0)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^percent() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^percent(|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^percent() with two empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^percent(||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^percent() with three empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^percent(1.0|string)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^percent() with an expected numeric parameter provided as a string");
    logExpectedError(err);
}

/******************************************************************************/
#pragma mark Regression tests
/******************************************************************************/

- (void) testMathExpressionParameters
{
    NSUInteger testResult1 = [[MBExpression asNumber:@"^min(100 | (20 * 10))"] unsignedIntegerValue];
    XCTAssertEqual((NSUInteger)100, testResult1, @"Math expression parameter test 1 failed");
    NSUInteger testResult2 = [[MBExpression asNumber:@"^min(100 | #(20 * 10))"] unsignedIntegerValue];
    XCTAssertEqual((NSUInteger)100, testResult2, @"Math expression parameter test 2 failed");
    NSUInteger testResult3 = [[MBExpression asNumber:@"^min(#(50 + 50) | #(20 * 10))"] unsignedIntegerValue];
    XCTAssertEqual((NSUInteger)100, testResult3, @"Math expression parameter test 3 failed");
}

@end
