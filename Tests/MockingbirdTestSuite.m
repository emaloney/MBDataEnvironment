//
//  MockingbirdTestSuite.m
//  MockingbirdTests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>
#import "MockingbirdTestSuite.h"
#import "MBEnvironment.h"
#import <objc/runtime.h>

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MockingbirdTestSuite class
/******************************************************************************/

@implementation MockingbirdTestSuite

/******************************************************************************/
#pragma mark Test setup/teardown
/******************************************************************************/

- (void) setUpAppData
{
    debugTrace();

    [MBEnvironment loadFromManifestFile:@"test-app-data.xml"
                    withSearchDirectory:[[NSBundle bundleForClass:[self class]] resourcePath]];
}

// note: a number of tests will rely on the sanity of this data; if this
//       test fails, a bunch of other tests probably will, too
- (void) testDataSanity
{
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
}

- (void) setUp
{
    debugTrace();

    [super setUp];
    [self fixBundle];
    [self setUpAppData];
}

- (void) tearDown
{
    debugTrace();

    [super tearDown];
}

- (void) fixBundle
{
    // [NSBundle mainBundle] doesn't return the XCTest bundle.
    // So we replace the mainBundle class method of NSBundle, with our testBundle method implementation.

    Method mainBundle = class_getClassMethod(NSBundle.class, @selector(mainBundle));
    Method testBundle = class_getInstanceMethod(self.class, @selector(testBundle));
    IMP testBundleIMP = method_getImplementation(testBundle);
    method_setImplementation(mainBundle, testBundleIMP);
}

- (NSBundle *) testBundle
{
    return [NSBundle bundleForClass:MockingbirdTestSuite.class];
}

@end
