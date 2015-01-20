//
//  MBMLEncodingFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/23/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

#import "MBMLFunction.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLEncodingFunctions class
/******************************************************************************/

/*!
 This class implements a set of MBML functions to be used for encoding strings
 and data into other representations, such as MD5, base-64, etc.

 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.

 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLEncodingFunctions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark MD5 encoding
/*!    @name MD5 encoding                                                     */
/*----------------------------------------------------------------------------*/

/*!
 Computes an MD5 hash from an input string.

 This Mockingbird function accepts a single expression parameter that is
 expected to yield the input string.

 #### Expression usage
 
 The expression:
 
    ^MD5FromString(12 Galaxies)
 
 would return the string `51eae4327df7f0617eaaf305832fe219`, a hexadecimal
 representation of the MD5 hash of the string "`12 Galaxies`".
 
 **Note:** This function is also exposed to the Mockingbird environment with
 the alias `^MD5()`.

 @param     string The function's input string.
 
 @return    An MD5 hash computed from the input string.
 */
+ (id) MD5FromString:(NSString*)string;

/*!
 Computes an MD5 hash from an `NSData` instance.

 This Mockingbird function accepts a single expression parameter that is
 expected to yield an `NSData` instance.
 
 #### Expression usage
 
 The expression:
 
    ^MD5FromData($myData)
 
 would return a hexadecimal string representation of the MD5 hash of the bytes
 contained in the `NSData` instance yielded by the MBML expression "`$myData`"
 
 @param     data The function's input data.
 
 @return    An MD5 hash computed from the input data.
 */
+ (id) MD5FromData:(NSData*)data;

/*----------------------------------------------------------------------------*/
#pragma mark SHA-1 encoding
/*!    @name SHA-1 encoding                                                   */
/*----------------------------------------------------------------------------*/

/*!
 Computes an SHA-1 hash from an input string.

 This function accepts a single expression parameter that is expected to yield
 the input string.
 
 #### Expression usage
 
 The expression:
 
    ^SHA1FromString(12 Galaxies)
 
 would return the string `51eae4327df7f0617eaaf305832fe219`, a hexadecimal
 representation of the MD5 hash of the string "`12 Galaxies`".
 
 **Note:** This function is also exposed to the Mockingbird environment with
 the alias `^SHA1()`.

 @param     string The function's input string.
 
 @return    An MD5 hash computed from the input string.
 */
+ (id) SHA1FromString:(NSString*)string;

/*!
 Computes an SHA-1 hash from an `NSData` instance.

 This Mockingbird function accepts a single expression parameter that is
 expected to yield an `NSData` instance.

 #### Expression usage
 
 The expression:
 
    ^SHA1FromData($myData)
 
 would return a hexadecimal string representation of the SHA-1 hash of the bytes
 contained in the `NSData` instance yielded by the MBML expression "`$myData`"
 
 @param     data The function's input data.
 
 @return    An MD5 hash computed from the input data.
 */
+ (id) SHA1FromData:(NSData*)data;

/*----------------------------------------------------------------------------*/
#pragma mark Base-64 encoding & decoding
/*!    @name Base-64 encoding & decoding                                      */
/*----------------------------------------------------------------------------*/

/*!
 Computes a Base-64 representation of a given `NSData` instance, and returns
 the resulting string.

 This Mockingbird function accepts a single expression parameter that is
 expected to yield an `NSData` instance.

 #### Expression usage
 
 The expression:
 
    ^base64FromData($myData)
 
 would return a string that contains the Base-64 encoding of the bytes within
 the `NSData` instance yielded by the MBML expression "`$myData`".
 
 @param     data The function's input data.
 
 @return    The base-64 representation of the input data.
 */
+ (id) base64FromData:(NSData*)data;

/*!
 Decodes a Base-64 string representation of data, and returns the resulting
 `NSData` instance.

 This function accepts a single expression parameter that is expected to yield
 the input string.

 #### Expression usage

    ^dataFromBase64(aHR0cDovL3RlY2guZ2lsdC5jb20v)
 
 The expression above returns an `NSData` instance containing the bytes
 representing the UTF-8 encoded string, "`http://tech.gilt.com/`".

 @param     base64 The function's input data, a Base-64-encoded string.
 
 @return    The Base-64-decoded form of `base64`, contained in an
            `NSData` instance.
 */
+ (id) dataFromBase64:(NSString*)base64;

@end
