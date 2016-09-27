//
//  MBDataEnvironmentTestSuite.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>
#import <CoreGraphics/CoreGraphics.h>
#import <MBDataEnvironment/MBDataEnvironment.h>
#import <objc/runtime.h>

#import "MBDataEnvironmentTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBDataEnvironmentTestSuite class
/******************************************************************************/

@implementation MBDataEnvironmentTestSuite
{
    BOOL _environmentLoaded;
}

/******************************************************************************/
#pragma mark Test setup/teardown
/******************************************************************************/

- (void) setUpVariableSpace:(MBVariableSpace*)vars
{
    CGRect rect = [MBStringConversions rectFromExpression:@"$rect"];
    NSValue* rectVal = [NSValue valueWithBytes:&rect objCType:@encode(CGRect)];
    vars[@"rect:val"] = rectVal;

    CGPoint origin = [MBStringConversions pointFromExpression:@"$rect:origin"];
    NSValue* originVal = [NSValue valueWithBytes:&origin objCType:@encode(CGPoint)];
    vars[@"rect:origin:val"] = originVal;

    CGSize size = [MBStringConversions sizeFromExpression:@"$rect:size"];
    NSValue* sizeVal = [NSValue valueWithBytes:&size objCType:@encode(CGSize)];
    vars[@"rect:size:val"] = sizeVal;
}

- (void) testDataSanity
{
    // note: a number of tests will rely on the sanity of this data; if this
    //       test fails, a bunch of other tests probably will, too.
    if (self.loadTestManifest) {
        NSDictionary* testMap = [MBExpression asObject:@"$testMap"];
        NSArray* testKeys = [MBExpression asObject:@"$testKeys"];
        NSArray* testValues = [MBExpression asObject:@"$testValues"];

        XCTAssertTrue([testMap isKindOfClass:[NSDictionary class]], @"Expecting $testMap to be a dictionary");
        XCTAssertTrue([testKeys isKindOfClass:[NSArray class]], @"Expecting $testKeys to be an array");
        XCTAssertTrue([testValues isKindOfClass:[NSArray class]], @"Expecting $testValues to be an array");

        XCTAssertTrue([testMap count] == 4, @"Number of values in $testMap not correct");
        XCTAssertTrue([testKeys count] == 4, @"Number of values in $testKeys not correct");
        XCTAssertTrue([testValues count] == 4, @"Number of values in $testValues not correct");

        XCTAssertEqualObjects([NSSet setWithArray:[testMap allKeys]], [NSSet setWithArray:testKeys], @"Keys in $testMap not correct");
        XCTAssertEqualObjects([NSSet setWithArray:[testMap allValues]], [NSSet setWithArray:testValues], @"Values in $testMap not correct");

        NSDictionary* emptyMap = [MBExpression asObject:@"$emptyMap"];
        NSArray* emptyList = [MBExpression asObject:@"$emptyList"];

        XCTAssertTrue([emptyMap isKindOfClass:[NSDictionary class]], @"Expecting $testMap to be a dictionary");
        XCTAssertTrue([emptyList isKindOfClass:[NSArray class]], @"Expecting $testKeys to be an array");

        XCTAssertTrue([emptyMap count] == 0, @"Number of values in $emptyMap not correct");
        XCTAssertTrue([emptyList count] == 0, @"Number of values in $emptyList not correct");

        NSArray* testList = [MBExpression asObject:@"$nameList"];
        XCTAssertTrue([testList isKindOfClass:[NSArray class]], @"expected result of $nameList to be an NSArray");
        XCTAssertTrue([testList count] == 6, @"Number of values in $nameList not correct");

        CGRect rect = [MBStringConversions rectFromExpression:@"$rect"];
        XCTAssertTrue(!CGRectEqualToRect(rect, CGRectZero));
        XCTAssertTrue(CGRectEqualToRect(rect, CGRectMake(10, 50, 300, 200)));
    }
}

- (BOOL) loadTestManifest
{
    return YES;
}

- (void) willLoadEnvironment
{
    [MBEnvironment addResourceSearchBundle:[NSBundle bundleForClass:[MBDataEnvironmentTestSuite class]]];

    // in case MBDataEnvironmentTestSuite is in a different bundle than the implementing subclass
    [MBEnvironment addResourceSearchBundle:[NSBundle bundleForClass:[self class]]];
}

- (void) didLoadEnvironment:(MBEnvironment*)env
{
}

- (NSString*) manifestFileName
{
    return @"test-MBDataEnvironment.xml";
}

- (NSArray*) mbmlSearchDirectories
{
    return nil;
}

- (void) setUp
{
    [super setUp];

    if (self.loadTestManifest) {
        [self willLoadEnvironment];

        MBEnvironment* env = [MBEnvironment loadFromManifestFile:[self manifestFileName]
                                           withSearchDirectories:[self mbmlSearchDirectories]];

        if (env) {
            _environmentLoaded = YES;

            [self didLoadEnvironment:env];

            [self setUpVariableSpace:[MBVariableSpace instance]];
        }
    }
}

- (void) tearDown
{
    if (_environmentLoaded && [MBEnvironment peekEnvironment]) {
        [MBEnvironment popEnvironment];
    }

    [super tearDown];
}

@end
