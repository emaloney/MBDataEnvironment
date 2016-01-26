//
//  MBMLEncodingFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/23/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBMLEncodingFunctions.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLEncodingFunctions implementation
/******************************************************************************/

@implementation MBMLEncodingFunctions

+ (id) MD5FromString:(NSString*)string
{
    MBLogDebugTrace();
    
    return [string MD5];
}

+ (id) MD5FromData:(NSData*)data
{
    MBLogDebugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:data isKindOfClass:[NSData class] error:&err];
    if (err) return err;

    return [data MD5];
}

+ (id) SHA1FromString:(NSString*)string
{
    MBLogDebugTrace();
    
    return [string SHA1];
}

+ (id) SHA1FromData:(NSData*)data
{
    MBLogDebugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:data isKindOfClass:[NSData class] error:&err];
    if (err) return err;

    return [data SHA1];
}

+ (id) base64FromData:(NSData*)data
{
    MBLogDebugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:data isKindOfClass:[NSData class] error:&err];
    if (err) return err;

    return [data base64EncodedStringWithOptions:0];
}

+ (id) dataFromBase64:(NSString*)base64
{
    MBLogDebugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameterIsString:base64 error:&err];
    if (err) return err;

    return [[NSData alloc] initWithBase64EncodedString:base64 options:0];
}

+ (id) hexStringFromData:(NSData*)data
{
    MBLogDebugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:data isKindOfClass:[NSData class] error:&err];
    if (err) return err;

    return [data hexString];
}

+ (id) dataFromHexString:(NSString*)hexString
{
    MBLogDebugTrace();

    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameterIsString:hexString error:&err];
    if (err) return err;

    return [NSData dataWithHexString:hexString];
}

@end
