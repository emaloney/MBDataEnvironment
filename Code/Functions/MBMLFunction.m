//
//  MBMLFunction.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 9/15/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLFunction.h"
#import "MBDataEnvironmentModule.h"

#define DEBUG_LOCAL                 0       // turns on tracing of function calls
#define DEBUG_VERBOSE               0       // turns on tracing of function parameter validation
#define DEBUG_EXCEPTIONS            0       // turns on logging of exception stack traces
#define DEBUG_TRANSFORMER_CALLS     0       // turns on logging the input & output of each function call

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

NSString* const kMBMLFunctionInputNone                  = @"none";
NSString* const kMBMLFunctionInputRaw                   = @"raw";
NSString* const kMBMLFunctionInputString                = @"string";
NSString* const kMBMLFunctionInputObject                = @"object";
NSString* const kMBMLFunctionInputMath                  = @"math";
NSString* const kMBMLFunctionInputPipedExpressions      = @"pipedExpressions";
NSString* const kMBMLFunctionInputPipedStrings          = @"pipedStrings";
NSString* const kMBMLFunctionInputPipedObjects          = @"pipedObjects";
NSString* const kMBMLFunctionInputPipedMath             = @"pipedMath";

NSString* const kMBMLFunctionOutputNone                 = @"none";
NSString* const kMBMLFunctionOutputObject               = @"object";

NSString* const kMBMLFunctionInputParameterName         = @"input parameter";

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFunction implementation
/******************************************************************************/

@implementation MBMLFunction
{
    NSString* _name;
    __strong Class _functionClass;
    NSString* _methodName;
    SEL _functionSelector;
    NSString* _deprecated;
    NSString* _deprecatedInFavorOf;
    NSString* _deprecationMessage;
}

/******************************************************************************/
#pragma mark Data model support
/******************************************************************************/

+ (NSSet*) supportedAttributes
{
    return [NSSet setWithObjects:kMBMLAttributeName,
            kMBMLAttributeClass,
            kMBMLAttributeMethod,
            kMBMLAttributeInput,
            kMBMLAttributeOutput,
            kMBMLAttributeDeprecated,
            kMBMLAttributeDeprecatedInFavorOf,
            kMBMLAttributeDeprecationMessage,
            nil];
}

- (BOOL) validateAttributes
{
    if (![super validateAttributes]) {
        return NO;
    }
    
    if (!_name) {
        errorLog(@"No name specified for %@ in: %@", [self class], self.simulatedXML);
        return NO;
    }
    if (_inputType == MBMLFunctionInputUnset) {
        _inputType = MBMLFunctionInputDefault;
    }
    if (_outputType == MBMLFunctionOutputUnset) {
        _outputType = MBMLFunctionOutputDefault;
    }
    
    if (!_functionClass) {
        errorLog(@"Couldn't find implementing class for %@ specified in: %@", [self class], self.simulatedXML);
        return NO;
    }
    
    _functionSelector = [[self class] _selectorFromMethodName:(_methodName ? _methodName : _name)
                                                 forInputType:_inputType];
    
    if (![_functionClass respondsToSelector:_functionSelector]) {
        errorLog(@"%@ class %@ does not implement %@ specified in: %@", [self class], NSStringFromClass(_functionClass), NSStringFromSelector(_functionSelector), self.simulatedXML);
        return NO;
    }
    
    return YES;
}

/******************************************************************************/
#pragma mark Debugging output
/******************************************************************************/

- (NSString*) functionDescription
{
    return [NSString stringWithFormat:@"^%@() implemented by +[%@ %@]", _name, _functionClass, NSStringFromSelector(_functionSelector)];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"<%@: %p; %@>", [self class], self, [self functionDescription]];
}

/******************************************************************************/
#pragma mark Helper routines
/******************************************************************************/

+ (SEL) _selectorFromMethodName:(NSString*)methodName forInputType:(MBMLFunctionInputType)type
{
    if (type == MBMLFunctionInputNone) {
        return NSSelectorFromString(methodName);
    }
    else {
        return NSSelectorFromString([NSString stringWithFormat:@"%@:", methodName]);
    }
}

/******************************************************************************/
#pragma mark XML property setting hooks
/******************************************************************************/

- (void) setClass:(NSString*)clsName
{
    debugTrace();
    
    _functionClass = NSClassFromString(clsName);
}

- (void) setMethod:(NSString*)methodName
{
    debugTrace();
    
    if (methodName != _methodName) {
        _methodName = methodName;
    }
}

- (void) setInput:(NSString*)input
{
    debugTrace();
    
    if (!input || [input length] < 1) {
        _inputType = MBMLFunctionInputDefault;
    }
    else if ([kMBMLFunctionInputNone isEqualToString:input]) {
        _inputType = MBMLFunctionInputNone;
    }
    else if ([kMBMLFunctionInputRaw isEqualToString:input]) {
        _inputType = MBMLFunctionInputRaw;
    }
    else if ([kMBMLFunctionInputString isEqualToString:input]) {
        _inputType = MBMLFunctionInputString;
    }
    else if ([kMBMLFunctionInputObject isEqualToString:input]) {
        _inputType = MBMLFunctionInputObject;
    }
    else if ([kMBMLFunctionInputMath isEqualToString:input]) {
        _inputType = MBMLFunctionInputMath;
    }
    else if ([kMBMLFunctionInputPipedExpressions isEqualToString:input]) {
        _inputType = MBMLFunctionInputPipedExpressions;
    }
    else if ([kMBMLFunctionInputPipedStrings isEqualToString:input]) {
        _inputType = MBMLFunctionInputPipedStrings;
    }
    else if ([kMBMLFunctionInputPipedObjects isEqualToString:input]) {
        _inputType = MBMLFunctionInputPipedObjects;
    }
    else if ([kMBMLFunctionInputPipedMath isEqualToString:input]) {
        _inputType = MBMLFunctionInputPipedMath;
    }
    else {
        errorLog(@"Unrecognized value for 'input' attribute of tranformer named %@: %@", _name, input);
        _inputType = MBMLFunctionInputDefault;
    }
}

- (void) setOutput:(NSString*)output
{
    debugTrace();
    
    if (!output || [output length] < 1) {
        _outputType = MBMLFunctionOutputDefault;
    }
    else if ([kMBMLFunctionOutputNone isEqualToString:output]) {
        _outputType = MBMLFunctionOutputNone;
    }
    else if ([kMBMLFunctionOutputObject isEqualToString:output]) {
        _outputType = MBMLFunctionOutputObject;
    }
    else {
        errorLog(@"Unrecognized value for 'output' attribute of tranformer named %@: %@", _name, output);
        _outputType = MBMLFunctionOutputDefault;
    }
}

/******************************************************************************/
#pragma mark Transformer parameter validation (high-level)
/******************************************************************************/

+ (BOOL) _validateParameter:(id)param plural:(BOOL)isPlural error:(MBMLFunctionError**)errPtr
{
    if (!param) {
        [[MBMLFunctionError errorWithFormat:@"expected %@%s, but got none", kMBMLFunctionInputParameterName, (isPlural ? "s" : "")] reportErrorTo:errPtr];
        return NO;
    }
    else if (param == (id)[NSNull null]) {
        [[MBMLFunctionError errorWithFormat:@"expected %@%s, but got a null value", kMBMLFunctionInputParameterName, (isPlural ? "s" : "")] reportErrorTo:errPtr];
        return NO;
    }
    else if (isPlural && ![param isKindOfClass:[NSArray class]]) {
        [[MBMLFunctionError errorWithFormat:@"expected an array of %@s, but got a %@", kMBMLFunctionInputParameterName, [param class]] reportErrorTo:errPtr];
        return NO;
    }
    return YES;
}

+ (NSUInteger) validateParameter:(NSArray*)params countIs:(NSUInteger)expectedCnt error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                 inArray:params
                                 countIs:expectedCnt
                                   error:errPtr];
    }
    return 0;
}

+ (NSUInteger) validateParameter:(NSArray*)params countIsAtLeast:(NSUInteger)expectedCnt error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                 inArray:params
                          countIsAtLeast:expectedCnt
                                   error:errPtr];
    }
    return 0;
}

+ (NSUInteger) validateParameter:(NSArray*)params countIsAtMost:(NSUInteger)expectedCnt error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                 inArray:params
                           countIsAtMost:expectedCnt
                                   error:errPtr];
    }
    return 0;
}

+ (NSUInteger) validateParameter:(NSArray*)params countIsAtLeast:(NSUInteger)minCnt andAtMost:(NSUInteger)maxCnt error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                 inArray:params
                          countIsAtLeast:minCnt
                               andAtMost:maxCnt
                                   error:errPtr];
    }
    return 0;
}

+ (NSUInteger) validateParameter:(NSArray*)params indexIsInRange:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                 inArray:params
                          indexIsInRange:idx
                                   error:errPtr];
    }
    return 0;
}

+ (id) validateParameter:(NSArray*)params objectAtIndex:(NSUInteger)idx isKindOfClass:(Class)cls error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                 inArray:params
                           objectAtIndex:idx
                           isKindOfClass:cls
                                   error:errPtr];
    }
    return nil;
}

+ (Class) validateParameter:(NSArray*)params objectAtIndex:(NSUInteger)idx isOneKindOfClass:(NSArray*)classes error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                 inArray:params
                           objectAtIndex:idx
                        isOneKindOfClass:classes
                                   error:errPtr];
    }
    return nil;
}

+ (NSString*) validateParameter:(NSArray*)params isStringAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                 inArray:params
                         isStringAtIndex:idx
                                   error:errPtr];
    }
    return nil;
}

+ (NSDecimalNumber*) validateParameter:(NSArray*)params containsNumberAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                 inArray:params
                   containsNumberAtIndex:idx
                                   error:errPtr];
    }
    return nil;
}

+ (NSArray*) validateParameter:(NSArray*)params isArrayAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                 inArray:params
                          isArrayAtIndex:idx
                                   error:errPtr];
    }
    return nil;
}

+ (NSDictionary*) validateParameter:(NSArray*)params isDictionaryAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                 inArray:params
                     isDictionaryAtIndex:idx
                                   error:errPtr];
    }
    return nil;
}

+ (id) validateParameter:(id)param isKindOfClass:(Class)cls error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:param plural:NO error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                  object:param
                           isKindOfClass:cls
                                   error:errPtr];
    }
    return nil;
}

+ (Class) validateParameter:(id)param isOneKindOfClass:(NSArray*)classes error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:param plural:NO error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                  object:param
                        isOneKindOfClass:classes
                                   error:errPtr];
    }
    return nil;
}

+ (id<NSObject>) validateParameter:(id<NSObject>)param respondsToSelector:(SEL)selector error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:param plural:NO error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName 
                                  object:param 
                      respondsToSelector:selector 
                                   error:errPtr];
    }
    return nil;
}

+ (NSString*) validateParameterIsString:(id)param error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:param plural:NO error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                isString:param
                                   error:errPtr];
    }
    return nil;
}

+ (NSNumber*) validateParameterContainsNumber:(id)param error:(MBMLFunctionError**)errPtr;
{
    if ([self _validateParameter:param plural:NO error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                          containsNumber:param
                                   error:errPtr];
    }
    return nil;
}

+ (NSArray*) validateParameterIsArray:(id)param error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:param plural:NO error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                                 isArray:param
                                   error:errPtr];
    }
    return nil;
}

+ (NSDictionary*) validateParameterIsDictionary:(id)param error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:param plural:NO error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                            isDictionary:param
                                   error:errPtr];
    }
    return nil;
}

/******************************************************************************/
#pragma mark Transformer expression validation (mid-level)
/******************************************************************************/

+ (id) validateExpression:(NSArray*)params objectAtIndex:(NSUInteger)idx isKindOfClass:(Class)cls error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                       expressionInArray:params
                           objectAtIndex:idx
                           isKindOfClass:cls 
                                   error:errPtr];
    }
    return nil;
}

+ (Class) validateExpression:(NSArray*)params objectAtIndex:(NSUInteger)idx isOneKindOfClass:(NSArray*)classes error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                       expressionInArray:params
                           objectAtIndex:idx
                        isOneKindOfClass:classes 
                                   error:errPtr];
    }
    return nil;
}

+ (NSString*) validateExpression:(NSArray*)params isStringAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                       expressionInArray:params
                         isStringAtIndex:idx
                                   error:errPtr];
    }
    return nil;
}

+ (NSNumber*) validateExpression:(NSArray*)params containsNumberAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                       expressionInArray:params
                   containsNumberAtIndex:idx
                                   error:errPtr];
    }
    return nil;
}

+ (NSArray*) validateExpression:(NSArray*)params isArrayAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                       expressionInArray:params
                          isArrayAtIndex:idx
                                   error:errPtr];
    }
    return nil;
}

+ (NSDictionary*) validateExpression:(NSArray*)params isDictionaryAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    if ([self _validateParameter:params plural:YES error:errPtr]) {
        return [self validateObjectNamed:kMBMLFunctionInputParameterName
                       expressionInArray:params
                     isDictionaryAtIndex:idx
                                   error:errPtr];
    }
    return nil;
}

/******************************************************************************/
#pragma mark Transformer input validation (low-level)
/******************************************************************************/

+ (NSUInteger) validateObjectNamed:(NSString*)objName inArray:(NSArray*)array countIs:(NSUInteger)expectedCnt error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return 0;      // a previous error was encountered, so bail out
    
    NSUInteger actualCnt = array.count;
    if (actualCnt != expectedCnt) {
        [[MBMLFunctionError errorWithFormat:@"expected exactly %u %@s, but got %u instead", expectedCnt, objName, actualCnt] reportErrorTo:errPtr];
        return 0;
    }
    return actualCnt;
}

+ (NSUInteger) validateObjectNamed:(NSString*)objName inArray:(NSArray*)array countIsAtLeast:(NSUInteger)expectedCnt error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return 0;      // a previous error was encountered, so bail out
    
    NSUInteger actualCnt = array.count;
    if (actualCnt < expectedCnt) {
        [[MBMLFunctionError errorWithFormat:@"expected at least %u %@s, but got %u instead", expectedCnt, objName, actualCnt] reportErrorTo:errPtr];
        return 0;
    }
    return actualCnt;
}

+ (NSUInteger) validateObjectNamed:(NSString*)objName inArray:(NSArray*)array countIsAtMost:(NSUInteger)expectedCnt error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return 0;      // a previous error was encountered, so bail out
    
    NSUInteger actualCnt = array.count;
    if (actualCnt > expectedCnt) {
        [[MBMLFunctionError errorWithFormat:@"expected no more than %u %@s, but got %u instead", expectedCnt, objName, actualCnt] reportErrorTo:errPtr];
        return 0;
    }
    return actualCnt;
}

+ (NSUInteger) validateObjectNamed:(NSString*)objName inArray:(NSArray*)array countIsAtLeast:(NSUInteger)minCnt andAtMost:(NSUInteger)maxCnt error:(MBMLFunctionError**)errPtr;
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return 0;      // a previous error was encountered, so bail out
    
    NSUInteger actualCnt = array.count;
    if (actualCnt < minCnt || actualCnt > maxCnt) {
        [[MBMLFunctionError errorWithFormat:@"expected at least %u and at most %u %@s, but got %u instead", minCnt, maxCnt, objName, actualCnt] reportErrorTo:errPtr];
        return 0;
    }
    return actualCnt;
}

+ (NSUInteger) validateObjectNamed:(NSString*)objName inArray:(NSArray*)array indexIsInRange:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return 0;      // a previous error was encountered, so bail out
    
    NSUInteger actualCnt = array.count;
    if (idx >= actualCnt) {
        [[MBMLFunctionError errorWithFormat:@"%@ index %u is out of bounds (valid range is 0 to %u)", objName, idx, actualCnt] reportErrorTo:errPtr];
        return 0;
    }
    return actualCnt;
}

+ (id) validateObjectNamed:(NSString*)objName inArray:(NSArray*)array objectAtIndex:(NSUInteger)idx isKindOfClass:(Class)cls error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return nil;    // a previous error was encountered, so bail out
    
    id objToTest = array[idx];
    if (![objToTest isKindOfClass:cls]) {
        [[MBMLFunctionError errorWithFormat:@"expected %@ at index %u to be of type %@, but got %@ instead", objName, idx, cls, [objToTest class]] reportErrorTo:errPtr];
        return nil;
    }
    return objToTest;
}

+ (Class) validateObjectNamed:(NSString*)objName inArray:(NSArray*)array objectAtIndex:(NSUInteger)idx isOneKindOfClass:(NSArray*)classes error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return nil;    // a previous error was encountered, so bail out
    
    id objToTest = array[idx];
    for (Class cls in classes) {
        if ([objToTest isKindOfClass:cls]) return cls;
    }
    [[MBMLFunctionError errorWithFormat:@"expected %@ at index %u to be among {%@}, but got %@ instead", objName, idx, [classes componentsJoinedByString:@", "], [objToTest class]] reportErrorTo:errPtr];
    return nil;
}

+ (NSString*) validateObjectNamed:(NSString*)objName inArray:(NSArray*)validate isStringAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    return (NSString*)[self validateObjectNamed:objName inArray:validate objectAtIndex:idx isKindOfClass:[NSString class] error:errPtr];
}

+ (NSDecimalNumber*) validateObjectNamed:(NSString*)objName inArray:(NSArray*)array containsNumberAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return nil;    // a previous error was encountered, so bail out

    id objToTest = array[idx];
    NSDecimalNumber* number = [MBExpression numberFromValue:objToTest];
    if (!number) {
        [[MBMLFunctionError errorWithFormat:@"expected %@ at index %u to contain a number value, but got \"%@\" (%@) instead", objName, idx, objToTest, [objToTest class]] reportErrorTo:errPtr];
    }
    return number;
}

+ (NSArray*) validateObjectNamed:(NSString*)objName inArray:(NSArray*)array isArrayAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    return (NSArray*)[self validateObjectNamed:objName inArray:array objectAtIndex:idx isKindOfClass:[NSArray class] error:errPtr];
}

+ (NSDictionary*) validateObjectNamed:(NSString*)objName inArray:(NSArray*)array isDictionaryAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    return (NSDictionary*)[self validateObjectNamed:objName inArray:array objectAtIndex:idx isKindOfClass:[NSDictionary class] error:errPtr];
}

+ (id) validateObjectNamed:(NSString*)objName expressionInArray:(NSArray*)array objectAtIndex:(NSUInteger)idx isKindOfClass:(Class)cls error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return nil;    // a previous error was encountered, so bail out
    
    NSString* exprToTest = array[idx];
    id objToTest = [MBExpression asObject:exprToTest];
    if (![objToTest isKindOfClass:cls]) {
        [[MBMLFunctionError errorWithFormat:@"expected %@ at index %u to be type %@, but got %@ instead", objName, idx, cls, [objToTest class]] reportErrorTo:errPtr];
        return nil;
    }
    return objToTest;
}

+ (Class) validateObjectNamed:(NSString*)objName expressionInArray:(NSArray*)array objectAtIndex:(NSUInteger)idx isOneKindOfClass:(NSArray*)classes error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return nil;    // a previous error was encountered, so bail out
    
    NSString* exprToTest = array[idx];
    id objToTest = [MBExpression asObject:exprToTest];
    for (Class cls in classes) {
        if ([objToTest isKindOfClass:cls]) return cls;
    }
    [[MBMLFunctionError errorWithFormat:@"expected %@ type at index %u to be among {%@}, but got %@ instead", objName, idx, [classes componentsJoinedByString:@", "], [objToTest class]] reportErrorTo:errPtr];
    return nil;
}

+ (NSString*) validateObjectNamed:(NSString*)objName expressionInArray:(NSArray*)array isStringAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    return (NSString*)[self validateObjectNamed:objName expressionInArray:array objectAtIndex:idx isKindOfClass:[NSString class] error:errPtr];
}

+ (NSNumber*) validateObjectNamed:(NSString*)objName expressionInArray:(NSArray*)array containsNumberAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return nil;    // a previous error was encountered, so bail out
    
    NSString* exprToTest = array[idx];
    NSNumber* number = [MBExpression asNumber:exprToTest error:errPtr];
    if (*errPtr) return nil;

    if (!number) {
        [[MBMLFunctionError errorWithFormat:@"expected %@ at index %u (expression: \"%@\") to contain a numeric value or math expression", objName, idx, exprToTest] reportErrorTo:errPtr];
    }
    return number;
}

+ (NSArray*) validateObjectNamed:(NSString*)objName expressionInArray:(NSArray*)array isArrayAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    return (NSArray*)[self validateObjectNamed:objName expressionInArray:array objectAtIndex:idx isKindOfClass:[NSArray class] error:errPtr];
}

+ (NSDictionary*) validateObjectNamed:(NSString*)objName expressionInArray:(NSArray*)array isDictionaryAtIndex:(NSUInteger)idx error:(MBMLFunctionError**)errPtr
{
    return (NSDictionary*)[self validateObjectNamed:objName expressionInArray:array objectAtIndex:idx isKindOfClass:[NSDictionary class] error:errPtr];
}

+ (id) validateObjectNamed:(NSString*)objName object:(id)validate isKindOfClass:(Class)cls error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return nil;    // a previous error was encountered, so bail out
    
    if (![validate isKindOfClass:cls]) {
        [[MBMLFunctionError errorWithFormat:@"expected %@ to be of type %@, but got %@ instead", objName, cls, [validate class]] reportErrorTo:errPtr];
        return nil;
    }
    return validate;
}

+ (Class) validateObjectNamed:(NSString*)objName object:(id)validate isOneKindOfClass:(NSArray*)classes error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return nil;    // a previous error was encountered, so bail out
    
    for (Class cls in classes) {
        if ([validate isKindOfClass:cls]) return cls;
    }
    [[MBMLFunctionError errorWithFormat:@"expected type of %@ to be among {%@}, but got %@ instead", objName, [classes componentsJoinedByString:@", "], [validate class]] reportErrorTo:errPtr];
    return nil;
}

+ (id<NSObject>) validateObjectNamed:(NSString*)objName object:(id<NSObject>)validate respondsToSelector:(SEL)selector error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return nil;    // a previous error was encountered, so bail out
    
    if (![validate respondsToSelector:selector]) {
        [[MBMLFunctionError errorWithFormat:@"expected %@ to respond to %@, underlying type is %@", 
          objName, NSStringFromSelector(selector), [validate class]] 
         reportErrorTo:errPtr];
        return nil;
    }
    return validate;
}

+ (NSString*) validateObjectNamed:(NSString*)objName isString:(id)validate error:(MBMLFunctionError**)errPtr
{
    return (NSString*)[self validateObjectNamed:objName object:validate isKindOfClass:[NSString class] error:errPtr];
}

+ (NSNumber*) validateObjectNamed:(NSString*)objName containsNumber:(id)validate error:(MBMLFunctionError**)errPtr
{
    verboseDebugTrace();
    
    assert(errPtr);             // don't accept 'nil'
    
    if (*errPtr) return nil;    // a previous error was encountered, so bail out
    
    NSNumber* number = [MBExpression numberFromValue:validate];
    if (!number) {
        [[MBMLFunctionError errorWithFormat:@"expected %@ to contain a number value, but got \"%@\" (%@) instead", objName, validate, [validate class]] reportErrorTo:errPtr];
    }
    return number;
}

+ (NSArray*) validateObjectNamed:(NSString*)objName isArray:(id)validate error:(MBMLFunctionError**)errPtr
{
    return (NSArray*)[self validateObjectNamed:objName object:validate isKindOfClass:[NSArray class] error:errPtr];
}

+ (NSDictionary*) validateObjectNamed:(NSString*)objName isDictionary:(id)validate error:(MBMLFunctionError**)errPtr
{
    return (NSDictionary*)[self validateObjectNamed:objName object:validate isKindOfClass:[NSDictionary class] error:errPtr];
}

/******************************************************************************/
#pragma mark Execution
/******************************************************************************/

- (id) executeWithInput:(id)input error:(MBExpressionError**)errPtr
{
    @try {
        if (_deprecationMessage && !_deprecatedInFavorOf) {
            [[MBDataEnvironmentModule log] issueDeprecationWarningWithFormat:@"^%@() has been deprecated: %@", _name, _deprecationMessage];
        }
        else if (_deprecationMessage && _deprecatedInFavorOf) {
            [[MBDataEnvironmentModule log] issueDeprecationWarningWithFormat:@"^%@() has been deprecated: %@; please update your code to use ^%@() instead", _name, _deprecationMessage, _deprecatedInFavorOf];
        }
        else if (_deprecatedInFavorOf) {
            [[MBDataEnvironmentModule log] issueDeprecationWarningWithFormat:@"^%@() has been deprecated; please update your code to use ^%@() instead", _name, _deprecatedInFavorOf];
        }
        else if (_deprecated && [MBExpression booleanFromValue:_deprecated]) {
            [[MBDataEnvironmentModule log] issueDeprecationWarningWithFormat:@"^%@() has been deprecated; please update your code to avoid using it", _name];
        }
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id output = [_functionClass performSelector:_functionSelector withObject:input];
#pragma clang diagnostic pop
        
        if (_outputType == MBMLFunctionOutputNone) {
            if (DEBUG_FLAG(DEBUG_TRANSFORMER_CALLS)) consoleLog(@"%@ called with input %@", self, input);
            return nil;
        }
        else {
            if (DEBUG_FLAG(DEBUG_TRANSFORMER_CALLS)) consoleLog(@"%@ called with input %@; returned: %@", self, input, output);
        }

        if ([output isKindOfClass:[MBExpressionError class]]) {
            MBExpressionError* err = (MBExpressionError*) output;
            err.value = self;
            [err reportErrorTo:errPtr];
            return nil;
        }

        return output;
    }
    @catch (NSException* ex) {
        MBMLFunctionError* currentErr = [MBMLFunctionError errorWithMessage:@"threw exception" exception:ex];
        currentErr.value = self;
        [currentErr reportErrorTo:errPtr];
        
        if (DEBUG_FLAG(DEBUG_EXCEPTIONS)) consoleLog(@"MBML function exception stack trace: %@", [ex callStackSymbols]);
        
        return nil;
    }
}

@end
