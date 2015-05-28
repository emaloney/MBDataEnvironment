//
//  MBMLEncodingFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/30/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MBDataEnvironmentTestSuite.h"
#import "MBMessageDigest.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLEncodingFunctionTests class
/******************************************************************************/

@interface MBMLEncodingFunctionTests : MBDataEnvironmentTestSuite
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
    MBLogInfoTrace();

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
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSData* data = [MBExpression asObject:@"^dataFromBase64(aHR0cDovL3RlY2guZ2lsdC5jb20v)"];

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"dataForMD5"] = data;
    NSString* md5 = [MBExpression asString:@"^MD5FromData($dataForMD5)"];
    XCTAssertEqualObjects(md5, @"70e21f8a4493cac0d6f5bd5a717f3907");
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^MD5FromData()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^MD5FromData($NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^MD5FromData(string)" error:&err];
    expectError(err);
}

- (void) testSHA1
{
    MBLogInfoTrace();

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
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSData* data = [MBExpression asObject:@"^dataFromBase64(aHR0cDovL3RlY2guZ2lsdC5jb20v)"];

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"dataForSHA1"] = data;
    NSString* sha1 = [MBExpression asString:@"^SHA1FromData($dataForSHA1)"];
    XCTAssertEqualObjects(sha1, @"ae29de41365b29ea4bd1f5c888f5a161c5cd7bfe");
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^SHA1FromData()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^SHA1FromData($NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^SHA1FromData(string)" error:&err];
    expectError(err);
}

- (void) testBase64FromData
{
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSData* data = [@"http://tech.gilt.com/" dataUsingEncoding:NSUTF8StringEncoding];

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"dataForBase64"] = data;
    NSString* base64 = [MBExpression asString:@"^base64FromData($dataForBase64)"];
    MBLogInfoObject(base64);
    XCTAssertEqualObjects(base64, @"aHR0cDovL3RlY2guZ2lsdC5jb20v");
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^base64FromData()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^base64FromData($NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asString:@"^base64FromData(string)" error:&err];
    expectError(err);
}

- (void) testDataFromBase64
{
    MBLogInfoTrace();

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
    MBLogInfoTrace();

    //
    // test expected successes
    //
    NSData* testData = [@"http://tech.gilt.com/" dataUsingEncoding:NSUTF8StringEncoding];

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"dataForHexString"] = testData;
    NSString* hexString = [MBExpression asString:@"^hexStringFromData($dataForHexString)"];
    MBLogInfoObject(hexString);
    XCTAssertEqualObjects(hexString, @"687474703a2f2f746563682e67696c742e636f6d2f");
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^hexStringFromData()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^hexStringFromData(thisIsNotData)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^hexStringFromData($NULL)" error:&err];
    expectError(err);
}

- (void) testDataFromHexString
{
    MBLogInfoTrace();

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
