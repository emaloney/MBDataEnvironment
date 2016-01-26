//
//  MBEvents+DataLoading.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 3/17/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

extern NSString* const __nonnull kMBEventSuffixWillRequestData;         // @"willRequestData"           // posted when a <FetchData> or ServerOp request is about to be sent
extern NSString* const __nonnull kMBEventSuffixDataLoaded;              // @"dataLoaded"
extern NSString* const __nonnull kMBEventSuffixDataLoadFailed;          // @"dataLoadFailed"

/******************************************************************************/
#pragma mark -
#pragma mark MBEvents class
/******************************************************************************/

/*!
 This `MBEvents` class category adds methods for managing events related to
 the asynchronous loading of data.
 */
@interface MBEvents (DataLoading)

/*----------------------------------------------------------------------------*/
#pragma mark Constructing event names
/*!    @name Constructing event names                                         */
/*----------------------------------------------------------------------------*/

/*!
 Constructs the name of the event that is fired when an asynchronous data
 load attempt is about to begin.
 
 @param     name The name of the data item being requested.
 
 @return    The name of the event fired when the data item named `name` is
            about to be requested.
 */
+ (nonnull NSString*) willRequestDataEventName:(nonnull NSString*)name;

/*!
 Constructs the name of the event that is fired when an asynchronous
 data load completes successfully.
 
 @param     name The name of the data item that was loaded.
 
 @return    The name of the event fired when the data item named `name` loads
            successfully.
 */
+ (nonnull NSString*) dataLoadedEventName:(nonnull NSString*)name;

/*!
 Constructs the name of the event that is fired when an asynchronous
 data load attempt fails.

 @param     name The name of the data item that failed to load.

 @return    The name of the event fired when the data item named `name` fails
            to load.
 */
+ (nonnull NSString*) dataLoadFailedEventName:(nonnull NSString*)name;

/*----------------------------------------------------------------------------*/
#pragma mark Posting specific events
/*!    @name Posting specific events                                          */
/*----------------------------------------------------------------------------*/

/*!
 Posts an event indicating that an asynchronous data load attempt is about
 to begin.
 
 The name of the `NSNotification` event fired is constructed based on the
 parameter `name`, and is constructed as: "*`name`*`:willRequestData`".
 
 In addition, when this event is fired, a boolean Mockingbird variable
 with the name "*`name`*`:requestPending`" will be set to `true`, and
 the value of the variable named "*`name`*`:lastRequestFailed`" will
 be unset.

 @param     name The name of the data item being requested.
 */
+ (void) postWillRequestData:(nonnull NSString*)name;

/*!
 Posts an event indicating that an asynchronous data load completed
 successfully.

 The name of the `NSNotification` event fired is constructed based on the
 parameter `name`, and is constructed as: "*`name`*`:dataLoaded`".

 In addition, when this event is fired, the Mockingbird variable
 with the name "*`name`*`:requestPending`" will be unset.

 @param     name The name of the data item that was loaded.
 */
+ (void) postDataLoaded:(nonnull NSString*)name;

/*!
 Posts an event indicating that an asynchronous data load failed.

 The name of the `NSNotification` event fired is constructed based on the
 parameter `name`, and is constructed as: "*`name`*`:dataLoadFailed`".

 In addition, when this event is fired, a boolean Mockingbird variable
 with the name "*`name`*`:lastRequestFailed`" will be set to `true`, and
 the value of the variable named "*`name`*`:requestPending`" will
 be unset.

 @param     name The name of the data item that failed to load.
 */
+ (void) postDataLoadFailed:(nonnull NSString*)name;

/*!
 Posts an event indicating that an asynchronous data load attempt is about
 to begin.
 
 The name of the `NSNotification` event fired is constructed based on the
 parameter `name`, and is constructed as: "*`name`*`:willRequestData`".
 
 In addition, when this event is fired, a boolean Mockingbird variable
 with the name "*`name`*`:requestPending`" will be set to `true`, and
 the value of the variable named "*`name`*`:lastRequestFailed`" will
 be unset.

 @param     name The name of the data item being requested.
 
 @param     eventObj An object to include as the value of the `NSNotification`'s
            `object` property.
 */
+ (void) postWillRequestData:(nonnull NSString*)name withEventObject:(nullable id)eventObj;

/*!
 Posts an event indicating that an asynchronous data load completed
 successfully.

 The name of the `NSNotification` event fired is constructed based on the
 parameter `name`, and is constructed as: "*`name`*`:dataLoaded`".

 In addition, when this event is fired, the Mockingbird variable
 with the name "*`name`*`:requestPending`" will be unset.

 @param     name The name of the data item that was loaded.
 
 @param     eventObj An object to include as the value of the `NSNotification`'s
            `object` property.
 */
+ (void) postDataLoaded:(nonnull NSString*)name withEventObject:(nullable id)eventObj;

/*!
 Posts an event indicating that an asynchronous data load failed.

 The name of the `NSNotification` event fired is constructed based on the
 parameter `name`, and is constructed as: "*`name`*`:dataLoadFailed`".

 In addition, when this event is fired, a boolean Mockingbird variable
 with the name "*`name`*`:lastRequestFailed`" will be set to `true`, and
 the value of the variable named "*`name`*`:requestPending`" will
 be unset.

 @param     name The name of the data item that failed to load.
 
 @param     eventObj An object to include as the value of the `NSNotification`'s
            `object` property.
 */
+ (void) postDataLoadFailed:(nonnull NSString*)name withEventObject:(nullable id)eventObj;

@end
