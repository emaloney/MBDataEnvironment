//
//  MBMLMathOperatorToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/20/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>

#import "MBMLMathOperatorToken.h"
#import "MBExpressionError.h"
#import "MBExpression.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathOperatorToken implementation
/******************************************************************************/

@implementation MBMLMathOperatorToken
{
    unichar _opChar;
}

- (instancetype) initWithOperatorCharacter:(unichar)ch
{
    self = [super init];
    if (self) {
        _opChar = ch;
    }
    return self;
}

- (MBMLTokenMatchStatus) matchWhenAddingCharacter:(unichar)ch toExpression:(NSString*)accumExpr
{
    debugTrace();
    
    if (accumExpr.length == 0 && _opChar == ch) {
        return MBMLTokenMatchFull;
    } else {
        return MBMLTokenMatchImpossible;
    }
}

- (NSUInteger) precedence
{
    MBErrorNotImplementedReturn(NSUInteger);
}

- (void) setLeftOperand:(MBMLParseToken<MBMLOperandToken>*)left
           rightOperand:(MBMLParseToken<MBMLOperandToken>*)right
{
    debugTrace();
    
    [_childTokens removeAllObjects];
    [self addChildToken:left];
    [self addChildToken:right];
}

- (MBMLParseToken<MBMLOperandToken>*) leftOperand
{
    debugTrace();

    return [_childTokens firstObject];
}

- (MBMLParseToken<MBMLOperandToken>*) rightOperand
{
    debugTrace();
    
    if (_childTokens.count > 1) {
        return _childTokens[1];
    }
    return nil;
}

- (BOOL) validateSyntax:(inout MBExpressionError**)errPtr
{
    id left = [self leftOperand];
    id right = [self rightOperand];

    MBExpressionError* err = nil;
    if (!left && !right) {
        err = [MBExpressionError errorWithFormat:@"The operator \"%@\" requires both left and right operands", [self expression]];
    }
    else if (!left) {
        err = [MBExpressionError errorWithFormat:@"The operator \"%@\" requires a left operand", [self expression]];
    }
    else if (!right) {
        err = [MBExpressionError errorWithFormat:@"The operator \"%@\" requires a right operand", [self expression]];
    }
    if (err) {
        [err reportErrorTo:errPtr];
        return NO;
    }
    return YES;
}

- (NSDecimalNumber*) numericValueForLeftValue:(NSDecimalNumber*)lValue
                                   rightValue:(NSDecimalNumber*)rValue
                                        error:(inout MBExpressionError**)errPtr
{
    MBErrorNotImplementedReturn(NSDecimalNumber*);
}

- (id) evaluateInVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    debugTrace();

    MBExpressionError* err = nil;
    id lValObj = [[self leftOperand] evaluateInVariableSpace:space error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return nil;
    }
    if (!lValObj) {
        err = [MBExpressionError errorWithFormat:@"The operator \"%@\" requires a valid left operand value", [self expression]];
        err.offendingToken = [self leftOperand];
        [err reportErrorTo:errPtr];
        return nil;
    }

    id rValObj = [[self rightOperand] evaluateInVariableSpace:space error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return nil;
    }
    if (!rValObj) {
        err = [MBExpressionError errorWithFormat:@"The operator \"%@\" requires a valid right operand value", [self expression]];
        err.offendingToken = [self rightOperand];
        [err reportErrorTo:errPtr];
        return nil;
    }
    
    NSDecimalNumber* lVal = [MBExpression numberFromValue:lValObj];
    if (!lVal) {
        err = [MBExpressionError errorWithFormat:@"Left operand couldn't be interpreted as a number: \"%@\"", [[self leftOperand] expression]];
        err.offendingToken = self;
        [err reportErrorTo:errPtr];
        return nil;
    }
    
    NSDecimalNumber* rVal = [MBExpression numberFromValue:rValObj];
    if (!rVal) {
        err = [MBExpressionError errorWithFormat:@"Right operand couldn't be interpreted as a number: \"%@\"", [[self rightOperand] expression]];
        err.offendingToken = self;
        [err reportErrorTo:errPtr];
        return nil;
    }
    
    return [self numericValueForLeftValue:lVal rightValue:rVal error:errPtr];
}

@end
