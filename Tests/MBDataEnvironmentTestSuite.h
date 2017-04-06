//
//  MBDataEnvironmentTestSuite.h
//  MockingbirdTests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MBToolbox/MBAvailability.h>
#import <MBDataEnvironment/MBVariableSpace.h>
#import <MBDataEnvironment/MBExpression.h>
#import <MBDataEnvironment/MBExpressionExtensions.h>
#import <MBDataEnvironment/MBEnvironment.h>
#import <MBDataEnvironment/MBStringConversions.h>
#import <MBDataEnvironment/MBScopedVariables.h>

#define LOG_EXPECTED_ERRORS         1
#define logExpectedError(x)         if (LOG_EXPECTED_ERRORS && (x)) MBLog(MBLogSeverityVerbose, @"Received expected error (this is safe to ignore): %@", [(MBExpressionError*)x logOutput])
#define expectError(x)              { XCTAssertNotNil(x); logExpectedError(x); }

/******************************************************************************/
#pragma mark -
#pragma mark MBDataEnvironmentTestSuite class
/******************************************************************************/

@interface MBDataEnvironmentTestSuite : XCTestCase

@property(nonatomic, assign, readonly) BOOL loadTestManifest;

- (void) willLoadEnvironment;

- (void) didLoadEnvironment:(MBEnvironment*)env;

- (NSString*) manifestFileName;

- (NSArray*) mbmlSearchDirectories;

- (void) setUpVariableSpace:(MBVariableSpace*)vars;

@end
