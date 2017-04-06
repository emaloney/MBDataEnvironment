//
//  MBMLBooleanOperatorToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/13/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MBMLKeywordMatchingToken.h"
#import "OperationTokens.h"

@class MBExpressionError;

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanOperator protocol
/******************************************************************************/

/*!
 A marker protocol for classes implementing boolean operators.
 */
@protocol MBMLBooleanOperator < MBMLOperandToken >
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanOperatorUnary protocol
/******************************************************************************/

/*!
 A protocol adopted by classes that implement boolean operators taking only
 one operand.
 */
@protocol MBMLBooleanOperatorUnary < MBMLUnaryOperatorToken, MBMLBooleanOperator >
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanOperatorBinary protocol
/******************************************************************************/

/*!
 A protocol adopted by classes that implement boolean operators taking two
 operands.
 */
@protocol MBMLBooleanOperatorBinary < MBMLBinaryOperatorToken, MBMLBooleanOperator >
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanComparator protocol
/******************************************************************************/

/*!
 A protocol adopted by classes that implement boolean operators taking two
 operands.
 */
@protocol MBMLBooleanComparator < MBMLBooleanOperatorBinary >
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanOperatorToken class
/******************************************************************************/

/*!
 A base class for keyword-based boolean operators.
 */
@interface MBMLBooleanOperatorToken : MBMLKeywordMatchingToken < MBMLBooleanOperator >
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLUnaryBooleanOperatorToken class
/******************************************************************************/

/*!
 A base class for keyword-based boolean operators taking one operand.
 */
@interface MBMLUnaryBooleanOperatorToken : MBMLBooleanOperatorToken < MBMLBooleanOperatorUnary >
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBinaryBooleanOperatorToken class
/******************************************************************************/

/*!
 A base class for keyword-based boolean operators that take two operands.
 */
@interface MBMLBinaryBooleanOperatorToken : MBMLBooleanOperatorToken < MBMLBooleanOperatorBinary >
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanComparatorToken class
/******************************************************************************/

/*!
 A base class for keyword-based boolean comparators that take two operands.
 */
@interface MBMLBooleanComparatorToken : MBMLBinaryBooleanOperatorToken < MBMLBooleanComparator >
- (BOOL) booleanValueForLeftValue:(id)lValue rightValue:(id)rValue;
@end





