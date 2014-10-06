//
//  MBDataEnvironmentModule.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 7/30/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

#import "MBDataEnvironmentModule.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBDataEnvironmentModule implementation
/******************************************************************************/

@implementation MBDataEnvironmentModule

+ (NSString*) moduleEnvironmentFilename
{
    return [[[self class] description] stringByAppendingPathExtension:@"xml"];
}

@end
