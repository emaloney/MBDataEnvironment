//
//  TypeCoercionSupport.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 12/3/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBNumericPrimitive protocol
/******************************************************************************/

/*!
 This is the base protocol that will be adopted by our NSString and NSNull
 extensions to ensure proper KVC type coercion on 64-bit processors.
 */
@protocol MBNumericPrimitiveAccessors

@required

- (char) charValue;
- (unsigned char) unsignedCharValue;
- (short) shortValue;
- (unsigned short) unsignedShortValue;
- (int) intValue;
- (unsigned int) unsignedIntValue;
- (long) longValue;
- (unsigned long) unsignedLongValue;
- (long long) longLongValue;
- (unsigned long long) unsignedLongLongValue;
- (float) floatValue;
- (double) doubleValue;
- (BOOL) boolValue;
- (NSInteger) integerValue;
- (NSUInteger) unsignedIntegerValue;
- (NSString*) stringValue;

@end

/******************************************************************************/
#pragma mark -
#pragma mark NSString MBNumericPrimitiveAccessors category
/******************************************************************************/

@interface NSString (MBNumericPrimitiveAccessors) < MBNumericPrimitiveAccessors >
@end

/******************************************************************************/
#pragma mark -
#pragma mark NSNull MBNumericPrimitiveAccessors category
/******************************************************************************/

@interface NSNull (MBNumericPrimitiveAccessors) < MBNumericPrimitiveAccessors >

- (NSUInteger) length;

@end

/******************************************************************************/
#pragma mark -
#pragma mark NSNull NSFastEnumeration category
/******************************************************************************/

@interface NSNull (NSFastEnumeration) < NSFastEnumeration >
@end

