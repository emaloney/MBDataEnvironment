//
//  MBMLKeywordMatchingToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/25/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLParseToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLKeywordMatchingToken class
/******************************************************************************/

/*!
 An abstract expression token representing a text keyword (or a set of keywords
 that should be treated synonymously by the parser). Subclass implementations
 indicate the keyword(s) that will be matched.
 */
@interface MBMLKeywordMatchingToken : MBMLParseToken

- (void) addKeyword:(NSString*)keyword;

@end
