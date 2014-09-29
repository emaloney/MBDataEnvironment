//
//  MBMLGreaterThanEqualsTestToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/26/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLGreaterThanEqualsTestToken.h"
#import "MBExpression.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLGreaterThanEqualsTestToken implementation
/******************************************************************************/

@implementation MBMLGreaterThanEqualsTestToken

- (id) init
{
    self = [super init];
    if (self) {
        [self addKeyword:@">="];
        [self addKeyword:@"=>"];
        [self addKeyword:@"-GTE"];
    }
    return self;
}

- (BOOL) booleanValueForLeftValue:(id)lValue rightValue:(id)rValue {
    
    debugTrace();
    
    NSComparisonResult comparisonResult = [MBExpression compareLeftValue:lValue againstRightValue:rValue];
    switch (comparisonResult) {
        case NSOrderedDescending: 
        case NSOrderedSame:
            return YES;

        default:
            break;
    }
    return NO;
}

@end
