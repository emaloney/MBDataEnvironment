//
//  MBMLBooleanOperatorToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/13/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>

#import "MBMLBooleanOperatorToken.h"
#import "MBExpression.h"
#import "MBExpressionError.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanOperatorToken implementation
/******************************************************************************/

@implementation MBMLBooleanOperatorToken

- (id) evaluateInVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    return @([self evaluateBooleanInVariableSpace:space error:errPtr]);
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLUnaryBooleanOperatorToken implementation
/******************************************************************************/

@implementation MBMLUnaryBooleanOperatorToken

- (void) setOperand:(MBMLParseToken<MBMLOperandToken>*)tok
{
    debugTrace();
    
    [_childTokens removeAllObjects];
    [self addChildToken:tok];
}

- (MBMLParseToken<MBMLOperandToken>*) operand
{
    debugTrace();

    return [_childTokens firstObject];
}

- (BOOL) evaluateBooleanInVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    return [[self operand] evaluateBooleanInVariableSpace:space error:errPtr];
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBinaryBooleanOperatorToken implementation
/******************************************************************************/

@implementation MBMLBinaryBooleanOperatorToken

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

- (BOOL) evaluateBooleanInVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    // subclasses must implement
    MBErrorNotImplementedReturn(BOOL);
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanComparatorToken implementation
/******************************************************************************/

/*!
 A base implementation for keyword-based boolean operators that take two
 operands.
 */
@implementation MBMLBooleanComparatorToken

- (BOOL) booleanValueForLeftValue:(id)lValue rightValue:(id)rValue
{
    // subclasses must implement
    MBErrorNotImplementedReturn(BOOL);
}

- (BOOL) evaluateBooleanInVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    MBExpressionError* err = nil;
    id lVal = [[self leftOperand] evaluateInVariableSpace:space error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return NO;
    }
    
    id rVal = [[self rightOperand] evaluateInVariableSpace:space error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return NO;
    }
    return [self booleanValueForLeftValue:lVal rightValue:rVal];
}

@end
