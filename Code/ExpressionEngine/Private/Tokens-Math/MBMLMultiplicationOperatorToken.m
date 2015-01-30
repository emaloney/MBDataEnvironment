//
//  MBMLMultiplicationOperatorToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/20/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import "MBMLMultiplicationOperatorToken.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMultiplicationOperatorToken implementation
/******************************************************************************/

@implementation MBMLMultiplicationOperatorToken

- (instancetype) init
{
    return [super initWithOperatorCharacter:'*'];
}

- (NSUInteger) precedence
{
    return 1;
}

- (NSDecimalNumber*) numericValueForLeftValue:(NSDecimalNumber*)lValue
                                   rightValue:(NSDecimalNumber*)rValue
                                        error:(inout MBExpressionError**)errPtr
{
    return [lValue decimalNumberByMultiplyingBy:rValue];
}

@end
