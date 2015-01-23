//
//  MockingbirdTestSuite.h
//  MockingbirdTests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <XCTest/XCTest.h>

#define LOG_EXPECTED_ERRORS         1
#define logExpectedError(x)         if (LOG_EXPECTED_ERRORS && (x)) consoleLog(@"Received expected error (this is safe to ignore): %@", [(MBExpressionError*)x logOutput])

/******************************************************************************/
#pragma mark -
#pragma mark MockingbirdTestSuite class
/******************************************************************************/

@interface MockingbirdTestSuite : XCTestCase

- (void) setUpAppData;

@end
