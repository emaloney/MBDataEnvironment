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
 This class implements a set of MBML functions and supporting methods that 
 provide access to Objective-C runtime information.
 
 These functions are exposed to the Mockingbird environment via 
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.
 
 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLRuntimeFunctions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Helper method for looking up classes
/*!    @name Helper method for looking up classes                             */
/*----------------------------------------------------------------------------*/

/*!
 Given a Class or a string containing the name of an Objective-C class, this
 method returns a Class object.
 
 @param     resolveCls A `Class` object or an `NSString` instance containing
            the name of a class.
 
 @param     errPtr If non-`nil` and an error occurs, this pointer will be
            set to an `NSError` instance indicating the error.
 
 @return    A `Class` object representing the specified class, or `nil` if
            the specified class was not recognized by the Objective-C runtime.
 
 @note      This method is not exposed to the Mockingbird environment as a
            an MBML function.
 */
+ (Class) resolveClass:(id)resolveCls error:(MBMLFunctionError**)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Looking up Classes
/*!    @name Looking up Classes                                               */
/*----------------------------------------------------------------------------*/

/*!
 Determines whether a given class exists in the Objective-C runtime.
 
 This Mockingbird function accepts a single string expression yielding the name
 of the class.
 
 #### Expression usage
 
    ^classExists(NSString)
 
 The expression above would return `YES`, because the class
 `NSString` is part of the iOS SDK.
 
 @param     className The function's input parameter.

 @return    If there is a class with the given name, `@YES` is returned. 
            Otherwise, `@NO`.
 */
+ (id) classExists:(NSString*)className;

/*!
 Returns the `Class` object for the given class name.
 
 This Mockingbird function accepts a single string expression yielding the name
 of the class.

 #### Expression usage
 
 **Note:** This function is exposed to the Mockingbird environment with a
 name that differs from that of its implementing method:

    ^class(NSString)
 
 The expression above would return the `Class` object representing the
 `NSString` class.
 
 @param     className The function's input parameter.
 
 @return    If there is a class with the given name, the corresponding 
            `Class` object is returned. Otherwise, `nil` is returned.
 */
+ (id) getClass:(NSString*)className;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing singleton instances
/*!    @name Accessing singleton instances                                    */
/*----------------------------------------------------------------------------*/

/*!
 Returns the singleton instance of a given class.
 
 This Mockingbird function accepts a single object expression yielding either
 a `Class` object or an `NSString` containing the name of an Objective-C class. 
 If the specified class responds to the selector `instance`, this function 
 returns that instance.
 
 #### Expression usage
 
    ^singleton(MBServiceManager)
 
 The expression above would return the singleton instance of the
 `MBServiceManager` class.
 
 @param     forCls The function's input parameter.
 
 @return    If there is a class with the given name, the corresponding 
            `Class` object is returned. Otherwise, `nil` is returned.
 */
+ (id) singleton:(id)forCls;

/*----------------------------------------------------------------------------*/
#pragma mark Getting a class's hierarchy
/*!    @name Getting a class's hierarchy                                      */
/*----------------------------------------------------------------------------*/

/*!
 Returns an array containing the inheritance hierarchy of a given class.

 This Mockingbird function accepts a single parameter, the *class* expression,
 an object expression yielding either a `Class` object or an `NSString`
 containing the name of an Objective-C class.

 The first item in the returned array will contain the `Class` object
 representing the class identified by *class*.

 Each subsequent item in the array will contain a `Class` representing the
 superclass of the item that preceded it.
 
 The last item in the returned array will contain the root class of the
 hierarchy (which is usually `NSObject`).
 
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

/*----------------------------------------------------------------------------*/
#pragma mark Checking for method implementations
/*!    @name Checking for method implementations                              */
/*----------------------------------------------------------------------------*/

/*!
 Determines whether a given object instance responds to a specific Objective-C
 message selector.
 
 This Mockingbird function accepts two pipe-separated parameters:
 
 * The *object*, an object expression yielding an `NSObject` instance, and
 
 * The *selector*, a string expression yielding the selector name.

 #### Expression usage

 **Note:** This function is exposed to the Mockingbird environment with a
 name that differs from that of its implementing method:

    ^respondsToSelector($myName|isEqualToString:)
 
 The expression above would evaluate to true if the expression `$myName` 
 yields an `NSString` instance (or an instance of any other class that
 responds to the `isEqualToString:` message).
 
 @param     params The function's input parameters.

 @return    If object instance referenced in the *object* expression
            responds to the selector specified in the *selector* expression,
            the return value will be `@YES`. Otherwise, `@NO` will be returned.
*/
+ (id) objectRespondsToSelector:(NSArray*)params;

/*!
 Determines whether a given class responds to a specific Objective-C message
 selector.
 
 This Mockingbird function accepts two pipe-separated parameters:

 * The *class*, an object expression yielding either a `Class` object or an
  `NSString` containing the name of an Objective-C class

 * The *selector*, a string expression yielding the selector name.

 #### Expression usage
 
 **Note:** This function is exposed to the Mockingbird environment with a
 name that differs from that of its implementing method:

    ^instancesRespondToSelector(NSString|availableStringEncodings)
 
 The expression above evaluates to `@YES` because the `NSString` class responds
 to the `availableStringEncodings` message.
 
 @param     params The function's input parameters.
 
 @return    If the Objective-C class referenced in the *class* expression
            responds to the selector specified in the *selector* expression,
            the return value will be `@YES`. Otherwise, `@NO` will be returned.
 */
+ (id) classRespondsToSelector:(NSArray*)params;

@end
