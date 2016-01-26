//
//  MBMLBooleanAndOperatorToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/25/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBMLBooleanAndOperatorToken.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanAndOperatorToken implementation
/******************************************************************************/

@implementation MBMLBooleanAndOperatorToken

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self addKeyword:@"&&"];
        [self addKeyword:@"-AND"];
    }
    return self;
}

- (BOOL) evaluateBooleanInVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    MBLogDebugTrace();

    if (![[self leftOperand] evaluateBooleanInVariableSpace:space error:errPtr]) {
        return NO;
    }
    return [[self rightOperand] evaluateBooleanInVariableSpace:space error:errPtr];
}

@end
