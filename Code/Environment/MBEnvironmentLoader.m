//
//  MBEnvironmentLoader.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/19/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>

#import "MBEnvironmentLoader.h"
#import "MBEnvironment.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

NSString* const kMBMLEnvironmentDidLoadNotification         = @"Environment:didLoad";

/******************************************************************************/
#pragma mark -
#pragma mark MBEnvironmentLoader implementation
/******************************************************************************/

@implementation MBEnvironmentLoader

/******************************************************************************/
#pragma mark Environment state changes
/******************************************************************************/

- (void) environmentWillLoad:(nonnull MBEnvironment*)env
{
    debugTrace();
}

- (void) environmentDidLoad:(nonnull MBEnvironment*)env
{
    debugTrace();
}

- (void) environmentLoadFailed:(nonnull MBEnvironment*)env
{
    debugTrace();
}

- (void) environmentWillActivate:(nonnull MBEnvironment*)env
{
    debugTrace();
}

- (void) environmentDidActivate:(nonnull MBEnvironment*)env
{
    debugTrace();

    _isActive = YES;
}

- (void) environmentWillDeactivate:(nonnull MBEnvironment*)env
{
    debugTrace();
}

- (void) environmentDidDeactivate:(nonnull MBEnvironment*)env
{
    debugTrace();

    _isActive = NO;
}

/******************************************************************************/
#pragma mark MBML parsing
/******************************************************************************/

- (nonnull NSArray*) acceptedTagNames
{
    MBErrorNotImplementedReturn(NSArray*);
}

- (BOOL) parseElement:(nonnull RXMLElement*)mbml forMatch:(nonnull NSString*)match
{
    MBErrorNotImplementedReturn(BOOL);
}

@end
