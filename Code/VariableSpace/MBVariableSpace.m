//
//  MBVariableSpace.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 8/30/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <RaptureXML/RXMLElement.h>
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
    NSMutableDictionary* _namesToDeclarations;  // a map of declared variable names to MBVariableDeclaration instances
}

/******************************************************************************/
#pragma mark Instance vendor
/******************************************************************************/

+ (nullable instancetype) instance
{
    return (MBVariableSpace*)[[MBEnvironment instance] environmentLoaderOfClass:self];
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (nonnull instancetype) init
{
    self = [super init];
    if (self) {
        _variables              = [NSMutableDictionary new];
        _variableStack          = [NSMutableDictionary new];
        _mbmlFunctions          = [NSMutableDictionary new];
        _namesToDeclarations    = [NSMutableDictionary new];
    }
    return self;
}

/******************************************************************************/
#pragma mark Managing the expression cache
/******************************************************************************/

- (void) environmentWillLoad:(nonnull MBEnvironment*)env
{
    MBLogDebugTrace();

    MBExpressionCache* cache = [MBExpressionCache instance];
    cache.pausePersistence = YES;    // turn off persistence while we reset
    [cache resetMemoryCache];
    cache.pausePersistence = NO;     // turn on persistence so we can load the environment
    [cache loadCache];
    cache.pausePersistence = YES;    // turn off persistence once more to avoid thrashing while loading the environment
}

- (void) environmentDidLoad:(nonnull MBEnvironment*)env
{
    MBLogDebugTrace();

    MBExpressionCache* cache = [MBExpressionCache instance];
    cache.pausePersistence = NO;     // re-enable cache persistence now that we're done loading
}

/******************************************************************************/
#pragma mark Managing the environment
/******************************************************************************/

- (nonnull NSArray*) acceptedTagNames
{
    return @[kMBVariableSpaceXMLTagVar,
             kMBVariableSpaceXMLTagFunction];
}

- (BOOL) parseElement:(nonnull RXMLElement*)mbml forMatch:(nonnull NSString*)match
{
    MBLogVerboseTrace();

    if ([match isEqualToString:kMBVariableSpaceXMLTagFunction]) {
        MBMLFunction* decl = [MBMLFunction dataModelFromXML:mbml];
        if (decl.shouldDeclare) {
            if (![self declareFunction:decl]) {
                MBLogError(@"The following <%@> did not validate and will be ignored: %@", match, mbml.xml);
                return NO;
            }
        }
    }
    else if ([match isEqualToString:kMBVariableSpaceXMLTagVar]) {
        MBVariableDeclaration* decl = [MBVariableDeclaration dataModelFromXML:mbml];
        if (decl.shouldDeclare) {
            if (![self declareVariable:decl]) {
                MBLogError(@"The following <%@> declaration did not validate and will be ignored: %@", match, mbml.xml);
                return NO;
            }
        }
    }
    else {
        return NO;
    }
    return YES;
}

/******************************************************************************/
#pragma mark Managing variable declarations
/******************************************************************************/

- (BOOL) declareVariable:(nonnull MBVariableDeclaration*)declaration
{
    MBLogDebugTrace();

    if ([declaration validateDataModelIfNeeded]) {
        NSString* varName = declaration.name;
        if (varName) {
            MBVariableDeclaration* curDecl = _namesToDeclarations[varName];
            if (curDecl) {
                MBLogWarning(@"Variable \"%@\" redeclared from %@ to %@", varName, curDecl.simulatedXML, declaration.simulatedXML);
            }

            if (!declaration.disallowsValueCaching) {
                MBExpressionError* err = nil;
                id val = [declaration initialValueInVariableSpace:self error:&err];
                if (err) {
                    [err log];
                    return NO;
                }
                if (val) {
                    _variables[varName] = val;
                }
            }

            _namesToDeclarations[varName] = declaration;

            return YES;
        }
    }
    return NO;
}

- (nullable MBVariableDeclaration*) declarationForVariable:(nonnull NSString*)varName
{
    return _namesToDeclarations[varName];
}

- (BOOL) isReadOnlyVariable:(nonnull NSString*)varName
{
    if (varName) {
        MBVariableDeclaration* decl = _namesToDeclarations[varName];
        if (decl) {
            return decl.isReadOnly;
        }
    }
    return NO;
}

/******************************************************************************/
#pragma mark Getting variable values
/******************************************************************************/

- (id) objectForKeyedSubscript:(NSString*)varName
{
    if (varName) {
        MBVariableDeclaration* decl = _namesToDeclarations[varName];
        if (decl && decl.disallowsValueCaching) {
            MBExpressionError* err = nil;
            id retVal = [decl currentValueInVariableSpace:self error:&err];
            if (err) {
                [err log];
            }
            return retVal;
        }
        else {
            return _variables[varName];
        }
    }
    return nil;
}

- (NSString*) variableAsString:(NSString*)varName
{
    return [self variableAsString:varName defaultValue:nil];
}

- (nullable NSString*) variableAsString:(nonnull NSString*)varName defaultValue:(nullable NSString*)def
{
    MBLogVerboseTrace();

    id value = self[varName];
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

- (void) setObject:(nullable id)value forKeyedSubscript:(nonnull NSString*)variableName
{
    if (!variableName || ![variableName isKindOfClass:[NSString class]]) {
        [NSException raise:NSInvalidArgumentException
                    format:@"%@ requires keyed subscripts to be %@ instances (got %@ instead)", [self class], [NSString class], [variableName class]];
    }

    if ([self isReadOnlyVariable:variableName]) {
        MBLogError(@"Attempted to change value of read-only variable named %@", variableName);
    }
    else {
        [self _setVariable:variableName value:value];
    }
}

- (void) setMapVariable:(NSString*)varName mapKey:(NSString*)key value:(id)val
{
    MBLogVerboseTrace();

    if ([self isReadOnlyVariable:varName]) {
        MBLogError(@"Attempted to set value for immutable map variable named %@", varName);
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
            MBLogError(@"Can't set value for key \"%@\" to \"%@\"; the instance of class %@ doesn't support it: %@", key, val, [map class], map);
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
    MBLogVerboseTrace();

    if ([self isReadOnlyVariable:varName]) {
        MBLogError(@"Attempted to set value for immutable list variable named %@", varName);
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
        MBLogError(@"Attempted to set a list index value for a variable (%@) that isn't an array (it's a %@)", varName, [list class]);
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
        MBLogError(@"Attempted to set %@ variable with a nil variable name", [self class]);
    }
}

- (void) unsetVariable:(NSString*)varName
{
    MBLogVerboseTrace();

    self[varName] = nil;
}

/******************************************************************************/
#pragma mark Managing the variable stack
/******************************************************************************/

- (void) pushVariable:(nonnull NSString*)variableName value:(nullable id)value
{
    MBLogVerboseTrace();

    if ([self isReadOnlyVariable:variableName]) {
        MBLogError(@"Attempted to push value for immutable variable named %@", variableName);
        return;
    }

    id curVal = _variables[variableName];
    if (!curVal) {
        curVal = [NSNull null];
    }

    NSMutableArray* stack = _variableStack[variableName];
    if (!stack) {
        stack = [NSMutableArray array];
        _variableStack[variableName] = stack;
    }
    [stack addObject:curVal];

    [self _setVariable:variableName value:value];
}

- (nullable id) popVariable:(nonnull NSString*)varName
{
    MBLogVerboseTrace();

    if ([self isReadOnlyVariable:varName]) {
        MBLogError(@"Attempted to pop value for immutable variable named %@", varName);
        return nil;
    }

    NSMutableArray* stack = _variableStack[varName];
    if (!stack || stack.count < 1) {
        MBLogError(@"Can't pop a variable that has no pushed values: %@", varName);
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

+ (nullable NSString*) name:(nullable NSString*)name withSuffix:(nullable NSString*)suffix
{
    return [MBEvents name:name withSuffix:suffix];
}

/******************************************************************************/
#pragma mark Observing NSUserDefaults value changes
/******************************************************************************/

- (void) addObserverForUserDefault:(nonnull NSString*)userDefaultsName
                            target:(nonnull id)observer
                            action:(nonnull SEL)action
{
    MBLogDebugTrace();

    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:action
                                                 name:[NSString stringWithFormat:@"UserDefault:%@:valueChanged", userDefaultsName]
                                               object:nil];
}

- (void) removeObserver:(nonnull id)observer
         forUserDefault:(nonnull NSString*)userDefaultsName
{
    MBLogDebugTrace();

    [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                    name:[NSString stringWithFormat:@"UserDefault:%@:valueChanged", userDefaultsName]
                                                  object:nil];
}

/******************************************************************************/
#pragma mark MBML functions
/******************************************************************************/

- (BOOL) declareFunction:(nonnull MBMLFunction*)function
{
    if ([function validateDataModelIfNeeded]) {
        NSString* funcName = function.name;
        if (funcName) {
            MBMLFunction* curDecl = _mbmlFunctions[funcName];
            if (curDecl) {
                MBLogWarning(@"Function ^%@() redeclared from %@ to %@", funcName, curDecl.simulatedXML, function.simulatedXML);
            }

            _mbmlFunctions[funcName] = function;
            [MBEvents postEvent:kMBVariableSpaceDidDeclareFunctionEvent withObject:function];
            return YES;
        }
    }
    return NO;
}

- (nonnull NSArray*) functionNames
{
    MBLogVerboseTrace();

    return [_mbmlFunctions allKeys];
}

- (nullable MBMLFunction*) functionWithName:(nonnull NSString*)name
{
    MBLogVerboseTrace();
    
    return _mbmlFunctions[name];
}

@end
