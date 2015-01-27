//
//  MBExpressionGrammar.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/2/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBSingleton.h>

@class MBVariableSpace;
@class MBMLParseToken;
@class MBExpressionError;

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionGrammar class
/******************************************************************************/

@interface MBExpressionGrammar : NSObject

- (NSMutableArray*) tokenClassesForInitialState;

- (NSMutableArray*) parseTokensForInitialState;

- (NSMutableArray*) tokenClassesForNextStates:(MBMLParseToken*)token;

- (void) arrangeGrammarTree:(NSMutableArray*)tokens
            inVariableSpace:(MBVariableSpace*)space
                      error:(out MBExpressionError**)errPtr;

/*!
 As a performance optimization to avoid tokenization and evaluation, an
 `MBExpressionGrammar` implementation determine whether a given expression
 is a constant expression.
 
 A constant expression is one whose value is not dependent on any runtime
 state, and therefore does not require token-based evaluation.
 
 @note      This method may return `NO` even in cases where an expression
            is constant, such as in cases where determining whether an
            expression is constant would be as expensive as evaluating the
            expression itself.

 @param     expr The expression to check.
 
 @return    `YES` if `expr` is a constant expression.
 */
- (BOOL) canOptimizeAsConstantExpression:(NSString*)expr;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLGrammar class
/******************************************************************************/

@interface MBMLGrammar : MBExpressionGrammar
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLObjectExpressionGrammar class
/******************************************************************************/

@interface MBMLObjectExpressionGrammar : MBMLGrammar <MBSingleton>
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanExpressionGrammar class
/******************************************************************************/

@interface MBMLBooleanExpressionGrammar : MBMLGrammar <MBSingleton>
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathExpressionGrammar class
/******************************************************************************/

@interface MBMLMathExpressionGrammar : MBMLGrammar <MBSingleton>
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLParameterListGrammar class
/******************************************************************************/

@interface MBMLParameterListGrammar : MBMLGrammar <MBSingleton>

- (void) arrangeParameterGroup:(NSMutableArray*)tokens
               inVariableSpace:(MBVariableSpace*)space
                         error:(out MBExpressionError**)errPtr;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathParameterListGrammar class
/******************************************************************************/

@interface MBMLMathParameterListGrammar : MBMLParameterListGrammar <MBSingleton>
@end
