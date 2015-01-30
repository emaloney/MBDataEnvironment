//
//  MBMLModuloOperatorToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/30/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MBMLModuloOperatorToken.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLModuloOperatorToken implementation
/******************************************************************************/

@implementation MBMLModuloOperatorToken

- (instancetype) init
{
    return [super initWithOperatorCharacter:'%'];
}

- (NSUInteger) precedence
{
    return 1;
}

- (NSDecimalNumber*) numericValueForLeftValue:(NSDecimalNumber*)lValue
                                   rightValue:(NSDecimalNumber*)rValue
                                        error:(inout MBExpressionError**)errPtr
{
    if ([rValue isEqualToNumber:[NSDecimalNumber zero]]) {
        MBExpressionError* err = [MBExpressionError errorWithMessage:@"It is mathematically irresponsible to perform the modulo operation using a divisor whose value is zero"];
        err.offendingToken = self;
        [err reportErrorTo:errPtr];
        return nil;
    }

    return [[NSDecimalNumber alloc] initWithLongLong:([lValue longLongValue] % [rValue longLongValue])];
}

@end
