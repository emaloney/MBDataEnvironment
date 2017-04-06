//
//  MBMLInequalityTestToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/26/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLBooleanOperatorToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLInequalityTestToken class
/******************************************************************************/

/*!
 A token representing a boolean comparator that returns true if the operands
 being compared are not considered equal.
 */
@interface MBMLInequalityTestToken : MBMLBooleanComparatorToken
@end
