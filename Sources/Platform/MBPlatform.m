//
//  MBPlatform.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 6/26/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBAvailability.h>

#import "MBPlatform.h"

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

NSString* const kMBPlatformUnknown  = @"unknown";
NSString* const kMBPlatformMacOS    = @"macOS";
NSString* const kMBPlatformIOS      = @"iOS";
NSString* const kMBPlatformTVOS     = @"tvOS";
NSString* const kMBPlatformWatchOS  = @"watchOS";

/******************************************************************************/
#pragma mark -
#pragma mark MBPlatform implementation
/******************************************************************************/

@implementation MBPlatform

MBImplementSingleton();

- (MBPlatformType) platformType
{
#if MB_BUILD_IOS
    return MBPlatformTypeIOS;
#elif MB_BUILD_MACOS
    return MBPlatformTypeMacOS;
#elif MB_BUILD_TVOS
    return MBPlatformTypeTVOS;
#elif MB_BUILD_WATCHOS
    return MBPlatformTypeWatchOS;
#else
    // support for MBPlatformTypeAppleTV is pending
    return MBPlatformTypeUnknown;
#endif
}

- (nonnull NSString*) platformName
{
    switch (self.platformType) {
        case MBPlatformTypeUnknown:     return kMBPlatformUnknown;
        case MBPlatformTypeMacOS:       return kMBPlatformMacOS;
        case MBPlatformTypeIOS:         return kMBPlatformIOS;
        case MBPlatformTypeTVOS:        return kMBPlatformTVOS;
        case MBPlatformTypeWatchOS:     return kMBPlatformWatchOS;
    }
}

- (BOOL) isMacOS
{
    return self.platformType == MBPlatformTypeMacOS;
}

- (BOOL) isOSX
{
    return self.isMacOS;
}

- (BOOL) isIOS
{
    return self.platformType == MBPlatformTypeIOS;
}

- (BOOL) isTVOS
{
    return self.platformType == MBPlatformTypeTVOS;
}

- (BOOL) isAppleTV
{
    return self.isTVOS;
}

- (BOOL) isWatchOS
{
    return self.platformType == MBPlatformTypeWatchOS;
}

- (BOOL) isUIKit
{
    return self.isIOS || self.isTVOS;
}

@end
