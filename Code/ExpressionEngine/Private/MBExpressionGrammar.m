//
//  MBExpressionGrammar.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/2/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>

#import "MBExpressionGrammar.h"
#import "MBMLAdditionOperatorToken.h"
#import "MBMLBooleanAndOperatorToken.h"
#import "MBMLBooleanGroupingToken.h"
#import "MBMLBooleanNegationToken.h"
#import "MBMLBooleanOrOperatorToken.h"
#import "MBMLDivisionOperatorToken.h"
#import "MBMLEqualityTestToken.h"
#import "MBMLEscapeSequenceToken.h"
#import "MBMLFunctionCallToken.h"
#import "MBMLGreaterThanEqualsTestToken.h"
#import "MBMLGreaterThanTestToken.h"
#import "MBMLIgnorableWhitespaceToken.h"
#import "MBMLInequalityTestToken.h"
#import "MBMLLessThanEqualsTestToken.h"
#import "MBMLLessThanTestToken.h"
#import "MBMLLiteralToken.h"
#import "MBMLMathExpressionToken.h"
#import "MBMLMathGroupingToken.h"
#import "MBMLMultiplicationOperatorToken.h"
#import "MBMLNumericLiteralToken.h"
#import "MBMLObjectReferenceToken.h"
#import "MBMLObjectSubreferenceToken.h"    
#import "MBMLParameterDelimiterToken.h"
#import "MBMLParameterGroupingToken.h"
#import "MBMLSubtractionOperatorToken.h"
#import "MBMLVariableReferenceToken.h"
#import "MBExpressionError.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionGrammar implementation
/******************************************************************************/

@implementation MBExpressionGrammar
{
@protected
    NSMutableArray* _initialStateTokenClasses;
    NSMutableDictionary* _tokenClassesToNextPossibleClasses;
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (instancetype) init
{
    self = [super init];
    if (self) {
        [[self class] setupStateForGrammar:self];
    }
    return self;
}

/******************************************************************************/
#pragma mark Public API
/******************************************************************************/

- (NSMutableArray*) tokenClassesForInitialState
{
    debugTrace();
    
    return [_initialStateTokenClasses mutableCopy];
}

- (NSMutableArray*) parseTokensForInitialState
{
    debugTrace();
    
    NSMutableArray* initialTokens = [NSMutableArray arrayWithCapacity:_initialStateTokenClasses.count];
    for (Class cls in _initialStateTokenClasses) {
        MBMLParseToken* tok = [cls tokenWithGrammar:self];
        [initialTokens addObject:tok];
    }
    return initialTokens;
}

- (NSMutableArray*) tokenClassesForNextStates:(MBMLParseToken*)token
{
    debugTrace();

    if (!token)
        return nil;
    
    Class tokenClass = [token class];
    
    //
    // because any thread can cause an expression to evaluate, any
    // thread can result in tokenization. we want to avoid a thread lock,
    // so we don't synchronize around the next states cache. instead,
    // we have a next states cache for each thread that causes at least
    // one expression to tokenize
    //
    NSMutableDictionary* nextStatesCache = [MBThreadLocalStorage cachedValueForClass:[self class]
                                                                 usingInstantiator:^(){ return [NSMutableDictionary dictionary]; }];
    
    
    NSArray* listOfNext = nextStatesCache[tokenClass];
    if (!listOfNext) {
        Class cls = tokenClass;
        Class parseTokenClass = [MBMLParseToken class];
        while (cls != nil && !listOfNext) {
            listOfNext = _tokenClassesToNextPossibleClasses[cls];
            if (!listOfNext) {
                if (cls == parseTokenClass) {
                    cls = nil;
                }
                cls = [cls superclass];
            }
        }
    }
    if (!listOfNext) {
        listOfNext = [self tokenClassesForInitialState];
    }
    nextStatesCache[(id<NSCopying>)tokenClass] = listOfNext;
    return [NSMutableArray arrayWithArray:listOfNext];
}

- (void) arrangeGrammarTree:(NSMutableArray*)tokens
            inVariableSpace:(MBVariableSpace*)space
                      error:(inout MBExpressionError**)errPtr
{
    debugTrace();
    
    //
    // now that we've collected all our tokens, expand any container tokens,
    // remove any ignorable whitespace, and assemble object subreferences
    //
    MBMLParseToken* operativeToken = nil;
    NSInteger tokCount = tokens.count;
    for (NSUInteger i=0; i<tokCount; i++) {
        MBMLParseToken* tok = tokens[i];
        if ([tok doesContainExpression]) {
            MBExpressionError* err = nil;
            NSArray* contained = [tok tokenizeContainedExpressionInVariableSpace:space error:&err];
            if (err) {
                [err reportErrorTo:errPtr];
                return;
            }
            
            // we should always have something if doesContainedExpression returned YES
            NSUInteger newTokenCnt = contained.count;
            assert(contained && newTokenCnt > 0);
            
            [tokens replaceObjectsInRange:NSMakeRange(i, 1) withObjectsFromArray:contained];
            tokCount = (tokCount - 1) + newTokenCnt;
            tok = tokens[i];
        }

        BOOL removeToken = NO;
        if ([tok isKindOfClass:[MBMLIgnorableWhitespaceToken class]]) {
            removeToken = YES;
        } 
        else if ([tok isKindOfClass:[MBMLObjectSubreferenceToken class]]) {
            [operativeToken addChildToken:tok];
            removeToken = YES;
        }
        else if ([tok isKindOfClass:[MBMLObjectReferenceToken class]]) {
            operativeToken = tok;
        }
        if (removeToken) {
            [tokens removeObjectAtIndex:i];
            i--;    // force re-evaluation of token at current index (because it was removed)
            tokCount--;
        }
    }
}

/******************************************************************************/
#pragma mark Expression optimization
/******************************************************************************/

- (BOOL) canOptimizeAsConstantExpression:(NSString*)expr
{
    return NO;      // subclasses must provide this functionality
}

/******************************************************************************/
#pragma mark Operator/operand convenience
/******************************************************************************/

- (BOOL) setLeftOperand:(MBMLParseToken<MBMLOperandToken>*)lVal
           rightOperand:(MBMLParseToken<MBMLOperandToken>*)rVal
     forBinaryOperation:(MBMLParseToken<MBMLBinaryOperatorToken>*)op
                  error:(inout MBExpressionError**)errPtr
{
    if (![lVal conformsToProtocol:@protocol(MBMLOperandToken)]) {
        MBExpressionError* err = [MBExpressionError errorWithFormat:@"Invalid left operand: \"%@\"", [lVal expression]];
        err.offendingToken = op;
        [err reportErrorTo:errPtr];
        return NO;
    }
    
    if (![rVal conformsToProtocol:@protocol(MBMLOperandToken)]) {
        MBExpressionError* err = [MBExpressionError errorWithFormat:@"Invalid right operand: \"%@\"", [rVal expression]];
        err.offendingToken = op;
        [err reportErrorTo:errPtr];
        return NO;
    }
    
    [op setLeftOperand:lVal rightOperand:rVal];
    
    return YES;
}

- (BOOL) setOperand:(MBMLParseToken<MBMLOperandToken>*)val
  forUnaryOperation:(MBMLParseToken<MBMLUnaryOperatorToken>*)op
              error:(inout MBExpressionError**)errPtr
{
    if (![val conformsToProtocol:@protocol(MBMLOperandToken)]) {
        MBExpressionError* err = [MBExpressionError errorWithFormat:@"Invalid operand: \"%@\"", [val expression]];
        err.offendingToken = op;
        [err reportErrorTo:errPtr];
        return NO;
    }
    
    [op setOperand:val];
    
    return YES;
}

/******************************************************************************/
#pragma mark Private API for subclasses
/******************************************************************************/

- (void) addTokenClassForInitialState:(Class)cls
{
    debugTrace();
    
    if (!_initialStateTokenClasses) {
        _initialStateTokenClasses = [NSMutableArray new];
    }
    [_initialStateTokenClasses addObject:cls];
}

- (void) addNextPossibleTokenClass:(Class)nextCls whenTransitioningFromClass:(Class)fromClass
{
    debugTrace();
    
    if (!_tokenClassesToNextPossibleClasses) {
        _tokenClassesToNextPossibleClasses = [NSMutableDictionary new];
    }
    NSMutableArray* nextList = _tokenClassesToNextPossibleClasses[fromClass];
    if (!nextList) {
        nextList = [NSMutableArray array];
        _tokenClassesToNextPossibleClasses[(id<NSCopying>)fromClass] = nextList;
    }
    [nextList addObject:nextCls];
}

- (void) addNextPossibleTokenClasses:(NSArray*)nextClasses whenTransitioningFromClass:(Class)fromClass
{
    for (Class nextClass in nextClasses) {
        [self addNextPossibleTokenClass:nextClass whenTransitioningFromClass:fromClass];
    }
}

/******************************************************************************/
#pragma mark Parser state setup
/******************************************************************************/

+ (void) setupStateForGrammar:(MBExpressionGrammar*)grammar
{
    MBErrorNotImplemented();
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLGrammar implementation
/******************************************************************************/

@implementation MBMLGrammar
{
    NSCharacterSet* _dynamicMarkerCharacters;
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (instancetype) init
{
    self = [super init];
    if (self) {
        _dynamicMarkerCharacters = [self dynamicMarkerCharacters];
    }
    return self;
}

/******************************************************************************/
#pragma mark Grammar setup
/******************************************************************************/

+ (void) setupStateForGrammar:(MBExpressionGrammar*)grammar
{
    debugTrace();
        
    [grammar addNextPossibleTokenClass:[MBMLObjectSubreferenceToken class] whenTransitioningFromClass:[MBMLObjectReferenceToken class]];
    [grammar addNextPossibleTokenClasses:grammar->_initialStateTokenClasses whenTransitioningFromClass:[MBMLObjectReferenceToken class]];
}

/******************************************************************************/
#pragma mark Expression optimization
/******************************************************************************/

- (BOOL) canOptimizeAsConstantExpression:(NSString*)expr
{
    BOOL isConstantExpr = NO;
    if (_dynamicMarkerCharacters) {
        isConstantExpr = ([expr rangeOfCharacterFromSet:_dynamicMarkerCharacters].location == NSNotFound);
    }
    return isConstantExpr;
}

- (NSCharacterSet*) dynamicMarkerCharacters
{
    return nil;
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLObjectExpressionGrammar implementation
/******************************************************************************/

@implementation MBMLObjectExpressionGrammar

MBImplementSingleton();

/******************************************************************************/
#pragma mark Expression optimization
/******************************************************************************/

- (NSCharacterSet*) dynamicMarkerCharacters
{
    return [NSCharacterSet characterSetWithCharactersInString:@"$^#\\"];
}

/******************************************************************************/
#pragma mark Grammar setup
/******************************************************************************/

+ (void) setupStateForGrammar:(MBExpressionGrammar*)grammar
{
    debugTrace();
    
    // note: the order of the tokens below is significant;
    // tokens that might match smaller strings should appear
    // after tokens that might match longer strings (i.e., "!="
    // needs to come before "!" to ensure proper tokenization)
    [grammar addTokenClassForInitialState:[MBMLVariableReferenceToken class]];
    [grammar addTokenClassForInitialState:[MBMLMathExpressionToken class]];
    [grammar addTokenClassForInitialState:[MBMLFunctionCallToken class]];
    [grammar addTokenClassForInitialState:[MBMLLiteralToken class]];
    [grammar addTokenClassForInitialState:[MBMLEscapeSequenceToken class]];
    
    [super setupStateForGrammar:grammar];
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLBooleanExpressionGrammar implementation
/******************************************************************************/

@implementation MBMLBooleanExpressionGrammar

MBImplementSingleton();

/******************************************************************************/
#pragma mark Expression optimization
/******************************************************************************/

- (NSCharacterSet*) dynamicMarkerCharacters
{
    return [NSCharacterSet characterSetWithCharactersInString:@"$^#-|&=<>!"];
}

/******************************************************************************/
#pragma mark Grammar setup
/******************************************************************************/

+ (void) setupStateForGrammar:(MBExpressionGrammar*)grammar
{
    // note: the order of the tokens below is significant;
    // tokens that might match smaller strings should appear
    // after tokens that might match longer strings (i.e., "!="
    // needs to come before "!" to ensure proper tokenization)
    [grammar addTokenClassForInitialState:[MBMLBooleanGroupingToken class]];
    [grammar addTokenClassForInitialState:[MBMLEqualityTestToken class]];
    [grammar addTokenClassForInitialState:[MBMLInequalityTestToken class]];
    [grammar addTokenClassForInitialState:[MBMLLessThanEqualsTestToken class]];
    [grammar addTokenClassForInitialState:[MBMLLessThanTestToken class]];
    [grammar addTokenClassForInitialState:[MBMLGreaterThanEqualsTestToken class]];
    [grammar addTokenClassForInitialState:[MBMLGreaterThanTestToken class]];
    [grammar addTokenClassForInitialState:[MBMLBooleanAndOperatorToken class]];
    [grammar addTokenClassForInitialState:[MBMLBooleanOrOperatorToken class]];
    [grammar addTokenClassForInitialState:[MBMLBooleanNegationToken class]];
    [grammar addTokenClassForInitialState:[MBMLVariableReferenceToken class]];
    [grammar addTokenClassForInitialState:[MBMLMathExpressionToken class]];
    [grammar addTokenClassForInitialState:[MBMLFunctionCallToken class]];
    [grammar addTokenClassForInitialState:[MBMLIgnorableWhitespaceToken class]];
    [grammar addTokenClassForInitialState:[MBMLLiteralToken class]];
    
    [super setupStateForGrammar:grammar];
}

/******************************************************************************/
#pragma mark Arranging token grammar
/******************************************************************************/

- (void) arrangeGrammarTree:(NSMutableArray*)tokens
            inVariableSpace:(MBVariableSpace*)space
                      error:(inout MBExpressionError**)errPtr
{
    debugTrace();
    
    MBExpressionError* err = nil;
    [super arrangeGrammarTree:tokens inVariableSpace:space error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return;
    }
    
    //
    // attach operands to unary boolean operators
    //
    MBMLParseToken* tok = nil;
    NSUInteger tokCount = tokens.count;
    for (NSUInteger i=0; i<tokCount; i++) {
        tok = tokens[i];
        if ([tok conformsToProtocol:@protocol(MBMLBooleanOperatorUnary)]) {
            if (i<tokCount-1) {
                if ([self setOperand:tokens[i+1] forUnaryOperation:(MBMLParseToken<MBMLUnaryOperatorToken>*)tok error:errPtr]) {
                    [tokens removeObjectAtIndex:i+1];
                    tokCount--;
                }
                else {
                    return;
                }
            }
            else {
                err = [MBExpressionError errorWithMessage:@"Missing right operand"];
                err.offendingToken = tok;
                [err reportErrorTo:errPtr];
                return;
            }
        }
    }
    
    //
    // attach operands to boolean comparators (comparators need to be
    // attached before other binary operators such as 'AND', etc.)
    //
    for (NSUInteger i=1; i<tokCount-1; i++) {
        tok = tokens[i];
        if ([tok conformsToProtocol:@protocol(MBMLBooleanComparator)]) {
            if ([self setLeftOperand:tokens[i-1] rightOperand:tokens[i+1] forBinaryOperation:(MBMLParseToken<MBMLBinaryOperatorToken>*)tok error:errPtr]) {
                [tokens removeObjectAtIndex:i+1];
                [tokens removeObjectAtIndex:i-1];
                i--;    // force re-evaluation of token at current index (because it was removed)
                tokCount -= 2;
            }
            else {
                return;
            }
        }
    }
    
    //
    // attach operands to any remaining binary boolean operators
    //
    for (NSUInteger i=1; i<tokCount-1; i++) {
        tok = tokens[i];
        if ([tok conformsToProtocol:@protocol(MBMLBooleanOperatorBinary)] && ![tok conformsToProtocol:@protocol(MBMLBooleanComparator)]) {
            if ([self setLeftOperand:tokens[i-1] rightOperand:tokens[i+1] forBinaryOperation:(MBMLParseToken<MBMLBinaryOperatorToken>*)tok error:errPtr]) {
                [tokens removeObjectAtIndex:i+1];
                [tokens removeObjectAtIndex:i-1];
                i--;    // force re-evaluation of token at current index (because it was removed)
                tokCount -= 2;
            }
            else {
                return;
            }
        }
    }
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathExpressionGrammar implementation
/******************************************************************************/

@implementation MBMLMathExpressionGrammar

MBImplementSingleton();

/******************************************************************************/
#pragma mark Expression optimization
/******************************************************************************/

- (NSCharacterSet*) dynamicMarkerCharacters
{
    return [NSCharacterSet characterSetWithCharactersInString:@"#$^-+*/ \\"];
}

/******************************************************************************/
#pragma mark Grammar setup
/******************************************************************************/

+ (void) setupStateForGrammar:(MBExpressionGrammar*)grammar
{
    // note: the order of the tokens below is significant;
    // tokens that might match smaller strings should appear
    // after tokens that might match longer strings (i.e., "!="
    // needs to come before "!" to ensure proper tokenization)
    [grammar addTokenClassForInitialState:[MBMLVariableReferenceToken class]];
    [grammar addTokenClassForInitialState:[MBMLFunctionCallToken class]];
    [grammar addTokenClassForInitialState:[MBMLIgnorableWhitespaceToken class]];
    [grammar addTokenClassForInitialState:[MBMLNumericLiteralToken class]];
    [grammar addTokenClassForInitialState:[MBMLAdditionOperatorToken class]];
    [grammar addTokenClassForInitialState:[MBMLSubtractionOperatorToken class]];
    [grammar addTokenClassForInitialState:[MBMLMultiplicationOperatorToken class]];
    [grammar addTokenClassForInitialState:[MBMLDivisionOperatorToken class]];
    [grammar addTokenClassForInitialState:[MBMLLiteralToken class]];
    [grammar addTokenClassForInitialState:[MBMLMathGroupingToken class]];
    [grammar addTokenClassForInitialState:[MBMLMathExpressionToken class]];

    [super setupStateForGrammar:grammar];
}

/******************************************************************************/
#pragma mark Arranging token grammar
/******************************************************************************/

- (void) arrangeGrammarTree:(NSMutableArray*)tokens
            inVariableSpace:(MBVariableSpace*)space
                      error:(inout MBExpressionError**)errPtr
{
    debugTrace();
    
    MBExpressionError* err = nil;
    [super arrangeGrammarTree:tokens inVariableSpace:space error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return;
    }

    //
    // make sure everything we've got is valid for math
    //
    for (MBMLParseToken* tok in tokens) {
        if (![tok conformsToProtocol:@protocol(MBMLMathToken)]
            && ![tok isKindOfClass:[MBMLObjectReferenceToken class]]
            && ![tok isKindOfClass:[MBMLMathExpressionToken class]]
            && ![tok isKindOfClass:[MBMLLiteralToken class]])
        {
            err = [MBExpressionError errorWithMessage:@"Expecting mathematical expression"];
            err.offendingToken = tok;
            [err reportErrorTo:errPtr];
            return;
        }
    }
    
    //
    // we will use the C language operator precedence. for the
    // first pass, handle multiplication & division; for the
    // second pass, addition & subtraction
    //
    MBMLMathOperatorToken* tok = nil;
    for (NSUInteger pass=1; pass<=2; pass++) {
        NSUInteger tokCount = tokens.count;
        for (NSUInteger i=1; i<tokCount-1; i++) {
            tok = tokens[i];
            if ([tok isKindOfClass:[MBMLMathExpressionToken class]]) {
                NSArray* childTokens = tok.childTokens;
                [tokens replaceObjectsInRange:NSMakeRange(i, 1) withObjectsFromArray:childTokens];
                tokCount = tokens.count;
            }
            else if ([tok isKindOfClass:[MBMLMathOperatorToken class]]) {
                if ([tok precedence] == pass) {
                    if ([self setLeftOperand:tokens[i-1] rightOperand:tokens[i+1] forBinaryOperation:tok error:errPtr]) {
                        [tokens removeObjectAtIndex:i+1];
                        [tokens removeObjectAtIndex:i-1];
                        i--;    // force re-evaluation of token at current index (because it was removed)
                        tokCount -= 2;
                    }
                    else {
                        return;
                    }
                }
            }
        }
    }
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLParameterListGrammar class
/******************************************************************************/

@implementation MBMLParameterListGrammar

MBImplementSingleton();

/******************************************************************************/
#pragma mark Grammar setup
/******************************************************************************/

+ (void) setupStateForGrammar:(MBExpressionGrammar*)grammar
{
    debugTrace();
    
    [grammar addTokenClassForInitialState:[MBMLParameterDelimiterToken class]];
    
    [MBMLObjectExpressionGrammar setupStateForGrammar:grammar];
}

/******************************************************************************/
#pragma mark Arranging token grammar
/******************************************************************************/

- (void) arrangeGrammarTree:(NSMutableArray*)tokens
            inVariableSpace:(MBVariableSpace*)space
                      error:(inout MBExpressionError**)errPtr
{
    debugTrace();
    
    NSMutableArray* paramGroups = nil;
    NSMutableArray* curParamGroup = nil;
    for (MBMLParseToken* tok in tokens) {
        if (!curParamGroup) {
            curParamGroup = [NSMutableArray new];
        }
        if ([tok isKindOfClass:[MBMLParameterDelimiterToken class]]) {
            if (!paramGroups) {
                paramGroups = [NSMutableArray new];
            }
            [paramGroups addObject:curParamGroup];
            curParamGroup = [NSMutableArray new];
        }
        else {
            [curParamGroup addObject:tok];
        }
    }
    if (curParamGroup) {
        if (!paramGroups) {
            paramGroups = [NSMutableArray new];
        }
        [paramGroups addObject:curParamGroup];
        curParamGroup = nil;
    }
    
    MBExpressionError* err = nil;
    [tokens removeAllObjects];
    for (NSMutableArray* paramGroup in paramGroups) {
        [self arrangeParameterGroup:paramGroup inVariableSpace:space error:&err];
        if (err) {
            [err reportErrorTo:errPtr];
            return;
        }
        [tokens addObject:[MBMLParameterGroupingToken parameterWithTokens:paramGroup]];
    }
}

- (void) arrangeParameterGroup:(NSMutableArray*)tokens
               inVariableSpace:(MBVariableSpace*)space
                         error:(inout MBExpressionError**)errPtr
{
    [[MBMLObjectExpressionGrammar instance] arrangeGrammarTree:tokens inVariableSpace:space error:errPtr];
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathParameterListGrammar implementation
/******************************************************************************/

@implementation MBMLMathParameterListGrammar

MBImplementSingleton();

/******************************************************************************/
#pragma mark Grammar setup
/******************************************************************************/

+ (void) setupStateForGrammar:(MBExpressionGrammar*)grammar
{
    [grammar addTokenClassForInitialState:[MBMLParameterDelimiterToken class]];
    
    [MBMLMathExpressionGrammar setupStateForGrammar:grammar];
}

- (void) arrangeParameterGroup:(NSMutableArray*)tokens
               inVariableSpace:(MBVariableSpace*)space
                         error:(inout MBExpressionError**)errPtr
{
    [[MBMLMathExpressionGrammar instance] arrangeGrammarTree:tokens inVariableSpace:space error:errPtr];
}

@end
