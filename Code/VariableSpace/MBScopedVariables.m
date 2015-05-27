//
//  MBScopedVariables.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 10/6/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>

#import "MBScopedVariables.h"
#import "MBVariableSpace.h"

#define DEBUG_LOCAL         0
#define DEBUG_VERBOSE       0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

NSObject* const kFakeNilValue = @"kFakeNilValue";     // used as a stand-in value for nil in _namesToValues

/******************************************************************************/
#pragma mark -
#pragma mark MBScopedVariables implementation
/******************************************************************************/

@implementation MBScopedVariables
{
    NSMutableDictionary* _namesToValues;
    NSMutableSet* _pushedToVariableSpace;
}

/******************************************************************************/
#pragma mark Thread-local scoped variables
/******************************************************************************/

+ (nullable instancetype) currentVariableScope
{
    return [[MBThreadLocalStorage valueForClass:self] lastObject];
}

+ (nonnull instancetype) enterVariableScope
{
    debugTrace();

    NSMutableArray* scopeStack = [MBThreadLocalStorage cachedValueForClass:self
                                                         usingInstantiator:^{ return [NSMutableArray new]; }];

    MBScopedVariables* scope = [MBScopedVariables new];
    [scopeStack addObject:scope];
    return scope;
}

+ (nullable instancetype) exitVariableScope
{
    debugTrace();

    NSMutableArray* scopeStack = [MBThreadLocalStorage valueForClass:self];
    if (scopeStack && scopeStack.count) {
        MBScopedVariables* stack = [scopeStack lastObject];
        [scopeStack removeLastObject];
        [stack unsetScopedVariables];
        return stack;
    }
    return nil;
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (instancetype) initWithVariableSpace:(MBVariableSpace*)vars
{
    self = [super init];
    if (self) {
        _variableSpace = vars;
        _namesToValues = [NSMutableDictionary new];
        _pushedToVariableSpace = [NSMutableSet new];
    }
    return self;    
}

- (instancetype) init
{
    return [self initWithVariableSpace:[MBVariableSpace instance]];
}

- (id) copyWithZone:(NSZone*)zone
{
    MBScopedVariables* copy = [[self class] allocWithZone:zone];
    copy->_variableSpace = _variableSpace;
    copy->_namesToValues = [_namesToValues mutableCopy];
    copy->_pushedToVariableSpace = [NSMutableSet new];      // note: we don't copy this, since we want the new instance to be functionally independent
    return copy;
}

- (void) dealloc
{
    [self unsetScopedVariables];
}

/******************************************************************************/
#pragma mark Debugging
/******************************************************************************/

- (void) addDescriptionFieldsTo:(MBFieldListFormatter*)fmt
{
    [super addDescriptionFieldsTo:fmt];

    [fmt setField:@"values" container:_namesToValues];
    [fmt setField:@"variableSpace" instance:_variableSpace];
    [fmt setField:@"pushedToVariableSpace" container:_pushedToVariableSpace];
}

/******************************************************************************/
#pragma mark Getting & setting scoped variable values
/******************************************************************************/

- (nullable id) objectForKeyedSubscript:(nonnull NSString*)variableName
{
    if (variableName) {
        return _namesToValues[variableName];
    }
    return nil;
}

- (void) setObject:(nullable id)value forKeyedSubscript:(nonnull NSString*)variableName
{
    if (!variableName || ![variableName isKindOfClass:[NSString class]]) {
        [NSException raise:NSInvalidArgumentException
                    format:@"%@ requires keyed subscripts to be %@ instances", [self class], [NSString class]];
    }

    if ([_pushedToVariableSpace containsObject:variableName]) {
        [_variableSpace popVariable:variableName];
    } else {
        [_pushedToVariableSpace addObject:variableName];
    }
    _namesToValues[variableName] = (value ?: kFakeNilValue);
    [_variableSpace pushVariable:variableName value:value];
}

/******************************************************************************/
#pragma mark Unsetting & reapplying the variable scope
/******************************************************************************/

- (void) unsetScopedVariables
{
    debugTrace();

    for (NSString* varName in _pushedToVariableSpace) {
        [_variableSpace popVariable:varName];
    }
    [_pushedToVariableSpace removeAllObjects];
}

- (void) reapplyScopedVariables
{
    debugTrace();

    for (NSString* varName in _namesToValues) {
        if (![_pushedToVariableSpace containsObject:varName]) {
            id val = _namesToValues[varName];
            if (val == kFakeNilValue) {
                val = nil;
            }
            [_pushedToVariableSpace addObject:varName];
            [_variableSpace pushVariable:varName value:val];
        }
    }
}

@end
