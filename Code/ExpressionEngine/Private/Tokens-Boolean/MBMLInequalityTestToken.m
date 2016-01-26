//
//  MBMLInequalityTestToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/26/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBMLInequalityTestToken.h"
#import "MBExpression.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLInequalityTestToken implementation
/******************************************************************************/

@implementation MBMLInequalityTestToken

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self addKeyword:@"!="];
        [self addKeyword:@"-NE"];
    }
    return self;
}

- (BOOL) booleanValueForLeftValue:(id)lValue rightValue:(id)rValue
{
    MBLogDebugTrace();
    
    return ![MBExpression value:lValue isEqualTo:rValue];
}

@end
