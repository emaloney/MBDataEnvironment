//
//  MBMLMathGroupingToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/20/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import "MBMLGroupingToken.h"
#import "MBMLMathOperatorToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathGroupingToken class
/******************************************************************************/

/*!
 A token representing a parenthetical grouping of math statements.
 */
@interface MBMLMathGroupingToken : MBMLGroupingToken < MBMLMathToken >
@end
