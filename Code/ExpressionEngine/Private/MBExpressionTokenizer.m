//
//  MBExpressionTokenizer.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/19/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBExpressionTokenizer.h"
#import "MBMLParseToken.h"
#import "MBExpressionGrammar.h"
#import "MBExpressionError.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBTokenizationState private class
/******************************************************************************/

@interface MBTokenizationState : NSObject
{
@public
    NSUInteger expressionLength;
    NSUInteger currentChar;
    NSUInteger lastMatchEnd;
    NSUInteger lastWildcardStart;
}

+ (MBTokenizationState*) stateForExpression:(NSString*)expr;

@end

/******************************************************************************/
#pragma mark MBTokenizationState implementation
/******************************************************************************/

@implementation MBTokenizationState

+ (MBTokenizationState*) stateForExpression:(NSString*)expr
{
    MBTokenizationState* tokState = [self new];
    tokState->expressionLength = [expr length];
    return tokState;
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionTokenizer implementation
/******************************************************************************/

@implementation MBExpressionTokenizer
{
    MBExpressionGrammar* _grammar;
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (instancetype) initWithGrammar:(MBExpressionGrammar*)grammar
{
    self = [super init];
    if (self) {
        _grammar = grammar;
    }
    return self;
}

+ (instancetype) tokenizerWithGrammar:(MBExpressionGrammar*)grammar
{
    return [[self alloc] initWithGrammar:grammar];
}

/******************************************************************************/
#pragma mark Parsing support
/******************************************************************************/

- (MBMLParseToken*) _parseToEndOfToken:(MBMLParseToken*)token
                      inExpression:(NSString*)expr
                        usingState:(MBTokenizationState*)tokState
{
    debugTrace();
    
    MBMLTokenMatchStatus startStatus = [token matchStatus];
    
    BOOL hadFullMatch = (startStatus == MBMLTokenMatchFull);
    NSUInteger i = tokState->currentChar + 1;
    for (; i<tokState->expressionLength; i++) {
        unichar ch = [expr characterAtIndex:i];

        MBMLTokenMatchStatus curStatus = [token matchNextCharacter:ch];
        if (curStatus != startStatus) {
            if (curStatus == MBMLTokenMatchFull) {
                hadFullMatch = YES;
                startStatus = curStatus;
            }
            else if (curStatus == MBMLTokenMatchImpossible) {
                break;
            }
        }
    }
    
    //
    // unless we got a full match at some point, we don't have a "real" match
    //
    if (hadFullMatch) {
        NSRange exprMatch = NSMakeRange(tokState->currentChar, i - tokState->currentChar);
        
        debugLog(@"Resolved match: %@ (%@)", [token class], [expr substringWithRange:exprMatch]);
        
        [token setMatchCompleted:exprMatch];
        
        tokState->currentChar = i;
        tokState->lastMatchEnd = i;
        
        return token;
    }
    return nil;
}

- (void) _pushWildcardToken:(MBMLParseToken*)wildcard
                 startIndex:(NSUInteger)start
                   endIndex:(NSUInteger)end
                    toStack:(NSMutableArray*)stack
{
    if (end > start) {
        NSUInteger wildcardLength = (end - start);
        if (wildcardLength > 0) {
            [wildcard setMatchCompleted:NSMakeRange(start, wildcardLength)];
            [stack addObject:wildcard];
        }
    }
}

/******************************************************************************/
#pragma mark Tokenizing
/******************************************************************************/

- (NSArray*) tokenize:(NSString*)expr inVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    debugTrace();
    
    NSMutableArray* tokens = [NSMutableArray new];

    @autoreleasepool {
        NSMutableArray* possibleTokens = [_grammar parseTokensForInitialState];

        MBMLParseToken* lastWildcard = nil;
        MBMLParseToken* tok = nil;
        
        MBTokenizationState* tokState = [MBTokenizationState stateForExpression:expr];
        while (tokState->currentChar < tokState->expressionLength) {
            //
            // see if the next character causes a state transition
            // that we need to handle
            //
            unichar ch = [expr characterAtIndex:tokState->currentChar];
            
            MBMLParseToken* matchedToken = nil;
            for (NSInteger i=0; i<[possibleTokens count]; i++) {
                tok = possibleTokens[i];
                MBMLTokenMatchStatus status = [tok matchNextCharacter:ch];
                if (status == MBMLTokenMatchFull ||
                    status == MBMLTokenMatchPartial)
                {
                    matchedToken = [self _parseToEndOfToken:tok
                                               inExpression:expr
                                                 usingState:tokState];
                    
                    if (matchedToken)
                        break;
                    
                    [possibleTokens removeObjectAtIndex:i];
                    i--;    // force re-evaluation of this index since we just shifted everything down one slot
                }
                else if (status == MBMLTokenMatchWildcard) {
                    if (!lastWildcard || lastWildcard != tok) {
                        lastWildcard = tok;
                        tokState->lastWildcardStart = tokState->currentChar;
                    }
                }
                else if (status == MBMLTokenMatchImpossible) {
                    [possibleTokens removeObjectAtIndex:i];
                    i--;    // force re-evaluation of this index since we just shifted everything down one slot
                }
            }

            if (matchedToken) {
                if (lastWildcard) {
                    [self _pushWildcardToken:lastWildcard
                                  startIndex:tokState->lastWildcardStart
                                    endIndex:tokState->currentChar - [matchedToken completedMatchLength]
                                     toStack:tokens];

                    lastWildcard = nil;
                }
                [tokens addObject:matchedToken];
                
                possibleTokens = [matchedToken possibleNextTokens];
            }
            else {
                // if we're in a wildcard match AND there is only one possible token
                // (it should be the wildcard), then reset the possible tokens
                if (lastWildcard && [possibleTokens count] == 1) {
                    possibleTokens = [lastWildcard possibleNextTokens];
                }
                
                tokState->currentChar++;
            }
        }
        
        if (tokState->lastMatchEnd < tokState->currentChar && lastWildcard) {
            [self _pushWildcardToken:lastWildcard
                          startIndex:tokState->lastWildcardStart
                            endIndex:tokState->currentChar
                             toStack:tokens];
        }

    }
    
    MBExpressionError* err = nil;
    [_grammar arrangeGrammarTree:tokens inVariableSpace:space error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return nil;
    }

    [_grammar validateSyntax:tokens error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return nil;
    }

    //
    // finally, freeze all the tokens in the match stack;
    // this effectively marks them as no longer changing
    // state, and allows us to free up some resources used
    // during the tokenization process
    //
    [tokens makeObjectsPerformSelector:@selector(freeze)];
    
    return tokens;
}

@end
