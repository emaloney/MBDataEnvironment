//
//  MBMLFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Coyne Maloney on 1/30/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import <MBDataEnvironment/MBMLFunction.h>

#import "MBDataEnvironmentTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFunctionTests class
/******************************************************************************/

@interface MBMLFunctionTests : MBDataEnvironmentTestSuite
@end

@implementation MBMLFunctionTests

- (void) testProgrammaticFunctionDeclaration
{
    MBLogInfoTrace();

    MBMLFunction* func = [[MBMLFunction alloc] initWithName:@"testDeclareFunctionProgrammatically"
                                                  inputType:MBMLFunctionInputString
                                                 outputType:MBMLFunctionOutputObject
                                          implementingClass:[self class]
                                             methodSelector:@selector(testDeclareFunctionProgrammatically:)];

    BOOL result = [[MBVariableSpace instance] declareFunction:func];
    XCTAssertTrue(result);

    NSString* tested = [MBExpression asString:@"^testDeclareFunctionProgrammatically(has this been tested?)"];
    XCTAssertEqualObjects(tested, @"TESTED: has this been tested?");
}

+ (id) testDeclareFunctionProgrammatically:(NSString*)input
{
    return [NSString stringWithFormat:@"TESTED: %@", input];
}

@end
