//
//  OperationTokens.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/21/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import "MBMLParseToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLOperatorToken protocol
/******************************************************************************/

/*!
 A marker protocol for token classes that implement operators.
 */
@protocol MBMLOperatorToken < NSObject >
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLOperandToken protocol
/******************************************************************************/

/*!
 A marker protocol for token classes that can act as operands for operators.
 */
@protocol MBMLOperandToken < NSObject >
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLUnaryOperatorToken protocol
/******************************************************************************/

/*!
 A protocol implemented by unary operator token classes.
 */
@protocol MBMLUnaryOperatorToken < MBMLOperatorToken >
- (void) setOperand:(MBMLParseToken<MBMLOperandToken>*)tok;
- (MBMLParseToken<MBMLOperandToken>*) operand;
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBinaryOperatorToken protocol
/******************************************************************************/

/*!
 A protocol implemented by binary operator token classes.
 */
@protocol MBMLBinaryOperatorToken < MBMLOperatorToken >
- (void) setLeftOperand:(MBMLParseToken<MBMLOperandToken>*)left
           rightOperand:(MBMLParseToken<MBMLOperandToken>*)right;
- (MBMLParseToken<MBMLOperandToken>*) leftOperand;
- (MBMLParseToken<MBMLOperandToken>*) rightOperand;
@end
