//
//  MBExpressionCache+Internal.h
//  Mockingbird Data Environment
//
//  Created by Evan Maloney on 1/15/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MBExpressionCache.h"

/*!
 Internal interface for `MBExpressionCache` class.
 */
@interface MBExpressionCache (Private)

/*----------------------------------------------------------------------------*/
#pragma mark Retrieving tokens for expressions
/*!    @name Retrieving tokens for expressions                                */
/*----------------------------------------------------------------------------*/

/*!
 Returns the cached `MBMLParseToken`s for the given expression.

 @param     expr The expression for which the cached tokens are sought.

 @param     grammar The grammar used to tokenize the expression.

 @return    An array of the cached tokens for the passed-in expression, or
 `nil` if there are no cached tokens for the given expression.
 */
- (NSArray*) cachedTokensForExpression:(NSString*)expr
                          usingGrammar:(MBExpressionGrammar*)grammar;

/*!
 Returns an array of `MBMLParseToken` instances representing the tokenized
 version of the passed-in expression.

 If the expression is already in the cache, the cached tokens are returned.
 Otherwise, the expression is be tokenized using the specified grammar,
 the resulting tokens are added to the cache, and are then returned.

 @param     expr The expression to tokenize.

 @param     space The variable space that will be used to look up values for
 any variable references contained in the expression.

 @param     grammar The grammar to be used for tokenizing the expression.

 @param     errPtr An optional pointer to a memory location for storing an
 `MBExpressionError` instance. If this parameter is non-`nil`
 and an error occurs during tokenization, `errPtr` will be updated
 to point to an `MBExpressionError` instance describing the error.

 @return    An array of tokens representing the passed-in expression. Will be
 `nil` if an error occurs.
 */
- (NSArray*) tokensForExpression:(NSString*)expr
                 inVariableSpace:(MBVariableSpace*)space
                    usingGrammar:(MBExpressionGrammar*)grammar
                           error:(MBExpressionError**)errPtr;

@end
