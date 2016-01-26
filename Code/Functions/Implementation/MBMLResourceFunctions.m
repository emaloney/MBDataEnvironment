//
//  MBMLResourceFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/30/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBMLResourceFunctions.h"
#import "MBMLFunction.h"

#define DEBUG_LOCAL             0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLResourceFunctions implementation
/******************************************************************************/

@implementation MBMLResourceFunctions

/******************************************************************************/
#pragma mark MBML function API
/******************************************************************************/

+ (id) directoryForMainBundle
{
    MBLogDebugTrace();
    
    return [[NSBundle mainBundle] bundlePath];
}

+ (id) directoryForBundleWithIdentifier:(NSString*)identifier
{
    MBLogDebugTrace();
    
    return [[NSBundle bundleWithIdentifier:identifier] bundlePath];
}

+ (id) directoryForClassBundle:(NSString*)className
{
    MBLogDebugTrace();
    
    Class cls = NSClassFromString(className);
    if (!cls) {
        return [MBMLFunctionError errorWithFormat:@"Expecting parameter to be a class name; \"%@\" does not appear to be a valid class name", className];
    }
    
    return [[NSBundle bundleForClass:cls] bundlePath];
}

@end
