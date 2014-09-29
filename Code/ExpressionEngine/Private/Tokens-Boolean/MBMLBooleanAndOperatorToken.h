//
//  MBMLBooleanAndOperatorToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/25/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLBooleanOperatorToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanAndOperatorToken class
/******************************************************************************/

/*!
 A token representing a binary boolean operator that returns true if and only
 if both operands are true.
 */
@interface MBMLBooleanAndOperatorToken : MBMLBinaryBooleanOperatorToken
@end
