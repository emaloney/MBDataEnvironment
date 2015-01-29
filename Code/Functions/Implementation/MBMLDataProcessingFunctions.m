//
//  MBMLDataProcessingFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 8/8/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import "MBMLDataProcessingFunctions.h"
#import "MBMLFunction.h"
#import "MBVariableSpace.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

// note that this assumes kComparisonValueName is @"comparisonValue"
// if the value of kComparisonValueName changes, this expression will
// need to be updated (and while you're at it, update this comment, too!)
#define kContainsValueTestExpression    @"$item -EQ $comparisonValue"

// possible values for the optional final parameter of ^filter()
#define kFilterMatchAtLeastOnce         @"matchAtLeastOnce"     // used if parameter is omitted
#define kFilterMatchAll                 @"matchAll"

// variable names used during comparisons & sorts
#define kLeftComparisonKey              @"left:key"
#define kLeftComparisonItem             @"left:item"
#define kRightComparisonKey             @"right:key"
#define kRightComparisonItem            @"right:item"

#define kComparisonValueName            @"comparisonValue"      // variable name containing a value against which another value is being compared
#define kCurrentValueName               @"currentValue"         // variable name for referencing the current value when reducing an array
#define kOuterItemPrefix                @"outer:"               //!< prefix of variable name for the object containing the current item in a recursive context

/******************************************************************************/
#pragma mark Type definitions
/******************************************************************************/

// determines how the values are associated with keys
typedef enum {
    AssociationReturnsSingleValue,          // the value of a given key will always be a single object instance
    AssociationAllowsMultipleValues,        // if multiple values map into a given key, an array of values is returned; otherwise, a single value is returned
    AssociationAlwaysReturnsArray           // an array is always returned, even if there is only one value for a given key
} AssociationValueHandling;

// determines how filters return results
typedef enum {
    FilterMatchAtLeastOnce,                 // filter will return any top-level item in the container where the filter expression matches at least once
    FilterMatchAll                          // filter will only return top-level items where the filter expression matches every time
} FilterMatchType;

@protocol MBObjectReceptacle <NSObject>
- (void) addObject:(id)obj;
@end

@interface NSMutableArray () <MBObjectReceptacle>
@end

@interface NSMutableSet () <MBObjectReceptacle>
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionSortContext private class
/******************************************************************************/

@interface MBExpressionSortContext : NSObject

@property(nonatomic, readonly) NSString* sortExpressionTemplate;
@property(nonatomic, strong) NSDictionary* dictionary;
@property(nonatomic, readonly) BOOL sortDictionaryValues;
@property(nonatomic, readonly) MBVariableSpace* vars;

+ (id) contextForSortKey:(NSString*)sortKey;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLDataProcessingFunctions implementation
/******************************************************************************/

@implementation MBMLDataProcessingFunctions

/******************************************************************************/
#pragma mark Private methods for handling "$outer:*" variables
/******************************************************************************/

+ (NSString*) _outerVariable:(NSString*)varName forDepth:(NSUInteger)depth
{
    NSMutableString* outerVarStr = [NSMutableString string];
    for (NSUInteger i=0; i<depth; i++) {
        [outerVarStr appendString:kOuterItemPrefix];
    }
    [outerVarStr appendString:varName];
    return outerVarStr;
}

+ (void) _pushOuterVariables:(NSUInteger)outerCount
{
    MBVariableSpace* vars = [MBVariableSpace instance];
    
    NSString* nextKeyVarName = [self _outerVariable:kMBMLVariableKey forDepth:outerCount];
    NSString* nextItemVarName = [self _outerVariable:kMBMLVariableItem forDepth:outerCount];
    for (NSInteger i=outerCount; i>0; i--) {
        NSString* thisKeyVarName = [self _outerVariable:kMBMLVariableKey forDepth:i-1];
        NSString* thisItemVarName = [self _outerVariable:kMBMLVariableItem forDepth:i-1];
        
        id moveKey = [vars variableForName:thisKeyVarName];
        id moveItem = [vars variableForName:thisItemVarName];
        
//        [vars pushVariable:nextKeyVarName value:moveKey];
//        [vars pushVariable:nextItemVarName value:moveItem];
        
        [vars setVariable:nextKeyVarName value:moveKey];
        [vars setVariable:nextItemVarName value:moveItem];
        
        nextKeyVarName = thisKeyVarName;
        nextItemVarName = thisItemVarName;
    }
}

+ (void) _popOuterVariables:(NSUInteger)outerCount
{
    /*
    MBVariableSpace* vars = [MBVariableSpace instance];
    
    for (NSInteger i=outerCount; i>=0; i--) {
        NSString* keyVarName = [self _outerVariable:kMBMLVariableKey forDepth:i];
        NSString* itemVarName = [self _outerVariable:kMBMLVariableItem forDepth:i];
        
        [vars popVariable:keyVarName];
        [vars popVariable:itemVarName];
    }
     */
}

/******************************************************************************/
#pragma mark Testing values in container objects
/******************************************************************************/

+ (id) containsValue:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    if (err) return err;
    
    MBVariableSpace* vars = [MBVariableSpace instance];

    BOOL retVal = NO;
    MBExpressionError* currentErr = nil;
    id comparisonValue = params[paramCnt-1];
    if (![comparisonValue isKindOfClass:[NSNull class]]) {
        [vars pushVariable:kComparisonValueName value:comparisonValue];
        for (NSUInteger i=0; i<paramCnt-1; i++) {
            id objectsToTest = params[i];
            if ([objectsToTest isKindOfClass:[NSNull class]]) {
                continue;
            }
            
            BOOL treatAsDict = [objectsToTest respondsToSelector:@selector(objectForKey:)];
            if (!treatAsDict && ![objectsToTest conformsToProtocol:@protocol(NSFastEnumeration)]) {
                currentErr = [MBMLFunctionError errorWithFormat:@"Expecting parameter %u (%@) to contain a value with an iterable type (got %@ instead)", (i+1), objectsToTest, [objectsToTest class]];
            }
            
            for (__strong id testObject in objectsToTest) {
                if (treatAsDict) {
                    [vars pushVariable:kMBMLVariableKey value:testObject];

                    // don't use modern Obj-C dictionary subscripting here
                    // since we may not have an actual dictionary
                    testObject = [(NSDictionary*)objectsToTest objectForKey:testObject];
                }
                
                [vars pushVariable:kMBMLVariableItem value:testObject];
                if ([MBExpression asBoolean:kContainsValueTestExpression]) {
                    retVal = YES;
                }
                [vars popVariable:kMBMLVariableItem];
                
                if (treatAsDict) {
                    [vars popVariable:kMBMLVariableKey];
                }
                
                if (retVal) {
                    break;
                }
            }
        }
        [vars popVariable:kComparisonValueName];
        
        if (currentErr) {
            return currentErr;
        }
    }
    return @(retVal);
}

+ (id) setContains:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    NSSet* operateOn = [MBMLFunction validateParameter:params objectAtIndex:0 isKindOfClass:[NSSet class] error:&err];
    if (err) return err;

    NSObject* testObj = params[1];
    return [NSNumber numberWithBool:[operateOn containsObject:testObj]];
}

+ (id) valuesPassingTest:(NSArray*)params
{
    debugTrace();
        
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    if (err) return err;
    
    MBVariableSpace* vars = [MBVariableSpace instance];

    NSString* testExpression = params[paramCnt-1];
    NSMutableArray* retVal = [NSMutableArray array];

    for (NSUInteger i=0; i<paramCnt-1; i++) {
        id objectsToTest = [MBExpression asObject:params[i]];

        BOOL treatAsDict = [objectsToTest respondsToSelector:@selector(objectForKey:)];
        if (!treatAsDict && ![objectsToTest conformsToProtocol:@protocol(NSFastEnumeration)]) {
            return [MBMLFunctionError errorWithFormat:@"Expecting parameter %u (%@) to contain a value with an iterable type (got %@ instead)", (i+1), objectsToTest, [objectsToTest class]];
        }

        for (__strong id testObject in objectsToTest) {
            if (treatAsDict) {
                [vars pushVariable:kMBMLVariableKey value:testObject];
                
                // don't use modern Obj-C dictionary subscripting here
                // since we may not have an actual dictionary
                testObject = [(NSDictionary*)objectsToTest objectForKey:testObject];
            }
            
            [vars pushVariable:kMBMLVariableItem value:testObject];
            if ([MBExpression asBoolean:testExpression]) {
                [retVal addObject:testObject];
            }
            [vars popVariable:kMBMLVariableItem];
            if (treatAsDict) {
                [vars popVariable:kMBMLVariableKey];
            }
        }
    }
    
    return retVal;
}

+ (id) collectionPassesTest:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    
    BOOL collectionPasses = NO;
    
    MBVariableSpace* vars = [MBVariableSpace instance];
        
    NSString* testExpression = params[1];
        
    id objectsToTest = [MBExpression asObject:params[0]];
    
    BOOL isDict = [objectsToTest isKindOfClass:[NSDictionary class]];

    for (__strong id testObject in objectsToTest) {
        if (isDict) {
            [vars pushVariable:kMBMLVariableKey value:testObject];
            testObject = ((NSDictionary*)objectsToTest)[testObject];
        }
        
        [vars pushVariable:kMBMLVariableItem value:testObject];
        BOOL matchFailed = ![MBExpression asBoolean:testExpression];
        [vars popVariable:kMBMLVariableItem];
        if (isDict) {
            [vars popVariable:kMBMLVariableKey];
        }
        
        if (matchFailed) {
            return @NO;
        }
        collectionPasses = YES;
    }
    return @(collectionPasses);
}

/******************************************************************************/
#pragma mark Set-like operations
/******************************************************************************/

+ (id) valuesIntersect:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;

    NSArray* containerClasses = @[[NSSet class], [NSDictionary class], [NSArray class]];
    [MBMLFunction validateParameter:params objectAtIndex:0 isOneKindOfClass:containerClasses error:&err];
    if (err) return err;

    [MBMLFunction validateParameter:params objectAtIndex:1 isOneKindOfClass:containerClasses error:&err];
    if (err) return err;

    id srcSet1 = params[0];
    NSSet* set1 = srcSet1;
    if ([srcSet1 isKindOfClass:[NSArray class]]) {
        set1 = [NSSet setWithArray:srcSet1];
    } else if ([srcSet1 isKindOfClass:[NSDictionary class]]) {
        set1 = [NSSet setWithArray:[srcSet1 allValues]];
    }

    id srcSet2 = params[1];
    NSSet* set2 = srcSet2;
    if ([srcSet2 isKindOfClass:[NSArray class]]) {
        set2 = [NSSet setWithArray:srcSet2];
    } else if ([srcSet2 isKindOfClass:[NSDictionary class]]) {
        set2 = [NSSet setWithArray:[srcSet2 allValues]];
    }

    return @([set1 intersectsSet:set2]);
}

/******************************************************************************/
#pragma mark Constructing strings from values
/******************************************************************************/

+ (id) join:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    NSString* separator = [MBMLFunction validateParameter:params isStringAtIndex:paramCnt - 1 error:&err];
    if (err) return err;

    BOOL useSeparator = NO;
    NSMutableString* retVal = [NSMutableString string];
    for (NSUInteger i=0; i<paramCnt-1; i++) {
        id extractFrom = params[i];

        BOOL treatAsDict = [extractFrom respondsToSelector:@selector(objectForKey:)];
        if (!treatAsDict && ![extractFrom conformsToProtocol:@protocol(NSFastEnumeration)]) {
            return [MBMLFunctionError errorWithFormat:@"Expecting parameter %d (%@) to contain a value with an iterable type (got %@ instead)", (i+1), extractFrom, [extractFrom class]];
        }

        for (__strong id element in extractFrom) {
            if (treatAsDict) {
                // don't use modern Obj-C dictionary subscripting here
                // since we may not have an actual dictionary
                element = [(NSDictionary*)extractFrom objectForKey:element];
            }
            if (useSeparator) {
                [retVal appendString:separator];
            }
            else {
                useSeparator = YES;
            }
            [retVal appendString:[element description]];
        }
    }
    return retVal;
}

/******************************************************************************/
#pragma mark String splitting
/******************************************************************************/

+ (id) split:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError *err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    
    NSString* delimiter = [MBExpression asString:params[0]];
    NSString* stringToSplit = [MBExpression asString:params[1]];
    return [stringToSplit componentsSeparatedByString:delimiter];
}

+ (id) splitLines:(NSString*)stringToSplit
{
    debugTrace();
    
    return [stringToSplit componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

/******************************************************************************/
#pragma mark Array manipulation
/******************************************************************************/

+ (id) appendArrays:(NSArray*)params
{
    debugTrace();

    MBMLFunctionError *err = nil;
    [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    if (err) return err;

    NSMutableArray* retVal = [NSMutableArray array];
    for (NSUInteger i=0; i<params.count; i++) {
        NSArray* array = params[i];
        if ([array isKindOfClass:[NSArray class]]) {
            [retVal addObjectsFromArray:array];
        }
        else {
            return [MBMLFunctionError errorWithFormat:@"Expecting parameter %d (%@) to contain a value with an array type (got %@ instead)", (i+1), array, [array class]];
        }
    }
    return retVal;
}

+ (void) _flatten:(id)toFlatten into:(NSMutableArray*)putInto depth:(NSUInteger)depth
{
    if ([toFlatten conformsToProtocol:@protocol(NSFastEnumeration)]) {
        for (id element in toFlatten) {
            [self _flatten:element into:putInto depth:depth + 1];
        }
    }
    else {
        if (depth > 1 || toFlatten != [NSNull null]) {
            [putInto addObject:toFlatten];
        }
    }
}

+ (id) flattenArrays:(NSArray*)params
{
    debugTrace();

    MBMLFunctionError* err = nil;
    for (NSUInteger i=0; i<params.count; i++) {
        [MBMLFunction validateParameter:params[i] isArrayAtIndex:i error:&err];
        if (err) return err;
    }

    NSMutableArray* retVal = [NSMutableArray array];
    [self _flatten:params into:retVal depth:0];
    return retVal;
}

/******************************************************************************/
#pragma mark Filter the contents of a container
/******************************************************************************/

+ (BOOL) _filterIntermediate:(NSArray*)intermediates
                     atIndex:(NSUInteger)intermediateIndex
             usingExpression:(NSString*)matchExpression
                   matchType:(FilterMatchType)matchType
                       error:(inout MBExpressionError**)errPtr
{
    NSString* intermediateExpr = intermediates[intermediateIndex];
    id container = [MBExpression asObject:intermediateExpr];
    if (!container) {
        MBMLFunctionError* err = [MBMLFunctionError errorWithFormat:@"Expecting expression \"%@\" to resolve to an object value (got nil instead)", intermediateExpr];
        [err reportErrorTo:errPtr];
        return NO;
    }
    
    BOOL treatAsDict = [container respondsToSelector:@selector(objectForKey:)];
    if (!treatAsDict && ![container conformsToProtocol:@protocol(NSFastEnumeration)]) {
        MBMLFunctionError* err = [MBMLFunctionError errorWithFormat:@"Expecting expression \"%@\" to resolve to an iterable type (got %@ instead)", intermediateExpr, [container class]];
        [err reportErrorTo:errPtr];
        return NO;
    }

    if (intermediateIndex > 0) {
        [self _pushOuterVariables:intermediateIndex];
    }
    NSUInteger intermediatesCnt = intermediates.count;
    
    BOOL shouldReturn = NO;
    BOOL retVal = NO;
    MBVariableSpace* vars = [MBVariableSpace instance];
    for (__strong id val in container) {
        if (treatAsDict) {
            [vars pushVariable:kMBMLVariableKey value:val];

            // don't use modern Obj-C dictionary subscripting here
            // since we may not have an actual dictionary
            val = [(NSDictionary*)container objectForKey:val];
        }
        [vars pushVariable:kMBMLVariableItem value:val];
        
        if (intermediateIndex == intermediatesCnt - 1) {
            BOOL thisMatched = [MBExpression asBoolean:matchExpression];
            if (matchType == FilterMatchAtLeastOnce) {
                if (thisMatched) {
                    shouldReturn = YES;
                    retVal = YES;
                }
            }
            else if (matchType == FilterMatchAll) {
                if (!thisMatched) {
                    shouldReturn = YES;
                    retVal = NO;
                }
            }
        }
        else {
            shouldReturn = YES;
            
            retVal = [self _filterIntermediate:intermediates
                                       atIndex:intermediateIndex+1
                               usingExpression:matchExpression
                                     matchType:matchType
                                         error:errPtr];
        }
        
        [vars popVariable:kMBMLVariableItem];
        if (treatAsDict) {
            [vars popVariable:kMBMLVariableKey];
        }
        
        if (shouldReturn) {
            break;
        }
    }
    
    if (intermediateIndex > 0) {
        [self _popOuterVariables:intermediateIndex];
    }
    
    if (!shouldReturn) {
        retVal = (matchType == FilterMatchAll ? YES : NO);
    }
    
    return retVal;
}

+ (void) _filterDictionary:(NSDictionary*)dataModel
                      into:(NSMutableDictionary*)retVal
           usingExpression:(NSString*)matchExpression
             intermediates:(NSArray*)intermediates
                 matchType:(FilterMatchType)matchType
                     error:(inout MBExpressionError**)errPtr
{
    MBExpressionError* currentErr = nil;
    MBVariableSpace* vars = [MBVariableSpace instance];
    for (id key in dataModel) {
        id val = dataModel[key];
        [vars pushVariable:kMBMLVariableKey value:key];
        [vars pushVariable:kMBMLVariableItem value:val];
        
        BOOL add = NO;
        if (intermediates) {
            [vars pushVariable:kMBMLVariableRootKey value:key];
            [vars pushVariable:kMBMLVariableRoot value:val];
            
            add = [self _filterIntermediate:intermediates
                                    atIndex:0
                            usingExpression:matchExpression
                                  matchType:matchType
                                      error:&currentErr];
            
            [vars popVariable:kMBMLVariableRootKey];
            [vars popVariable:kMBMLVariableRoot];
        }
        else {
            add = [MBExpression asBoolean:matchExpression];
        }
        if (add) {
            retVal[key] = val;
        }
        
        [vars popVariable:kMBMLVariableKey];
        [vars popVariable:kMBMLVariableItem];
        
        if (currentErr) {
            [currentErr reportErrorTo:errPtr];
            return;
        }
    }
}

+ (void) _filterList:(NSObject<NSFastEnumeration>*)dataModel
                into:(NSObject<MBObjectReceptacle>*)retVal
     usingExpression:(NSString*)matchExpression
       intermediates:(NSArray*)intermediates
           matchType:(FilterMatchType)matchType
               error:(inout MBExpressionError**)errPtr
{
    MBExpressionError* currentErr = nil;
    MBVariableSpace* vars = [MBVariableSpace instance];
    for (id val in dataModel) {
        [vars pushVariable:kMBMLVariableItem value:val];
        
        BOOL add = NO;
        if (intermediates) {
            [vars pushVariable:kMBMLVariableRoot value:val];
            
            add = [self _filterIntermediate:intermediates
                                    atIndex:0
                            usingExpression:matchExpression
                                  matchType:matchType
                                      error:&currentErr];
            
            [vars popVariable:kMBMLVariableRoot];
        }
        else {
            add = [MBExpression asBoolean:matchExpression];
        }
        if (add) {
            [retVal addObject:val];
        }
        
        [vars popVariable:kMBMLVariableItem];

        if (currentErr) {
            [currentErr reportErrorTo:errPtr];
            return;
        }
    }
}

+ (id) filter:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    if (err) return err;

    FilterMatchType matchType = FilterMatchAtLeastOnce;
    BOOL hasMatchParam = NO;
    NSString* matchParameter = params[paramCnt-1];
    if ([kFilterMatchAtLeastOnce isEqualToString:matchParameter]) {
        hasMatchParam = YES;
    }
    else if ([kFilterMatchAll isEqualToString:matchParameter]) {
        hasMatchParam = YES;
        matchType = FilterMatchAll;
    }
    
    if (hasMatchParam) {
        [MBMLFunction validateParameter:params countIsAtLeast:3 error:&err];
        if (err) return err;
    }
    NSString* matchExpression = params[paramCnt - (hasMatchParam ? 2 : 1)];
    
    NSUInteger intermediateCnt = 0;
    if ((hasMatchParam && paramCnt > 3) || (!hasMatchParam && paramCnt > 2)) {
        intermediateCnt = paramCnt - (hasMatchParam ? 3 : 2);
    }
    NSArray* intermediates = nil;
    if (intermediateCnt > 0) {
        intermediates = [params subarrayWithRange:NSMakeRange(1, intermediateCnt)];
    }
    
    id retVal = nil;
    MBExpressionError* currentErr = nil;
    NSString* dataModelExpr = params[0];
    id dataModel = [MBExpression asObject:dataModelExpr];
    if ([dataModel isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        [self _filterDictionary:dataModel 
                           into:dict
                usingExpression:matchExpression
                  intermediates:intermediates
                      matchType:matchType
                          error:&currentErr];
        
        retVal = dict;
    }
    else if ([dataModel isKindOfClass:[NSArray class]]) {
        NSMutableArray* array = [NSMutableArray new];

        [self _filterList:dataModel
                     into:array
          usingExpression:matchExpression
            intermediates:intermediates
                matchType:matchType
                    error:&currentErr];

        retVal = array;
    }
    else if ([dataModel isKindOfClass:[NSSet class]]) {
        NSMutableSet* set = [NSMutableSet new];

        [self _filterList:dataModel
                     into:set
          usingExpression:matchExpression
            intermediates:intermediates
                matchType:matchType
                    error:&currentErr];

        retVal = set;
    }
    else {
        currentErr = [MBMLFunctionError errorWithFormat:@"Expecting a filterable data model object (array, dictionary or set); instead got %@ from expression \"%@\"", [dataModel class], dataModelExpr];
    }
    if (currentErr) {
        return currentErr;
    }
    return retVal;
}

+ (id) unique:(id)param
{
    debugTrace();

    if (![param conformsToProtocol:@protocol(NSFastEnumeration)]) {
        return [MBMLFunctionError errorWithFormat:@"Expecting the input parameter to conform to NSFastEnumeration; got a %@ instance instead", [param class]];
    }

    NSMutableArray* retVal = [NSMutableArray array];
    NSMutableSet* found = [NSMutableSet new];           // optimization to avoid having to scan large arrays
    for (id val in (NSObject<NSFastEnumeration>*)param) {
        if (![found containsObject:val]) {
            [found addObject:val];
            [retVal addObject:val];
        }
    }
    return retVal;
}

/******************************************************************************/
#pragma mark Collect values into an array
/******************************************************************************/

+ (void) _list:(NSObject<NSFastEnumeration>*)collectFrom 
          into:(NSMutableArray*)collection 
keyExpressions:(NSArray*)keyExprs 
  keyExprIndex:(NSUInteger)keyExprIdx
         error:(inout MBExpressionError**)errPtr
{
    if (!collectFrom) {
        return;
    }

    NSString* keyExpr = keyExprs[keyExprIdx];

    BOOL treatAsDict = [collectFrom respondsToSelector:@selector(objectForKey:)];
    if (!treatAsDict && ![collectFrom conformsToProtocol:@protocol(NSFastEnumeration)]) {
        MBMLFunctionError* err = [MBMLFunctionError errorWithFormat:@"Expecting expression \"%@\" to resolve to an iterable type (got %@ instead)", keyExpr, [collectFrom class]];
        [err reportErrorTo:errPtr];
        return;
    }

    MBVariableSpace* vars = [MBVariableSpace instance];
    for (__strong id item in collectFrom) {
        if (treatAsDict) {
            [vars pushVariable:kMBMLVariableKey value:item];
            if (keyExprIdx == 1) {
                [vars pushVariable:kMBMLVariableRootKey value:item];
            }

            // don't use modern Obj-C dictionary subscripting here
            // since we may not have an actual dictionary
            item = [(NSDictionary*)collectFrom objectForKey:item];
        }
        
        [vars pushVariable:kMBMLVariableItem value:item];
        if (keyExprIdx == 1) {
            [vars pushVariable:kMBMLVariableRoot value:item];
        }
        id keyVal = [MBExpression asObject:keyExpr];
        
        if (keyVal) {
            if (keyExprIdx < keyExprs.count-1) {
                [self _list:keyVal 
                       into:collection
             keyExpressions:keyExprs 
               keyExprIndex:keyExprIdx+1
                      error:errPtr];
            }
            else {
                [collection addObject:keyVal];
            }
        }
        
        [vars popVariable:kMBMLVariableItem];
        if (treatAsDict) {
            [vars popVariable:kMBMLVariableKey];
            if (keyExprIdx == 1) {
                [vars popVariable:kMBMLVariableRootKey];
            }
        }
        if (keyExprIdx == 1) {
            [vars popVariable:kMBMLVariableRoot];
        }
    }
}

+ (id) list:(NSArray*)params
{
    debugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    if (err) return err;
    
    NSMutableArray* retVal = [NSMutableArray array];
    
    id rootObjects = [MBExpression asObject:params[0]];
    [self _list:rootObjects into:retVal keyExpressions:params keyExprIndex:1 error:&err]; 
    if (err) return err;

    return retVal;
}

/******************************************************************************/
#pragma mark Map values into a dictionary
/******************************************************************************/

+ (void) _mapItem:(id)item 
             into:(NSMutableDictionary*)map
    valueHandling:(AssociationValueHandling)valueHandling
   keyExpressions:(NSArray*)keyExprs
         keyIndex:(NSUInteger)keyExprIdx
            error:(inout MBExpressionError**)errPtr
{
    NSUInteger exprCount = keyExprs.count;
    
    MBVariableSpace* vars = [MBVariableSpace instance];

    [vars pushVariable:kMBMLVariableItem value:item];
    
    NSString* keyExpr = keyExprs[keyExprIdx];
    id keyVal = [MBExpression asObject:keyExpr];
    if (keyVal) {
        if (keyExprIdx < exprCount-2) {
            BOOL treatAsDict = [keyVal respondsToSelector:@selector(objectForKey:)];
            if (!treatAsDict && ![keyVal conformsToProtocol:@protocol(NSFastEnumeration)]) {
                MBMLFunctionError* err = [MBMLFunctionError errorWithFormat:@"Expecting expression \"%@\" to resolve to an iterable type (got %@ instead)", keyExpr, [keyVal class]];
                [err reportErrorTo:errPtr];
            }
            else {
                [self _pushOuterVariables:keyExprIdx];
                for (__strong id nextItem in keyVal) {
                    if (treatAsDict) {
                        [vars pushVariable:kMBMLVariableKey value:nextItem];

                        // don't use modern Obj-C dictionary subscripting here
                        // since we may not have an actual dictionary
                        nextItem = [(NSDictionary*)keyVal objectForKey:nextItem];
                    }
                    [self _mapItem:nextItem into:map valueHandling:valueHandling keyExpressions:keyExprs keyIndex:keyExprIdx+1 error:errPtr];
                    if (treatAsDict) {
                        [vars popVariable:kMBMLVariableKey];
                    }
                }
                [self _popOuterVariables:keyExprIdx];
            }
        }
        else {
            NSString* mapValExpr = keyExprs[exprCount-1];
            id mapValObject = [MBExpression asObject:mapValExpr];
            
            if (mapValObject) {
                if (valueHandling == AssociationReturnsSingleValue) {
                    map[keyVal] = mapValObject;
                }
                else {
                    id curVal = map[keyVal];
                    if (curVal) {
                        // key already has a value; check to see what to do with it
                        if ([curVal isKindOfClass:[NSArray class]]) {
                            curVal = [curVal mutableCopy];
                            [(NSMutableArray*)curVal addObject:mapValObject];
                            map[keyVal] = curVal;
                        }
                        else {
                            NSMutableArray* values = [NSMutableArray new];
                            [values addObject:curVal];
                            [values addObject:mapValObject];
                            map[keyVal] = values;
                        }
                    }
                    else {
                        // no value currently exists for this key
                        if (valueHandling == AssociationAlwaysReturnsArray) {
                            NSMutableArray* values = [NSMutableArray new];
                            [values addObject:mapValObject];
                            map[keyVal] = values;
                        }
                        else {
                            map[keyVal] = mapValObject;
                        }
                    }
                }
            }
        }
    }
    
    [vars popVariable:kMBMLVariableItem];
}

+ (id) _associate:(NSArray*)params valueHandling:(AssociationValueHandling)valueHandling
{
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIsAtLeast:3 error:&err];
    if (err) return err;
    
    NSString* rootObjExpr = params[0];
    NSArray* rootObjects = [MBExpression asObject:rootObjExpr];
    if (!rootObjects) {
        return [MBMLFunctionError errorWithFormat:@"Expecting expression \"%@\" to resolve to an object value (got nil instead)", rootObjExpr];
    }
    
    BOOL treatAsDict = [rootObjects respondsToSelector:@selector(objectForKey:)];
    if (!treatAsDict && ![rootObjects conformsToProtocol:@protocol(NSFastEnumeration)]) {
        return [MBMLFunctionError errorWithFormat:@"Expecting expression \"%@\" to resolve to an iterable type (got %@ instead)", rootObjExpr, [rootObjects class]];
    }

    MBVariableSpace* vars = [MBVariableSpace instance];
    NSMutableDictionary* retVal = [NSMutableDictionary dictionary];

    for (__strong id root in rootObjects) {
        if (treatAsDict) {
            [vars pushVariable:kMBMLVariableKey value:root];
            [vars pushVariable:kMBMLVariableRootKey value:root];
            
            // don't use modern Obj-C dictionary subscripting here
            // since we may not have an actual dictionary
            root = [(NSDictionary*)rootObjects objectForKey:root];
        }
        [vars pushVariable:kMBMLVariableRoot value:root];
        
        MBExpressionError* currentErr = nil;
        [self _mapItem:root 
                  into:retVal
         valueHandling:valueHandling
        keyExpressions:params
              keyIndex:1
                 error:&currentErr];
        
        [vars popVariable:kMBMLVariableRoot];
        if (treatAsDict) {
            [vars popVariable:kMBMLVariableKey];
            [vars popVariable:kMBMLVariableRootKey];
        }
        
        if (currentErr) {
            return currentErr;
        }
    }
    
    return retVal;
}

+ (id) associate:(NSArray*)params
{
    debugTrace();

    return [self _associate:params valueHandling:AssociationAllowsMultipleValues];
}

+ (id) associateWithSingleValue:(NSArray*)params
{
    debugTrace();

    return [self _associate:params valueHandling:AssociationReturnsSingleValue];
}

+ (id) associateWithArray:(NSArray*)params
{
    debugTrace();

    return [self _associate:params valueHandling:AssociationAlwaysReturnsArray];
}

/******************************************************************************/
#pragma mark Constructing sorted arrays
/******************************************************************************/

NSComparisonResult expressionSort(id left, id right, MBExpressionSortContext* ctxt, NSComparisonResult ltResult, NSComparisonResult gtResult)
{
    MBVariableSpace* vars = ctxt.vars;
    
    BOOL isDict = ctxt.sortDictionaryValues;
    if (isDict) {
        id lVal = (ctxt.dictionary)[left];
        id rVal = (ctxt.dictionary)[right];

        [vars pushVariable:kLeftComparisonItem value:lVal];
        [vars pushVariable:kLeftComparisonKey value:left];

        [vars pushVariable:kRightComparisonItem value:rVal];
        [vars pushVariable:kRightComparisonKey value:right];
    }
    else {
        [vars pushVariable:kLeftComparisonItem value:left];
        [vars pushVariable:kRightComparisonItem value:right];
    }
    
    NSComparisonResult retVal = 0;
    if ([MBExpression asBoolean:[NSString stringWithFormat:ctxt.sortExpressionTemplate, @"-EQ"]]) {
        retVal = NSOrderedSame;
    }
    else if ([MBExpression asBoolean:[NSString stringWithFormat:ctxt.sortExpressionTemplate, @"-LT"]]) {
        retVal = ltResult;
    }
    else {
        retVal = gtResult;
    }
    
    [vars popVariable:kLeftComparisonItem];
    [vars popVariable:kRightComparisonItem];
    if (isDict) {
        [vars popVariable:kLeftComparisonKey];
        [vars popVariable:kRightComparisonKey];
    }
    
    return retVal;
}

NSComparisonResult expressionSortAsc(id left, id right, void* ctxt)
{
    return expressionSort(left, right, (__bridge MBExpressionSortContext*)ctxt, NSOrderedAscending, NSOrderedDescending);
}

NSComparisonResult expressionSortDesc(id left, id right, void* ctxt)
{
    return expressionSort(left, right, (__bridge MBExpressionSortContext*)ctxt, NSOrderedDescending, NSOrderedAscending);
}

+ (id) reverse:(id)param
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSArray* toReverse = [MBMLFunction validateParameterIsArray:param error:&err];
    if (err) return err;

    NSMutableArray* reversed = [NSMutableArray arrayWithCapacity:toReverse.count];
    for (id obj in toReverse.reverseObjectEnumerator) {
        [reversed addObject:obj];
    }
    return reversed;
}

+ (id) sort:(NSArray*)params
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:1 andAtMost:3 error:&err];
    if (err) return err;
    
    BOOL asc = YES;
    if (paramCnt > 2) {
        NSString* sortOrderStr = [MBExpression asString:params[2]];
        asc = ([sortOrderStr caseInsensitiveCompare:@"desc"] != NSOrderedSame);
    }
    
    NSString* containerExpr = params[0];
    id container = [MBExpression asObject:containerExpr];
    if (!container) {
        return [MBMLFunctionError errorWithFormat:@"Expecting expression \"%@\" to resolve to an object value (got nil instead)", containerExpr];
    }
    
    BOOL isDict = [container isKindOfClass:[NSDictionary class]];
    if (!isDict && ![container conformsToProtocol:@protocol(NSFastEnumeration)]) {
        return [MBMLFunctionError errorWithFormat:@"Expecting parameter %d (%@) to contain a value with an iterable type (got %@ instead)", 1, containerExpr, [container class]];
    }
    
    NSString* sortKey = @"$item";
    if (paramCnt > 1) {
        sortKey = params[1];
    }
    MBExpressionSortContext* ctxt = [MBExpressionSortContext contextForSortKey:sortKey];
    if (isDict) {
        ctxt.dictionary = container;
        container = [container allKeys];
    }

    NSMutableArray* retVal = [container mutableCopy];

    if (asc) {
        [retVal sortUsingFunction:&expressionSortAsc context:(__bridge void*)ctxt];
    }
    else {
        [retVal sortUsingFunction:&expressionSortDesc context:(__bridge void*)ctxt];
    }
    
    if (isDict) {
        NSDictionary* dict = ctxt.dictionary;

        NSUInteger valCnt = retVal.count;
        for (NSUInteger i=0; i<valCnt; i++) {
            id key = retVal[i];
            id val = dict[key];
            retVal[i] = val;
        }
    }

    return retVal;
}

/******************************************************************************/
#pragma mark Dictionary manipulations
/******************************************************************************/

+ (id) mergeDictionaries:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    if (err) return err;

    NSMutableDictionary* retVal = [NSMutableDictionary dictionary];
    for (NSUInteger i=0; i<paramCnt; i++) {
        NSString* extractFromExpr = params[i];
        id extractFrom = [MBExpression asObject:extractFromExpr];
        BOOL isDict = [extractFrom isKindOfClass:[NSDictionary class]];
        if (isDict) {
            [retVal addEntriesFromDictionary:extractFrom];
        }
        else if (extractFrom) {
            return [MBMLFunctionError errorWithFormat:@"Expecting parameter %d (%@) to contain a value with an iterable type (got %@ instead)", (i+1), extractFromExpr, [extractFrom class]];
        }
    }
    return retVal;
}

/******************************************************************************/
#pragma mark Tree operations
/******************************************************************************/

+ (NSArray*) _addLeavesFrom:(NSArray*)leavesFrom testExpression:(NSString*)testExpr addIfTrue:(BOOL)addIfTrue
{
    MBVariableSpace* vars = [MBVariableSpace instance];

    NSMutableArray* passedTest = [NSMutableArray array];
    for (id item in leavesFrom) {
        if ([item isKindOfClass:[NSArray class]]) {
            NSArray* subTree = [self _addLeavesFrom:item testExpression:testExpr addIfTrue:addIfTrue];
            if (subTree.count > 0) {
                [passedTest addObject:subTree];
            }
        }
        else {
            [vars pushVariable:kMBMLVariableItem value:item];
            if ([MBExpression asBoolean:testExpr] == addIfTrue) {
                [passedTest addObject:item];
            }
            [vars popVariable:kMBMLVariableItem];
        }
    }
    
    return passedTest;
}

+ (id) _pruneLeaves:(NSArray*)params keepMatches:(BOOL)keepMatches
{
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    
    NSArray* srcItems = [MBMLFunction validateExpression:params isArrayAtIndex:0 error:&err];
    if (err) return err;
    
    return [self _addLeavesFrom:srcItems testExpression:params[1] addIfTrue:keepMatches];
}

+ (id) pruneMatchingLeaves:(NSArray*)params
{
    debugTrace();
 
    return [self _pruneLeaves:params keepMatches:NO];
}

+ (id) pruneNonmatchingLeaves:(NSArray*)params
{
    debugTrace();
    
    return [self _pruneLeaves:params keepMatches:YES];
}

/******************************************************************************/
#pragma mark Array manipulations
/******************************************************************************/

+ (id) distributeArrayElements:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    
    NSArray* srcItems = [MBMLFunction validateParameter:params isArrayAtIndex:0 error:&err];
    if (err) return err;

    NSNumber* returnCntNum = [MBMLFunction validateParameter:params containsNumberAtIndex:1 error:&err];
    if (err) return err;

    NSInteger returnCnt = [returnCntNum integerValue];
    if (returnCnt < 1) {
        return [MBMLFunctionError errorWithFormat:@"second parameter must be an integer with a value of 1 or greater (got %@ instead)", returnCntNum];
    }
    if (returnCnt == 1) {
        return srcItems;
    }
    
    NSMutableArray* retVal = [NSMutableArray arrayWithCapacity:returnCnt];
    for (NSInteger i=0; i<returnCnt; i++) {
        [retVal addObject:[NSMutableArray array]];
    }

    NSInteger srcCnt = srcItems.count;
    for (NSInteger i=0; i<srcCnt; i++) {
        id curObj = srcItems[i];
        NSMutableArray* addTo = retVal[i % returnCnt];
        [addTo addObject:curObj];
    }
    
    return retVal;
}

+ (id) groupArrayElements:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    
    NSArray* srcItems = [MBMLFunction validateParameter:params isArrayAtIndex:0 error:&err];
    if (err) return err;
    
    NSNumber* groupSizeNum = [MBMLFunction validateParameter:params containsNumberAtIndex:1 error:&err];
    if (err) return err;
    
    NSInteger groupSize = [groupSizeNum integerValue];
    if (groupSize < 1) {
        return [MBMLFunctionError errorWithFormat:@"second parameter must be an integer with a value of 1 or greater (got %@ instead)", groupSizeNum];
    }

    NSMutableArray* retVal = [NSMutableArray array];
    NSInteger srcCnt = srcItems.count;

    NSMutableArray* curGrp = nil;
    for (NSInteger i=0; i<srcCnt; i++) {
        if (i % groupSize == 0) {
            curGrp = [NSMutableArray array];
            [retVal addObject:curGrp];
        }
        [curGrp addObject:srcItems[i]];
    }
    return retVal;
}

+ (id) reduce:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:3 error:&err];
    if (err) return err;
    
    NSArray* items = [MBMLFunction validateExpression:params isArrayAtIndex:0 error:&err];
    if (err) return err;
    
    id value = [MBExpression asObject:params[1]];
    
    NSString* reduceExpression = params[2];
    
    NSInteger count = [items count];
                
    if(count > 0) {
        MBVariableSpace* vars = [MBVariableSpace instance];
        [vars pushVariable:kCurrentValueName value:value];
        for (id item in items) {
            [vars pushVariable:kMBMLVariableItem value:item];
            value = [MBExpression asObject:reduceExpression];
            [vars popVariable:kMBMLVariableItem];
            [vars popVariable:kCurrentValueName];
            [vars pushVariable:kCurrentValueName value:value];
        }
        [vars popVariable:kCurrentValueName];
    }
    
    return value;
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionSortContext implementation
/******************************************************************************/

@implementation MBExpressionSortContext

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (instancetype) initWithSortKey:(NSString*)sortKey
{
    self = [super init];
    if (self) {
        NSMutableString* sortExprL = [sortKey mutableCopy];
        NSMutableString* sortExprR = [sortKey mutableCopy];
        
        [sortExprL replaceOccurrencesOfString:@"$item" withString:@"$left:item" options:0 range:NSMakeRange(0, [sortExprL length])]; 
        [sortExprR replaceOccurrencesOfString:@"$item" withString:@"$right:item" options:0 range:NSMakeRange(0, [sortExprR length])]; 
        
        [sortExprL replaceOccurrencesOfString:@"$key" withString:@"$left:key" options:0 range:NSMakeRange(0, [sortExprL length])]; 
        [sortExprR replaceOccurrencesOfString:@"$key" withString:@"$right:key" options:0 range:NSMakeRange(0, [sortExprR length])]; 
        
        _sortExpressionTemplate = [NSString stringWithFormat:@"%@ %@ %@", sortExprL, @"%@", sortExprR];
        
        _vars = [MBVariableSpace instance];
    }
    return self;
}

+ (id) contextForSortKey:(NSString*)sortKey
{
    return [[MBExpressionSortContext alloc] initWithSortKey:sortKey];
}

/******************************************************************************/
#pragma mark Property handling
/******************************************************************************/

- (BOOL) sortDictionaryValues
{
    return (_dictionary != nil);
}

@end
