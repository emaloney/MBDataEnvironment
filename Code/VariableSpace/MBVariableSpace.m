//
//  MBVariableSpace.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 8/30/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <RaptureXML@Gilt/RXMLElement.h>
#import <MBToolbox/MBToolbox.h>

#import "MBVariableSpace.h"
#import "MBEnvironment.h"
#import "MBVariableDeclaration.h"
#import "MBExpression.h"
#import "MBMLFunction.h"
#import "MBExpressionCache.h"
#import "MBDataEnvironmentModule.h"

#define DEBUG_LOCAL         0
#define DEBUG_VERBOSE       0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

// public
NSString* const kMBVariableSpaceDidDeclareFunctionEvent     = @"MBVariableSpaceDidDeclareFunctionEvent";

// private
NSString* const kMBVariableSpaceXMLTagVar                   = @"Var";
NSString* const kMBVariableSpaceXMLTagFunction              = @"Function";

/******************************************************************************/
#pragma mark -
#pragma mark MBVariableSpace implementation
/******************************************************************************/

@implementation MBVariableSpace
{
    NSMutableDictionary* _variables;
    NSMutableDictionary* _variableStack;        // map of variable names -> arrays of values for pushed variables
    NSMutableDictionary* _mbmlFunctions;        // map of MBML function names -> MBMLFunction instances
    NSMutableArray* _variableDeclarations;      // an array of the MBVariableDeclaration instances that were used to declare the initial variables
    NSMutableDictionary* _namesToDeclarations;  // a map of declared variable names to MBVariableDeclaration instances
}

/******************************************************************************/
#pragma mark Instance vendor
/******************************************************************************/

+ (instancetype) instance
{
    return (MBVariableSpace*)[[MBEnvironment instance] environmentLoaderOfClass:self];
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (id) init
{
    self = [super init];
    if (self) {
        _variables              = [NSMutableDictionary new];
        _variableStack          = [NSMutableDictionary new];
        _mbmlFunctions          = [NSMutableDictionary new];
        _variableDeclarations   = [NSMutableArray new];
        _namesToDeclarations    = [NSMutableDictionary new];
    }
    return self;
}

/******************************************************************************/
#pragma mark Managing the expression cache
/******************************************************************************/

- (void) environmentWillLoad:(MBEnvironment*)env
{
    debugTrace();

    MBExpressionCache* cache = [MBExpressionCache instance];
    cache.enablePersistence = NO;      // turn off persistence while we reset
    [cache resetMemoryCache];
    cache.enablePersistence = YES;     // turn on persistence so we can load the environment
    [cache loadCache];
    cache.enablePersistence = NO;      // turn off persistence once more to avoid thrashing while loading the environment
}

- (void) environmentDidLoad:(MBEnvironment*)env
{
    debugTrace();

    MBExpressionCache* cache = [MBExpressionCache instance];
    cache.enablePersistence = YES;     // re-enable cache persistence now that we're done loading
}

/******************************************************************************/
#pragma mark Managing the environment
/******************************************************************************/

- (NSArray*) acceptedTagNames
{
    return @[kMBVariableSpaceXMLTagVar,
             kMBVariableSpaceXMLTagFunction];
}

- (BOOL) parseElement:(RXMLElement*)mbml forMatch:(NSString*)match
{
    verboseDebugTrace();

    if ([match isEqualToString:kMBVariableSpaceXMLTagFunction]) {
        MBMLFunction* function = [MBMLFunction dataModelFromXML:mbml];
        if (![self declareFunction:function]) {
            errorLog(@"The following <%@> did not validate and will be ignored: %@", match, mbml.xml);
            return NO;
        }
    }
    else if ([match isEqualToString:kMBVariableSpaceXMLTagVar]) {
        MBVariableDeclaration* decl = [MBVariableDeclaration dataModelFromXML:mbml];
        if (![self declareVariable:decl]) {
            errorLog(@"The following <%@> declaration did not validate and will be ignored: %@", match, mbml.xml);
            return NO;
        }
    }
    else {
        return NO;
    }
    return YES;
}

/******************************************************************************/
#pragma mark Keyed subscripting support
/******************************************************************************/

- (id) objectForKeyedSubscript:(NSString*)key
{
    if ([key isKindOfClass:[NSString class]]) {
        return [self variableForName:key];
    }
    else {
        errorLog(@"The %@ class only supports keyed subscripting using %@-based keys; instead got a key of type %@ with the value: %@", [self class], [NSString class], [key class], key);
    }
    return nil;
}

- (void) setObject:(id)obj forKeyedSubscript:(NSString*)key
{
    if ([key isKindOfClass:[NSString class]]) {
        [self setVariable:key value:obj];
    }
    else {
        errorLog(@"The %@ class only supports keyed subscripting using %@-based keys; instead got a key of type %@ with the value: %@", [self class], [NSString class], [key class], key);
    }
}

/******************************************************************************/
#pragma mark Accessing variables
/******************************************************************************/

- (BOOL) declareVariable:(MBVariableDeclaration*)decl
{
    debugTrace();

    if ([decl validateDataModelIfNeeded]) {
        [_variableDeclarations addObject:decl];

        NSString* varName = decl.name;

        _namesToDeclarations[varName] = decl;

        if (!decl.disallowsValueCaching) {
            MBExpressionError* err = nil;
            id val = [decl initialValueInVariableSpace:self error:&err];
            if (err) {
                [err log];
                return NO;
            }
            if (val) {
                _variables[varName] = val;
            }
        }
        return YES;
    }
    return NO;
}

- (MBVariableDeclaration*) declarationForVariable:(NSString*)varName
{
    return _namesToDeclarations[varName];
}

- (BOOL) isReadOnlyVariable:(NSString*)varName
{
    if (varName) {
        MBVariableDeclaration* decl = _namesToDeclarations[varName];
        if (decl) {
            return decl.isReadOnly;
        }
    }
    return NO;
}

- (id) variableForName:(NSString*)varName
{
    return [self variableForName:varName defaultValue:nil];
}

- (id) variableForName:(NSString*)varName defaultValue:(id)def
{
    verboseDebugTrace();

    if (!varName)
        return nil;

    MBVariableDeclaration* decl = _namesToDeclarations[varName];
    if (decl && decl.disallowsValueCaching) {
        MBExpressionError* err = nil;
        id retVal = [decl currentValueInVariableSpace:self error:&err];
        if (err) {
            [err log];
            return nil;
        }
        return retVal;
    }

    id value = _variables[varName];
    if (!value) {
        return def;
    }
    return value;
}

- (NSString*) variableAsString:(NSString*)varName
{
    return [self variableAsString:varName defaultValue:nil];
}

- (NSString*) variableAsString:(NSString*)varName defaultValue:(NSString*)def
{
    verboseDebugTrace();
    
    id value = [self variableForName:varName defaultValue:def];
    if (!value) {
        return def;
    }
    if (![value isKindOfClass:[NSString class]]) {
        value = [value description];
    }
    return value;
}

/******************************************************************************/
#pragma mark Setting variable values
/******************************************************************************/

- (void) setMapVariable:(NSString*)varName mapKey:(NSString*)key value:(id)val
{
    verboseDebugTrace();
    
    if ([self isReadOnlyVariable:varName]) {
        errorLog(@"Attempted to set value for immutable map variable named %@", varName);
        return;
    }
    
    BOOL isDict = YES;
    NSMutableDictionary* map = _variables[varName];
    if (!map) {
        map = [NSMutableDictionary dictionary];
    }
    else if ([map isKindOfClass:[NSDictionary class]]) {
        map = [map mutableCopy];
    }
    else {
        // set values on non-maps using key/value coding
        isDict = NO;
        @try {
            [map setValue:val forKey:key];
        }
        @catch (NSException* ex) {
            errorLog(@"Can't set value for key \"%@\" to \"%@\"; the instance of class %@ doesn't support it: %@", key, val, [map class], map);
            return;
        }
    }
    
    if (isDict) {
        if (val) {
            map[key] = val;
        } else {
            [map removeObjectForKey:key];
        }
    }
    
    [self _setVariable:varName value:map];
}

- (void) setListVariable:(NSString*)varName listIndex:(NSUInteger)idx value:(id)val
{
    verboseDebugTrace();
    
    if ([self isReadOnlyVariable:varName]) {
        errorLog(@"Attempted to set value for immutable list variable named %@", varName);
        return;
    }
    
    NSMutableArray* list = _variables[varName];
    if (!list) {
        list = [NSMutableArray array];
    }
    else if ([list isKindOfClass:[NSArray class]]) {
        if (![list isKindOfClass:[NSMutableArray class]]) {
            list = [list mutableCopy];
        }
    }
    else {
        errorLog(@"Attempted to set a list index value for a variable (%@) that isn't an array (it's a %@)", varName, [list class]);
        return;
    }
    
    NSNull* null = [NSNull null];
    while (idx >= [list count]) {
        [list addObject:null];
    }
    list[idx] = (val ? val : null);
    
    [self _setVariable:varName value:list];
}

- (void) _setVariable:(NSString*)varName value:(id)val
{
    if (varName) {
        if (val) {
            _variables[varName] = val;
        } else {
            [_variables removeObjectForKey:varName];
        }

        MBVariableDeclaration* decl = _namesToDeclarations[varName];
        if (decl) {
            [decl valueChangedTo:val inVariableSpace:self];
        }
    }
    else {
        errorLog(@"WARNING: Attempted to set %@ variable with a nil variable name", [self class]);
    }
}

- (void) setVariable:(NSString*)varName value:(id)val
{
    verboseDebugTrace();
    
    if ([self isReadOnlyVariable:varName]) {
        errorLog(@"Attempted to change value of read-only variable named %@", varName);
    }
    else {
        [self _setVariable:varName value:val];
    }
}

- (void) unsetVariable:(NSString*)varName
{
    verboseDebugTrace();
    
    [self setVariable:varName value:nil];
}

/******************************************************************************/
#pragma mark Managing the variable stack
/******************************************************************************/

- (void) pushVariable:(NSString*)varName value:(id)val
{
    verboseDebugTrace();
    
    if ([self isReadOnlyVariable:varName]) {
        errorLog(@"Attempted to push value for immutable variable named %@", varName);
        return;
    }
    
    id curVal = _variables[varName];
    if (!curVal) {
        curVal = [NSNull null];
    }
    
    NSMutableArray* stack = _variableStack[varName];
    if (!stack) {
        stack = [NSMutableArray array];
        _variableStack[varName] = stack;
    }
    [stack addObject:curVal];
    
    [self _setVariable:varName value:val];
}

- (id) popVariable:(NSString*)varName
{
    verboseDebugTrace();
    
    if ([self isReadOnlyVariable:varName]) {
        errorLog(@"Attempted to pop value for immutable variable named %@", varName);
        return nil;
    }
    
    NSMutableArray* stack = _variableStack[varName];
    if (!stack || stack.count < 1) {
        errorLog(@"Can't pop a variable that has no pushed values: %@", varName);
        return nil;
    }
    
    id popVal = [stack lastObject];
    if (popVal == [NSNull null]) {
        popVal = nil;
    }
    [self _setVariable:varName value:popVal];
    [stack removeLastObject];
    return popVal;
}

/******************************************************************************/
#pragma mark Constructing variable-related names
/******************************************************************************/

+ (NSString*) name:(NSString*)name withSuffix:(NSString*)suffix
{
    return [MBEvents name:name withSuffix:suffix];
}

/******************************************************************************/
#pragma mark Observing NSUserDefaults value changes
/******************************************************************************/

- (void) addObserverForUserDefault:(NSString*)userDefaultsName target:(id)target action:(SEL)action
{
    debugTrace();
    
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:action
                                                 name:[NSString stringWithFormat:@"UserDefault:%@:valueChanged", userDefaultsName]
                                               object:nil];
}

- (void) removeObserver:(id)observer forUserDefault:(NSString*)userDefaultsName
{
    debugTrace();
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                    name:[NSString stringWithFormat:@"UserDefault:%@:valueChanged", userDefaultsName]
                                                  object:nil];
}

/******************************************************************************/
#pragma mark MBML functions
/******************************************************************************/

- (BOOL) declareFunction:(MBMLFunction*)function
{
    if (function) {
        if ([function validateDataModelIfNeeded]) {
            NSString* funcName = function.name;
            if (funcName) {
                _mbmlFunctions[funcName] = function;
                [MBEvents postEvent:kMBVariableSpaceDidDeclareFunctionEvent withObject:function];
                return YES;
            }
        }
    }
    return NO;
}

- (NSArray*) functionNames
{
    verboseDebugTrace();

    return [_mbmlFunctions allKeys];
}

- (MBMLFunction*) functionWithName:(NSString*)name
{
    verboseDebugTrace();

    return _mbmlFunctions[name];
}

@end
