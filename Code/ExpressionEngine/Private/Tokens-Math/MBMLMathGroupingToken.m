//
//  MBMLMathGroupingToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/20/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBMLMathGroupingToken.h"
#import "MBExpression.h"
#import "MBExpressionTokenizer.h"
#import "MBExpressionError.h"
#import "MBExpressionGrammar.h"
#import "MBExpression+Internal.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathGroupingToken implementation
/******************************************************************************/

@implementation MBMLMathGroupingToken

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

    MBExpressionTokenizer* tokenizer = [MBExpressionTokenizer tokenizerWithGrammar:[MBMLMathExpressionGrammar instance]];

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

    MBExpressionError* err = nil;
    NSArray* values = [MBExpression evaluateTokens:_childTokens inVariableSpace:space error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return nil;
    }
    
    if (values.count != 1) {
        MBExpressionError* err = [MBExpressionError errorWithMessage:@"Expecting one and only one value here"];
        err.offendingToken = self;
        [err reportErrorTo:errPtr];
        return nil;
    }
    return values[0];
}

@end
