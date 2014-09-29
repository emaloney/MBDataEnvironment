//
//  MBMLMathExpressionToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/20/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import "OperationTokens.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathExpressionToken class
/******************************************************************************/

/*!
 An expression token representing a mathematical expression. These expressions
 take the form:
 
    #( ... )
 
 Where the text contained between the parentheses is interpreted as a 
 mathematical expression that can contain variable references, function
 calls, and numeric literals, joined by the following binary operators:
 
    * = multiplication
    / = division
    + = addition
    - = subtraction
 */
@interface MBMLMathExpressionToken : MBMLParseToken < MBMLOperandToken >
@end
