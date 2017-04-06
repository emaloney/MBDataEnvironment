//
//  MBPlatform.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 6/26/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBSingleton.h>

/******************************************************************************/
#pragma mark Types
/******************************************************************************/

/*!
 The possible operating system types on which this code could run.
 */
typedef NS_ENUM(NSUInteger, MBPlatformType) {
    /*! The platform is not known. */
    MBPlatformTypeUnknown   = 0,

    /*! The platform runs macOS. */
    MBPlatformTypeMacOS     = 1,

    /*! The platform runs iOS. */
    MBPlatformTypeIOS       = 2,

    /*! The platform runs tvOS. */
    MBPlatformTypeTVOS      = 3,

    /*! The platform runs watchOS. */
    MBPlatformTypeWatchOS   = 4
};

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/
extern NSString* const __nonnull kMBPlatformUnknown;        // returned by `platformName` when `platformType == MBPlatformTypeUnknown`
extern NSString* const __nonnull kMBPlatformMacOS;          // returned by `platformName` when `platformType == MBPlatformTypeOSX`
extern NSString* const __nonnull kMBPlatformIOS;            // returned by `platformName` when `platformType == MBPlatformTypeIOS`
extern NSString* const __nonnull kMBPlatformTVOS;           // returned by `platformName` when `platformType == MBPlatformTypeAppleTV`
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
 is, `NO` otherwise. */
@property(nonatomic, readonly) MBPlatformType platformType;

/*! Returns a human-readable string containing the name of the platform on
 which the code is running. */
@property(nonnull, nonatomic, readonly) NSString* platformName;

/*! Determines whether the code is running on a macOS system; `YES` if it
    is, `NO` otherwise. */
@property(nonatomic, readonly) BOOL isMacOS;

/*! Determines whether the code is running on an iOS system; `YES` if it
    is, `NO` otherwise. */
@property(nonatomic, readonly) BOOL isIOS;

/*! Determines whether the code is running on an Apple TV (tvOS) system; 
 `YES` if it is, `NO` otherwise. */
@property(nonatomic, readonly) BOOL isTVOS;

/*! Determines whether the code is running on an Apple Watch (watchOS) system;
 `YES` if it is, `NO` otherwise. */
@property(nonatomic, readonly) BOOL isWatchOS;

/*! Determines whether the code is running on a UIKit-based system such as
 an iPhone, iPad or Apple TV; `YES` if it is, `NO` otherwise. */
@property(nonatomic, readonly) BOOL isUIKit;

@end
