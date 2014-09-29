//
//  TypeCoercionSupport.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 12/3/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import "TypeCoercionSupport.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark NSString MBNumericPrimitiveAccessors category implementation
/******************************************************************************/

@implementation NSString (MBNumericPrimitiveAccessors)

- (char) charValue
{
    return [[NSDecimalNumber decimalNumberWithString:self] charValue];
}

- (unsigned char) unsignedCharValue
{
    return [[NSDecimalNumber decimalNumberWithString:self] unsignedCharValue];
}

- (short) shortValue
{
    return [[NSDecimalNumber decimalNumberWithString:self] shortValue];
}

- (unsigned short) unsignedShortValue
{
    return [[NSDecimalNumber decimalNumberWithString:self] unsignedShortValue];
}

- (unsigned int) unsignedIntValue
{
    return [[NSDecimalNumber decimalNumberWithString:self] unsignedIntValue];
}

- (long) longValue
{
    return [[NSDecimalNumber decimalNumberWithString:self] longValue];
}

- (unsigned long) unsignedLongValue
{
    return [[NSDecimalNumber decimalNumberWithString:self] unsignedLongValue];
}

- (long long) longLongValue
{
    return [[NSDecimalNumber decimalNumberWithString:self] longLongValue];
}

- (unsigned long long) unsignedLongLongValue
{
    return [[NSDecimalNumber decimalNumberWithString:self] unsignedLongLongValue];
}

- (NSUInteger) unsignedIntegerValue
{
    return [[NSDecimalNumber decimalNumberWithString:self] unsignedIntegerValue];
}

- (NSString*) stringValue
{
    return self;
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark NSNull MBNumericPrimitiveAccessors category implementation
/******************************************************************************/

@implementation NSNull (MBNumericPrimitiveAccessors)

- (NSUInteger) length
{
    return 0;
}

- (char) charValue
{
    return (char)0;
}

- (unsigned char) unsignedCharValue
{
    return (unsigned char)0;
}

- (short) shortValue
{
    return (short)0;
}

- (unsigned short) unsignedShortValue
{
    return (unsigned short)0;
}

- (int) intValue
{
    return (int)0;
}

- (unsigned int) unsignedIntValue
{
    return (unsigned int)0;
}

- (long) longValue
{
    return (long)0;
}

- (unsigned long) unsignedLongValue
{
    return (unsigned long)0;
}

- (long long) longLongValue
{
    return (long long)0;
}

- (unsigned long long) unsignedLongLongValue
{
    return (unsigned long long)0;
}

- (float) floatValue
{
    return (float)0;
}

- (double) doubleValue
{
    return (double)0;
}

- (BOOL) boolValue
{
    return NO;
}

- (NSInteger) integerValue
{
    return (NSInteger)0;
}

- (NSUInteger) unsignedIntegerValue
{
    return (NSUInteger)0;
}

- (NSString*) stringValue
{
    return [self description];
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark NSNull NSFastEnumeration category implementation
/******************************************************************************/

@implementation NSNull (NSFastEnumeration)

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState*)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    return 0;
}

@end


