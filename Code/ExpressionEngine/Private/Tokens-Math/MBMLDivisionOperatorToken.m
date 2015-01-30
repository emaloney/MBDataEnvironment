//
//  MBMLDivisionOperatorToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/20/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import "MBMLDivisionOperatorToken.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLDivisionOperatorToken implementation
/******************************************************************************/

@implementation MBMLDivisionOperatorToken

- (instancetype) init
{
    return [super initWithOperatorCharacter:'/'];
}

- (NSUInteger) precedence
{
    return 1;
}

- (NSDecimalNumber*) numericValueForLeftValue:(NSDecimalNumber*)lValue
                                   rightValue:(NSDecimalNumber*)rValue
                                        error:(inout MBExpressionError**)errPtr
{
    if ([rValue isEqualToNumber:[NSDecimalNumber zero]] || [lValue isEqualToNumber:[NSDecimalNumber zero]]) {
        MBExpressionError* err = [MBExpressionError errorWithMessage:@"It is mathematically irresponsible to divide by zero"];
        err.offendingToken = self;
        [err reportErrorTo:errPtr];
        return nil;
    }

    return [lValue decimalNumberByDividingBy:rValue];
}

@end
