//
//  MBMLVariableReferenceToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/22/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBModuleLogMacros.h>

#import "MBMLVariableReferenceToken.h"
#import "MBMLObjectSubreferenceToken.h"
#import "MBExpressionError.h"
#import "MBDataEnvironmentConstants.h"
#import "MBExpressionGrammar.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

static NSString* const kCoderKeyIsQuotedReference   = @"isQuoted";
static NSString* const kCoderKeyOpenQuoteChar       = @"openQuoteChar";
static NSString* const kCoderKeyCloseQuoteChar      = @"closeQuoteChar";

/******************************************************************************/
#pragma mark -
#pragma mark MBMLVariableReferenceToken implementation
/******************************************************************************/

@implementation MBMLVariableReferenceToken
{
    // state used during tokenization
    BOOL _gotVariableMarker;
    NSUInteger _unclosedOpenQuoteCount;
    BOOL _gotCloseQuoteChar;

    // serializable token state
    BOOL _isQuotedReference;
    unichar _openQuoteChar;
    unichar _closeQuoteChar;
}

/******************************************************************************/
#pragma mark Object serialization
/******************************************************************************/

- (instancetype) initWithCoder:(NSCoder*)coder
{
    MBLogDebugTrace();

    self = [super initWithCoder:coder];
    if (self) {
        _isQuotedReference = [coder decodeBoolForKey:kCoderKeyIsQuotedReference];
        _openQuoteChar = (unichar)[coder decodeInt32ForKey:kCoderKeyOpenQuoteChar];
        _closeQuoteChar = (unichar)[coder decodeInt32ForKey:kCoderKeyCloseQuoteChar];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder*)coder
{
    MBLogDebugTrace();

    [super encodeWithCoder:coder];

    [coder encodeBool:_isQuotedReference forKey:kCoderKeyIsQuotedReference];
    [coder encodeInt32:(int32_t)_openQuoteChar forKey:kCoderKeyOpenQuoteChar];
    [coder encodeInt32:(int32_t)_closeQuoteChar forKey:kCoderKeyCloseQuoteChar];
}

/******************************************************************************/
#pragma mark Token implementation
/******************************************************************************/

- (MBMLTokenMatchStatus) matchWhenAddingCharacter:(unichar)ch toExpression:(NSString*)accumExpr
{
    MBLogDebugTrace();

    NSUInteger pos = [accumExpr length];
    if (pos == 0) {
        if (ch == '$') {
            _gotVariableMarker = YES;
            [self setIdentifierStartAtPosition:pos+1];
            return MBMLTokenMatchPartial;
        }
    }
    else if (pos == 1) {
        /*
         A variable name refers to the key by which a top-level variable
         is known to the application environment. A simple variable reference
         refers to a top-level variable by name, eg: $variableName refers to
         a variable named 'variableName'.
         
         A complex variable reference starts with a variable name, but it
         includes subreferences that refer to objects contained within the
         top-level variable. Subreferences will use either a dot notation or
         a bracket notation, so a complex variable reference will look like:
         
            $variableName[$indexInArray]
            $variableName.objectProperty
            $variableName.keyInDictionary
            $variableName[key that includes spaces]
         
         Multiple object subreferences can be appended together, allowing 
         traversal of arbitrary object graphs.
         
         A complex variable reference be in one of several forms:
         
            - unquoted, meaning that the variable name comes directly after the
              dollar sign, eg. $variableName. The tokenizer will attempt to 
              interpret subreferences after the variable name.
         
            - curly-brace quoted, in which a simple or complex variable 
              reference is wrapped in curly quotes, eg. ${variableName.property}
              The closing curly brace indicates a tokenization boundary after
              which characters will not be interpreted as part of the variable
              reference, allowing things such as:
         
                    For the ${familySurname}s, we have a nice assortment of...
         
            - bracket quoted, in which a simple variable reference containing
              spaces (or other characters that wouldn't normally be tokenized
              as part of a variable name) is wrapped in brackets, allowing
              references to top-level variables whose names prevent them from
              being referenced via the unquoted method. For example:
         
                    $[variable name with spaces]
                    $[total $]
                    $[com.gilt.ipad]
         
            - parentheses quoted, which allows quoting in the same way as the
              bracket-quote notation, but like the curly brace, the closing
              parenthesis character is a tokenization boundary. 
         
         Note that these two notations differ:
         
                    $[variable name].objectProperty
                    $(variable name).objectProperty
         
              The tokenizer will interpret the bracket form as "a reference to
              a value called 'objectProperty' on the variable 'variable name',
              but the paretheses form tokenizes as "a reference to a variable
              named 'variable name' followed by the literal '.objectProperty'"
         */
        if (ch == '$') {
            // this indicates someone had $$, which is the escape sequence
            // for $...let a different parser handle that, capiche?
            return MBMLTokenMatchImpossible;
        }
        else if (ch == '{') {
            _isQuotedReference = YES;
            _openQuoteChar = '{';
            _closeQuoteChar = '}';
        }
        else if (ch == '(') {
            _isQuotedReference = YES;
            _openQuoteChar = '(';
            _closeQuoteChar = ')';
        }
        else if (ch == '[') {
            _isQuotedReference = YES;
            _openQuoteChar = '[';
            _closeQuoteChar = ']';
        }
        else { 
            if ([[self class] isValidObjectReferenceCharacter:ch atPosition:pos - 1]) {
                [self setIdentifierStartAtPosition:pos];
            }
            else {
                // if we didn't see an open quote marker, then
                // we should have a valid object reference character;
                // otherwise, we don't have a match
                return MBMLTokenMatchImpossible;
            }
        }
        return MBMLTokenMatchPartial;
    }
    else if (_gotVariableMarker && (!_isQuotedReference || !_gotCloseQuoteChar)) {
        if (ch == _openQuoteChar) {
            _unclosedOpenQuoteCount++;
            return MBMLTokenMatchPartial;
        }
        else {
            if (_isQuotedReference) {
                if (pos == 2) {
                    switch (_openQuoteChar) {
                        case '{':
                            [self setContainedExpressionStartAtPosition:pos];
                            break;
                            
                        case '(':
                            [self setIdentifierStartAtPosition:pos];
                            break;
                            
                        case '[':
                            [self setIdentifierStartAtPosition:pos];
                            break;
                    }
                }
                if (!_gotCloseQuoteChar) {
                    if (ch == _closeQuoteChar) {
                        if (_unclosedOpenQuoteCount == 0) {
                            switch (_openQuoteChar) {
                                case '{':
                                    [self setContainedExpressionEndBeforePosition:pos];
                                    [self removePossibleNextTokenClass:[MBMLObjectSubreferenceToken class]];
                                    break;
                                
                                case '(':
                                    [self setIdentifierEndBeforePosition:pos];
                                    [self removePossibleNextTokenClass:[MBMLObjectSubreferenceToken class]];
                                    break;
                                    
                                case '[':
                                    [self setIdentifierEndBeforePosition:pos];
                                    break;
                            }
                            _gotCloseQuoteChar = YES;
                            return MBMLTokenMatchFull;
                        }
                        else {
                            _unclosedOpenQuoteCount--;
                        }
                    }
                    return MBMLTokenMatchPartial;
                }
            }
            else if ([[self class] isValidObjectReferenceCharacter:ch atPosition:pos - 1]) {
                [self setIdentifierEndBeforePosition:pos+1];
                return MBMLTokenMatchFull;
            }
        }
    }
    return MBMLTokenMatchImpossible;
}

- (NSString*) containedExpression
{
    NSString* contained = [super containedExpression];
    if (contained) {
        return [NSString stringWithFormat:@"$%@", [super containedExpression]];
    }
    return nil;
}

- (NSString*) normalizedRepresentation
{
    if (_isQuotedReference) {
        switch (_openQuoteChar) {
            case '{':
            {
                NSString* contained = [super containedExpression];
                if (!contained) {
                    NSMutableString* normal = [[self tokenIdentifier] mutableCopy];
                    for (MBMLParseToken* tok in self.childTokens) {
                        NSString* childRep = [tok expression];
                        if (childRep) {
                            if (!normal) {
                                normal = [NSMutableString string];
                            }
                            [normal appendString:childRep];
                        }
                    }
                    contained = [normal copy];
                }
                return [NSString stringWithFormat:@"$%c%@%c", _openQuoteChar, (contained ?: kMBEmptyString), _closeQuoteChar];
            }

            case '(':
                return [NSString stringWithFormat:@"$%c%@%c", _openQuoteChar, [self tokenIdentifier], _closeQuoteChar];

            case '[':
                return [NSString stringWithFormat:@"$%c%@%c", _openQuoteChar, [self tokenIdentifier], _closeQuoteChar];

            default: break;
        }
    }
    return [super normalizedRepresentation];
}

+ (NSString*) expressionForReferencingVariableNamed:(NSString*)varName
{
    for (NSUInteger i=0; i<varName.length; i++) {
        unichar ch = [varName characterAtIndex:i];
        if (![self isValidObjectReferenceCharacter:ch atPosition:i]) {
            return [NSString stringWithFormat:@"$[%@]", varName];
        }
    }
    return [NSString stringWithFormat:@"$%@", varName];
}

- (NSArray*) tokenizeContainedExpressionInVariableSpace:(MBVariableSpace*)space
                                                  error:(inout MBExpressionError**)errPtr
{
    MBLogDebugTrace();

    // only the curly brace notation results in a contained expression
    // that gets tokenized. the curly brace notation only allows
    // object references & subreferences; if we got something else,
    // we have an invalid expression and need to report it
    MBExpressionError* err = nil;
    NSArray* tokens = [super tokenizeContainedExpressionInVariableSpace:space
                                                           usingGrammar:[MBMLObjectExpressionGrammar instance]
                                                                  error:&err];
    if (err) {
        err.offendingToken = self;
        [err reportErrorTo:errPtr];
        return nil;
    }
    
    if (tokens.count != 1 || ![tokens[0] isKindOfClass:[MBMLVariableReferenceToken class]]) {
        err = [MBParseError errorWithFormat:@"expecting exactly one %@ here", [self class]];
        if (tokens.count > 1) {
            err.offendingToken = tokens[1];
        }
        [err reportErrorTo:errPtr];
        return nil;
    }

    MBMLVariableReferenceToken* tok = tokens[0];
    tok->_openQuoteChar = _openQuoteChar;
    tok->_closeQuoteChar = _closeQuoteChar;
    tok->_isQuotedReference = _isQuotedReference;

    return tokens;
}

@end
