//
//  MBMLEqualityTestToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/26/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLEqualityTestToken.h"
#import "MBExpression.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLEqualityTestToken implementation
/******************************************************************************/

@implementation MBMLEqualityTestToken

- (id) init
{
    self = [super init];
    if (self) {
        [self addKeyword:@"=="];
        [self addKeyword:@"-EQ"];
    }
    return self;
}

- (BOOL) booleanValueForLeftValue:(id)lValue rightValue:(id)rValue
{
    debugTrace();
    
    return [MBExpression value:lValue isEqualTo:rValue];
}

@end
