//
//  MBEvents+DataLoading.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 3/17/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

#import "MBEvents+DataLoading.h"
#import "MBVariableSpace.h"
#import "MBDataEnvironmentConstants.h"

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

NSString* const kMBEventSuffixWillRequestData           = @"willRequestData";
NSString* const kMBEventSuffixDataLoaded                = @"dataLoaded";
NSString* const kMBEventSuffixDataLoadFailed            = @"dataLoadFailed";

/******************************************************************************/
#pragma mark -
#pragma mark MBEvents implementation
/******************************************************************************/

@implementation MBEvents (DataLoading)

/******************************************************************************/
#pragma mark Getting names for parameterized events
/******************************************************************************/

+ (NSString*) willRequestDataEventName:(NSString*)name
{
    return [self name:name withSuffix:kMBEventSuffixWillRequestData];
}

+ (NSString*) dataLoadedEventName:(NSString*)name 
{
    return [self name:name withSuffix:kMBEventSuffixDataLoaded];
}

+ (NSString*) dataLoadFailedEventName:(NSString*)name
{
    return [self name:name withSuffix:kMBEventSuffixDataLoadFailed];
}

/******************************************************************************/
#pragma mark Sending events
/******************************************************************************/

+ (void) postWillRequestData:(NSString*)name
{
    [self postWillRequestData:name withEventObject:nil];
}

+ (void) postDataLoaded:(NSString*)name
{
    [self postDataLoaded:name withEventObject:nil];
}

+ (void) postDataLoadFailed:(NSString*)name
{
    [self postDataLoadFailed:name withEventObject:nil];
}

+ (void) postWillRequestData:(NSString*)name withEventObject:(id)eventObj
{
    if (name) {
        MBVariableSpace* vars = [MBVariableSpace instance];
        NSString* pendingVar = [self name:name withSuffix:kMBMLVariableSuffixRequestPending];
        NSString* failedVar = [self name:name withSuffix:kMBMLVariableSuffixLastRequestFailed];

        vars[pendingVar] = @(YES);
        [vars unsetVariable:failedVar];
        
        [self postEvent:[self willRequestDataEventName:name] withObject:eventObj];
    }
}

+ (void) postDataLoaded:(NSString*)name withEventObject:(id)eventObj
{
    if (name) {
        [[MBVariableSpace instance] unsetVariable:[self name:name withSuffix:kMBMLVariableSuffixRequestPending]];
        
        [self postEvent:[self dataLoadedEventName:name] withObject:eventObj];
    }
}

+ (void) postDataLoadFailed:(NSString*)name withEventObject:(id)eventObj
{
    if (name) {
        MBVariableSpace* vars = [MBVariableSpace instance];
        NSString* pendingVar = [self name:name withSuffix:kMBMLVariableSuffixRequestPending];
        NSString* failedVar = [self name:name withSuffix:kMBMLVariableSuffixLastRequestFailed];

        [vars unsetVariable:pendingVar];
        vars[failedVar] = @(YES);
        
        [self postEvent:[self dataLoadFailedEventName:name] withObject:eventObj];
    }
}

@end
