//
//  MBMLBooleanNegationToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/25/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLBooleanOperatorToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanNegationToken class
/******************************************************************************/

/*!
 A token representing a unary boolean operator that returns the opposite
 boolean value of its operand.
 */
@interface MBMLBooleanNegationToken : MBMLUnaryBooleanOperatorToken
@end
