//
//  MBMLEncodingFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/23/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>

#import "MBMLEncodingFunctions.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLEncodingFunctions implementation
/******************************************************************************/

@implementation MBMLEncodingFunctions

+ (id) MD5FromString:(NSString*)string
{
    debugTrace();
    
    return [string MD5];
}

+ (id) MD5FromData:(NSData*)data
{
    debugTrace();
    
    return [data MD5];
}

+ (id) base64FromData:(NSData*)data
{
    debugTrace();
    
    return [data base64EncodedStringWithOptions:0];
}

@end
