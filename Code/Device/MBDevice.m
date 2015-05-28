//
//  MBDevice.m
//  Mockingbird Data Environment
//
//  Created by Jesse Boyes on 6/1/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBModuleLogMacros.h>

#import "MBDevice.h"
#import "MBStringConversions.h"
#import "MBDataEnvironmentConstants.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBDevice implementation
/******************************************************************************/

@implementation MBDevice

MBImplementSingleton();

- (BOOL) isSimulator
{
    return ([[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location != NSNotFound);
}

- (BOOL) isIPhone
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

- (BOOL) isIPad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (nonnull NSString*) osType
{
    return [UIDevice currentDevice].systemName;
}

- (nonnull NSString*) osVersion
{
    return [UIDevice currentDevice].systemVersion;
}

- (nonnull NSArray*) osVersionComponents
{
    NSMutableArray* compNums = [NSMutableArray new];
    NSArray* comps = [[self osVersion] componentsSeparatedByString:@"."];
    for (NSString* comp in comps) {
        [compNums addObject:@((NSUInteger)[comp integerValue])];
    }
    return [compNums copy];
}

- (nonnull NSNumber*) osVersionMajor
{
    return [self osVersionComponents][0];
}

- (nonnull NSNumber*) osVersionMinor
{
    return [self osVersionComponents][1];
}

- (nonnull NSNumber*) osVersionRevision
{
    return [self osVersionComponents][2];
}

- (nonnull NSString*) currentOrientation
{
    return ([self isLandscape] ? kMBInterfaceOrientationLandscape : kMBInterfaceOrientationPortrait);
}

- (BOOL) isLandscape
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

- (BOOL) isPortrait
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

- (nonnull NSNumber*) screenScale
{
    return @([[UIScreen mainScreen] scale]);
}

- (BOOL) isRetina
{
    return ([[UIScreen mainScreen] scale] >= 2.0);
}

- (CGSize) _screenSize
{
    if ([self isPortrait]) {
        return [UIScreen mainScreen].bounds.size;
    } else {
        CGSize size = [UIScreen mainScreen].bounds.size;
        return (CGSize){size.height, size.width};  // flip width & height in landscape
    }
}

- (nonnull NSNumber*) screenWidth
{
    return @([self _screenSize].width);
}

- (nonnull NSNumber*) screenHeight;
{
    return @([self _screenSize].height);
}

- (nonnull NSString*) screenSize
{
    return [MBStringConversions stringFromSize:[self _screenSize]];
}

- (nonnull NSString*) screenSizePortrait
{
    return [MBStringConversions stringFromSize:[UIScreen mainScreen].bounds.size];
}

- (nonnull NSString*) screenSizeLandscape
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    return [MBStringConversions stringFromSize:(CGSize){size.height, size.width}];  // flip width & height in landscape
}

- (BOOL) appIsInBackground
{
    return [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground;
}

@end
