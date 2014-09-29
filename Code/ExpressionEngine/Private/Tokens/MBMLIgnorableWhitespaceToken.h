//
//  MBMLIgnorableWhitespaceToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 12/1/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLWhitespaceToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLIgnorableWhitespaceToken class
/******************************************************************************/

/*!
 An expression token representing whitespace that can be safely ignored without
 affecting the result of an expression evaluation.
 */
@interface MBMLIgnorableWhitespaceToken : MBMLWhitespaceToken
@end
