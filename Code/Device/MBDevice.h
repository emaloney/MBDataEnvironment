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
 
 @warning   You *must not* create instances of this class yourself; this class
            is a singleton. Call the `instance` class method (declared by the
            `MBSingleton` protocol) to acquire the singleton instance.
 */
@interface MBDevice : NSObject <MBSingleton>

- (BOOL) isSimulator;
- (BOOL) isIPhone;
- (BOOL) isIPad;

- (NSString*) osType;               // eg., "iPhone OS"
- (NSString*) osVersion;            // eg., "5.1.3"
- (NSArray*) osVersionComponents;   // eg., [5, 1, 3]
- (NSUInteger) osVersionMajor;      // eg., the "5" in 5.1.3
- (NSUInteger) osVersionMinor;      // eg., the "1" in 5.1.3
- (NSUInteger) osVersionRevision;   // eg., the "3" in 5.1.3

- (NSString*) currentOrientation;   // returns "portrait" or "landscape"; for use from within MBML
- (BOOL) isLandscape;
- (BOOL) isPortrait;

- (NSNumber*) screenWidth;
- (NSNumber*) screenHeight;
- (NSString*) screenSize;               // returns the size of the main screen, as a comma-separated string in the format "width,height"; for use from within MBML
- (NSString*) screenSizePortrait;
- (NSString*) screenSizeLandscape;

- (NSString*) contentFrame;
- (NSNumber*) contentWidth;
- (NSNumber*) contentHeight;
- (NSString*) contentSize;              // returns the size of the main screen's application frame, as a comma-separated string in the format "width,height"; for use from within MBML
- (NSString*) contentSizePortrait;
- (NSString*) contentSizeLandscape;

- (BOOL) isRetina;  // returns YES if the main UIScreen's scale is 2.0 or greater

- (BOOL) appIsInBackground;

@end
