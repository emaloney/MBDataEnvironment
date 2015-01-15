//
//  MBMLDebugFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/10/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBMLDebugFunctions.h"
#import "MBExpression.h"
#import "MBMLFunction.h"
#import "MBExpressionGrammar.h"
#import "MBDataEnvironmentModule.h"
#import "MBExpressionCache.h"
#import "MBVariableSpace.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLDebugFunctions implementation
/******************************************************************************/

@implementation MBMLDebugFunctions

/******************************************************************************/
#pragma mark Private methods
/******************************************************************************/

+ (void) logObject:(id)obj forExpression:(NSString*)expr
{
    if (!obj) {
        NSLog(@"--> Expression \"%@\" resolves to nil", expr);
    }
    else {
        NSString* instanceInfo = [NSString stringWithFormat:@"an instance of class %@ at memory address %p", [obj class], obj];
        if ([obj respondsToSelector:@selector(count)]) {
            NSLog(@"--> Expression \"%@\" resolves to %@ containing %lu items:\n%@", expr, instanceInfo, (unsigned long)[obj count], [obj description]);
        }
        else {
            NSLog(@"--> Expression \"%@\" resolves to %@: %@", expr, instanceInfo, [obj description]);
        }
    }
}

/******************************************************************************/
#pragma mark Public API
/******************************************************************************/

+ (NSString*) log:(NSString*)expr
{
    id obj = [MBExpression asObject:expr];
    [self logObject:obj forExpression:expr];
    return obj;
}

+ (NSNumber*) test:(NSString*)expr
{
    BOOL result = [MBExpression asBoolean:expr];
    NSLog(@"--> Expression \"%@\" evaluates to %s", expr, (result ? "TRUE" : "FALSE"));
    return @(result);
}

+ (NSString*) dump:(NSString*)expr
{
    id obj = [MBExpression asObject:expr];
    [self logObject:obj forExpression:expr];
#if DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([obj respondsToSelector:@selector(recursiveDescription)]) {
        return (NSString*)[obj performSelector:@selector(recursiveDescription)];
    } else {
        return [obj description];
    }
#pragma clang diagnostic pop
#else
    return [obj description];
#endif
}

+ (NSString*) debugBreak:(NSString*)input
{
#if DEBUG
    NSString* msg = [NSString stringWithFormat:@"triggered with input: %@", input];
    triggerDebugBreakMsg(msg);    // this will trigger a debug breakpoint when running in a Debug build
#endif

    return input;
}

+ (NSString*) _tokenizeExpression:(NSString*)exprStr
                           ofType:(NSString*)exprType
                     usingGrammar:(MBMLGrammar*)grammar
{
    MBExpressionError* err = nil;

    NSArray* tokens = [[MBExpressionCache instance] tokensForExpression:exprStr
                                                        inVariableSpace:[MBVariableSpace instance]
                                                           usingGrammar:[MBMLObjectExpressionGrammar instance]
                                                                  error:&err];

    if (err) {
        NSLog(@"--> Failed to tokenize %@ expression \"%@\" due to error: %@", exprType, exprStr, err);
    }
    else {
        NSMutableString* tokStr = [NSMutableString string];
        for (id t in tokens) {
            [tokStr appendFormat:@"\n%@", [t description]];
        }
        NSLog(@"--> Tokens for %@ expression \"%@\":%@", exprType, exprStr, tokStr);
    }
    return exprStr;
}

+ (NSString*) tokenize:(NSString*)exprStr
{
    return [self _tokenizeExpression:exprStr
                              ofType:@"variable expansion"
                        usingGrammar:[MBMLObjectExpressionGrammar instance]];
}

+ (NSString*) tokenizeBoolean:(NSString*)exprStr
{
    return [self _tokenizeExpression:exprStr
                              ofType:@"boolean"
                        usingGrammar:[MBMLBooleanExpressionGrammar instance]];
}

+ (NSString*) tokenizeMath:(NSString*)exprStr
{
    return [self _tokenizeExpression:exprStr
                              ofType:@"math"
                        usingGrammar:[MBMLMathExpressionGrammar instance]];
}

+ (id) bench:(NSString*)expr
{
    MBExpressionError* err = nil;
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    id obj = [MBExpression asObject:expr error:&err];
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    if (err) {
        NSLog(@"--> Evaluated variable expansion expression \"%@\" with error %@ in %g seconds", expr, err, end - start);
        return err;
    } else {
        NSLog(@"--> Evaluated variable expansion expression \"%@\" in %g seconds", expr, end - start);
        return obj;
    }
}

+ (id) benchBool:(NSString*)expr
{
    MBExpressionError* err = nil;
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    bool retVal = [MBExpression asBoolean:expr error:&err];
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    if (err) {
        NSLog(@"--> Evaluated boolean expression \"%@\" with error %@ in %g seconds", expr, err, end - start);
        return err;
    } else {
        NSLog(@"--> Evaluated boolean expression \"%@\" in %g seconds", expr, end - start);
        return @(retVal);
    }
}

+ (id) repeat:(NSArray*)params
{
    MBExpressionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:(MBMLFunctionError**)&err];
    if (err) return err;
    
    id retVal = nil;
    NSInteger repeat = [[params[0] description] integerValue];
    NSString* expr = [params[1] description];
    for (NSInteger i=0; i<repeat; i++) {
        retVal = [MBExpression asObject:expr error:&err];
        if (err) {
            NSLog(@"--> Error while attempting to repeat variable expansion expression \"%@\" (at run %ld of %ld): %@", expr, (long)i, (long)repeat, err);
            return err;
        }
    }
    NSLog(@"--> Successfully repeated variable expansion expression \"%@\" %ld times", expr, (long)repeat);
    return retVal;
}

+ (id) repeatBool:(NSArray*)params
{
    MBExpressionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:(MBMLFunctionError**)&err];
    if (err) return err;
    
    BOOL retVal = NO;
    NSInteger repeat = [[params[0] description] integerValue];
    NSString* expr = [params[1] description];
    for (NSInteger i=0; i<repeat; i++) {
        retVal = [MBExpression asBoolean:expr error:&err];
        if (err) {
            NSLog(@"--> Error while attempting to repeat boolean expression \"%@\" (at run %ld of %ld): %@", expr, (long)i, (long)repeat, err);
            return err;
        }
    }
    NSLog(@"--> Successfully repeated boolean expression \"%@\" %ld times", expr, (long)repeat);
    return @(retVal);
}

+ (id) deprecateVariableInFavorOf:(NSArray*)params
{
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 andAtMost:3 error:&err];
    if (err) return err;

    MBModuleLog* log = [MBDataEnvironmentModule log];
    if (paramCnt == 3) {
        Class specifiedClass = NSClassFromString([params[2] evaluateAsString]);
        if (specifiedClass && [specifiedClass conformsToProtocol:@protocol(MBModule)]) {
            log = [specifiedClass log];
        }
    }

    [log issueDeprecationWarningWithFormat:@"The MBML variable \"%@\" has been deprecated; please update your code to use \"%@\" instead", params[0], params[1]];

    return [params[1] evaluateAsObject];
}

@end
