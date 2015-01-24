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
 NEED TO ADD:
    <Function class="MBMLStringFunctions" name="eval" input="string"/>
    <Function class="MBMLStringFunctions" name="evalBool" input="string"/>
    <Function class="MBMLStringFunctions" name="trimSpaces" input="string"/>
    <Function class="MBMLStringFunctions" name="indentLines" input="string"/>
    <Function class="MBMLStringFunctions" name="indentLinesToDepth" input="pipedObjects"/>
    <Function class="MBMLStringFunctions" name="prefixLinesWith" input="pipedObjects"/>
    <Function class="MBMLStringFunctions" name="formatInteger" input="math"/>
    <Function class="MBMLStringFunctions" name="hasPrefix" input="pipedStrings"/>
    <Function class="MBMLStringFunctions" name="hasSuffix" input="pipedStrings"/>
    <Function class="MBMLStringFunctions" name="containsString" input="pipedStrings"/>

 
 FULL LIST:
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

- (void) testStringFunctions
{
    //
    // test of ^q()
    //
    NSString* test = [MBExpression asObject:@"^q(    -- THIS IS A TEST --    )"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^q() to be an NSString");
    XCTAssertEqualObjects(test, @"    -- THIS IS A TEST --    ", @"unexpected result for ^q()");
    XCTAssertEqualObjects([@"^q(Ke$ha)" evaluateAsString], @"Ke$ha", @"unexpected result for ^q()");

    //
    // test of ^stripQueryString()
    //
    test = [MBExpression asObject:@"^stripQueryString(http://m.gilt.com/testapps?platform=iphone)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^stripQueryString() to be an NSString");
    XCTAssertEqualObjects(test, @"http://m.gilt.com/testapps", @"unexpected result for ^stripQueryString()");
    
    //
    // test of ^lowercase()
    //
    test = [MBExpression asObject:@"^lowercase(This is ALL upperCASE!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^lowercase() to be an NSString");
    XCTAssertEqualObjects(test, @"this is all uppercase!", @"unexpected result for ^lowercase()");
    
    //
    // test of ^uppercase()
    //
    test = [MBExpression asObject:@"^uppercase(This is NOT all lowercase!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^uppercase() to be an NSString");
    XCTAssertEqualObjects(test, @"THIS IS NOT ALL LOWERCASE!", @"unexpected result for ^uppercase()");
    
    //
    // test of ^titleCase()
    //
    test = [MBExpression asObject:@"^titleCase(dark side of the moon)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^titleCase() to be an NSString");
    XCTAssertEqualObjects(test, @"Dark Side Of The Moon", @"unexpected result for ^titleCase()");
    
    //
    // test of ^titleCaseIfAllCaps()
    //
    test = [MBExpression asObject:@"^titleCaseIfAllCaps(IBM)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^titleCaseIfAllCaps() to be an NSString");
    XCTAssertEqualObjects(test, @"Ibm", @"unexpected result for ^titleCaseIfAllCaps()");
    
    //
    // test of ^pluralize()
    //
    MBVariableSpace* vars = [MBVariableSpace instance];
    [vars setVariable:@"zero" value:[NSNumber numberWithInt:0]];
    [vars setVariable:@"one" value:[NSNumber numberWithInt:1]];
    [vars setVariable:@"two" value:[NSNumber numberWithInt:2]];
    test = [MBExpression asObject:@"^pluralize(1|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"one", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize(2|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"some", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize($one|one|not one)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"one", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize($two|one|not one)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"not one", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize(0|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"none", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize(1|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"one", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize(2|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"some", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize($zero|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"none", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize($one|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"one", @"unexpected result for ^pluralize()");
    test = [MBExpression asObject:@"^pluralize($two|none|one|some)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^pluralize() to be an NSString");
    XCTAssertEqualObjects(test, @"some", @"unexpected result for ^pluralize()");

    //
    // test of ^concatenateFields()
    //
    test = [MBExpression asObject:@"^concatenateFields(One: |value 1|Two: |value 2)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^concatenateFields() to be an NSString");
    XCTAssertEqualObjects(test, @"One: value 1; Two: value 2", @"unexpected result for ^concatenateFields()");
    test = [MBExpression asObject:@"^concatenateFields(One: |value 1|Two: |value 2|Three: |value 3)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^concatenateFields() to be an NSString");
    XCTAssertEqualObjects(test, @"One: value 1; Two: value 2; Three: value 3", @"unexpected result for ^concatenateFields()");
    test = [MBExpression asObject:@"^concatenateFields(/|One: |value 1|Two: |value 2)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^concatenateFields() to be an NSString");
    XCTAssertEqualObjects(test, @"One: value 1/Two: value 2", @"unexpected result for ^concatenateFields()");
    test = [MBExpression asObject:@"^concatenateFields(/|One: |value 1|Two: |value 2|Three: |value 3)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^concatenateFields() to be an NSString");
    XCTAssertEqualObjects(test, @"One: value 1/Two: value 2/Three: value 3", @"unexpected result for ^concatenateFields()");

    //
    // test of ^firstNonemptyString()
    //
    [vars setVariable:@"emptyString" value:@""];
    [vars setVariable:@"null" value:[NSNull null]];
    test = [MBExpression asObject:@"^firstNonemptyString($emptyString|$null|$nonexistentVariable|value 1| value 2|ignore this)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^firstNonemptyString() to be an NSString");
    XCTAssertEqualObjects(test, @"value 1", @"unexpected result for ^firstNonemptyString()");
    
    //
    // test of ^firstNonemptyTrimmedString()
    //
    [vars setVariable:@"nonEmptyString" value:@"     but... but... this has spaces!!! OH NO!!!     "];
    test = [MBExpression asObject:@"^firstNonemptyTrimmedString($emptyString|$null|$nonexistentVariable|$nonEmptyString| ignore this )"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^firstNonemptyTrimmedString() to be an NSString");
    XCTAssertEqualObjects(test, @"but... but... this has spaces!!! OH NO!!!", @"unexpected result for ^firstNonemptyTrimmedString()");

    //
    // test of ^truncate()
    //
    test = [MBExpression asObject:@"^truncate(10|This is your chance!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^truncate() to be an NSString");
    XCTAssertEqualObjects(test, @"This is yo…", @"unexpected result for ^truncate()");
    test = [MBExpression asObject:@"^truncate(10|…|This is your chance!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^truncate() to be an NSString");
    XCTAssertEqualObjects(test, @"This is yo…", @"unexpected result for ^truncate()");
    test = [MBExpression asObject:@"^truncate(10|...|This is your chance!)"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^truncate() to be an NSString");
    XCTAssertEqualObjects(test, @"This is yo...", @"unexpected result for ^truncate()");
    
    //
    // test of ^stripSpaces()
    //
    test = [MBExpression asObject:@"^stripSpaces(    -- THIS IS A TEST --    )"];
    XCTAssertTrue([test isKindOfClass:[NSString class]], @"expected result of ^stripSpaces() to be an NSString");
    XCTAssertEqualObjects(test, @"--THISISATEST--", @"unexpected result for ^stripSpaces()");
    
    //
    // test of ^parseInteger()
    //
    NSNumber* num = [MBExpression asObject:@"^parseInteger(123)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]], @"expected result of ^parseInteger() to be an NSNumber");
    XCTAssertEqualObjects(num, [NSNumber numberWithInt:123], @"unexpected result for ^parseInteger()");
    num = [MBExpression asObject:@"^parseInteger(1.3)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]], @"expected result of ^parseInteger() to be an NSNumber");
    XCTAssertEqualObjects(num, [NSNumber numberWithInt:1], @"unexpected result for ^parseInteger()");

    //
    // test of ^parseDouble()
    //
    num = [MBExpression asObject:@"^parseDouble(123)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]], @"expected result of ^parseDouble() to be an NSNumber");
    XCTAssertEqualObjects(num, [NSNumber numberWithFloat:123], @"unexpected result for ^parseDouble()");
    num = [MBExpression asObject:@"^parseDouble(1.3)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]], @"expected result of ^parseDouble() to be an NSNumber");
    XCTAssertEqualObjects(num, [NSNumber numberWithDouble:1.3], @"unexpected result for ^parseDouble()");
    
    //
    // test of ^parseNumber()
    //
    num = [MBExpression asObject:@"^parseNumber(123)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]], @"expected result of ^parseNumber() to be an NSNumber");
    XCTAssertEqualObjects(num, [NSNumber numberWithInteger:123], @"unexpected result for ^parseNumber()");
    num = [MBExpression asObject:@"^parseNumber(1.3)"];
    XCTAssertTrue([num isKindOfClass:[NSNumber class]], @"expected result of ^parseNumber() to be an NSNumber");
    XCTAssertEqualObjects(num, [NSNumber numberWithDouble:1.3], @"unexpected result for ^parseNumber()");
    
    //
    // test of ^rangeOfString()
    //
    NSArray * range = [MBExpression asObject:@"^rangeOfString(test123|test)"];
    NSArray * expected = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:0],[NSNumber numberWithUnsignedInteger:4], nil];
    XCTAssertTrue([range isKindOfClass:[NSArray class]], @"expected result of ^rangeOfString() to be an NSArray");
    XCTAssertEqualObjects(range, expected, @"unexpected result for ^rangeOfString()");
    range = [MBExpression asObject:@"^rangeOfString(test123|123)"];
    expected = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:4],[NSNumber numberWithUnsignedInteger:3], nil];
    XCTAssertTrue([range isKindOfClass:[NSArray class]], @"expected result of ^rangeOfString() to be an NSArray");
    XCTAssertEqualObjects(range, expected, @"unexpected result for ^rangeOfString()");
    range = [MBExpression asObject:@"^rangeOfString(test123|1)"];
    expected = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:4],[NSNumber numberWithUnsignedInteger:1], nil];
    XCTAssertTrue([range isKindOfClass:[NSArray class]], @"expected result of ^rangeOfString() to be an NSArray");
    XCTAssertEqualObjects(range, expected, @"unexpected result for ^rangeOfString()");
    range = [MBExpression asObject:@"^rangeOfString(test123|nope)"];
    expected = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:NSNotFound],[NSNumber numberWithUnsignedInteger:0], nil];
    XCTAssertTrue([range isKindOfClass:[NSArray class]], @"expected result of ^rangeOfString() to be an NSArray");
    XCTAssertEqualObjects(range, expected, @"unexpected result for ^rangeOfString()");
}

- (void) testStringFunctionFailures
{
    // note: not every string function reports errors;
    // functions that take simple strings and only perform
    // string operations typically don't. so, you'll notice
    // that we're not testing ALL MBMLStringFunctions below...
    
    //
    // test of ^pluralize()
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^pluralize()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^pluralize() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^pluralize(1)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^pluralize() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^pluralize(1|one)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^pluralize() with two parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^pluralize(one|pony|ponies)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^pluralize() with non-numeric first parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^pluralize(|||)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^pluralize() with four empty parameters");
    logExpectedError(err);

    //
    // test of ^concatenateFields()
    //
    err = nil;
    [MBExpression asString:@"^concatenateFields()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^concatenateFields() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^concatenateFields(Field:)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^concatenateFields() with one parameter");
    logExpectedError(err);
    
    //
    // test of ^truncate()
    //
    err = nil;
    [MBExpression asString:@"^truncate()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^truncate() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^truncate(10)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^truncate() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^truncate(ten|truncate me at the tenth character, yo)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^truncate() with non-numeric first parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^truncate(ten|...|truncate me at ten)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^truncate() with non-numeric first parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^truncate(10|...|truncate me at ten|extra param)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^truncate() with four parameters");
    logExpectedError(err);
    
    //
    // test of ^parseInteger()
    //
    err = nil;
    [MBExpression asString:@"^parseInteger()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseInteger() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^parseInteger(string)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseInteger() with non-numeric parameter");
    logExpectedError(err);

    //
    // test of ^parseDouble()
    //
    err = nil;
    [MBExpression asString:@"^parseDouble()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseDouble() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^parseDouble(string)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseDouble() with non-numeric parameter");
    logExpectedError(err);
    
    //
    // test of ^parseNumber()
    //
    err = nil;
    [MBExpression asString:@"^parseNumber()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseNumber() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^parseNumber(string)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseNumber() with non-numeric parameter");
    logExpectedError(err);
    
    //
    // test of ^rangeOfString()
    //
    err = nil;
    [MBExpression asString:@"^rangeOfString()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^rangeOfString() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^rangeOfString(string)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^rangeOfString() with 1 parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^rangeOfString(|string)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^rangeOfString() with nil 1st parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^rangeOfString(string|)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^rangeOfString() with nil 2nd parameter");
    logExpectedError(err);
}

@end
