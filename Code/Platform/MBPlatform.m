//
//  MBPlatform.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 6/26/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBPlatform.h"

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

NSString* const kMBPlatformUnknown  = @"unknown";
NSString* const kMBPlatformOSX      = @"Mac OS X";
NSString* const kMBPlatformIOS      = @"iOS";
NSString* const kMBPlatformAppleTV  = @"Apple TV";
NSString* const kMBPlatformWatchOS  = @"watchOS";

/******************************************************************************/
#pragma mark -
#pragma mark MBPlatform implementation
/******************************************************************************/

@implementation MBPlatform

MBImplementSingleton();

- (MBPlatformType) platformType
{
#if MB_BUILD_OSX
    return MBPlatformTypeOSX;
#elif MB_BUILD_WATCH
    return kMBPlatformWatchOS;
#elif MB_BUILD_IOS
    return MBPlatformTypeIOS;
#else
    // support for MBPlatformTypeAppleTV is pending
    return MBPlatformTypeUnknown;
#endif
}

- (nonnull NSString*) platformName
{
    switch (self.platformType) {
        case MBPlatformTypeUnknown:     return kMBPlatformUnknown;
        case MBPlatformTypeOSX:         return kMBPlatformOSX;
        case MBPlatformTypeIOS:         return kMBPlatformIOS;
        case MBPlatformTypeAppleTV:     return kMBPlatformAppleTV;
        case MBPlatformTypeWatchOS:     return kMBPlatformWatchOS;
    }
}

- (BOOL) isOSX
{
    return self.platformType == MBPlatformTypeOSX;
}

- (BOOL) isIOS
{
    return self.platformType == MBPlatformTypeIOS;
}

- (BOOL) isAppleTV
{
    return self.platformType == MBPlatformTypeAppleTV;
}

- (BOOL) isWatchOS
{
    return self.platformType == MBPlatformTypeWatchOS;
}

@end
