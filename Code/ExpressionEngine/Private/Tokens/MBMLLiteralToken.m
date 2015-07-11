//
//  MBMLLiteralToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/19/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBModuleLogMacros.h>

#import "MBMLLiteralToken.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

static NSString* const kCoderKeyLiteralValue        = @"literalValue";
static NSString* const kCoderKeyLiteralValueIsSet   = @"valueIsSet";

/******************************************************************************/
#pragma mark -
#pragma mark MBMLLiteralToken implementation
/******************************************************************************/

@implementation MBMLLiteralToken
{
    id _value;
    BOOL _containsValue;
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

+ (instancetype) literalTokenWithValue:(id)value
{
    return [[self alloc] initWithValue:value];
}

- (instancetype) initWithValue:(id)value
{
    self = [super init];
    if (self) {
        _value = value;
        _containsValue = YES;
        
        [self freeze];
    }
    return self;
}

/******************************************************************************/
#pragma mark Object serialization
/******************************************************************************/

- (instancetype) initWithCoder:(NSCoder*)coder
{
    MBLogDebugTrace();
    
    self = [super initWithCoder:coder];
    if (self) {
        _value = [coder decodeObjectForKey:kCoderKeyLiteralValue];
        _containsValue = [coder decodeBoolForKey:kCoderKeyLiteralValueIsSet];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder*)coder
{
    MBLogDebugTrace();
    
    [super encodeWithCoder:coder];
    
    [coder encodeObject:_value                      forKey:kCoderKeyLiteralValue];
    [coder encodeBool:_containsValue                forKey:kCoderKeyLiteralValueIsSet];
}

/******************************************************************************/
#pragma mark Token implementation
/******************************************************************************/

- (MBMLTokenMatchStatus) matchWhenAddingCharacter:(unichar)ch toExpression:(NSString*)accumExpr
{
    MBLogDebugTrace();
    
    // we accept characters of all kinds
    return MBMLTokenMatchWildcard;
}

- (NSString*) expression
{
    if (_containsValue) {
        return (_value ? _value : @"");
    }
    else {
        return [super expression];
    }
}

- (id) value
{
    MBLogDebugTrace();
    
    if (_containsValue) {
        return (_value ? _value : [NSNull null]);
    } else {
        return [super value];
    }
}

- (BOOL) isMatchCompleted
{
    if (_containsValue) {
        return YES;
    } else {
        return [super isMatchCompleted];
    }
}

/******************************************************************************/
#pragma mark Debugging output
/******************************************************************************/

- (NSString*) tokenDescription
{
    if (_containsValue) {
        NSMutableString* desc = [NSMutableString stringWithFormat:@"<%@@%p: contains ", [self class], self];
        if (_value) {
            [desc appendFormat:@"%@@%p: \"%@\"", [_value class], (void *) _value, [_value description]];
        } else {
            [desc appendString:@"nil"];
        }
        [desc appendString:@">"];
        return desc;
    } 
    else {
        return [super tokenDescription];
    }
}

@end
