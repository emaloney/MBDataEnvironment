//
//  MBMLParameterGroupingToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/24/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MBMLGroupingToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLParameterGroupingToken class
/******************************************************************************/

/*!
 A token representing a grouping of tokens that should be treated as a
 single entity.
 */
@interface MBMLParameterGroupingToken : MBMLGroupingToken

+ (MBMLParameterGroupingToken*) parameterWithLiteralValue:(id)literal;
+ (MBMLParameterGroupingToken*) parameterWithTokens:(NSArray*)tokens;

@end
