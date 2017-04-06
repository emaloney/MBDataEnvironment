//
//  MBMLNumericLiteralToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/20/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import "OperationTokens.h"
#import "MBMLMathOperatorToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLNumericLiteralToken class
/******************************************************************************/

/*!
 An expression token representing a numeric literal based on the U.S. number
 format. Numeric literals may start with an optional sign character ("+" or
 "-"), followed by zero or more digits (0-9), followed by an optional decimal
 point ("."), followed by zero or more digits.
 */
@interface MBMLNumericLiteralToken : MBMLParseToken < MBMLOperandToken, MBMLMathToken >
@end
