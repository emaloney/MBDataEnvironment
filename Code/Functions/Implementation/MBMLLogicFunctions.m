//
//  MBMLLogicFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/20/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import "MBMLLogicFunctions.h"
#import "MBExpression.h"
#import "MBMLFunction.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLLogicFunctions implementation
/******************************************************************************/

@implementation MBMLLogicFunctions

+ (id) ifOperator:(NSArray*)params
{
    debugTrace();

    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:1 andAtMost:3 error:&err];
    if (err) return err;
    
    if ([MBExpression asBoolean:params[0]]) {
        if (paramCnt > 1) {
            return [MBExpression asObject:params[1]];
        } else {
            return [MBExpression asObject:params[0]];
        }
    }
    if (paramCnt > 2) {
        return [MBExpression asObject:params[2]];
    }
    return nil;
}

+ (id) selectFirstValue:(NSArray*)params
{
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    if (err) return err;
    
    NSNull* null = [NSNull null];
    for (NSUInteger i=0; i<paramCnt; i++) {
        id value = [MBExpression asObject:params[i]];
        if (value && value != null) {
            return value;
        }
    }
    return nil;
}

@end
