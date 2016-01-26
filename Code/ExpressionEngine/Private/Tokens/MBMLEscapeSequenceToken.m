//
//  MBMLEscapeSequenceToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 12/2/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBMLEscapeSequenceToken.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

#define kCoderKeyFrozenValue               @"frozenValue"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLEscapeSequenceToken implementation
/******************************************************************************/

@implementation MBMLEscapeSequenceToken
{
    NSMutableDictionary* _sequencesToValues;
    NSString* _frozenValue;
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (instancetype) init
{
    self = [super init];
    if (self) {
        _sequencesToValues = [NSMutableDictionary new];

        [self setEscapeSequence:@"$$" value:@"$"];
        [self setEscapeSequence:@"##" value:@"#"];
        [self setEscapeSequence:@"^^" value:@"^"];
        [self setEscapeSequence:@"\\n" value:@"\n"];
        [self setEscapeSequence:@"\\t" value:@"\t"];
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
        _frozenValue = [coder decodeObjectForKey:kCoderKeyFrozenValue];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder*)coder
{
    MBLogDebugTrace();
    
    [super encodeWithCoder:coder];
    
    [coder encodeObject:[self unescapedValue] forKey:kCoderKeyFrozenValue];
}

/******************************************************************************/
#pragma mark Escape sequence mapping
/******************************************************************************/

- (void) setEscapeSequence:(NSString*)seq value:(NSString*)val
{
    MBLogDebugTrace();
    
    _sequencesToValues[seq] = val;
    
    [self addKeyword:seq];
}

/******************************************************************************/
#pragma mark Token implementation
/******************************************************************************/

- (NSString*) unescapedValue
{
    MBLogDebugTrace();
    
    if (_frozenValue) {
        return _frozenValue;
    }
    else {
        return _sequencesToValues[[self expression]];
    }
}

- (void) freeze
{
    MBLogDebugTrace();
    
    if (![self isFrozen]) {
        _frozenValue = [self unescapedValue];
        
        _sequencesToValues = nil;

        [super freeze];
    }
}

- (NSString*) normalizedRepresentation
{
    MBLogDebugTrace();
    
    return [self unescapedValue];
}

@end
