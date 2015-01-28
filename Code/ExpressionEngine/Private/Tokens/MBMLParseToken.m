//
//  MBMLParseToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/19/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBMLParseToken.h"
#import "MBExpression.h"
#import "MBExpressionGrammar.h"
#import "MBExpressionTokenizer.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

#define kCoderKeyGrammarClass               @"grammarClass"
#define kCoderKeyAccumulatedChars           @"accumulatedChars"
#define kCoderKeyIdentifierStart            @"startIdentifier"
#define kCoderKeyIdentifierEnd              @"endIdentifier"
#define kCoderKeyContainedExpressionStart   @"startContainedExpr"
#define kCoderKeyContainedExpressionEnd     @"endContainedExpr"
#define kCoderKeyMatchRangeLocation         @"locMatchRange"
#define kCoderKeyMatchRangeLength           @"lenMatchRange"
#define kCoderKeyChildTokens                @"childTokens"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLParseToken implementation
/******************************************************************************/

@implementation MBMLParseToken

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (instancetype) initWithGrammar:(MBExpressionGrammar*)grammar
{
    self = [self init];
    if (self) {
        _grammar = grammar;
        _accumulatedChars = [NSMutableString new];
        _identifierStartAtChar = -1;
        _identifierEndBeforeChar = -1;
        _containedExpressionStartAtChar = -1;
        _containedExpressionEndBeforeChar = -1;
        _matchRange = NSMakeRange(NSNotFound, 0);
    }
    return self;
}

+ (instancetype) tokenWithGrammar:(MBExpressionGrammar*)grammar
{
    return [[self alloc] initWithGrammar:grammar];
}

/******************************************************************************/
#pragma mark Object serialization
/******************************************************************************/

- (instancetype) initWithCoder:(NSCoder*)coder
{
    debugTrace();
    
    // we only support keyed coding
    if (![coder allowsKeyedCoding]) {
        return nil;
    }
    
    self = [self init];
    if (self) {
        NSString* grammarClassName = [coder decodeObjectForKey:kCoderKeyGrammarClass];
        Class grammarClass = NSClassFromString(grammarClassName);
        if (grammarClass) {
            if ([grammarClass respondsToSelector:@selector(instance)]) {
                _grammar = (MBExpressionGrammar*) [grammarClass instance];
                assert(_grammar);
            }
            else {
                errorLog(@"Could not properly deserialize %@ because the %@ class named \"%@\" isn't a singleton", [self class], [MBExpressionGrammar class], grammarClassName);
            }
        }
        else if (!grammarClass && grammarClassName) {
            errorLog(@"Could not properly deserialize %@ because the %@ class named \"%@\" wasn't found", [self class], [MBExpressionGrammar class], grammarClassName);
        }
        
        _accumulatedChars = [coder decodeObjectForKey:kCoderKeyAccumulatedChars];
        if (_accumulatedChars) {
            _identifierStartAtChar = [coder decodeIntegerForKey:kCoderKeyIdentifierStart];
            _identifierEndBeforeChar = [coder decodeIntegerForKey:kCoderKeyIdentifierEnd];
            _containedExpressionStartAtChar = [coder decodeIntegerForKey:kCoderKeyContainedExpressionStart];
            _containedExpressionEndBeforeChar = [coder decodeIntegerForKey:kCoderKeyContainedExpressionEnd];
            _matchRange.location = (NSUInteger) [coder decodeIntegerForKey:kCoderKeyMatchRangeLocation];
            _matchRange.length = (NSUInteger) [coder decodeIntegerForKey:kCoderKeyMatchRangeLength];
        }
        else {
            _accumulatedChars = [NSMutableString new];
            _identifierStartAtChar = -1;
            _identifierEndBeforeChar = -1;
            _containedExpressionStartAtChar = -1;
            _containedExpressionEndBeforeChar = -1;
            _matchRange = NSMakeRange(NSNotFound, 0);
        }
        _childTokens = [coder decodeObjectForKey:kCoderKeyChildTokens];
        
        _matchStatus = MBMLTokenMatchFrozen;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder*)coder
{
    debugTrace();
    
    assert([coder allowsKeyedCoding]);              // we only support keyed coding, and we
    assert(_matchStatus == MBMLTokenMatchFrozen);   // only serialize frozen tokens
    
    [coder encodeObject:[[_grammar class] description]      forKey:kCoderKeyGrammarClass];
    [coder encodeObject:_accumulatedChars                   forKey:kCoderKeyAccumulatedChars];
    if (_accumulatedChars) {
        [coder encodeInteger:_identifierStartAtChar             forKey:kCoderKeyIdentifierStart];
        [coder encodeInteger:_identifierEndBeforeChar           forKey:kCoderKeyIdentifierEnd];
        [coder encodeInteger:_containedExpressionStartAtChar    forKey:kCoderKeyContainedExpressionStart];
        [coder encodeInteger:_containedExpressionEndBeforeChar  forKey:kCoderKeyContainedExpressionEnd];
        [coder encodeInteger:_matchRange.location               forKey:kCoderKeyMatchRangeLocation];
        [coder encodeInteger:_matchRange.length                 forKey:kCoderKeyMatchRangeLength];
    }
    [coder encodeObject:_childTokens                        forKey:kCoderKeyChildTokens];
}

/******************************************************************************/
#pragma mark Debugging output
/******************************************************************************/

- (NSString*) tokenDescription
{
    NSMutableString* desc = [NSMutableString stringWithFormat:@"<%@@%p: ", [self class], self];
    if ([self isMatchCompleted]) {
        NSString* expr = [self expression];
        if (expr) {
            [desc appendFormat:@"\"%@\"", expr];
            if (_matchRange.location != NSNotFound) {
                [desc appendFormat:@" %@", NSStringFromRange(_matchRange)];
            }
        }
    }
    else {
        [desc appendFormat:@"\"%@\"", _accumulatedChars];
        switch (_matchStatus) {
            case MBMLTokenMatchNotStarted:
                [desc appendString:@" (initial)"];
                break;
                
            case MBMLTokenMatchWildcard:
                [desc appendString:@" (wildcard match)"];
                break;
                
            case MBMLTokenMatchPartial:
                [desc appendString:@" (partial match)"];
                break;
                
            case MBMLTokenMatchFull:
                [desc appendString:@" (match)"];
                break;
                
            case MBMLTokenMatchImpossible:
                [desc appendString:@" (no match)"];
                break;
                
            default:
                break;
        }
    }
    [desc appendString:@">"];
    return desc;
}

- (NSString*) tokenDescriptionAtIndent:(NSUInteger)indentLevel withLabel:(NSString*)label
{
    NSMutableString* desc = [NSMutableString string];
    for (NSUInteger i=0; i<indentLevel; i++) {
        [desc appendString:@"\t"];
    }
    if (label) {
        [desc appendString:label];
    }
    [desc appendString:[self tokenDescription]];
    return desc;
}

- (NSString*) descriptionAtIndent:(NSUInteger)indentLevel withLabel:(NSString*)label
{
    NSMutableString* desc = [NSMutableString string];
    [desc appendString:[self tokenDescriptionAtIndent:indentLevel withLabel:label]];

    NSUInteger children = _childTokens.count;
    if (children > 0) {
        [desc appendFormat:@" containing %lu token%s:\n", (unsigned long)children, (children == 1 ? "" : "s")];
        for (NSUInteger i=0; i<children; i++) {
            if (i>0) {
                [desc appendString:@"\n"];
            }
            MBMLParseToken* child = _childTokens[i];
            NSString* childLabel = [NSString stringWithFormat:@"%lu: ", (unsigned long)i];
            [desc appendString:[child descriptionAtIndent:indentLevel+1 withLabel:childLabel]];
        }
    }
    return desc;
}

- (NSString*) description
{
    return [self descriptionAtIndent:0 withLabel:nil];
}

/******************************************************************************/
#pragma mark Processing characters
/******************************************************************************/

- (MBMLTokenMatchStatus) matchNextCharacter:(unichar)ch
{
    debugTrace();

    assert(_matchStatus != MBMLTokenMatchFrozen);
    
    if (_matchStatus != MBMLTokenMatchImpossible) {
        _matchStatus = [self matchWhenAddingCharacter:ch toExpression:_accumulatedChars];

        [_accumulatedChars appendFormat:@"%C", ch];
    }
    return _matchStatus;
}

- (MBMLTokenMatchStatus) matchWhenAddingCharacter:(unichar)ch toExpression:(NSString*)accumExpr
{
    // subclasses must implement this
    return MBMLTokenMatchNotStarted;
}

- (MBMLTokenMatchStatus) matchStatus
{
    debugTrace();
    
    return _matchStatus;
}

/******************************************************************************/
#pragma mark Match completion
/******************************************************************************/

- (BOOL) isMatchCompleted
{
    debugTrace();
    
    return (_matchRange.location != NSNotFound && _matchRange.length > 0);
}

- (void) setMatchCompleted:(NSRange)matchRange
{
    debugTrace();
    
    _matchRange = matchRange;
}

- (NSRange) completedMatchRange
{
    return _matchRange;
}

- (NSUInteger) completedMatchStartCharacter
{
    return _matchRange.location;
}

- (NSUInteger) completedMatchLength
{
    return _matchRange.length;
}

/******************************************************************************/
#pragma mark State transitions
/******************************************************************************/

- (NSMutableArray*) possibleNextTokenClasses
{
    if (!_possibleNextTokenClasses) {
        _possibleNextTokenClasses = [_grammar tokenClassesForNextStates:self];
    }
    return _possibleNextTokenClasses;
}

- (void) addPossibleNextTokenClass:(Class)cls
{
    debugTrace();
    
    NSMutableArray* next = [self possibleNextTokenClasses];
    if (![next containsObject:cls]) {
        [next addObject:cls];
    }
}

- (void) removePossibleNextTokenClass:(Class)cls
{
    debugTrace();
    
    [[self possibleNextTokenClasses] removeObject:cls];
}

- (NSMutableArray*) possibleNextTokens
{
    debugTrace();
    
    NSMutableArray* nextTokens = [NSMutableArray array];
    for (Class tokCls in [self possibleNextTokenClasses]) {
        if (_matchStatus == MBMLTokenMatchWildcard && [self isMemberOfClass:tokCls]) {
            // if we're a wildcard token AND tokCls is our EXACT
            // type of class, don't instantiate a new token; add ourselves 
            // instead so we can keep collecting wildcard data
            [nextTokens addObject:self];
        }
        else {
            [nextTokens addObject:[tokCls tokenWithGrammar:_grammar]];
        }
    }
    return nextTokens;
}

- (void) freeze
{
    debugTrace();
    
    if (_matchStatus != MBMLTokenMatchFrozen) {
        _possibleNextTokenClasses = nil;
        
        _matchStatus = MBMLTokenMatchFrozen;
        
        [_childTokens makeObjectsPerformSelector:@selector(freeze)];
    }
}

- (BOOL) isFrozen
{
    return _matchStatus == MBMLTokenMatchFrozen;
}

/******************************************************************************/
#pragma mark Token identifiers
/******************************************************************************/

- (void) setIdentifierStartAtPosition:(NSUInteger)pos
{
    _identifierStartAtChar = pos;
}

- (void) setIdentifierEndBeforePosition:(NSUInteger)pos
{
    _identifierEndBeforeChar = pos;
}

- (BOOL) isIdentifierStartPositionSet
{
    return _identifierStartAtChar >= 0;
}

- (BOOL) isIdentifierEndPositionSet
{
    return _identifierEndBeforeChar >= 0;
}

- (BOOL) hasIdentifier
{
    debugTrace();
    
    return (_identifierStartAtChar >= 0 && _identifierEndBeforeChar > _identifierStartAtChar);
}

- (NSString*) tokenIdentifier
{
    debugTrace();
    
    if ([self hasIdentifier]) {
        return [_accumulatedChars substringWithRange:NSMakeRange(_identifierStartAtChar, _identifierEndBeforeChar - _identifierStartAtChar)];
    }
    return nil;
}

/******************************************************************************/
#pragma mark Contained expressions
/******************************************************************************/

- (void) addChildToken:(MBMLParseToken*)child
{
    debugTrace();
    
    assert(_matchStatus != MBMLTokenMatchFrozen);
    
    if (!_childTokens) _childTokens = [NSMutableArray new];
        
    [_childTokens addObject:child];
}

- (void) addChildTokens:(NSArray*)children
{
    debugTrace();
    
    assert(_matchStatus != MBMLTokenMatchFrozen);
    
    if (!_childTokens) {
        _childTokens = [children mutableCopy];
    }
    else {
        [_childTokens addObjectsFromArray:children];
    }
}

- (void) addFirstChildToken:(MBMLParseToken*)child
{
    debugTrace();
    
    assert(_matchStatus != MBMLTokenMatchFrozen);
    
    if (!_childTokens) {
        _childTokens = [NSMutableArray arrayWithObject:child];
    }
    else {
        [_childTokens insertObject:child atIndex:0];
    }
}

- (void) addFirstChildTokens:(NSArray*)children
{
    debugTrace();
    
    assert(_matchStatus != MBMLTokenMatchFrozen);
    
    if (!_childTokens) {
        _childTokens = [children mutableCopy];
    }
    else {
        NSInteger childCnt = _childTokens.count;
        for (NSInteger i=childCnt-1; i>=0; i--) {
            [_childTokens insertObject:_childTokens[i] atIndex:0];
        }
    }
}

- (void) setContainedExpressionStartAtPosition:(NSUInteger)pos
{
    _containedExpressionStartAtChar = pos;
}

- (void) setContainedExpressionEndBeforePosition:(NSUInteger)pos
{
    _containedExpressionEndBeforeChar = pos;
}

- (BOOL) isContainedExpressionStartPositionSet
{
    return _containedExpressionStartAtChar >= 0;
}

- (BOOL) isContainedExpressionEndPositionSet
{
    return _containedExpressionEndBeforeChar >= 0;
}

- (BOOL) doesContainExpression
{
    return (_containedExpressionStartAtChar >= 0 && _containedExpressionEndBeforeChar > _containedExpressionStartAtChar);
}

- (NSString*) containedExpression
{
    debugTrace();
    
    if ([self doesContainExpression]) {
        return [_accumulatedChars substringWithRange:NSMakeRange(_containedExpressionStartAtChar, _containedExpressionEndBeforeChar - _containedExpressionStartAtChar)];
    }
    return nil;
}

- (NSArray*) tokenizeContainedExpressionInVariableSpace:(MBVariableSpace*)space
                                                  error:(inout MBExpressionError**)errPtr
{
    return [self tokenizeContainedExpressionInVariableSpace:space
                                               usingGrammar:_grammar
                                                      error:errPtr];
}

- (NSArray*) tokenizeContainedExpressionInVariableSpace:(MBVariableSpace*)space
                                           usingGrammar:(MBExpressionGrammar*)grammar
                                                  error:(inout MBExpressionError**)errPtr
{
    debugTrace();
    
    return [[MBExpressionTokenizer tokenizerWithGrammar:grammar] tokenize:[self containedExpression]
                                                          inVariableSpace:space
                                                                    error:errPtr];
}

- (NSArray*) childTokens
{
    if (_matchStatus == MBMLTokenMatchFrozen) {
        return _childTokens;
    }
    else {
        return [_childTokens copy];
    }
}

/******************************************************************************/
#pragma mark Accessing the accumulated input
/******************************************************************************/

- (NSString*) accumulatedString
{
    return _accumulatedChars;
}

- (NSUInteger) accumulatedLength
{
    return [_accumulatedChars length];
}

/******************************************************************************/
#pragma mark Token evaluation
/******************************************************************************/

- (id) evaluateInVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    debugTrace();
    
    // assume tokens are literals unless overriden
    return [self value];
}

- (BOOL) evaluateBooleanInVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    return [MBExpression booleanFromValue:[self evaluateInVariableSpace:space error:errPtr]];
}

/******************************************************************************/
#pragma mark Token & value representation
/******************************************************************************/

- (NSString*) expression
{
    if ([self isMatchCompleted]) {
        return [_accumulatedChars substringToIndex:_matchRange.length];
    }
    return nil;
}

- (NSString*) normalizedRepresentation
{
    debugTrace();
    
    return [self expression];
}

- (id) value
{
    return [self normalizedRepresentation];
}

@end
