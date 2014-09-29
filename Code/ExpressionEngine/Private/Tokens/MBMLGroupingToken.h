//
//  MBMLGroupingToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/29/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "OperationTokens.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLGroupingToken class
/******************************************************************************/

/*!
 An abstract expression token representing a pair of grouping characters such 
 quotes or parentheses, and whatever text is contained between the open marker
 and close marker characters. Subclass implementations specify the particular
 open and close markers that will be matched.
 */
@interface MBMLGroupingToken : MBMLParseToken < MBMLOperandToken >

- (void) setOpenMarker:(unichar)marker;
- (void) setCloseMarker:(unichar)marker;

@end
