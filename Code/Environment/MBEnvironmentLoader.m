//
//  MBEnvironmentLoader.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/19/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

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
#pragma mark Property handling
/******************************************************************************/

- (NSString*) defaultEnvironmentFilename
{
    return nil;
}

/******************************************************************************/
#pragma mark Environment state changes
/******************************************************************************/

- (void) environmentWillLoad:(MBEnvironment*)env
{
    debugTrace();
}

- (void) environmentDidLoad:(MBEnvironment*)env
{
    debugTrace();
}

- (void) environmentLoadFailed:(MBEnvironment*)env
{
    debugTrace();
}

- (void) environmentWillActivate:(MBEnvironment*)env
{
    debugTrace();
}

- (void) environmentDidActivate:(MBEnvironment*)env
{
    debugTrace();

    _isActive = YES;
}

- (void) environmentWillDeactivate:(MBEnvironment*)env
{
    debugTrace();
}

- (void) environmentDidDeactivate:(MBEnvironment*)env
{
    debugTrace();

    _isActive = NO;
}

/******************************************************************************/
#pragma mark MBML parsing
/******************************************************************************/

- (NSArray*) acceptedTagNames
{
    MBErrorNotImplementedReturn(NSArray*);
}

- (BOOL) parseElement:(RXMLElement*)mbml forMatch:(NSString*)match
{
    MBErrorNotImplementedReturn(BOOL);
}

@end
