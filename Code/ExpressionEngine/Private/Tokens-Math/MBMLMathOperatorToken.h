//
//  MBMLMathOperatorToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/20/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import "MBMLKeywordMatchingToken.h"
#import "OperationTokens.h"

@class MBExpressionError;

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathToken protocol
/******************************************************************************/

/*!
 A marker protocol for token classes that can appear in math expressions.
 */
@protocol MBMLMathToken < NSObject >
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathOperatorToken class
/******************************************************************************/

/*!
 A base class for math operators.
 */
@interface MBMLMathOperatorToken : MBMLParseToken < MBMLBinaryOperatorToken, MBMLMathToken, MBMLOperandToken >
- (id) initWithOperatorCharacter:(unichar)ch;

// must be implemented by subclasses
- (NSUInteger) precedence;
- (NSDecimalNumber*) numericValueForLeftValue:(NSDecimalNumber*)lValue
                                   rightValue:(NSDecimalNumber*)rValue;
@end
