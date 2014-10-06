//
//  MBDataEnvironmentModule.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 7/30/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

#import "MBDataEnvironmentModule.h"
#import "MBVariableSpace.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBDataEnvironmentModule implementation
/******************************************************************************/

@implementation MBDataEnvironmentModule

+ (NSArray*) environmentLoaderClasses
{
    return @[[MBVariableSpace class]];
}

+ (NSString*) moduleEnvironmentFilename
{
    return [[self description] stringByAppendingPathExtension:@"xml"];
}

@end
