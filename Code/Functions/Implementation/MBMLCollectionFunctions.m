//
//  MBMLCollectionFunctions.m
//  Mockingbird Data Environment
//
//  Created by Alberto Tafoya on 8/23/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBMLCollectionFunctions.h"
#import "MBExpression.h"
#import "MBMLFunction.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLCollectionFunctions implementation
/******************************************************************************/

@implementation MBMLCollectionFunctions

+ (NSNumber*) isCollection:(id)param;
{
    debugTrace();

    if (param) {
        if ([param isKindOfClass:[NSDictionary class]])
            return @(YES);
        
        if ([param isKindOfClass:[NSArray class]])
            return @(YES);
        
        if ([param isKindOfClass:[NSSet class]])
            return @(YES);
    }
    return @(NO);
}

+ (NSNumber*) isSet:(id)param
{
    debugTrace();
    
    return @(param && [param isKindOfClass:[NSSet class]]);
}

+ (NSNumber*) isDictionary:(id)param
{
    debugTrace();
    
    return @(param && [param isKindOfClass:[NSDictionary class]]);
}

+ (NSNumber*) isArray:(id)param
{
    debugTrace();
    
    return @(param && [param isKindOfClass:[NSArray class]]);
}

+ (id) count:(id)param
{
    debugTrace();

    if (param == [NSNull null]) {
        return @0;
    }

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:param
                   isOneKindOfClass:@[[NSDictionary class], [NSSet class], [NSArray class]]
                              error:&err];
    if (err) return err;

    return @([param count]);
}

+ (id) removeObject:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameterIsArray:params error:&err];
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    NSArray* operateOn = [MBMLFunction validateParameter:params isArrayAtIndex:0 error:&err];
    if (err) return err;
        
    NSMutableArray* tArray = [NSMutableArray arrayWithArray:operateOn];
    for (int i = 1; i < paramCnt; i++) {
        [tArray removeObject:params[i]];
    }
    return tArray;
}

+ (id) removeObjectAtIndex:(NSArray*)params
{
    debugTrace();
        
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameterIsArray:params error:&err];
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    NSArray* operateOn = [MBMLFunction validateParameter:params isArrayAtIndex:0 error:&err];
    NSNumber* indexNum = [MBMLFunction validateParameter:params containsNumberAtIndex:1 error:&err];
    if (err) return err;

    NSUInteger idx = [indexNum integerValue];
    [MBMLFunction validateParameter:operateOn indexIsInRange:idx error:&err];
    if (err) return err;

    NSMutableArray* tArray = [NSMutableArray arrayWithArray:operateOn];
    [tArray removeObjectAtIndex:idx];
    return tArray;
}

+ (id) appendObject:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameterIsArray:params error:&err];
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    NSArray* operateOn = [MBMLFunction validateParameter:params isArrayAtIndex:0 error:&err];
    if (err) return err;
    
    NSMutableArray* tArray = [NSMutableArray arrayWithArray:operateOn];
    for (int i=1; i<paramCnt; i++) {
        [tArray addObject:params[i]];
    }
    return tArray;
}

+ (id) insertObjectAtIndex:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:3 error:&err];
    NSArray* operateOn = [MBMLFunction validateParameter:params isArrayAtIndex:0 error:&err];
    NSNumber* indexNum = [MBMLFunction validateParameter:params containsNumberAtIndex:2 error:&err];
    if (err) return err;
    
    NSUInteger idx = [indexNum integerValue];
    [MBMLFunction validateParameter:operateOn indexIsInRange:idx error:&err];
    if (err) return err;

    NSMutableArray* tArray = [NSMutableArray arrayWithArray:operateOn];
    [tArray insertObject:params[1] atIndex:idx];
    return tArray;
}

+ (id) array:(NSArray*)params
{
    debugTrace();
    
    if (params) {
        return [params mutableCopy];
    }
    else {
        return [NSMutableArray array];
    }
}

+ (id) set:(NSArray*)params
{
    debugTrace();

    if (params) {
        return [NSMutableSet setWithArray:params];
    }
    else {
        return [NSMutableSet set];
    }
}

+ (id) dictionary:(NSArray*)params
{
    debugTrace();

    if (params) {
        NSUInteger paramCnt = params.count;
        if (paramCnt % 2 != 0) {
            return [MBMLFunctionError errorWithFormat:@"expected an even number of input parameters; instead, got %u", paramCnt];
        }
        
        NSNull* null = [NSNull null];
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        for (NSUInteger i=0; i<paramCnt-1; i+=2) {
            id key = [MBExpression asObject:params[i] defaultValue:null];
            id val = [MBExpression asObject:params[i+1] defaultValue:null];
            
            dict[key] = val;
        }
        return dict;
    }
    else {
        return [NSMutableDictionary dictionary];
    }
}

+ (id) keys:(NSDictionary*)dict
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameterIsDictionary:dict error:&err];
    if (err) return err;
    
    return [dict allKeys];
}

+ (id) values:(NSDictionary*)dict
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameterIsDictionary:dict error:&err];
    if (err) return err;
    
    return [dict allValues];
}

+ (id) removeLastObject:(id)input
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    
    NSArray* operateOn = [MBMLFunction validateParameterIsArray:input error:&err];
    
    if (err) return err;
    
    NSMutableArray* tArray = [NSMutableArray arrayWithArray:operateOn];
    
    [tArray removeLastObject];
    
    return tArray;
}

+ (id) lastObject:(id)input
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    
    NSArray* operateOn = [MBMLFunction validateParameterIsArray:input error:&err];
    
    if (err) return err;
    
    return [operateOn lastObject];
}

+ (id) indexOf:(NSArray*)params
{
    debugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;

    NSNull* null = [NSNull null];
    id objectsToTest = [MBExpression asObject:params[0] defaultValue:null];
    id valueToFind = [MBExpression asObject:params[1] defaultValue:null];

    if ([objectsToTest isKindOfClass:[NSNull class]] || [valueToFind isKindOfClass:[NSNull class]]) {
        return [MBMLFunctionError errorWithFormat:@"Expecting non-null parameters for array (%@) and value (%@)", objectsToTest, valueToFind];
    }
    else if (![objectsToTest isKindOfClass:[NSArray class]]) {
        return [MBMLFunctionError errorWithFormat:@"Expecting parameter 1 (%@) to contain a value with an array type (got %@ instead)", objectsToTest, [objectsToTest class]];
    }
    else {
        return [NSNumber numberWithInteger:[(NSArray*)objectsToTest indexOfObject:valueToFind]];
    }
}

+ (id) copyOf:(id)param
{
    debugTrace();
    
    if ([param conformsToProtocol:@protocol(NSCopying)]) {
        return [((id<NSCopying>)param) copyWithZone:nil];
    }
    else {
        return [MBMLFunctionError errorWithFormat:@"expected %@ to conform to %@", [param class], NSStringFromProtocol(@protocol(NSCopying))];
    }
}

+ (id) mutableCopyOf:(id)param
{
    debugTrace();
    
    if ([param conformsToProtocol:@protocol(NSMutableCopying)]) {
        return [((id<NSMutableCopying>)param) mutableCopyWithZone:nil];
    }
    else {
        return [MBMLFunctionError errorWithFormat:@"expected %@ to conform to %@", [param class], NSStringFromProtocol(@protocol(NSMutableCopying))];
    }
}

+ (id) getValueForKey:(NSArray *)params
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 andAtMost:3 error:&err];
    NSString* key = [MBMLFunction validateParameter:params isStringAtIndex:1 error:&err];
    if (err) return err;

    id operateOn = params[0];
    id retVal = nil;
    @try {
        retVal = [operateOn valueForKey:key];
    }
    @catch (NSException* ex) {
        // this can occur if the specified key is not supported
    }
    if (!retVal && paramCnt > 2) {
        retVal = params[2];
    }
    return retVal;
}

@end
