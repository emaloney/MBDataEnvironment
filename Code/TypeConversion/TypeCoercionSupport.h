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
 This is the base protocol that will be adopted by our `NSString` and `NSNull`
 extensions to ensure proper KVC type coercion on 64-bit processors.
 */
@protocol MBNumericPrimitiveAccessors

/*!
 Returns the `char` value equivalent of the receiver.
 
 @return    The value of the receiver as a `char`.
 */
- (char) charValue;

/*!
 Returns the `unsigned char` value equivalent of the receiver.
 
 @return    The value of the receiver as an `unsigned char`.
 */
- (unsigned char) unsignedCharValue;

/*!
 Returns the `short` value equivalent of the receiver.
 
 @return    The value of the receiver as a `short`.
 */
- (short) shortValue;

/*!
 Returns the `unsigned short` value equivalent of the receiver.
 
 @return    The value of the receiver as an `unsigned short`.
 */
- (unsigned short) unsignedShortValue;

/*!
 Returns the `int` value equivalent of the receiver.
 
 @return    The value of the receiver as a `int`.
 */
- (int) intValue;

/*!
 Returns the `unsigned int` value equivalent of the receiver.
 
 @return    The value of the receiver as an `unsigned int`.
 */
- (unsigned int) unsignedIntValue;

/*!
 Returns the `long` value equivalent of the receiver.
 
 @return    The value of the receiver as a `long`.
 */
- (long) longValue;

/*!
 Returns the `unsigned long` value equivalent of the receiver.
 
 @return    The value of the receiver as an `unsigned long`.
 */
- (unsigned long) unsignedLongValue;

/*!
 Returns the `long long` value equivalent of the receiver.
 
 @return    The value of the receiver as a `long long`.
 */
- (long long) longLongValue;

/*!
 Returns the `unsigned long long` value equivalent of the receiver.
 
 @return    The value of the receiver as an `unsigned long long`.
 */
- (unsigned long long) unsignedLongLongValue;

/*!
 Returns the `float` value equivalent of the receiver.
 
 @return    The value of the receiver as a `float`.
 */
- (float) floatValue;

/*!
 Returns the `double` value equivalent of the receiver.
 
 @return    The value of the receiver as a `double`.
 */
- (double) doubleValue;

/*!
 Returns the `BOOL` value equivalent of the receiver.
 
 @return    The value of the receiver as a `BOOL`.
 */
- (BOOL) boolValue;

/*!
 Returns the `NSInteger` value equivalent of the receiver.
 
 @return    The value of the receiver as an `NSInteger`.
 */
- (NSInteger) integerValue;

/*!
 Returns the `NSUInteger` value equivalent of the receiver.
 
 @return    The value of the receiver as an `NSUInteger`.
 */
- (NSUInteger) unsignedIntegerValue;

/*!
 Returns the `NSString` value equivalent of the receiver.
 
 @return    The value of the receiver as an `NSString`.
 */
- (NSString*) stringValue;

@end

/******************************************************************************/
#pragma mark -
#pragma mark NSString MBNumericPrimitiveAccessors category
/******************************************************************************/

/*!
 Our `NSString` class category is used to add support for the
 `MBNumericPrimitiveAccessors` protocol.
 */
@interface NSString (MBNumericPrimitiveAccessors) < MBNumericPrimitiveAccessors >
@end

/******************************************************************************/
#pragma mark -
#pragma mark NSNull MBNumericPrimitiveAccessors category
/******************************************************************************/

/*!
 Our `NSNull` class category is used to add support for the
 `MBNumericPrimitiveAccessors` protocol.
 */
@interface NSNull (MBNumericPrimitiveAccessors) < MBNumericPrimitiveAccessors >

/*!
 Adds a `length` method to `NSNull`, which always returns `0`.
 
 @return    `0`.
 */
- (NSUInteger) length;

@end

/******************************************************************************/
#pragma mark -
#pragma mark NSNull NSFastEnumeration category
/******************************************************************************/

/*!
 Our `NSNull` class category is used to add support for the
 `NSFastEnumeration` protocol.
 */
@interface NSNull (NSFastEnumeration) < NSFastEnumeration >
@end

