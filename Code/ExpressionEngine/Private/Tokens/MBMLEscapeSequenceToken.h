//
//  MBMLEscapeSequenceToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 12/2/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLKeywordMatchingToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLEscapeSequenceToken class
/******************************************************************************/

/*!
 An expression token representing an escape sequence. Escape sequences are used
 to ensure that a set of characters is interpreted as a literal, not as an
 expression such as a <code>$variableReference</code> or a 
 <code>^functionCall()</code>.
 */
@interface MBMLEscapeSequenceToken : MBMLKeywordMatchingToken

- (void) setEscapeSequence:(NSString*)seq value:(NSString*)val;

- (NSString*) unescapedValue;

@end
