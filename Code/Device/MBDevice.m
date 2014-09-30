//
//  MBDevice.m
//  Mockingbird Data Environment
//
//  Created by Jesse Boyes on 6/1/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

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

- (NSString*) osType
{
    return [UIDevice currentDevice].systemName;
}

- (NSString*) osVersion
{
    return [UIDevice currentDevice].systemVersion;
}

- (NSArray*) osVersionComponents
{
    return [[self osVersion] componentsSeparatedByString:@"."]; 
}

- (NSUInteger) _osVersionComponentAtIndex:(NSUInteger)index
{
    NSUInteger v = 0;
    NSArray* vComp = [self osVersionComponents];
    if (vComp.count > index) {
        v = [[vComp objectAtIndex:index] integerValue];
    }
    return v;
}

- (NSUInteger) osVersionMajor
{
    return [self _osVersionComponentAtIndex:0];
}

- (NSUInteger) osVersionMinor
{
    return [self _osVersionComponentAtIndex:1];
}

- (NSUInteger) osVersionRevision
{
    return [self _osVersionComponentAtIndex:2];
}

- (NSString*) currentOrientation
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

- (CGSize) _screenSize
{
    if ([self isPortrait]) {
        return [UIScreen mainScreen].bounds.size;
    } else {
        CGSize size = [UIScreen mainScreen].bounds.size;
        return (CGSize){size.height, size.width};  // flip width & height in landscape
    }
}

- (NSNumber*) screenWidth
{
    return @([self _screenSize].width);
}

- (NSNumber*) screenHeight;
{
    return @([self _screenSize].height);
}

- (NSString*) screenSize
{
    return [MBStringConversions stringFromSize:[self _screenSize]];
}

- (NSString*) screenSizePortrait
{
    return [MBStringConversions stringFromSize:[UIScreen mainScreen].bounds.size];
}

- (NSString*) screenSizeLandscape
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    return [MBStringConversions stringFromSize:(CGSize){size.height, size.width}];  // flip width & height in landscape
}

- (NSString*) contentFrame
{
    return [MBStringConversions stringFromRect:[UIScreen mainScreen].applicationFrame];
}

- (CGSize) _contentSize
{
    if ([self isPortrait]) {
        return [UIScreen mainScreen].applicationFrame.size;
    } else {
        CGSize size = [UIScreen mainScreen].applicationFrame.size;
        return (CGSize){size.height, size.width};  // flip width & height in landscape
    }
}

- (NSNumber*) contentWidth
{
    return @([self _contentSize].width);
}

- (NSNumber*) contentHeight
{
    return @([self _contentSize].height);
}

- (NSString*) contentSize
{
    return [MBStringConversions stringFromSize:[self _contentSize]];
}

- (NSString*) contentSizePortrait
{
    return [MBStringConversions stringFromSize:[UIScreen mainScreen].applicationFrame.size];
}

- (NSString*) contentSizeLandscape
{
    CGSize size = [UIScreen mainScreen].applicationFrame.size;
    return [MBStringConversions stringFromSize:(CGSize){size.height, size.width}];  // flip width & height in landscape
}

- (BOOL) isRetina
{
    return ([[UIScreen mainScreen] scale] >= 2.0);
}

- (BOOL) appIsInBackground
{
    return [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground;
}

- (id) valueForUndefinedKey:(NSString*)key
{
    // Pass anything we don't know about on to UIDevice
    @try {
        return [[UIDevice currentDevice] valueForKey:key];
    }
    @catch (NSException* ex) {
        errorObj(ex);
    }
    return nil;
}

@end
