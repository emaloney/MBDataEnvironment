//
//  MBMLEncodingFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/30/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLEncodingFunctionTests class
/******************************************************************************/

@interface MBMLEncodingFunctionTests : MockingbirdTestSuite
@end

@implementation MBMLEncodingFunctionTests

/*
    <Function class="MBMLEncodingFunctions" name="MD5" method="MD5FromString" input="string"/>
    <Function class="MBMLEncodingFunctions" name="MD5FromString" input="string"/>
    <Function class="MBMLEncodingFunctions" name="MD5FromData" input="object"/>
    <Function class="MBMLEncodingFunctions" name="SHA1" method="SHA1FromString" input="string"/>
    <Function class="MBMLEncodingFunctions" name="SHA1FromString" input="string"/>
    <Function class="MBMLEncodingFunctions" name="SHA1FromData" input="object"/>
    <Function class="MBMLEncodingFunctions" name="base64FromData" input="object"/>
    <Function class="MBMLEncodingFunctions" name="dataFromBase64" input="string"/>
    <Function class="MBMLEncodingFunctions" name="hexStringFromData" input="object"/>
    <Function class="MBMLEncodingFunctions" name="dataFromHexString" input="string"/>
 */

/******************************************************************************/
#pragma mark Tests
/******************************************************************************/

- (void) testMD5
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* hash1 = [MBExpression asString:@"^MD5FromString(12 Galaxies)"];
    NSString* hash2 = [MBExpression asString:@"^MD5(12 Galaxies)"];
    XCTAssertEqualObjects(hash1, hash2);
    XCTAssertEqualObjects(hash1, @"51eae4327df7f0617eaaf305832fe219");
}

- (void) testMD5FromData
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

- (void) testSHA1
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* hash1 = [MBExpression asString:@"^SHA1FromString(12 Galaxies)"];
    NSString* hash2 = [MBExpression asString:@"^SHA1(12 Galaxies)"];
    XCTAssertEqualObjects(hash1, hash2);
    XCTAssertEqualObjects(hash1, @"b9f4599289911696e76d1e401a449dbf3dd97b72");
}

- (void) testSHA1FromData
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

- (void) testBase64FromData
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

- (void) testDataFromBase64
{
    consoleTrace();

    //
    // test expected successes
    //
    NSData* data = [MBExpression asObject:@"^dataFromBase64(aHR0cDovL3RlY2guZ2lsdC5jb20v)"];
    XCTAssertEqualObjects([data toString], @"http://tech.gilt.com/");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^dataFromBase64()" error:&err];
    expectError(err);
}

- (void) testHexStringFromData
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

- (void) testDataFromHexString
{
    consoleTrace();

    //
    // test expected successes
    //
    NSData* data = [MBExpression asObject:@"^dataFromHexString(687474703a2f2f746563682e67696c742e636f6d2f)"];
    XCTAssertEqualObjects([data toString], @"http://tech.gilt.com/");

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^dataFromHexString()" error:&err];
    expectError(err);
}

@end
