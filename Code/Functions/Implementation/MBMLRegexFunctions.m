//
//  MBMLRegexFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>

#import "MBMLRegexFunctions.h"
#import "MBMLFunction.h"

#define DEBUG_LOCAL     0

@implementation MBMLRegexFunctions

+ (id) stripRegex:(NSArray*)params 
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    NSUInteger paramCnt = [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    if (err) return err;
    
    NSError* nsErr = nil;
    NSMutableString* retVal = [params[0] mutableCopy];
    for (NSInteger i=1; i<paramCnt; i++) {
        [retVal replaceRegexMatches:params[i] 
                       withTemplate:@""
                            options:0
                              range:NSMakeRange(0, retVal.length)
                              error:&nsErr];
        if (nsErr) {
            return [MBMLFunctionError errorWithFormat:@"received invalid regular expression in input parameter at index %u: \"%@\"", i, params[i]];
        }
    }
    return retVal;
}

+ (id) replaceRegex:(NSArray*)params 
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:3 error:&err];
    if (err) return err;
        
    NSMutableString* retVal = [params[0] mutableCopy];
    NSString* regex = params[1];
    NSString* template = params[2];
    
    NSError* nsErr = nil;
    [retVal replaceRegexMatches:regex
                   withTemplate:template
                        options:0
                          range:NSMakeRange(0, retVal.length)
                          error:&nsErr];
    if (nsErr) {
        return [MBMLFunctionError errorWithFormat:@"received invalid regular expression in input parameter at index 1: \"%@\"", regex];
    }
    
    return retVal;
}

+ (id) matchesRegex:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIsAtLeast:2 error:&err];
    if (err) return err;

    BOOL matches = NO;
    NSError* nsErr = nil;
    NSEnumerator *iter = [params objectEnumerator];
    NSString* test = [iter nextObject];
    for (NSString *param in iter) {
        matches = [test isMatchedByRegex:param
                                 options:0
                                   range:NSMakeRange(0, test.length)
                                   error:&nsErr];
        if (nsErr) {
            return [MBMLFunctionError errorWithFormat:@"received invalid regular expression in input parameter: '%@'", param];
        }
        if (!matches) {
            break;
        }
    }

    return @(matches);
}

@end
