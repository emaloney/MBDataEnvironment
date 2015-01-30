//
//  MBMLStringFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLStringFunctionTests class
/******************************************************************************/

@interface MBMLStringFunctionTests : MockingbirdTestSuite
@end

@implementation MBMLStringFunctionTests

/*
    <Function class="MBMLStringFunctions" name="q" input="raw"/>
    <Function class="MBMLStringFunctions" name="eval" input="string"/>
    <Function class="MBMLStringFunctions" name="evalBool" input="string"/>
    <Function class="MBMLStringFunctions" name="stripQueryString" input="string"/>
    <Function class="MBMLStringFunctions" name="lowercase" input="string"/>
    <Function class="MBMLStringFunctions" name="uppercase" input="string"/>
    <Function class="MBMLStringFunctions" name="titleCase" input="string"/>
    <Function class="MBMLStringFunctions" name="titleCaseIfAllCaps" input="string"/>
    <Function class="MBMLStringFunctions" name="pluralize" input="pipedStrings"/>
    <Function class="MBMLStringFunctions" name="concatenateFields" input="pipedStrings"/>
    <Function class="MBMLStringFunctions" name="firstNonemptyString" input="pipedExpressions"/>
    <Function class="MBMLStringFunctions" name="firstNonemptyTrimmedString" input="pipedExpressions"/>
    <Function class="MBMLStringFunctions" name="truncate" input="pipedStrings"/>
    <Function class="MBMLStringFunctions" name="stripSpaces" input="string"/>
    <Function class="MBMLStringFunctions" name="trimSpaces" input="string"/>
    <Function class="MBMLStringFunctions" name="indentLines" input="string"/>
    <Function class="MBMLStringFunctions" name="indentLinesToDepth" input="pipedObjects"/>
    <Function class="MBMLStringFunctions" name="prefixLinesWith" input="pipedObjects"/>
    <Function class="MBMLStringFunctions" name="parseInteger" input="string"/>
    <Function class="MBMLStringFunctions" name="parseDouble" input="string"/>
    <Function class="MBMLStringFunctions" name="parseNumber" input="string"/>
    <Function class="MBMLStringFunctions" name="rangeOfString" input="pipedObjects"/>
    <Function class="MBMLStringFunctions" name="formatInteger" input="math"/>
    <Function class="MBMLStringFunctions" name="hasPrefix" input="pipedStrings"/>
    <Function class="MBMLStringFunctions" name="hasSuffix" input="pipedStrings"/>
    <Function class="MBMLStringFunctions" name="containsString" input="pipedStrings"/>
*/

- (void) testQ
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* test = [MBExpression asObject:@"^q(    -- THIS IS A TEST --    )"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"    -- THIS IS A TEST --    ");
    XCTAssertEqualObjects([@"^q(Ke$ha)" evaluateAsString], @"Ke$ha");
}

- (void) testEval
{
    consoleTrace();

    //
    // test expected successes
    //
    NSDictionary* testBarrett = [@"$(Barrett Test)" evaluateAsObject];
    NSDictionary* barrett = [MBExpression asObject:@"^eval($$(Barrett Test))"];
    XCTAssertTrue([barrett isKindOfClass:[NSDictionary class]]);
    XCTAssertEqualObjects(barrett, testBarrett);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^eval(^prefixLinesWith())" error:&err];
    expectError(err);
}

- (void) testEvalBool
{
    consoleTrace();

    //
    // test expected successes
    //
    BOOL test = [MBExpression asBoolean:@"^evalBool(T)"];
    XCTAssertTrue(test);
    test = [MBExpression asBoolean:@"^evalBool(F)"];
    XCTAssertFalse(test);
    test = [MBExpression asBoolean:@"^evalBool(F -AND T)"];
    XCTAssertFalse(test);
    test = [MBExpression asBoolean:@"^evalBool(F -OR T)"];
    XCTAssertTrue(test);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^evalBool(-OR)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^evalBool(T -AND)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^evalBool(T -AND ^prefixLinesWith())" error:&err];
    expectError(err);
}

- (void) testStripQueryString
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* test = [MBExpression asObject:@"^stripQueryString(http://m.gilt.com/testapps?platform=iphone)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"http://m.gilt.com/testapps");
}

- (void) testLowercase
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* test = [MBExpression asObject:@"^lowercase(This is ALL upperCASE!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"this is all uppercase!");
}

- (void) testUppercase
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* test = [MBExpression asObject:@"^uppercase(This is NOT all lowercase!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"THIS IS NOT ALL LOWERCASE!");
}

- (void) testTitleCase
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* test = [MBExpression asObject:@"^titleCase(dark side of the moon)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"Dark Side Of The Moon");
}

- (void) testTitleCaseIfAllCaps
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* test = [MBExpression asObject:@"^titleCaseIfAllCaps(IBM)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"Ibm");
}

- (void) testPluralize
{
    consoleTrace();

    //
    // test expected successes
    //
    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"zero"] = @(0);
    scope[@"one"] = @(1);
    scope[@"two"] = @(2);

    NSString* test = [MBExpression asObject:@"^pluralize(1|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"one");

    test = [MBExpression asObject:@"^pluralize(2|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"some");

    test = [MBExpression asObject:@"^pluralize($one|one|not one)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"one");

    test = [MBExpression asObject:@"^pluralize($two|one|not one)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"not one");

    test = [MBExpression asObject:@"^pluralize(0|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"none");

    test = [MBExpression asObject:@"^pluralize(1|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"one");

    test = [MBExpression asObject:@"^pluralize(2|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"some");

    test = [MBExpression asObject:@"^pluralize($zero|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"none");

    test = [MBExpression asObject:@"^pluralize($one|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"one");

    test = [MBExpression asObject:@"^pluralize($two|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"some");

    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^pluralize()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^pluralize(1)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^pluralize(1|one)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^pluralize(one|pony|ponies)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^pluralize(|||)" error:&err];
    expectError(err);
}

- (void) testConcatenateFields
{
    consoleTrace();

    //
    // test expected successes
    //
    NSString* test = [MBExpression asObject:@"^concatenateFields(One: |value 1|Two: |value 2)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"One: value 1; Two: value 2");

    test = [MBExpression asObject:@"^concatenateFields(One: |value 1|Two: |value 2|Three: |value 3)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"One: value 1; Two: value 2; Three: value 3");

    test = [MBExpression asObject:@"^concatenateFields(/|One: |value 1|Two: |value 2)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"One: value 1/Two: value 2");

    test = [MBExpression asObject:@"^concatenateFields(/|One: |value 1|Two: |value 2|Three: |value 3)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"One: value 1/Two: value 2/Three: value 3");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^concatenateFields()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^concatenateFields(Field:)" error:&err];
    expectError(err);
}

- (void) testFirstNonemptyString
{
    consoleTrace();

    //
    // test expected successes
    //
    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"emptyString"] = @"";
    scope[@"null"] = [NSNull null];

    NSString* test = [MBExpression asObject:@"^firstNonemptyString($emptyString|$null|$nonexistentVariable|value 1| value 2|ignore this)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"value 1");
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^firstNonemptyString(^associate())" error:&err]; // will only fail if inner expression fails
    expectError(err);
}

- (void) testFirstNonemptyTrimmedString
{
    consoleTrace();

    //
    // test expected successes
    //
    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"nonEmptyString"] = @"     but... but... this has spaces!!! OH NO!!!     ";

    NSString* test = [MBExpression asObject:@"^firstNonemptyTrimmedString($emptyString|$null|$nonexistentVariable|$nonEmptyString| ignore this )"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"but... but... this has spaces!!! OH NO!!!");
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^firstNonemptyTrimmedString(^associate())" error:&err]; // will only fail if inner expression fails
    expectError(err);
}

- (void) testTruncate
{
    consoleTrace();

    //
    // test expected successes
    //
    NSString* test = [MBExpression asObject:@"^truncate(10|This is your chance!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"This is yo…");

    test = [MBExpression asObject:@"^truncate(10|…|This is your chance!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"This is yo…");

    test = [MBExpression asObject:@"^truncate(10|...|This is your chance!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"This is yo...");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^truncate()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^truncate(10)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^truncate(ten|truncate me at the tenth character, yo)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^truncate(ten|...|truncate me at ten)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^truncate(10|...|truncate me at ten|extra param)" error:&err];
    expectError(err);
}

- (void) testStripSpaces
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* test = [MBExpression asObject:@"^stripSpaces(    -- THIS IS A TEST --    )"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"--THISISATEST--");
}

- (void) testTrimSpaces
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* test = [MBExpression asObject:@"^trimSpaces(    -- THIS IS A TEST --    )"];
    XCTAssertTrue([test isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(test, @"-- THIS IS A TEST --");
}

- (void) testIndentLines
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* testIndented = @"\tThis\n\tis\n\tmy\n\tstring";
    NSString* indented = [MBExpression asObject:@"^indentLines(This\nis\nmy\nstring)"];
    XCTAssertTrue([indented isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(indented, testIndented);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"indentMe"] = @"This\nis\nmy\nstring";
    indented = [MBExpression asObject:@"^indentLines($indentMe)"];
    XCTAssertTrue([indented isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(indented, testIndented);
    [MBScopedVariables exitVariableScope];
}

- (void) testIndentLinesToDepth
{
    consoleTrace();

    //
    // test expected successes
    //
    NSString* testIndented = @"\t\tThis\n\t\tis\n\t\tmy\n\t\tstring";
    NSString* indented = [MBExpression asObject:@"^indentLinesToDepth(This\nis\nmy\nstring|2)"];
    XCTAssertTrue([indented isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(indented, testIndented);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"indentMe"] = @"This\nis\nmy\nstring";
    indented = [MBExpression asObject:@"^indentLinesToDepth($indentMe|2)"];
    XCTAssertTrue([indented isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(indented, testIndented);
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^indentLinesToDepth()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^indentLinesToDepth(This\nis\nmy\nstring)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^indentLinesToDepth(This\nis\nmy\nstring|2|3)" error:&err];
    expectError(err);
}

- (void) testPrefixLinesWith
{
    consoleTrace();

    //
    // test expected successes
    //
    NSString* testIndented = @"> This\n> is\n> my\n> string";
    NSString* indented = [MBExpression asObject:@"^prefixLinesWith(This\nis\nmy\nstring|> )"];
    XCTAssertTrue([indented isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(indented, testIndented);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"indentMe"] = @"This\nis\nmy\nstring";
    indented = [MBExpression asObject:@"^prefixLinesWith($indentMe|> )"];
    XCTAssertTrue([indented isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(indented, testIndented);
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^prefixLinesWith()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^prefixLinesWith($indentMe)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^prefixLinesWith($indentMe|$NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^prefixLinesWith($indentMe|> |two)" error:&err];
    expectError(err);
}

- (void) testParseInteger
{
    consoleTrace();

    //
    // test expected successes
    //
    NSNumber* num = [MBExpression asObject:@"^parseInteger(123)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(num, [NSNumber numberWithInt:123]);

    num = [MBExpression asObject:@"^parseInteger(1.3)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(num, [NSNumber numberWithInt:1]);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^parseInteger()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^parseInteger(string)" error:&err];
    expectError(err);
}

- (void) testParseDouble
{
    consoleTrace();

    //
    // test expected successes
    //
    NSNumber* num = [MBExpression asObject:@"^parseDouble(123)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(num, [NSNumber numberWithFloat:123]);

    num = [MBExpression asObject:@"^parseDouble(1.3)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(num, [NSNumber numberWithDouble:1.3]);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^parseDouble()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^parseDouble(string)" error:&err];
    expectError(err);
}

- (void) testParseNumber
{
    consoleTrace();

    //
    // test expected successes
    //
    NSNumber* num = [MBExpression asObject:@"^parseNumber(123)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(num, [NSNumber numberWithInteger:123]);
    num = [MBExpression asObject:@"^parseNumber(1.3)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(num, [NSNumber numberWithDouble:1.3]);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^parseNumber()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^parseNumber(string)" error:&err];
    expectError(err);
}

- (void) testRangeOfString
{
    consoleTrace();

    //
    // test expected successes
    //
    NSArray * range = [MBExpression asObject:@"^rangeOfString(test123|test)"];
    NSArray * expected = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:0],[NSNumber numberWithUnsignedInteger:4], nil];
    XCTAssertTrue([range isKindOfClass:[NSArray class]]);
    XCTAssertEqualObjects(range, expected);
    range = [MBExpression asObject:@"^rangeOfString(test123|123)"];
    expected = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:4],[NSNumber numberWithUnsignedInteger:3], nil];
    XCTAssertTrue([range isKindOfClass:[NSArray class]]);
    XCTAssertEqualObjects(range, expected);
    range = [MBExpression asObject:@"^rangeOfString(test123|1)"];
    expected = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:4],[NSNumber numberWithUnsignedInteger:1], nil];
    XCTAssertTrue([range isKindOfClass:[NSArray class]]);
    XCTAssertEqualObjects(range, expected);
    range = [MBExpression asObject:@"^rangeOfString(test123|nope)"];
    expected = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:NSNotFound],[NSNumber numberWithUnsignedInteger:0], nil];
    XCTAssertTrue([range isKindOfClass:[NSArray class]]);
    XCTAssertEqualObjects(range, expected);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^rangeOfString()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^rangeOfString(string)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^rangeOfString(|string)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^rangeOfString(string|)" error:&err];
    expectError(err);
}

- (void) testFormatInteger
{
    consoleTrace();

    //
    // test expected successes
    //
    NSString* formatted = [MBExpression asObject:@"^formatInteger(11.75)"];
    XCTAssertTrue([formatted isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(formatted, @"11");
    formatted = [MBExpression asObject:@"^formatInteger(10 * 3)"];
    XCTAssertTrue([formatted isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(formatted, @"30");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^formatInteger()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^formatInteger(foo)" error:&err];
    expectError(err);
}

- (void) testHasPrefix
{
    consoleTrace();

    //
    // test expected successes
    //
    BOOL test = [MBExpression asBoolean:@"^hasPrefix(Tuesday|Tue)"];
    XCTAssertTrue(test);
    test = [MBExpression asBoolean:@"^hasPrefix(Wednesday|Tue)"];
    XCTAssertFalse(test);
    test = [MBExpression asBoolean:@"^hasPrefix(Wednesday|day)"];
    XCTAssertFalse(test);
    test = [MBExpression asBoolean:@"^hasPrefix($backendDomain|m.)"];
    XCTAssertTrue(test);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^hasPrefix(string)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^hasPrefix(string|str|foo)" error:&err];
    expectError(err);
}

- (void) testHasSuffix
{
    consoleTrace();

    //
    // test expected successes
    //
    BOOL test = [MBExpression asBoolean:@"^hasSuffix(Tuesday|day)"];
    XCTAssertTrue(test);
    test = [MBExpression asBoolean:@"^hasSuffix(Wednesday|day)"];
    XCTAssertTrue(test);
    test = [MBExpression asBoolean:@"^hasSuffix(Wednesday|Wed)"];
    XCTAssertFalse(test);
    test = [MBExpression asBoolean:@"^hasSuffix($backendDomain|gilt.com)"];
    XCTAssertTrue(test);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^hasSuffix(string)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^hasSuffix(string|str|foo)" error:&err];
    expectError(err);
}

- (void) testContainsString
{
    consoleTrace();
    
    //
    // test expected successes
    //
    BOOL test = [MBExpression asBoolean:@"^containsString($backendDomain|.gilt.)"];
    XCTAssertTrue(test);
    test = [MBExpression asBoolean:@"^containsString(Tuesday|ues)"];
    XCTAssertTrue(test);
    test = [MBExpression asBoolean:@"^containsString(Tuesday|Wed)"];
    XCTAssertFalse(test);

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^containsString()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^containsString(Tuesday)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^containsString(Tuesday|day|ay)" error:&err];
    expectError(err);
}

@end
