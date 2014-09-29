//
//  MBEvents+DataLoading.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 3/17/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBEvents.h>

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

extern NSString* const kMBEventSuffixWillRequestData;         // @"willRequestData"           // posted when a <FetchData> or ServerOp request is about to be sent
extern NSString* const kMBEventSuffixDataLoaded;              // @"dataLoaded"
extern NSString* const kMBEventSuffixDataLoadFailed;          // @"dataLoadFailed"

/******************************************************************************/
#pragma mark -
#pragma mark MBEvents class
/******************************************************************************/

@interface MBEvents (DataLoading)

/*----------------------------------------------------------------------------*/
#pragma mark Constructing event names
/*!    @name Constructing event names                                         */
/*----------------------------------------------------------------------------*/

+ (NSString*) willRequestDataEventName:(NSString*)name;
+ (NSString*) dataLoadedEventName:(NSString*)name;
+ (NSString*) dataLoadFailedEventName:(NSString*)name;

/*----------------------------------------------------------------------------*/
#pragma mark Posting specific events
/*!    @name Posting specific events                                          */
/*----------------------------------------------------------------------------*/

+ (void) postWillRequestData:(NSString*)name;
+ (void) postDataLoaded:(NSString*)name;
+ (void) postDataLoadFailed:(NSString*)name;

+ (void) postWillRequestData:(NSString*)name withEventObject:(id)eventObj;
+ (void) postDataLoaded:(NSString*)name withEventObject:(id)eventObj;
+ (void) postDataLoadFailed:(NSString*)name withEventObject:(id)eventObj;

@end
