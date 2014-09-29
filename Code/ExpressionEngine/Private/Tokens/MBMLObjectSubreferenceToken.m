//
//  MBMLObjectSubreferenceToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/24/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLObjectSubreferenceToken.h"
#import "MBExpressionError.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

#define kCoderKeyMarkerCharacter               @"subreferenceMarker"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLObjectSubreferenceToken implementation
/******************************************************************************/

@implementation MBMLObjectSubreferenceToken
{
    unichar _subreferenceMarker;
    NSInteger _unclosedLeftBrackets;
    BOOL _matchedLastBracket;
}

/******************************************************************************/
#pragma mark Object serialization
/******************************************************************************/

- (void) encodeWithCoder:(NSCoder*)coder
{
    debugTrace();
    
    [super encodeWithCoder:coder];

    NSString* markerStr = [NSString stringWithFormat:@"%C", _subreferenceMarker];
    [coder encodeObject:markerStr forKey:kCoderKeyMarkerCharacter];
}

- (id) initWithCoder:(NSCoder*)coder
{
    debugTrace();
    
    self = [super initWithCoder:coder];
    if (self) {
        NSString* markerChar = [coder decodeObjectForKey:kCoderKeyMarkerCharacter];
        _subreferenceMarker = [markerChar characterAtIndex:0];
    }
    return self;
}

/******************************************************************************/
#pragma mark Token implementation
/******************************************************************************/

- (MBMLTokenMatchStatus) matchWhenAddingCharacter:(unichar)ch toExpression:(NSString*)accumExpr
{
    debugTrace();
    
    NSUInteger pos = [accumExpr length];
    if (pos == 0) {
        _unclosedLeftBrackets = 0;
        _matchedLastBracket = NO;
        if (ch == '.' || ch == '[') {
            _subreferenceMarker = ch;
            if (ch == '.') {
                [self setIdentifierStartAtPosition:pos+1];
            } else {
                _unclosedLeftBrackets++;
                [self setContainedExpressionStartAtPosition:pos+1];
            }
            return MBMLTokenMatchPartial;
        }
    } else {
        if (_subreferenceMarker) {
            //
            // we handle variable subreferences differently based on whether
            // they are "$var.subreference" or "$var[subreference]". the bracket
            // notation allows any characters within the subreference, whereas the 
            // dot notation allows identifier characters only
            //
            if (_subreferenceMarker == '.') {
                if ([[self class] isValidObjectReferenceCharacter:ch atPosition:pos - 1]) {
                    [self setIdentifierEndBeforePosition:pos+1];
                    return MBMLTokenMatchFull;
                }
            }
            else if (_subreferenceMarker == '[') {
                if (!_matchedLastBracket) {
                    if (ch == '[') {
                        _unclosedLeftBrackets++;
                    }
                    else if (ch == ']') {
                        _unclosedLeftBrackets--;
                        if (_unclosedLeftBrackets == 0) {
                            [self setContainedExpressionEndBeforePosition:pos];
                            _matchedLastBracket = YES;
                            return MBMLTokenMatchFull;
                        }
                    }
                    return MBMLTokenMatchPartial;
                }
            }
        }
    }
    return MBMLTokenMatchImpossible;
}

- (NSArray*) tokenizeContainedExpressionInVariableSpace:(MBVariableSpace*)space
                                                  error:(MBExpressionError**)errPtr
{
    MBExpressionError* err = nil;
    NSArray* containedTokens = [super tokenizeContainedExpressionInVariableSpace:space
                                                                           error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
    }
    [self addFirstChildTokens:containedTokens];
    return @[self];
}

@end
