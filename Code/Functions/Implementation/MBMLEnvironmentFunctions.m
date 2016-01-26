//
//  MBMLEnvironmentFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/15/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBMLEnvironmentFunctions.h"
#import "MBEnvironment.h"
#import "MBExpressionError.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLEnvironmentFunctions implementation
/******************************************************************************/

@implementation MBMLEnvironmentFunctions

+ (NSArray*) mbmlLoadedPaths
{
    MBLogDebugTrace();

    return [MBEnvironment instance].mbmlPathsLoaded;
}

+ (NSArray*) mbmlLoadedFiles
{
    MBLogDebugTrace();

    NSArray* paths = [MBEnvironment instance].mbmlPathsLoaded;
    NSMutableArray* files = [NSMutableArray arrayWithCapacity:paths.count];
    for (NSString* path in paths) {
        [files addObject:[path lastPathComponent]];
    }
    return files;
}

+ (NSNumber*) mbmlPathIsLoaded:(NSString*)pathName
{
    MBLogDebugTrace();

    return @([[MBEnvironment instance] mbmlPathIsLoaded:pathName]);
}

+ (NSNumber*) mbmlFileIsLoaded:(NSString*)fileName
{
    MBLogDebugTrace();

    return @([[MBEnvironment instance] mbmlFileIsLoaded:fileName]);
}

@end
