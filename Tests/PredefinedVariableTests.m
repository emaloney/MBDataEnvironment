//
//  PredefinedVariableTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/30/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"
#import "MBDevice.h"

/******************************************************************************/
#pragma mark -
#pragma mark PredefinedVariableTests class
/******************************************************************************/

@interface PredefinedVariableTests : MockingbirdTestSuite
@end

@implementation PredefinedVariableTests

/*
    <Var name="UIApplication" type="singleton" class="UIApplication" method="sharedApplication"/>
    <Var name="UIDevice" type="singleton" class="UIDevice" method="currentDevice"/>
    <Var name="UIScreen" type="singleton" class="UIScreen" method="mainScreen"/>

    <Var name="Device" type="singleton" class="MBDevice"/>
    <Var name="Environment" type="singleton" class="MBEnvironment"/>
    <Var name="Network" type="singleton" class="MBNetworkMonitor"/>
*/

- (void) testPredefinedVariablesUIKit
{
    consoleTrace();

    // note: $UIApplication is nil in unit tests because
    //       [UIApplication sharedApplication] returns nil.
    //       so, the test for $UIApplication isn't rigorous
    UIApplication* testApp = [UIApplication sharedApplication];
    UIApplication* app = [@"$UIApplication" evaluateAsObject];
    XCTAssertEqualObjects(app, testApp);

    UIDevice* testDevice = [UIDevice currentDevice];
    UIDevice* device = [@"$UIDevice" evaluateAsObject];
    XCTAssertNotNil(device);
    XCTAssertEqualObjects(device, testDevice);

    UIScreen* testScreen = [UIScreen mainScreen];
    UIScreen* screen = [@"$UIScreen" evaluateAsObject];
    XCTAssertNotNil(screen);
    XCTAssertEqualObjects(screen, testScreen);
}

- (void) testPredefinedVariablesMBDataEnvironment
{
    consoleTrace();

    MBDevice* testDevice = [MBDevice instance];
    MBDevice* device = [@"$Device" evaluateAsObject];
    XCTAssertNotNil(device);
    XCTAssertEqualObjects(device, testDevice);

    MBEnvironment* testEnvironment = [MBEnvironment instance];
    MBEnvironment* environment = [@"$Environment" evaluateAsObject];
    XCTAssertNotNil(environment);
    XCTAssertEqualObjects(environment, testEnvironment);

    MBNetworkMonitor* testNetwork = [MBNetworkMonitor instance];
    MBNetworkMonitor* network = [@"$Network" evaluateAsObject];
    XCTAssertNotNil(network);
    XCTAssertEqualObjects(network, testNetwork);
}

@end
