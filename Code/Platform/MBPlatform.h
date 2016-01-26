//
//  MBPlatform.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 6/26/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

/******************************************************************************/
#pragma mark Types
/******************************************************************************/

/*!
 An `enum` containing the possible platform types on which this code could run.
 */
typedef NS_ENUM(NSUInteger, MBPlatformType) {
    MBPlatformTypeUnknown   = 0,
    MBPlatformTypeOSX       = 1,
    MBPlatformTypeIOS       = 2,
    MBPlatformTypeAppleTV   = 3,
    MBPlatformTypeWatchOS   = 4
};

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

extern NSString* const __nonnull kMBPlatformUnknown;        // returned by `platformName` when `platformType == MBPlatformTypeUnknown`
extern NSString* const __nonnull kMBPlatformOSX;            // returned by `platformName` when `platformType == MBPlatformTypeOSX`
extern NSString* const __nonnull kMBPlatformIOS;            // returned by `platformName` when `platformType == MBPlatformTypeIOS`
extern NSString* const __nonnull kMBPlatformAppleTV;        // returned by `platformName` when `platformType == MBPlatformTypeAppleTV`
extern NSString* const __nonnull kMBPlatformWatchOS;        // returned by `platformName` when `platformType == MBPlatformTypeWatchOS`

/******************************************************************************/
#pragma mark -
#pragma mark MBPlatform class
/******************************************************************************/

/*!
 The `MBPlatform` singleton provides a platform-independent mechanism for
 accessing information about the current execution environment.

 @warning   You *must not* create instances of this class yourself; this class
            is a singleton. Call the `instance` class method (declared by the
            `MBSingleton` protocol) to acquire the singleton instance.
 */
@interface MBPlatform : NSObject <MBSingleton>

/*----------------------------------------------------------------------------*/
#pragma mark Platform information
/*!    @name Platform information                                             */
/*----------------------------------------------------------------------------*/

/*! Determines whether the code is running on a Mac OS X system; `YES` if it
 is; `NO` otherwise. */
@property(nonatomic, readonly) MBPlatformType platformType;

/*! Returns a human-readable string containing the name of the platform on
 which the code is running. */
@property(nonnull, nonatomic, readonly) NSString* platformName;

/*! Determines whether the code is running on a Mac OS X system; `YES` if it
    is; `NO` otherwise. */
@property(nonatomic, readonly) BOOL isOSX;

/*! Determines whether the code is running on an iOS system; `YES` if it
    is; `NO` otherwise. */
@property(nonatomic, readonly) BOOL isIOS;

/*! Determines whether the code is running on an Apple TV system; `YES` if it
    is; `NO` otherwise. */
@property(nonatomic, readonly) BOOL isAppleTV;

/*! Determines whether the code is running on an watchOS system; `YES` if it
    is; `NO` otherwise. */
@property(nonatomic, readonly) BOOL isWatchOS;

@end
