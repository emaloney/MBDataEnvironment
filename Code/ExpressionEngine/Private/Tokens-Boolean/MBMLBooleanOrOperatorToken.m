//
//  MBMLBooleanOrOperatorToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/26/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBMLBooleanOrOperatorToken.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanOrOperatorToken implementation
/******************************************************************************/

@implementation MBMLBooleanOrOperatorToken

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self addKeyword:@"||"];
        [self addKeyword:@"-OR"];
    }
    return self;
}

- (BOOL) evaluateBooleanInVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    MBLogDebugTrace();

    if ([[self leftOperand] evaluateBooleanInVariableSpace:space error:errPtr]) {
        return YES;
    }
    return [[self rightOperand] evaluateBooleanInVariableSpace:space error:errPtr];
}

@end
