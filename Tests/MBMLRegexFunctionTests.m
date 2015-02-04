//
//  MBMLRegexFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MBDataEnvironmentTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLRegexFunctionTests class
/******************************************************************************/

@interface MBMLRegexFunctionTests : MBDataEnvironmentTestSuite
@end

@implementation MBMLRegexFunctionTests

/*
    <Function class="MBMLRegexFunctions" name="stripRegex" input="pipedStrings"/>
    <Function class="MBMLRegexFunctions" name="replaceRegex" input="pipedStrings"/>
    <Function class="MBMLRegexFunctions" name="matchesRegex" input="pipedStrings"/>
 */

- (void) testRegexFunctions
{
    //
    // note: the purpose here is not to test every possible regex, but
    //       to ensure that the correct parameters are passed to the regex 
    //       engine, resulting in expected return values
    //
    
    //
    // test of ^stripRegex()
    //
    NSString* regexResult = [MBExpression asObject:@"^stripRegex(ThisIsAStringThatWillBeStripped|[TIASWB])"];
    XCTAssertTrue([regexResult isKindOfClass:[NSString class]], @"expected result of ^stripRegex() to be an NSString");
    XCTAssertEqualObjects(regexResult, @"hisstringhatilletripped", @"unexpected result from ^stripRegex()");
    regexResult = [MBExpression asObject:@"^stripRegex(ThisIsAStringThatWillBeStripped|[TIASWB]|[aeiou])"];
    XCTAssertTrue([regexResult isKindOfClass:[NSString class]], @"expected result of ^stripRegex() to be an NSString");
    XCTAssertEqualObjects(regexResult, @"hsstrnghtlltrppd", @"unexpected result from ^stripRegex()");
    regexResult = [MBExpression asObject:@"^stripRegex(ThisIsAStringThatWillBeStripped|[TIASWB]|[a-e]|ripp)"];
    XCTAssertTrue([regexResult isKindOfClass:[NSString class]], @"expected result of ^stripRegex() to be an NSString");
    XCTAssertEqualObjects(regexResult, @"hisstringhtillt", @"unexpected result from ^stripRegex()");

    //
    // test of ^replaceRegex()
    //
    regexResult = [MBExpression asObject:@"^replaceRegex(Replace Me, Replace Me| Me|)"];
    XCTAssertTrue([regexResult isKindOfClass:[NSString class]], @"expected result of ^replaceRegex() to be an NSString");
    XCTAssertEqualObjects(regexResult, @"Replace, Replace", @"unexpected result from ^replaceRegex()");
    regexResult = [MBExpression asObject:@"^replaceRegex(This is my string. There are many like it, but this one is mine.|string|gun)"];
    XCTAssertTrue([regexResult isKindOfClass:[NSString class]], @"expected result of ^replaceRegex() to be an NSString");
    XCTAssertEqualObjects(regexResult, @"This is my gun. There are many like it, but this one is mine.", @"unexpected result from ^replaceRegex()");

    //
    // test of ^matchesRegex()
    //
    NSNumber* boolResult = [MBExpression asObject:@"^matchesRegex(212-452-2510|[0-9]{3}-[0-9]{3}-[0-9]{4})"];
    XCTAssertTrue([boolResult isKindOfClass:[NSNumber class]], @"expected result of ^matchesRegex() to be an NSNumber");
    XCTAssertTrue([boolResult boolValue], @"unexpected result from ^matchesRegex()");
    boolResult = [MBExpression asObject:@"^matchesRegex(212-452-2510|[0-9]{3}-[0-9]{3}-[0-9]{4}|.*-452-.*|^212-|2510$)"];
    XCTAssertTrue([boolResult isKindOfClass:[NSNumber class]], @"expected result of ^matchesRegex() to be an NSNumber");
    XCTAssertTrue([boolResult boolValue], @"unexpected result from ^matchesRegex()");
    boolResult = [MBExpression asObject:@"^matchesRegex(unknown|[0-9]{3}-[0-9]{3}-[0-9]{4}|unknown)"];
    XCTAssertTrue([boolResult isKindOfClass:[NSNumber class]], @"expected result of ^matchesRegex() to be an NSNumber");
    XCTAssertTrue([boolResult boolValue] == NO, @"unexpected result from ^matchesRegex()");
    boolResult = [MBExpression asObject:@"^matchesRegex(match|match)"];
    XCTAssertTrue([boolResult isKindOfClass:[NSNumber class]], @"expected result of ^matchesRegex() to be an NSNumber");
    XCTAssertTrue([boolResult boolValue], @"unexpected result from ^matchesRegex()");
}

- (void) testRegexFunctionFailures
{
    //
    // test of ^stripRegex()
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^stripRegex()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^stripRegex() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^stripRegex(stripFromString)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^stripRegex() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^stripRegex(stripFromString|[)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^stripRegex() with an invalid regular expression");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^stripRegex(|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^stripRegex() with two empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^stripRegex(||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^stripRegex() with three empty parameters");
    logExpectedError(err);
    
    //
    // test of ^replaceRegex()
    //
    err = nil;
    [MBExpression asString:@"^replaceRegex()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^replaceRegex() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^replaceRegex(replace)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^replaceRegex() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^replaceRegex(replace|replace)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^replaceRegex() with two parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^replaceRegex(stringToReplaceIn|Replace|Fit|extra)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^replaceRegex() with four parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^replaceRegex(||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^replaceRegex() with three empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^replaceRegex(string[To]ReplaceIn|[|-)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^replaceRegex() with an invalid regular expression");
    logExpectedError(err);

    //
    // test of ^matchesRegex()
    //
    err = nil;
    [MBExpression asObject:@"^matchesRegex()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^matchesRegex() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^matchesRegex(match)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^matchesRegex() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^matchesRegex(match|[)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^matchesRegex() with an invalid regular expression");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^matchesRegex(match|at|[)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^matchesRegex() with one valid regex and one invalid regex");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^matchesRegex(|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^matchesRegex() with two empty parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asObject:@"^matchesRegex(||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^matchesRegex() with three empty parameters");
    logExpectedError(err);
}

@end
