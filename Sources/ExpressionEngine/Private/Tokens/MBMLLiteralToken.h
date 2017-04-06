//
//  MBMLLiteralToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/19/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "OperationTokens.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLLiteralToken class
/******************************************************************************/

/*!
 An expression token representing a concrete object value. During expression
 tokenization, ranges of text that do not match other tokens will become
 literals. Also, during expression evaluation, as object references are
 resolved, literals will be used to contain the resulting value.
 */
@interface MBMLLiteralToken : MBMLParseToken < MBMLOperandToken >

+ (instancetype) literalTokenWithValue:(id)value;

@end
