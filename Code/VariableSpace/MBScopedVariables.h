//
//  MBScopedVariables.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 10/6/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

@class MBVariableSpace;
@class MBScopedVariables;

#import <MBToolbox/MBFormattedDescriptionObject.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBScopedVariables class
/******************************************************************************/

/*!
 Provides a mechanism for maintaining scoped variable values in the
 context of a particular <code>MBVariableSpace</code> instance.
 */
@interface MBScopedVariables : MBFormattedDescriptionObject < NSCopying >

@property(nonatomic, readonly) MBVariableSpace* variableSpace;

/******************************************************************************
 @name Thread-local scoped variables
 ******************************************************************************/

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

/******************************************************************************
 @name Creating variable scopes
 ******************************************************************************/

/*!
 Initializes the receiver with the given variable space.
 
 @param     vars The `MBVariableSpace` instance where variable valued will
            be maintained while the scope is in use.

 @return    `self`
 */
- (id) initWithVariableSpace:(MBVariableSpace*)vars;

/*!
 Initializes the receiver using the `MBVariableSpace` associated with the
 current `MBEnvironment`
 
 @return    `self`
 */
- (id) init;

/******************************************************************************
 @name Setting & unsetting scoped variable values
 ******************************************************************************/

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

@end
