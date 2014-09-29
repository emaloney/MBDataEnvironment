//
//  MBMLParseToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/19/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "Mockingbird-DataEnvironment.h"

@class MBVariableSpace;
@class MBExpressionGrammar;
@class MBExpressionError;

/******************************************************************************/
#pragma mark MBMLTokenMatchStatus typedef
/******************************************************************************/

//!< the possible match states for a token
typedef enum
{
    MBMLTokenMatchNotStarted = 0,      //!< initial state; useful for detecting uninitialized variables
    MBMLTokenMatchWildcard,            //!< matches because parse state is accepting wildcards
    MBMLTokenMatchPartial,             //!< matches partially so far; will become either MBMLTokenMatchFull or MBMLTokenMatchImpossible with more input
    MBMLTokenMatchFull,                //!< matches fully without additional input but may take more input
    MBMLTokenMatchFrozen,              //!< was a wildcard or full match that is now frozen due to a successful match
    MBMLTokenMatchImpossible           //!< can't be a match given current input
} MBMLTokenMatchStatus;

/******************************************************************************/
#pragma mark -
#pragma mark MBMLParseToken class
/******************************************************************************/

/*!
 The superclass of all expression tokens.
 */
@interface MBMLParseToken : NSObject < NSCoding >
{
@protected
    MBExpressionGrammar* _grammar;
    NSMutableString* _accumulatedChars;
    NSMutableArray* _possibleNextTokenClasses;
    MBMLTokenMatchStatus _matchStatus;
    NSInteger _identifierStartAtChar;
    NSInteger _identifierEndBeforeChar;
    NSInteger _containedExpressionStartAtChar;
    NSInteger _containedExpressionEndBeforeChar;
    NSRange _matchRange;
    NSMutableArray* _childTokens;
}

@property(nonatomic, strong, readonly) NSArray* childTokens;

+ (id) tokenWithGrammar:(MBExpressionGrammar*)grammar;

- (id) initWithGrammar:(MBExpressionGrammar*)grammar;

- (NSString*) expression;   // nil unless isMatchCompleted is YES
- (NSString*) normalizedRepresentation;
- (id) value;

- (BOOL) hasIdentifier;
- (NSString*) tokenIdentifier;

- (BOOL) doesContainExpression;
- (NSString*) containedExpression;


- (NSString*) tokenDescription;

- (void) addChildToken:(MBMLParseToken*)child;
- (void) addChildTokens:(NSArray*)children;

- (void) addFirstChildToken:(MBMLParseToken*)child;
- (void) addFirstChildTokens:(NSArray*)children;

- (MBMLTokenMatchStatus) matchNextCharacter:(unichar)ch;

- (MBMLTokenMatchStatus) matchStatus;

- (NSMutableArray*) possibleNextTokens;

- (BOOL) isMatchCompleted;
- (NSRange) completedMatchRange;
- (NSUInteger) completedMatchStartCharacter;
- (NSUInteger) completedMatchLength;

- (NSString*) accumulatedString;
- (NSUInteger) accumulatedLength;

- (MBMLTokenMatchStatus) matchWhenAddingCharacter:(unichar)ch toExpression:(NSString*)accumExpr;

- (void) addPossibleNextTokenClass:(Class)cls;
- (void) removePossibleNextTokenClass:(Class)cls;

- (BOOL) isIdentifierStartPositionSet;
- (BOOL) isIdentifierEndPositionSet;

- (void) setIdentifierStartAtPosition:(NSUInteger)pos;
- (void) setIdentifierEndBeforePosition:(NSUInteger)pos;

- (BOOL) isContainedExpressionStartPositionSet;
- (BOOL) isContainedExpressionEndPositionSet;

- (void) setContainedExpressionStartAtPosition:(NSUInteger)pos;
- (void) setContainedExpressionEndBeforePosition:(NSUInteger)pos;

- (void) setMatchCompleted:(NSRange)matchRange;

- (void) freeze;
- (BOOL) isFrozen;

- (NSArray*) tokenizeContainedExpressionInVariableSpace:(MBVariableSpace*)space
                                                  error:(MBExpressionError**)errPtr;

- (NSArray*) tokenizeContainedExpressionInVariableSpace:(MBVariableSpace*)space
                                           usingGrammar:(MBExpressionGrammar*)grammar
                                                  error:(MBExpressionError**)errPtr;

- (id) evaluateInVariableSpace:(MBVariableSpace*)space error:(MBExpressionError**)err;
- (BOOL) evaluateBooleanInVariableSpace:(MBVariableSpace*)space error:(MBExpressionError**)err;

@end

