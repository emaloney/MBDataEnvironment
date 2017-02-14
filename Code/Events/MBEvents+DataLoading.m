//
//  MBEvents+DataLoading.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 3/17/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>

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

+ (nonnull NSString*) willRequestDataEventName:(nonnull NSString*)name
{
    return [self name:name withSuffix:kMBEventSuffixWillRequestData];
}

+ (nonnull NSString*) dataLoadedEventName:(nonnull NSString*)name
{
    return [self name:name withSuffix:kMBEventSuffixDataLoaded];
}

+ (nonnull NSString*) dataLoadFailedEventName:(nonnull NSString*)name
{
    return [self name:name withSuffix:kMBEventSuffixDataLoadFailed];
}

/******************************************************************************/
#pragma mark Sending events
/******************************************************************************/

+ (void) postWillRequestData:(nonnull NSString*)name
{
    [self postWillRequestData:name withEventObject:nil];
}

+ (void) postDataLoaded:(nonnull NSString*)name
{
    [self postDataLoaded:name withEventObject:nil];
}

+ (void) postDataLoadFailed:(nonnull NSString*)name withError:(nonnull NSError*)error
{
    [self postDataLoadFailed:name withError:error eventObject:nil];
}

+ (void) postWillRequestData:(nonnull NSString*)name withEventObject:(nullable id)eventObj
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

+ (void) postDataLoaded:(nonnull NSString*)name withEventObject:(nullable id)eventObj
{
    if (name) {
        [[MBVariableSpace instance] unsetVariable:[self name:name withSuffix:kMBMLVariableSuffixRequestPending]];
        
        [self postEvent:[self dataLoadedEventName:name] withObject:eventObj];
    }
}

+ (void) postDataLoadFailed:(nonnull NSString*)name withError:(nonnull NSError*)error eventObject:(nullable id)eventObj
{
    if (name) {
        MBVariableSpace* vars = [MBVariableSpace instance];
        NSString* pendingVar = [self name:name withSuffix:kMBMLVariableSuffixRequestPending];
        NSString* failedVar = [self name:name withSuffix:kMBMLVariableSuffixLastRequestFailed];

        [vars unsetVariable:pendingVar];
        vars[failedVar] = @(YES);

        [vars pushVariable:kMBMLVariableError value:error];
        [self postEvent:[self dataLoadFailedEventName:name] withObject:eventObj];
        [vars popVariable:kMBMLVariableError];
    }
}

@end
