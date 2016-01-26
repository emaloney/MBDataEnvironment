//
//  MBMLBooleanGroupingToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/29/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBMLBooleanGroupingToken.h"
#import "MBExpression.h"
#import "MBExpressionTokenizer.h"
#import "MBExpressionError.h"
#import "MBExpressionGrammar.h"
#import "MBExpression+Internal.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanGroupingToken implementation
/******************************************************************************/

@implementation MBMLBooleanGroupingToken

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self setOpenMarker:'('];
        [self setCloseMarker:')'];
    }
    return self;
}

- (NSArray*) tokenizeContainedExpressionInVariableSpace:(MBVariableSpace*)space
                                                  error:(inout MBExpressionError**)errPtr
{
    MBLogDebugTrace();

    MBExpressionTokenizer* tokenizer = [MBExpressionTokenizer tokenizerWithGrammar:[MBMLBooleanExpressionGrammar instance]];

    MBExpressionError* err = nil;
    NSArray* children = [tokenizer tokenize:[self containedExpression] inVariableSpace:space error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return nil;
    }
    [self addFirstChildTokens:children];
    return @[self];
}

- (id) evaluateInVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    MBLogDebugTrace();

    return @([self evaluateBooleanInVariableSpace:space error:errPtr]);
}

- (BOOL) evaluateBooleanInVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    MBLogDebugTrace();
    
    return [MBExpression booleanFromTokens:_childTokens inVariableSpace:space defaultValue:NO error:errPtr];
}

@end
