//
//  MBMLLogicFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MBDataEnvironmentTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLLogicFunctionTests class
/******************************************************************************/

@interface MBMLLogicFunctionTests : MBDataEnvironmentTestSuite
@end

@implementation MBMLLogicFunctionTests

/*
    <Function class="MBMLLogicFunctions" name="if" method="ifOperator" input="pipedExpressions"/>
*/

- (void) testIf
{
    consoleTrace();

    //
    // test expected successes
    //
    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    NSNumber* testNum = [NSNumber numberWithInteger:102686];
    scope[@"ifTestNumber"] = testNum;
    id result = [MBExpression asObject:@"^if($ifTestNumber)"];
    XCTAssertTrue([result isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(result, [NSNumber numberWithInteger:102686]);
    
    result = [MBExpression asObject:@"^if($thisVariableDoesNotExist)"];
    XCTAssertNil(result);

    result = [MBExpression asObject:@"^if(T|true)"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(result, @"true");
    
    result = [MBExpression asObject:@"^if(F|true)"];
    XCTAssertTrue(result == nil);
    
    result = [MBExpression asObject:@"^if(T|true|false)"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(result, @"true");

    result = [MBExpression asObject:@"^if(F|true|false)"];
    XCTAssertTrue([result isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects(result, @"false");
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^if()" error:&err];
    XCTAssertNotNil(err);
    logExpectedError(err);

    err = nil;
    [MBExpression asString:@"^if(T|true|false|quantum superposition)" error:&err];
    XCTAssertNotNil(err);
    logExpectedError(err);
}

@end
