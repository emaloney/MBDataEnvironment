//
//  MBVariableSpace.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 8/30/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBSingleton.h>

#import "MBEnvironmentLoader.h"

@class MBVariableDeclaration;
@class MBMLFunction;

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

// posted to NSNotificationCenter when a new function is declared in a variable space
extern NSString* const __nonnull kMBVariableSpaceDidDeclareFunctionEvent;

/******************************************************************************/
#pragma mark -
#pragma mark MBVariableSpace class
/******************************************************************************/

/*!
 The `MBVariableSpace` class is responsible for loading variable declarations
 from MBML files and for maintaining the current values of named Mockingbird
 variables across the lifetime of the application.
 
 Each `MBEnvironment` will have an associated `MBVariableSpace` that will be 
 consulted when Mockingbird expressions are evaluated. When a given environment
 is active, its `MBVariableSpace` will provide the values when variables are
 referenced.
 */
@interface MBVariableSpace : MBEnvironmentLoader < MBInstanceVendor >

/*----------------------------------------------------------------------------*/
#pragma mark Getting the current variable space
/*!    @name Getting the current variable space                               */
/*----------------------------------------------------------------------------*/

/*!
 Retrieves the `MBVariableSpace` instance associated with the currently-active
 `MBEnvironment`.

 @return    The current variable space.
 */
+ (nullable instancetype) instance;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing variable values
/*!    @name Accessing variable values                                        */
/*----------------------------------------------------------------------------*/

/*!
 Returns the current value for the variable with the given name using
 the keyed subscripting notation.

 For example, the following Objective-C code:

    NSString* addr = [MBVariableSpace instance][@"email"];

 would set the value of the Objective-C string `addr` to the value of the MBML
 variable named `email`.

 @param     variableName The name of the MBML variable whose value is to be
            retrieved.

 @return    The current variable value. Will return `nil` if there is no
            variable with the given name or if there was an error retrieving
            the variable's value.
 */
- (nullable id) objectForKeyedSubscript:(nonnull NSString*)variableName;

/*!
 Returns the current string value of the variable with the given name.

 If the underlying variable value is not an `NSString`, the value's
 `description` method will be called to convert the value into a string.

 @param     varName The name of the variable whose string value is being
            retrieved.

 @return    The current string value of the variable. Will return `nil` if
            there is no variable with the given name or if there was an error
            retrieving the variable's value.
 */
- (nullable NSString*) variableAsString:(nonnull NSString*)varName;

/*!
 Returns the current string value for the variable with the given name, or a
 default value if there is no available variable value.

 If the underlying variable value is not an `NSString`, the value's
 `description` method will be called to convert the value into a string.

 @param     varName The name of the variable whose string value is being
            retrieved.

 @param     def A default value to return in cases where the method would
            otherwise return `nil`.

 @return    The current string value of the variable. Will return `def` if
            there is no variable with the given name or if there was an error
            retrieving the variable's value.
 */
- (nullable NSString*) variableAsString:(nonnull NSString*)varName defaultValue:(nullable NSString*)def;

/*----------------------------------------------------------------------------*/
#pragma mark Modifying variable values
/*!    @name Modifying variable values                                        */
/*----------------------------------------------------------------------------*/

/*!
 Sets a variable to the given value using the keyed subscripting notation.

 For example, the following Objective-C code:

    [MBVariableSpace instance][@"title"] = @"MBML";

 would set the MBML variable named `title` to the string "`MBML`".

 @param     value The value to set for the variable named `variableName`.

 @param     variableName The name of the variable whose value is to be set.
            If the name represents a read-only variable, the call will be
            ignored and an error will be logged to the console.

 @warning   An `NSInvalidArgumentException` is raised if `variableName`
            is `nil` or is not an `NSString`.
 */
- (void) setObject:(nullable id)value forKeyedSubscript:(nonnull NSString*)variableName;

/*!
 Pushes a new value onto the stack for the variable with the given name.
 
 @param     variableName The name of the variable whose value is to be set.
            If the name represents a read-only variable, the call will be
            ignored and an error will be logged to the console.

 @param     value The value to set for the variable named `variableName`.
 */
- (void) pushVariable:(nonnull NSString*)variableName value:(nullable id)value;

/*!
 Pops the current value from the stack for the variable with the given name.
 (The value of the variable prior to the previous call to `pushVariable:value:`
 will be restored.)
 
 If there are no stack values for the variable, an error will be logged to
 the console.
 
 @param     varName The name of the variable whose value is to be set.
            If the name represents a read-only variable, the call will be
            ignored and an error will be logged to the console.
 
 @return    The value of the variable `varName` that was popped from the stack.
            If there were no stack values for the variable, `nil` will be
            returned.
 */
- (nullable id) popVariable:(nonnull NSString*)varName;

/*!
 Sets the value of a given key for the `type="map"` variable with the specified
 name. (This method will also operate on any variable whose value is of type
 `NSDictionary`.)
 
 @param     varName The name of the map variable whose key-value is being set.
            If the name represents a read-only variable, the call will be
            ignored and an error will be logged to the console.

 @param     key The map key whose value is being set.
 
 @param     val The new value for the given key. If `nil`, the value for `key`
            will be removed.
 */
- (void) setMapVariable:(nonnull NSString*)varName mapKey:(nonnull NSString*)key value:(nullable id)val;

/*!
 Sets the value of a given key for the `type="list"` variable with the specified
 name. (This method will also operate on any variable whose value is of type
 `NSArray`.)

 @param     varName The name of the list variable whose index-value is being
            set. If the name represents a read-only variable, the call will be
            ignored and an error will be logged to the console.

 @param     idx The list index whose value is being set. If `idx` is
            greater than the last index of the list, the list array will be
            expanded to include the new index, and any empty index slots
            will be filled with `NSNull`.

 @param     val The new value to set at the given index. If `nil`, the value 
            will be set as `NSNull`.
 */
- (void) setListVariable:(nonnull NSString*)varName listIndex:(NSUInteger)idx value:(nullable id)val;

/*!
 Removes the current value of the variable with the specified name. Values on
 the variable stack will not be affected.
 
 @param     varName The name of the variable whose value is to be unset.
            If the name represents a read-only variable, the call will be
            ignored and an error will be logged to the console.
 */
- (void) unsetVariable:(nonnull NSString*)varName;

/*----------------------------------------------------------------------------*/
#pragma mark Constructing variable-related names
/*!    @name Constructing variable-related names                              */
/*----------------------------------------------------------------------------*/

/*!
 Constructs a string for a variable-related name with the given suffix.

 Calling this method with the name "`Foo`" and the suffix "`willBar`" would
 return the string "`Foo:willBar`".

 @param     name The name to use for the root of the returned string. If
            `nil`, this method returns `nil`.

 @param     suffix The optional suffix to apply to `name`. If `nil`, this
            method returns `name`.

 @return    If `name` and `suffix` are both non-`nil`, the concatenation of
            `name`, "`:`" and `suffix` is returned. Otherwise, the value of the
            `name` parameter is returned.
 */
+ (nullable NSString*) name:(nullable NSString*)name withSuffix:(nullable NSString*)suffix;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing variable information
/*!    @name Accessing variable information                                   */
/*----------------------------------------------------------------------------*/

/*!
 Determines whether the variable with the given name is a read-only variable.

 Read-only variables are marked as such in MBML or when they are declared
 programmatically via `declareVariable:`.

 Certain types of variable declarations—such as those represented by
 `MBSingletonVariableDeclaration` and `MBDynamicVariableDeclaration`—are always
 read-only.
 
 `MBConcreteVariableDeclaration`s declared in MBML with a `mutable="F"` 
 attribute are read-only.
 
 Otherwise, variables are not considered read-only.
 
 Note that the read-only concept only applies to whether or not the
 `MBVariableSpace` will allow you to change the value through its interface.

 In this way, even immutable objects such as `NSArray` may be considered 
 read/write as far as the Mockingbird Data Environment goes.

 Conversely, a `NSMutableDictionary`, for example, may be declared as a
 read-only Mockingbird variable, but the dictionary can still be mutated
 directly.

 @param     varName The name of the variable.
 
 @return    `YES` if the variable named `varName` is read-only; `NO` otherwise.
 */
- (BOOL) isReadOnlyVariable:(nonnull NSString*)varName;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing variable declarations
/*!    @name Accessing variable declarations                                  */
/*----------------------------------------------------------------------------*/

/*!
 Programmatically declares a variable.
 
 @param     declaration An `MBVariableDeclaration` representing the variable.
            Note that this method ignores the `shouldDeclare` property of the
            variable declaration.
 
 @return    `YES` if the variable represented by `declaration` was successfully
            declared; `NO` if an error occured.
 */
- (BOOL) declareVariable:(nonnull MBVariableDeclaration*)declaration;

/*!
 Returns the `MBVariableDeclaration` for the variable with the given name.
 
 Note that not all variables will have explicit declarations; only variables
 declared in MBML or created programmatically using `declareVariable:` will
 have an associated `MBVariableDeclaration`. Undeclared variables can be 
 created implicitly by being set directly using keyed subscripting and
 other methods.

 @param     varName The name of the variable whose declaration is being
            retrieved.
 
 @return    The declaration for `varName`, or `nil` if no declaration exists.
 */
- (nullable MBVariableDeclaration*) declarationForVariable:(nonnull NSString*)varName;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing MBML functions
/*!    @name Accessing MBML functions                                         */
/*----------------------------------------------------------------------------*/

/*!
 Programmatically declares an MBML function.

 @param     function An `MBMLFunction` representing the function and its
            implementation.

 @return    `YES` if `function` was successfully declared; `NO` if an error
            occurred.
 */
- (BOOL) declareFunction:(nonnull MBMLFunction*)function;

/*!
 Returns the names of the currently-declared MBML functions.
 
 @return    An `NSArray` containing the names of the declared MBML functions.
 */
- (nonnull NSArray*) functionNames;

/*!
 Returns the `MBMLFunction` associated with the given name.
 
 @param     name The name of the function whose `MBMLFunction` is sought.
 
 @return    The `MBMLFunction`, or `nil` if there is no function declared having
            the given name.
 */
- (nullable MBMLFunction*) functionWithName:(nonnull NSString*)name;

/*----------------------------------------------------------------------------*/
#pragma mark Observing changes to variables bound to `NSUserDefaults`
/*!    @name Observing changes to variables bound to `NSUserDefaults`         */
/*----------------------------------------------------------------------------*/

/*!
 Adds an observer to be notified of changes to the value of the Mockingbird
 variable with the given `NSUserDefaults` key name.

 @param     userDefaultsName The `userDefaultsName` of the variable to observe.
            Note that this is *not necessarily* the same as the variable name.
 
 @param     observer The object to notify.
 
 @param     action The method selector of `observer` to call when notifying.
 */
- (void) addObserverForUserDefault:(nonnull NSString*)userDefaultsName
                            target:(nonnull id)observer
                            action:(nonnull SEL)action;

/*!
 Stops an observer from being notified of changes to the value of the
 Mockingbird variable with the given `NSUserDefaults` key name.

 @param     observer The observer to remove.

 @param     userDefaultsName The `userDefaultsName` of the variable to stop
            observing.
 */
- (void) removeObserver:(nonnull id)observer
         forUserDefault:(nonnull NSString*)userDefaultsName;

@end
