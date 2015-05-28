//
//  MBMLDebugFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/30/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MBDataEnvironmentTestSuite.h"
#import "MBMLFunction.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLDebugFunctionTests class
/******************************************************************************/

@interface MBMLDebugFunctionTests : MBDataEnvironmentTestSuite
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
#pragma mark ^functionForTestingRepeat()
/******************************************************************************/

static int s_repeatCounter = 0;

+ (id) functionForTestingRepeat
{
    return @(++s_repeatCounter);
}


/******************************************************************************/
#pragma mark Setup
/******************************************************************************/

- (void) setUpVariableSpace:(MBVariableSpace*)vars
{
    MBLogInfoTrace();

    [super setUpVariableSpace:vars];

    MBMLFunction* func = [[MBMLFunction alloc] initWithName:@"functionForTestingRepeat"
                                                  inputType:MBMLFunctionInputNone
                                                 outputType:MBMLFunctionOutputObject
                                          implementingClass:[self class]
                                             methodSelector:@selector(functionForTestingRepeat)];

    XCTAssertTrue([vars declareFunction:func]);
}

/******************************************************************************/
#pragma mark Tests
/******************************************************************************/

- (void) testLog
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    // we can't test that the logging actually happens, just that
    // the passthrough functionality works as expected
    //
    NSDictionary* nameMap = [MBVariableSpace instance][@"nameMap"];
    NSDictionary* barrett = nameMap[@"Barrett"];

    id passthru = [MBExpression asObject:@"^log($nameMap)"];
    XCTAssertEqualObjects(passthru, nameMap);
    passthru = [MBExpression asObject:@"^log($nameMap).Barrett"];
    XCTAssertEqualObjects(passthru, barrett);
    passthru = [MBExpression asObject:@"^log($nameMap)[Barrett]"];
    XCTAssertEqualObjects(passthru, barrett);
    passthru = [MBExpression asObject:@"^log($nameMap.Barrett)"];
    XCTAssertEqualObjects(passthru, barrett);
    passthru = [MBExpression asObject:@"^log($nameMap[Barrett])"];
    XCTAssertEqualObjects(passthru, barrett);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^log(^associate())" error:&err];
    expectError(err);
}

- (void) testTest
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    // we can't test that the logging actually happens, just that
    // the passthrough functionality works as expected
    //
    BOOL passthru = [MBExpression asBoolean:@"^test(T)"];
    XCTAssertTrue(passthru);
    passthru = [MBExpression asBoolean:@"^test(T -AND F)"];
    XCTAssertFalse(passthru);
    passthru = [MBExpression asBoolean:@"^test(T -OR F)"];
    XCTAssertTrue(passthru);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^test(-OR)" error:&err];
    expectError(err);
}

- (void) testDump
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    // we can't test that the logging actually happens, just that
    // the passthrough functionality works as expected
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSDictionary* testData = [@"$testData" evaluateAsObject];
    NSString* dumped = [MBExpression asObject:@"^dump($testData)"];
    XCTAssertEqualObjects(dumped, [testData description]);
}

- (void) testDebugBreak
{
    //
    // we don't unit test this function because it will trigger
    // a debug breakpoint, effectively halting the unit tests :O
    //
}

- (void) testTokenize
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    // we can't test that the logging actually happens, just that
    // the passthrough functionality works as expected
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* passthru = [MBExpression asString:@"^tokenize(this $is a test)"];
    XCTAssertEqualObjects(passthru, @"this $is a test");
    passthru = [MBExpression asString:@"^tokenize($thisIsAlsoATest)"];
    XCTAssertEqualObjects(passthru, @"$thisIsAlsoATest");
    passthru = [MBExpression asString:@"^tokenize()"];
    XCTAssertNil(passthru);
}

- (void) testTokenizeBoolean
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    // we can't test that the logging actually happens, just that
    // the passthrough functionality works as expected
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* passthru = [MBExpression asString:@"^tokenizeBoolean(T -AND F)"];
    XCTAssertEqualObjects(passthru, @"T -AND F");
    passthru = [MBExpression asString:@"^tokenizeBoolean(!T -OR !(F))"];
    XCTAssertEqualObjects(passthru, @"!T -OR !(F)");
    passthru = [MBExpression asString:@"^tokenizeBoolean()"];
    XCTAssertNil(passthru);
}

- (void) testTokenizeMath
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    // we can't test that the logging actually happens, just that
    // the passthrough functionality works as expected
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* passthru = [MBExpression asString:@"^tokenizeMath(3 * 10)"];
    XCTAssertEqualObjects(passthru, @"3 * 10");
    passthru = [MBExpression asString:@"^tokenizeMath(52)"];
    XCTAssertEqualObjects(passthru, @"52");
    passthru = [MBExpression asString:@"^tokenizeMath($testOrderNumber * 2)"];
    XCTAssertEqualObjects(passthru, @"$testOrderNumber * 2");
    passthru = [MBExpression asString:@"^tokenizeMath()"];
    XCTAssertNil(passthru);
}

- (void) testBench
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    // we can't test that the logging actually happens, just that
    // the passthrough functionality works as expected
    //
    NSDictionary* nameMap = [MBVariableSpace instance][@"nameMap"];
    NSDictionary* barrett = nameMap[@"Barrett"];

    id passthru = [MBExpression asObject:@"^bench($nameMap)"];
    XCTAssertEqualObjects(passthru, nameMap);
    passthru = [MBExpression asObject:@"^bench($nameMap).Barrett"];
    XCTAssertEqualObjects(passthru, barrett);
    passthru = [MBExpression asObject:@"^bench($nameMap)[Barrett]"];
    XCTAssertEqualObjects(passthru, barrett);
    passthru = [MBExpression asObject:@"^bench($nameMap.Barrett)"];
    XCTAssertEqualObjects(passthru, barrett);
    passthru = [MBExpression asObject:@"^bench($nameMap[Barrett])"];
    XCTAssertEqualObjects(passthru, barrett);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^bench(^associate())" error:&err];
    expectError(err);
}

- (void) testBenchBool
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    // we can't test that the logging actually happens, just that
    // the passthrough functionality works as expected
    //
    BOOL passthru = [MBExpression asBoolean:@"^benchBool(T)"];
    XCTAssertTrue(passthru);
    passthru = [MBExpression asBoolean:@"^benchBool(T -AND F)"];
    XCTAssertFalse(passthru);
    passthru = [MBExpression asBoolean:@"^benchBool(T -OR F)"];
    XCTAssertTrue(passthru);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^benchBool(^associate())" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^benchBool(-OR)" error:&err];
    expectError(err);
}

- (void) testRepeat
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    int startCount = s_repeatCounter;
    NSNumber* lastVal = [MBExpression asNumber:@"^repeat(10|^functionForTestingRepeat())"];
    XCTAssertEqualObjects(lastVal, @(s_repeatCounter));
    XCTAssertEqual(startCount + 10, s_repeatCounter);
    
    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^repeat()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^repeat(^associate())" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^repeat(2|^associate())" error:&err];
    expectError(err);
}

- (void) testRepeatBool
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    int startCount = s_repeatCounter;
    BOOL result = [MBExpression asBoolean:@"^repeatBool(10|#(^functionForTestingRepeat() % 2) == 0)"];
    XCTAssertTrue(result);
    XCTAssertEqual(startCount + 10, s_repeatCounter);
    result = [MBExpression asBoolean:@"^repeatBool(11|#(^functionForTestingRepeat() % 2) == 0)"];
    XCTAssertFalse(result);
    XCTAssertEqual(startCount + 21, s_repeatCounter);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^repeatBool()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^repeatBool(^associate())" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^repeatBool(2|^associate())" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^repeatBool(2|-OR)" error:&err];
    expectError(err);
}

- (void) testDeprecateVariableInFavorOf
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    // we can't test that the logging actually happens, just that
    // the passthrough functionality works as expected
    //
    NSDictionary* testData = [@"$testData" evaluateAsObject];
    NSDictionary* data = [MBExpression asObject:@"^deprecateVariableInFavorOf($deprecatedTestData|$testData)"];
    XCTAssertEqualObjects(data, testData);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^deprecateVariableInFavorOf()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^deprecateVariableInFavorOf($nameList)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^deprecateVariableInFavorOf($nameList|2|3|4)" error:&err];
    expectError(err);
}


@end
