//
//  MBExpressionTokenizer.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/19/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBVariableSpace;
@class MBExpressionGrammar;
@class MBExpressionError;

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionTokenizer class
/******************************************************************************/

/*!
 A class that uses a specific `MBExpressionGrammar` to tokenize an MBML 
 expression.
 */
@interface MBExpressionTokenizer : NSObject

/*!
 Returns the grammar used by the receiver to tokenize expressions.
 */
@property(nonatomic, readonly) MBExpressionGrammar* grammar;

/*!
 Returns an `MBExpressionTokenizer` configured to use the specified grammar.
 
 @param     grammar The `MBExpressionGrammar` that the returned tokenizer
            will use.
 */
+ (instancetype) tokenizerWithGrammar:(MBExpressionGrammar*)grammar; 

/*!
 Tokenizes the passed-in expression using the grammar with which the receiver
 was created.
 
 @param     expr The expression to be tokenized.
 
 @param     space The `MBVariableSpace` where the tokenized expression will
            be used.

 @param     errPtr An optional pointer to a memory location for storing an
            `MBExpressionError` instance. If this parameter is non-`nil`
            and an error occurs during evaluation, `*errPtr` will be updated
            to point to an `MBExpressionError` instance describing the error.

 @return    An array of `MBMLParseToken`s representing a grammar tree for the
            passed-in expression, or `nil` if there was an error.
 */
- (NSArray*) tokenize:(NSString*)expr
      inVariableSpace:(MBVariableSpace*)space
                error:(out MBExpressionError**)errPtr;

@end
