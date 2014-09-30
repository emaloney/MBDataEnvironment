//
//  MBMLMathFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/9/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <stdlib.h>
#import <MBToolbox/MBDebug.h>

#import "MBMLMathFunctions.h"
#import "MBExpression.h"
#import "MBMLFunction.h"

#define DEBUG_LOCAL             0

#define RANDOM_TYPE             long
#define RANDOM_MIN              ((RANDOM_TYPE)0)
#define RANDOM_MAX              ((RANDOM_TYPE)RAND_MAX)

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathFunctions implementation
/******************************************************************************/

@implementation MBMLMathFunctions

+ (void) initialize
{
    if (self == [MBMLMathFunctions class]) {
        srandom([NSDate timeIntervalSinceReferenceDate]);
    }
}

/******************************************************************************/
#pragma mark Private methods
/******************************************************************************/

+ (NSArray*) _flattenNumbersFromParameters:(NSArray*)params
                           startingAtIndex:(NSUInteger)startIdx
                         endingBeforeIndex:(NSUInteger)endingBefore
                                     error:(MBMLFunctionError**)errPtr
{
    MBMLFunctionError* err = nil;
    
    NSMutableArray* numbers = [NSMutableArray array];
    for (NSUInteger i=startIdx; i<endingBefore; i++) {
        id val = params[i];
        if ([val isKindOfClass:[NSArray class]]) {
            NSArray* flattened = [self _flattenNumbersFromParameters:val
                                                     startingAtIndex:0 
                                                   endingBeforeIndex:[val count]
                                                               error:&err];
            if (err) return nil;
            
            [numbers addObjectsFromArray:flattened];
        }
        else {
            NSDecimalNumber* numVal = [MBMLFunction validateParameter:params
                                                containsNumberAtIndex:i
                                                                error:&err];
            if (err) return nil;
            
            [numbers addObject:numVal];
        }
    }
    return numbers;
}

/******************************************************************************/
#pragma mark Calculation API
/******************************************************************************/

+ (id) performMathFunction:(MathTransformationFunctionBlock)funcBlock
            withParameters:(NSArray*)params
{
    MBMLFunctionError* err = nil;
    
    NSArray* numbers = [self _flattenNumbersFromParameters:params
                                           startingAtIndex:0
                                         endingBeforeIndex:params.count
                                                     error:&err];
    if (err) return err;
    
    NSUInteger numCnt = numbers.count;
    if (numCnt < 2)
        return [MBMLFunctionError errorWithMessage:@"expecting at least two valid numeric input parameters"];
    
    NSDecimalNumber* curVal = numbers[0];
    for (NSUInteger i=1; i<numCnt; i++) {
        curVal = funcBlock(curVal, numbers[i]);
    }
    return curVal;
}

/******************************************************************************/
#pragma mark Math calculations
/******************************************************************************/

+ (id) mod:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    
    return @([params[0] integerValue] % [params[1] integerValue]);
}

+ (id) modFloat:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    
    return @(fmod([params[0] doubleValue], [params[1] doubleValue]));
}

+ (id) ceil:(id)number
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSDecimalNumber* decimalNumber = [MBMLFunction validateParameterContainsNumber:number error:&err];
    if (err) {
        return err;
    }
    return @(ceil([decimalNumber doubleValue]));
}

+ (id) floor:(id)number
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSDecimalNumber* decimalNumber = [MBMLFunction validateParameterContainsNumber:number error:&err];
    if (err) {
        return err;
    }
    return @(floor([decimalNumber doubleValue]));
}

+ (id) round:(id)number
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSDecimalNumber* decimalNumber = [MBMLFunction validateParameterContainsNumber:number error:&err];
    if (err) {
        return err;
    }
    return @(round([decimalNumber doubleValue]));
}

+ (id) min:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    
    return [self performMathFunction:^(NSDecimalNumber* lVal, NSDecimalNumber* rVal){ return [lVal compare:rVal] == NSOrderedAscending ? lVal : rVal; }
                      withParameters:params];
}

+ (id) max:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    
    return [self performMathFunction:^(NSDecimalNumber* lVal, NSDecimalNumber* rVal){ return [lVal compare:rVal] == NSOrderedDescending ? lVal : rVal; }
                      withParameters:params];
}

/******************************************************************************/
#pragma mark Percent calculation
/******************************************************************************/

+ (id) percent:(NSArray*)params
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 andAtMost:3 error:&err];
    if (err) return err;

    BOOL hasFormatString = (paramCnt == 3);
    NSUInteger startIndex = (hasFormatString ? 1 : 0);
    NSNumber* num1 = [MBExpression asNumber:params[startIndex] error:&err];
    if (err) return err;
    if (!num1) {
        return [MBMLFunctionError errorWithFormat:@"expected %@ at index %u (expression: \"%@\") to contain a numeric value or math expression", kMBMLFunctionInputParameterName, startIndex, params[startIndex]];
    }
    NSNumber* num2 = [MBExpression asNumber:params[startIndex+1] error:&err];
    if (err) return err;
    if (!num2) {
        return [MBMLFunctionError errorWithFormat:@"expected %@ at index %u (expression: \"%@\") to contain a numeric value or math expression", kMBMLFunctionInputParameterName, startIndex+1, params[startIndex+1]];
    }
    NSString* formatString = @"%.0f%%";
    if (hasFormatString) {
        formatString = [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
        if (err) return err;
    }
    
    CGFloat num = [num1 doubleValue];
    CGFloat denom = [num2 doubleValue];
    return [NSString stringWithFormat:formatString, ((num*100)/denom)];
}

/******************************************************************************/
#pragma mark Randomness
/******************************************************************************/

+ (id) randomPercent
{
    return @(random() / RANDOM_MAX);
}

+ (id) random:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:1 andAtMost:2 error:&err];
    if (err) return err;
    
    NSNumber* param1 = [MBMLFunction validateParameter:params containsNumberAtIndex:0 error:&err];
    if (err) return err;

    NSNumber* param2 = nil;
    if (paramCnt > 1) {
        param2 = [MBMLFunction validateParameter:params containsNumberAtIndex:1 error:&err];
        if (err) return err;
    }
    
    RANDOM_TYPE lowerBounds = RANDOM_MIN;
    RANDOM_TYPE upperBounds = RANDOM_MAX;
    if (paramCnt == 1) {
        upperBounds = (RANDOM_TYPE)[param1 longValue];
    } else if (paramCnt == 2) {
        lowerBounds = (RANDOM_TYPE)[param1 longValue];
        upperBounds = (RANDOM_TYPE)[param2 longValue];
    }

    RANDOM_TYPE range = upperBounds - lowerBounds;
    RANDOM_TYPE rnd = random();
    RANDOM_TYPE result = (rnd % range) + lowerBounds;
    return @(result);
}

/******************************************************************************/
#pragma mark Filling an array with numbers
/******************************************************************************/

// params: ($startNum|$count|$step)
+ (id) arrayFilledWithIntegers:(NSArray*)params
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 andAtMost:3 error:&err];
    if (err) return err;

    NSNumber* startNum = [MBMLFunction validateParameter:params containsNumberAtIndex:0 error:&err];
    if (err) return err;
    NSInteger start = [startNum integerValue];

    NSNumber* countNum = [MBMLFunction validateParameter:params containsNumberAtIndex:1 error:&err];
    if (err) return err;
    NSInteger count = [countNum integerValue];

    NSInteger step = 1;
    if (paramCnt > 2) {
        NSNumber* stepNum = [MBMLFunction validateParameter:params containsNumberAtIndex:3 error:&err];
        if (err) return err;
        step = [stepNum integerValue];
    }

    NSMutableArray* array = [NSMutableArray arrayWithCapacity:(count / step) + 1];
    for (NSInteger i=start; i<=count; i += step) {
        [array addObject:@(i)];
    }
    return array;
}

@end
