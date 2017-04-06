//
//  MBMLWhitespaceToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/19/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLParseToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLWhitespaceToken class
/******************************************************************************/

/*!
 A token representing a string of one or more whitespace characters, as
 determined by <code>[NSCharacterSet whitespaceAndNewlineCharacterSet]</code>.
 */
@interface MBMLWhitespaceToken : MBMLParseToken
@end
