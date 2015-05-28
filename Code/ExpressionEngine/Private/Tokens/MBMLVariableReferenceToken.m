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
#import "MBExpressionGrammar.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLVariableReferenceToken implementation
/******************************************************************************/

@implementation MBMLVariableReferenceToken
{
    BOOL _gotVariableMarker;
    BOOL _isQuotedReference;
    unichar _openQuoteChar;
    unichar _closeQuoteChar;
    NSUInteger _unclosedOpenQuoteCount;
    BOOL _gotCloseQuoteChar;
}

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
    return [NSString stringWithFormat:@"$%@", [super containedExpression]];
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
    
    for (MBMLParseToken* tok in tokens) {
        if (![tok isKindOfClass:[MBMLObjectReferenceToken class]]) {
            err = [MBParseError errorWithFormat:@"not expecting a %@ here", [tok class]];
            err.offendingToken = tok;
            [err reportErrorTo:errPtr];
            return nil;
        }
    }
    return tokens;
}

@end
