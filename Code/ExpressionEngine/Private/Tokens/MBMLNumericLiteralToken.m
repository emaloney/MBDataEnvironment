//
//  MBMLNumericLiteralToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/20/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBMLNumericLiteralToken.h"
#import "MBExpressionError.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

#define kCoderKeyFrozenValue               @"frozenValue"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLNumericLiteralToken class
/******************************************************************************/

@implementation MBMLNumericLiteralToken
{
    BOOL _hasDecimalPoint;
    BOOL _gotDigit;
    NSDecimalNumber* _frozenValue;
}

/******************************************************************************/
#pragma mark Object serialization
/******************************************************************************/

- (instancetype) initWithCoder:(NSCoder*)coder
{
    MBLogDebugTrace();
    
    self = [super initWithCoder:coder];
    if (self) {
        _frozenValue = [coder decodeObjectForKey:kCoderKeyFrozenValue];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder*)coder
{
    MBLogDebugTrace();
    
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_frozenValue forKey:kCoderKeyFrozenValue];
}

/******************************************************************************/
#pragma mark Token implementation
/******************************************************************************/

- (MBMLTokenMatchStatus) matchWhenAddingCharacter:(unichar)ch toExpression:(NSString*)accumExpr
{
    MBLogDebugTrace();

    NSUInteger pos = [accumExpr length];
    switch (ch) {
        case '.':
            if (_hasDecimalPoint) {
                // can't have 2 decimal points!
                return MBMLTokenMatchImpossible;
            }
            _hasDecimalPoint = YES;
            break;
            
        case '-':
        case '+':
            if (pos != 0) {
                return MBMLTokenMatchImpossible;
            }
            break;
            
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
            _gotDigit = YES;
            break;
            
        default:
            return MBMLTokenMatchImpossible;
    }
    return (_gotDigit ? MBMLTokenMatchFull : MBMLTokenMatchPartial);
}

- (void) freeze
{
    MBLogDebugTrace();
    
    if (![self isFrozen]) {
        _frozenValue = [NSDecimalNumber decimalNumberWithString:[self expression]];
        
        [super freeze];
    }
}

- (id) value
{
    MBLogDebugTrace();
    
    if (_frozenValue) {
        return _frozenValue;
    } else {
        return [super value];
    }
}

@end
