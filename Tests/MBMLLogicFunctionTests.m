//
//  MBMLLogicFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLLogicFunctionTests class
/******************************************************************************/

@interface MBMLLogicFunctionTests : MockingbirdTestSuite
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
    NSNumber* testNum = [NSNumber numberWithInteger:102772];
    scope[@"ifTestNumber"] = testNum;
    id result = [MBExpression asObject:@"^if($ifTestNumber)"];
    XCTAssertTrue([result isKindOfClass:[NSNumber class]], @"expected result of ^if($ifTestNumber) to return a number");
    XCTAssertEqualObjects(result, [NSNumber numberWithInteger:102772], @"expected result of ^if($ifTestNumber) to be the number 102772");
    
    result = [MBExpression asObject:@"^if($thisVariableDoesNotExist)"];
    XCTAssertNil(result, @"expected result of ^if($thisVariableDoesNotExist) to be nil");

    result = [MBExpression asObject:@"^if(T|true)"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected result of ^if(T|true) to return an NSString");
    XCTAssertEqualObjects(result, @"true", @"expected result of ^if(T|true) to be the string \"true\"");
    
    result = [MBExpression asObject:@"^if(F|true)"];
    XCTAssertTrue(result == nil, @"expected result of ^if(F|true) to return nil");
    
    result = [MBExpression asObject:@"^if(T|true|false)"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected result of ^if(T|true|false) to return an NSString");
    XCTAssertEqualObjects(result, @"true", @"expected result of ^if(T|true|false) to be the string \"true\"");

    result = [MBExpression asObject:@"^if(F|true|false)"];
    XCTAssertTrue([result isKindOfClass:[NSString class]], @"expected result of ^if(F|true|false) to return an NSString");
    XCTAssertEqualObjects(result, @"false", @"expected result of ^if(F|true|false) to be the string \"false\"");
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^if()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^if() with no parameters");
    logExpectedError(err);

    err = nil;
    [MBExpression asString:@"^if(T|true|false|quantum superposition)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^if() with four parameters");
    logExpectedError(err);
}

@end
