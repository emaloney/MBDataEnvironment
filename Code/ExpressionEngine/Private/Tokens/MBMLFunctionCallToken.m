//
//  MBMLFunctionCallToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/24/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLFunctionCallToken.h"
#import "MBMLParameterGroupingToken.h"
#import "MBMLFunction.h"
#import "MBExpression.h"
#import "MBExpressionTokenizer.h"
#import "MBExpressionGrammar.h"
#import "MBVariableSpace.h"
#import "MBExpression+Internal.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFunctionCallToken implementation
/******************************************************************************/

@implementation MBMLFunctionCallToken
{
    NSUInteger _innerParens;
    BOOL _gotFunctionMarker;
    BOOL _gotOpeningParen;
    BOOL _gotClosingParen;
}

/******************************************************************************/
#pragma mark Private methods
/******************************************************************************/

- (id) _resolveObjectFromTokens:(NSArray*)tokens
                inVariableSpace:(MBVariableSpace*)space
                   defaultValue:(id)defaultVal
                          error:(inout MBExpressionError**)errPtr
{
    MBExpressionError* err = nil;
    NSString* retVal = [MBExpression objectFromTokens:tokens
                                      inVariableSpace:space
                                         defaultValue:nil
                                                error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return nil;
    }
    if (!retVal) {
        return defaultVal;
    }
    return retVal;
}

- (id) _resolveNumberFromTokens:(NSArray*)tokens
                inVariableSpace:(MBVariableSpace*)space
                   defaultValue:(id)defaultVal
                          error:(inout MBExpressionError**)errPtr
{
    MBExpressionError* err = nil;
    NSString* retVal = [MBExpression objectFromTokens:tokens
                                      inVariableSpace:space
                                         defaultValue:nil
                                                error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return nil;
    }
    if (!retVal) {
        return defaultVal;
    }
    return retVal;
}

- (NSString*) _resolveStringFromTokens:(NSArray*)tokens
                       inVariableSpace:(MBVariableSpace*)space
                          defaultValue:(NSString*)defaultVal
                                 error:(inout MBExpressionError**)errPtr
{
    MBExpressionError* err = nil;
    NSString* retVal = [MBExpression stringFromTokens:tokens
                                      inVariableSpace:space
                                         defaultValue:nil
                                                error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return nil;
    }
    if (!retVal) {
        return defaultVal;
    }
    return retVal;
}

- (id) resolveParametersForFunction:(MBMLFunction*)func
                    inVariableSpace:(MBVariableSpace*)space
                              error:(inout MBExpressionError**)errPtr
{
    if (_childTokens.count < 1) {
        return nil;
    }
    
    switch (func.inputType) {
        case MBMLFunctionInputRaw:
            return [self containedExpression];
            
        case MBMLFunctionInputString:
            return [self _resolveStringFromTokens:self.functionParameters
                                  inVariableSpace:space
                                     defaultValue:kMBEmptyString
                                            error:errPtr];

        case MBMLFunctionInputMath:
            return [self _resolveObjectFromTokens:self.functionParameters
                                  inVariableSpace:space
                                     defaultValue:@0
                                            error:errPtr];

        case MBMLFunctionInputObject:
            return [self _resolveObjectFromTokens:self.functionParameters
                                  inVariableSpace:space
                                     defaultValue:[NSNull null]
                                            error:errPtr];

        case MBMLFunctionInputPipedObjects:
        {
            MBExpressionError* err = nil;
            NSMutableArray* retVal = [NSMutableArray new];
            for (MBMLParameterGroupingToken* group in self.functionParameters) {
                id val = [self _resolveObjectFromTokens:group.childTokens
                                        inVariableSpace:space
                                           defaultValue:[NSNull null]
                                                  error:&err];
                if (err) {
                    [err reportErrorTo:errPtr];
                    return nil;
                }
                [retVal addObject:val];
            }
            return retVal;
        }
            
        case MBMLFunctionInputPipedStrings:
        {
            MBExpressionError* err = nil;
            NSMutableArray* retVal = [NSMutableArray new];
            for (MBMLParameterGroupingToken* group in self.functionParameters) {
                id val = [self _resolveStringFromTokens:group.childTokens
                                        inVariableSpace:space
                                           defaultValue:kMBEmptyString
                                                  error:&err];
                if (err) {
                    [err reportErrorTo:errPtr];
                    return nil;
                }
                [retVal addObject:val];
            }
            return retVal;
        }
            
        case MBMLFunctionInputPipedMath:
        {
            MBExpressionError* err = nil;
            NSMutableArray* retVal = [NSMutableArray new];
            for (MBMLParameterGroupingToken* group in self.functionParameters) {
                id val = [self _resolveObjectFromTokens:group.childTokens
                                        inVariableSpace:space
                                           defaultValue:@0
                                                  error:&err];
                if (err) {
                    [err reportErrorTo:errPtr];
                    return nil;
                }
                [retVal addObject:val];
            }
            return retVal;
        }

        case MBMLFunctionInputPipedExpressions:
        {
            NSMutableArray* retVal = [NSMutableArray array];
            for (MBMLParameterGroupingToken* group in self.functionParameters) {
                [retVal addObject:[group normalizedRepresentation]];
            }
            return retVal;
        }

        case MBMLFunctionInputNone:
            return nil;
            
        default:
        {
            MBExpressionError* err = [MBExpressionError errorWithFormat:@"Unexpected input type (%d) for %@: %@", func.inputType, [MBMLFunction class], self];
            err.offendingExpression = [self expression];
            err.value = self;
            [err reportErrorTo:errPtr];
            return nil;
        }            
    }
}

/******************************************************************************/
#pragma mark Object subreferences
/******************************************************************************/

- (NSArray*) functionParameters
{
    NSMutableArray* params = [NSMutableArray arrayWithCapacity:_childTokens.count];
    for (MBMLParseToken* tok in _childTokens) {
        if ([tok isKindOfClass:[MBMLParameterGroupingToken class]]) {
            [params addObject:tok];
        }
    }
    return params;
}

/******************************************************************************/
#pragma mark Token API
/******************************************************************************/

- (NSString*) normalizedRepresentation
{
    debugTrace();
    
    NSString* normal = [self expression];
    NSString* subrefs = [self subreferenceExpression];
    if (subrefs) {
        return [normal stringByAppendingString:subrefs];
    } else {
        return normal;
    }
}

- (MBMLTokenMatchStatus) matchWhenAddingCharacter:(unichar)ch toExpression:(NSString*)accumExpr
{
    debugTrace();

    NSUInteger pos = [accumExpr length];
    if (pos == 0) {
        if (ch == '^') {
            [self setIdentifierStartAtPosition:pos+1];
            _gotFunctionMarker = YES;
            return MBMLTokenMatchPartial;
        }
    } else {
        if (pos == 1 && ch == '^') {
            // this indicates someone had ^^, which is the escape sequence
            // for ^...let a different parser handle that, OK?
            return MBMLTokenMatchImpossible;
        }
        else if (_gotFunctionMarker) {
            if (ch == '(') {
                if (!_gotOpeningParen) {
                    [self setIdentifierEndBeforePosition:pos];
                    [self setContainedExpressionStartAtPosition:pos+1];
                    _gotOpeningParen = YES;
                }
                else {
                    _innerParens++;
                }
                return MBMLTokenMatchPartial;
            }
            else if (ch == ')') {
                if (_gotOpeningParen && !_gotClosingParen) {
                    if (_innerParens == 0) {
                        [self setContainedExpressionEndBeforePosition:pos];
                        _gotClosingParen = YES;
                        return MBMLTokenMatchFull;
                    }
                    else {
                        _innerParens--;
                        return MBMLTokenMatchPartial;
                    }
                }
            }
            else if (_gotOpeningParen && !_gotClosingParen) {
                // match everything between the parentheses
                return MBMLTokenMatchPartial;
            }
            else if (!_gotOpeningParen && [[self class] isValidObjectReferenceCharacter:ch atPosition:pos - 1]) {
                // function names (after '^' but before '(') must be identifiers
                return MBMLTokenMatchPartial;
            }
        }
    }
    return MBMLTokenMatchImpossible;
}

- (NSArray*) tokenizeContainedExpressionInVariableSpace:(MBVariableSpace*)space
                                                  error:(inout MBExpressionError**)errPtr
{
    debugTrace();

    MBMLFunction* func = [space functionWithName:[self tokenIdentifier]];

    NSString* inputParamStr = [self containedExpression];
    if (func) {
        //
        // interpret the function expression input
        //
        MBExpressionError* err = nil;
        MBMLFunctionInputType inType = func.inputType;
        switch (inType) {
            case MBMLFunctionInputRaw:
                [self addFirstChildToken:[MBMLParameterGroupingToken parameterWithLiteralValue:inputParamStr]];
                break;
                
            case MBMLFunctionInputObject:
            case MBMLFunctionInputString:
            {
                NSArray* tokens = [[MBExpressionTokenizer tokenizerWithGrammar:[MBMLObjectExpressionGrammar instance]] tokenize:inputParamStr
                                                                                                                inVariableSpace:space
                                                                                                                          error:&err];
                if (err) {
                    [err reportErrorTo:errPtr];
                    return nil;
                }
                [self addFirstChildToken:[MBMLParameterGroupingToken parameterWithTokens:tokens]];
            }
                break;
                
            case MBMLFunctionInputPipedExpressions:
            case MBMLFunctionInputPipedObjects:
            case MBMLFunctionInputPipedStrings:
            {
                NSArray* tokens = [[MBExpressionTokenizer tokenizerWithGrammar:[MBMLParameterListGrammar instance]] tokenize:inputParamStr
                                                                                                             inVariableSpace:space
                                                                                                                       error:&err];
                if (err) {
                    [err reportErrorTo:errPtr];
                    return nil;
                }
                [self addFirstChildTokens:tokens];
            }
                break;
                
            case MBMLFunctionInputMath:
            {
                NSArray* tokens = [[MBExpressionTokenizer tokenizerWithGrammar:[MBMLMathExpressionGrammar instance]] tokenize:inputParamStr
                                                                                                              inVariableSpace:space
                                                                                                                        error:&err];
                if (err) {
                    [err reportErrorTo:errPtr];
                    return nil;
                }
                [self addFirstChildToken:[MBMLParameterGroupingToken parameterWithTokens:tokens]];
            }
                break;
                
                
            case MBMLFunctionInputPipedMath:
            {
                NSArray* tokens = [[MBExpressionTokenizer tokenizerWithGrammar:[MBMLMathParameterListGrammar instance]] tokenize:inputParamStr
                                                                                                                 inVariableSpace:space
                                                                                                                           error:&err];
                if (err) {
                    [err reportErrorTo:errPtr];
                    return nil;
                }
                [self addFirstChildTokens:tokens];
            }
                break;
                
            default:
                errorLog(@"Unexpected input type for MBML function: %@", func);
                break;
        }
    }

    return @[self];
}

- (id) valueInVariableSpace:(MBVariableSpace*)space valueContext:(id)ctxt error:(inout MBExpressionError**)errPtr
{
    debugTrace();

    MBMLFunction* func = [space functionWithName:[self tokenIdentifier]];
    if (!func) {
        [[MBEvaluationError errorWithFormat:@"Can't find %@ declaration for: ^%@()", [MBMLFunction class], [self tokenIdentifier]] reportErrorTo:errPtr];
        return nil;
    }

    //
    // interpret the transformation expression input
    //
    MBExpressionError* err = nil;
    id input = [self resolveParametersForFunction:func
                                  inVariableSpace:space
                                            error:&err];
    if (err) {
        err.offendingToken = self;
        [err reportErrorTo:errPtr];
        return nil;
    }

    id retVal = [func executeWithInput:input error:&err];
    if (err) {
        err.offendingToken = self;
        [err reportErrorTo:errPtr];
        return nil;
    }
    return retVal;
}

@end
