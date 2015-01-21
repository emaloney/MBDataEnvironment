//
//  MBDevice.h
//  Mockingbird Data Environment
//
//  Created by Jesse Boyes on 6/1/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBSingleton.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBDevice class
/******************************************************************************/

/*!
 The `MBDevice` singleton provides information about the device and operating
 environment of the running application.

 The `MBDevice` singleton is available by default as the Mockingbird variable
 `$Device`.

 @warning   You *must not* create instances of this class yourself; this class
            is a singleton. Call the `instance` class method (declared by the
            `MBSingleton` protocol) to acquire the singleton instance.
 */
@interface MBDevice : NSObject <MBSingleton>

/*----------------------------------------------------------------------------*/
#pragma mark Device information
/*!    @name Device information                                               */
/*----------------------------------------------------------------------------*/

/*! Returns `YES` when running in the iOS Simulator environment; `NO` when
    running on the device. */
@property(nonatomic, readonly) BOOL isSimulator;

/*! Returns `YES` when running in an iPhone environment. */
@property(nonatomic, readonly) BOOL isIPhone;

/*! Returns `YES` when running in an iPad environment. */
@property(nonatomic, readonly) BOOL isIPad;

/*----------------------------------------------------------------------------*/
#pragma mark Operating system information
/*!    @name Operating system information                                     */
/*----------------------------------------------------------------------------*/

/*! Returns a human-readable string indicating the operating system type, 
    eg. "`iPhone OS`". */
@property(nonatomic, readonly) NSString* osType;

/*! Returns the operating system version string, eg. "`8.1.3`" */
@property(nonatomic, readonly) NSString* osVersion;

/*! Returns the individual components of the operating system version as an
    array of `NSNumber`s, eg. [`8`, `1`, `3`]. */
@property(nonatomic, readonly) NSArray* osVersionComponents;

/*! Returns the major component of the operating system version, eg. the `8`
    in "`8.1.3`". */
@property(nonatomic, readonly) NSNumber* osVersionMajor;

/*! Returns the minor component of the operating system version, eg. the `1`
    in "`8.1.3`". */
@property(nonatomic, readonly) NSNumber* osVersionMinor;

/*! Returns the revision component of the operating system version, eg. the `3`
    in "`8.1.3`". */
@property(nonatomic, readonly) NSNumber* osVersionRevision;

/*----------------------------------------------------------------------------*/
#pragma mark Application state information
/*!    @name Application state information                                    */
/*----------------------------------------------------------------------------*/

/*! Returns `YES` if the application is currently in the background. */
@property(nonatomic, readonly) BOOL appIsInBackground;

/*----------------------------------------------------------------------------*/
#pragma mark Screen orientation information
/*!    @name Screen orientation information                                   */
/*----------------------------------------------------------------------------*/

/*! Returns the string "`portrait`" or "`landscape`" depending on the current
    orientation of the device. */
@property(nonatomic, readonly) NSString* currentOrientation;

/*! Returns `YES` if the device is currently in portrait orientation. */
@property(nonatomic, readonly) BOOL isPortrait;

/*! Returns `YES` if the device is currently in landscape orientation. */
@property(nonatomic, readonly) BOOL isLandscape;

/*----------------------------------------------------------------------------*/
#pragma mark Screen resolution information
/*!    @name Screen resolution information                                    */
/*----------------------------------------------------------------------------*/

/*! Returns the `scale` of the main `UIScreen`. */
@property(nonatomic, readonly) NSNumber* screenScale;

/*! Returns `YES` if the main `UIScreen`'s `scale` is `2.0` or greater. */
@property(nonatomic, readonly) BOOL isRetina;

/*! Returns the width of the main `UIScreen` in the current orientation. */
@property(nonatomic, readonly) NSNumber* screenWidth;

/*! Returns the height of the main `UIScreen` in the current orientation. */
@property(nonatomic, readonly) NSNumber* screenHeight;

/*! Returns a comma-separated string containing the width and height of the
    screen in the current orientation as "*`width`*`,`*`height`*". */
@property(nonatomic, readonly) NSString* screenSize;

/*! Returns a comma-separated string containing the width and height of the
    screen when the device is in portrait orientation. */
@property(nonatomic, readonly) NSString* screenSizePortrait;

/*! Returns a comma-separated string containing the width and height of the
    screen when the device is in landscape orientation. */
@property(nonatomic, readonly) NSString* screenSizeLandscape;

@end
