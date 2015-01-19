//
//  MBMLRuntimeFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/11/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBMLFunctionError;

/******************************************************************************/
#pragma mark -
#pragma mark MBMLRuntimeFunctions class
/******************************************************************************/

/*!
 A class containing a set of MBML functions and supporting methods that provide
 access to Objective-C runtime information.
 
 See `MBMLFunction` for more information on MBML functions and how they're used.
 */
@interface MBMLRuntimeFunctions : NSObject

/*******************************************************************************
 @name Helper for ensuring we've got Class
 ******************************************************************************/

/*!
 Given a Class or a string containing the name of an Objective-C class, this
 method returns a Class object.
 
 @param     resolveCls A `Class` object or an `NSString` instance containing
            the name of a class.
 
 @param     errPtr If non-`nil` and an error occurs, this pointer will be
            set to an `NSError` instance indicating the error.
 
 @return    A `Class` object representing the specified class, or `nil` if
            the specified class was not recognized by the Objective-C runtime.
 
 @note      This method is not exposed to MBML as a function.
 */
+ (Class) resolveClass:(id)resolveCls error:(MBMLFunctionError**)errPtr;

/*******************************************************************************
 @name MBML functions
 ******************************************************************************/

/*!
 An MBML function implementation that determines whether a given class exists
 in the Objective-C runtime.
 
 This function accepts a single MBML expression that will be evaluated as a
 string. 
 
 #### Expression usage
 
    ^classExists(NSString)
 
 The expression above would return <code>YES</code>, because the class
 <code>NSString</code> is part of the iOS SDK.
 
 @param     className The function's input parameter.

 @return    If there is a class with the given name, an `NSNumber` containing
            the boolean value `YES` is returned. Otherwise, the returned
            `NSNumber` will contain the value `NO`.
 */
+ (id) classExists:(NSString*)className;

/*!
 An MBML function implementation that returns the `Class` object for the given
 class name.
 
 This function accepts a single MBML expression that will be evaluated as a
 string.

 #### Expression usage
 
    ^class(NSString)
 
 The expression above would return the `Class` object representing the
 `NSString` class.
 
 @param     className The function's input parameter.
 
 @return    If there is a class with the given name, the corresponding 
            `Class` object is returned. Otherwise, `nil` is returned.
 
 @note      This function is exposed to the MBML environment as `^class()`.
 */
+ (id) getClass:(NSString*)className;

/*!
 An MBML function implementation that returns the singleton instance of a
 given class.
 
 This function accepts a single MBML expression that will be evaluated as an
 object. The expression is expected to yield a `Class` object or an `NSString`
 containing the name of an Objective-C class. If the specified class responds
 to the selector `instance`, this function returns that instance.
 
 #### Expression usage
 
    ^singleton(MBServiceManager)
 
 The expression above would return the singleton instance of the
 `MBServiceManager` class.
 
 @param     forCls The function's input parameter.
 
 @return    If there is a class with the given name, the corresponding 
            `Class` object is returned. Otherwise, `nil` is returned.
 */
+ (id) singleton:(id)forCls;

/*!
 An MBML function implementation that returns the inheritance hierarchy of 
 a given class.
 
 This function accepts a single MBML expression that will be evaluated as an
 object. The expression is expected to yield a `Class` object or an `NSString`
 containing the name of an Objective-C class. If the specified class responds
 to the selector `instance`, this function returns that instance.

 The first item in the returned array will contain a `Class` object for the
 passed-in parameter, while each subsequent item will the `Class` for the
 superclass of the preceding class. The last item in the returned array 
 will contain the root class of the hierarchy (which is usually `NSObject`).
 
 #### Expression usage
 
    ^inheritanceHierarchyForClass(NSMutableString)

 The expression above would return an array containing three objects: the
 `Class` object for the `NSMutableString` class, the `Class` object for 
 `NSString`, and finally the `Class` for `NSObject`.
 
 @param     forCls The function's input parameter.
 
 @return    An array containing the Objective-C class hierarchy for the
            specified class. If no such class was found, `nil` is returned.
 */
+ (id) inheritanceHierarchyForClass:(id)forCls;

/*!
 An MBML function implementation that determines whether a given object 
 instance responds to a specific Objective-C message selector.
 
 This function expects two pipe-separated expressions as parameters:
 
 * the *object* expression, which should yield an `NSObject` instance, and
 
 * the *selector* expression, which should yield a string containing the
 name of the selector

 #### Expression usage
 
    ^objectRespondsToSelector($myName|isEqualToString:)
 
 The expression above would evaluate to true if the expression `$myName` 
 yields an `NSString` instance (or an instance of any other class that
 responds to the `isEqualToString:` message).
 
 @param     params The function's input parameters.

 @return    If object instance referenced in the *object* expression
            responds to the selector specified in the *selector* expression,
            the return value will be an `NSNumber` containing the boolean value
            `YES`. Otherwise, an `NSNumber` containing the value `NO` will
            be returned.
*/
+ (id) objectRespondsToSelector:(NSArray*)params;

/*!
 An MBML function implementation that determines whether a given class responds
 to a specific Objective-C message selector.
 
 This function expects two pipe-separated expressions as parameters:
 
 * the *class* expression, which should yield a `Class` object or an `NSString`
 containing the name of an Objective-C class, and
 
 * the *selector* expression, which should yield a string containing the
 name of the selector
 
 #### Expression usage
 
    ^classRespondsToSelector(NSString|availableStringEncodings)
 
 The expression above evaluates to true because the `NSString` class responds
 to the `availableStringEncodings` message.
 
 @param     params The function's input parameters.
 
 @return    If the Objective-C class referenced in the *class* expression
            responds to the selector specified in the *selector* expression,
            the return value will be an `NSNumber` containing the boolean value
            `YES`. Otherwise, an `NSNumber` containing the value `NO` will
            be returned.
 */
+ (id) classRespondsToSelector:(NSArray*)params;

@end
