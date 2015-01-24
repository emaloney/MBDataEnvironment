//
//  MBScopedVariables.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 10/6/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBFormattedDescriptionObject.h>

@class MBVariableSpace;

/******************************************************************************/
#pragma mark -
#pragma mark MBScopedVariables class
/******************************************************************************/

/*!
 Provides a mechanism for maintaining scoped variable values in the
 context of a particular `MBVariableSpace` instance.
 
 ### About variable scopes
 
 A *variable scope* allows the creation of a short-lived values for named
 Mockingbird variables.
 
 The `MBScopedVariables` class provides an interface for *entering* and
 *exiting* a variable scope.
 
 When a scope is *entered*, an `MBScopedVariables` instance is associated
 with the calling thread. That instance can then be used to set values for
 scoped variables. When a scoped variable value is set, it is *pushed*
 on top of the existing value (if any) in the associated `MBVariableSpace`.

 When the scope is *exited*, any scoped variable values that were set are
 then *popped* from the associated `MBVariableSpace`, restoring it to the
 state that existed before the scope was entered.
 
 ### Setting a scoped variable
 
 To set a scoped variable, you first need an `MBScopedVariables` instance.
 If there's already a scope associated with the calling thread, you can
 retrieve it by calling:
 
    MBScopedVariables* scope = [MBScopedVariables currentVariableScope];
 
 If there's no pre-existing scope, or if you want to create a new scope
 that masks any existing scope, you would call:
 
    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];

 Once you've got a scope instance, you can use it to set a scoped
 variable:
 
    NSString* userName = ... // a string set elsewhere
    [scope setScopedVariable:@"user" value:userName];
 
 The value `userName` is then *pushed* onto the Mockingbird variable stack
 for the name "`user`". If there is a pre-existing value for the "`user`"
 variable, it is temporarily masked by the new value. When the scope is
 exited—or when a scope's `unsetScopedVariables` method is called—the "`user`"
 variable will be *popped*, and the previous value will be restored.
 
 ### Exiting the current scope
 
 When you no longer need a scope that you've previously entered, you **must**
 call:
 
    [MBScopedVariables exitVariableScope];
 
 It is considered a coding error if you do not explicitly exit a
 scope you've previously entered.
 
 For performance reasons, you should keep any scopes you create as short-lived
 as possible.

 ### Threading concerns
 
 Although a given `MBScopedVariables` instance is specific to the thread that
 created it, the underlying `MBVariableSpace` manipulated by the scope is
 a global resource. Therefore, values set within your scope will be visible
 to all threads until your scope is exited.
 */
@interface MBScopedVariables : MBFormattedDescriptionObject < NSCopying >

/*!
 Returns the `MBVariableSpace` instance in which the scoped variables will
 be stored.
 */
@property(nonatomic, readonly) MBVariableSpace* variableSpace;

/*----------------------------------------------------------------------------*/
#pragma mark Thread-local scoped variables
/*!    @name Thread-local scoped variables                                    */
/*----------------------------------------------------------------------------*/

/*! 
 Returns the `MBScopedVariables` instance that represents the current
 variable scope associated with the calling thread.

 @return    The current scope, or `nil` if there isn't one.
 */
+ (instancetype) currentVariableScope;

/*!
 Enters a new variable scope on the calling thread using the `MBVariableSpace`
 associated with the current `MBEnvironment`.
 
 @note      Although only the calling thread will see this scope through
            the `currentVariableScope` method, variable values set using this
            scope will be visible to *all* threads through the `MBVariableSpace`
            associated with the scope.
 
 @warning   All calls to `enterVariableScope` must be balanced by a 
            corresponding call to `exitVariableScope`. Failing to do this
            is a coding error.

 @return    A newly-created `MBScopedVariables` instance representing
            the new scope. Until the scope is exited, code running on the
            calling thread will be able to retrieve this scope through
            the `currentVariableScope` method.
 */
+ (instancetype) enterVariableScope;

/*! 
 Exits the current variable scope--if there is one--associated with the
 calling thread. Any variables set within the scope being exited will be 
 removed from that scope's `variableSpace`, and the variable values will
 return to what they were prior to entering the scope.
 
 @return    The `MBScopedVariables` instance representing the scope that
            was exited, or `nil` if there was no current scope at the time
            of calling and therefore there was no scope to exit.
 */
+ (instancetype) exitVariableScope;

/*----------------------------------------------------------------------------*/
#pragma mark Setting & unsetting scoped variable values
/*!    @name Setting & unsetting scoped variable values                       */
/*----------------------------------------------------------------------------*/

/*!
 Sets the value of a scoped variable. This variable value will be reflected
 in the receiver's `variableSpace`.

 @param     varName The name of the variable whose value is being set.
 
 @param     val The variable value.
 */
- (void) setScopedVariable:(NSString*)varName value:(id)val;

/*!
 Removes from the receiver's `variableSpace` all variables set using the scope.
 The values in the `variableSpace` will return to what they were prior to the
 scope becoming active.
 */
- (void) unsetScopedVariables;

/*!
 Reapplies any scoped variables that were previously unset using 
 `unsetScopedVariables` (and have not been set again since then using
 `setScopedVariable:value:`).
 
 The reapplied variable values will be reflected in the receiver's 
 `variableSpace` until the scope is exited or the receiver's
 `unsetScopedVariables` method is called.
 */
- (void) reapplyScopedVariables;

/*----------------------------------------------------------------------------*/
#pragma mark Keyed subscripting support
/*!    @name Keyed subscripting support                                       */
/*----------------------------------------------------------------------------*/

/*!
 Allows accessing scoped variable values using the Objective-C keyed
 subscripting notation.

 For example, the following expression:

 [MBScopedVariables currentVariableScope][@"tempVar"]

 would yield the in-scope value of the MBML variable named `tempVar`.

 @param     variableName The name of the scoped variable whose value is to be
            retrieved.

 @return    The in-scope value of the MBML variable named `variableName`.
 */
- (id) objectForKeyedSubscript:(NSString*)variableName;

/*!
 Allows setting a scoped variable value using the Objective-C keyed
 subscripting notation.

 For example, the following expression:

 [MBScopedVariables currentVariableScope][@"tempVar"] = @"will go away"

 would set the in-scope value of the MBML variable named `tempVar` to the
 string "`will go away`".

 @param     value The new value for the MBML variable.

 @param     variableName The name of the scoped variable whose value is to be
            set.
 */
- (void) setObject:(id)value forKeyedSubscript:(NSString*)variableName;

@end
