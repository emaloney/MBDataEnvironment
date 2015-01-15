//
//  MBMLMathExpressionToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/20/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBMLMathExpressionToken.h"
#import "MBExpressionGrammar.h"
#import "MBExpressionTokenizer.h"
#import "MBExpression.h"
#import "MBExpressionError.h"
#import "MBExpression+Internal.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathExpressionToken class
/******************************************************************************/

@implementation MBMLMathExpressionToken
{
    BOOL _gotOpenParen;
    NSUInteger _unclosedOpenParenCount;
    BOOL _gotCloseParen;
}

- (MBMLTokenMatchStatus) matchWhenAddingCharacter:(unichar)ch toExpression:(NSString*)accumExpr
{
    debugTrace();

    if (!_gotCloseParen) {
        NSUInteger pos = [accumExpr length];
        if (pos == 0) {
            // first character
            if (ch == '#') {
                return MBMLTokenMatchPartial;
            }
        }
        else if (pos == 1) {
            // second character
            if (ch == '(') {
                _gotOpenParen = YES;
                [self setContainedExpressionStartAtPosition:pos+1];
                return MBMLTokenMatchPartial;
            }
        }
        else {
            // third character and up
            if (ch == '(') {
                _unclosedOpenParenCount++;
            }
            else if (ch == ')') {
                if (_unclosedOpenParenCount > 0) {
                    _unclosedOpenParenCount--;
                }
                else {
                    _gotCloseParen = YES;
                    [self setContainedExpressionEndBeforePosition:pos];
                    return MBMLTokenMatchFull;
                }
            }
            return MBMLTokenMatchPartial;
        }
    }
    return MBMLTokenMatchImpossible;
}

- (NSArray*) tokenizeContainedExpressionInVariableSpace:(MBVariableSpace*)space
                                                  error:(MBExpressionError**)errPtr
{
    debugTrace();
    
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

- (id) evaluateInVariableSpace:(MBVariableSpace*)space error:(MBExpressionError**)errPtr
{
    debugTrace();
    
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
