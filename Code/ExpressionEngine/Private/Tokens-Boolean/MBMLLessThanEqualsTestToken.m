//
//  MBMLLessThanEqualsTestToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/26/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBMLLessThanEqualsTestToken.h"
#import "MBExpression.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLLessThanEqualsTestToken implementation
/******************************************************************************/

@implementation MBMLLessThanEqualsTestToken

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self addKeyword:@"<="];
        [self addKeyword:@"=<"];
        [self addKeyword:@"-LTE"];
    }
    return self;
}

- (BOOL) booleanValueForLeftValue:(id)lValue rightValue:(id)rValue {
    
    MBLogDebugTrace();
    
    NSComparisonResult comparisonResult = [MBExpression compareLeftValue:lValue againstRightValue:rValue];
    switch (comparisonResult) {
        case NSOrderedAscending: 
        case NSOrderedSame:
            return YES;

        default:
            break;
    }
    return NO;
}

@end
