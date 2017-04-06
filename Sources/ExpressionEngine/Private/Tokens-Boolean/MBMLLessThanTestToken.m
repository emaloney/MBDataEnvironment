//
//  MBMLLessThanTestToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/26/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBModuleLogMacros.h>

#import "MBMLLessThanTestToken.h"
#import "MBExpression.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLLessThanTestToken implementation
/******************************************************************************/

@implementation MBMLLessThanTestToken

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self addKeyword:@"<"];
        [self addKeyword:@"-LT"];
    }
    return self;
}

- (BOOL) booleanValueForLeftValue:(id)lValue rightValue:(id)rValue {
    
    MBLogDebugTrace();
    
    NSComparisonResult comparisonResult = [MBExpression compareLeftValue:lValue againstRightValue:rValue];
    return comparisonResult == NSOrderedAscending;
}

@end
