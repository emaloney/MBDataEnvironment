//
//  MBMLGreaterThanTestToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/26/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBMLGreaterThanTestToken.h"
#import "MBExpression.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLGreaterThanTestToken implementation
/******************************************************************************/

@implementation MBMLGreaterThanTestToken

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self addKeyword:@">"];
        [self addKeyword:@"-GT"];
    }
    return self;
}

- (BOOL) booleanValueForLeftValue:(id)lValue rightValue:(id)rValue {
    
    debugTrace();
    
    NSComparisonResult comparisonResult = [MBExpression compareLeftValue:lValue againstRightValue:rValue];
    return comparisonResult == NSOrderedDescending;
}

@end
