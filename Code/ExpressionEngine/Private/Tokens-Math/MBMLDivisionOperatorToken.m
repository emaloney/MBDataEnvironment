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

- (NSDecimalNumber*) numericValueForLeftValue:(NSDecimalNumber*)lValue rightValue:(NSDecimalNumber*)rValue
{
    return [lValue decimalNumberByDividingBy:rValue];
}

@end
