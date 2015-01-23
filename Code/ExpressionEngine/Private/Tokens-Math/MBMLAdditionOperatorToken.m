//
//  MBMLAdditionOperatorToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/20/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import "MBMLAdditionOperatorToken.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLAdditionOperatorToken implementation
/******************************************************************************/

@implementation MBMLAdditionOperatorToken

- (instancetype) init
{
    return [super initWithOperatorCharacter:'+'];
}

- (NSUInteger) precedence
{
    return 2;
}

- (NSDecimalNumber*) numericValueForLeftValue:(NSDecimalNumber*)lValue rightValue:(NSDecimalNumber*)rValue
{
    return [lValue decimalNumberByAdding:rValue];
}

@end
