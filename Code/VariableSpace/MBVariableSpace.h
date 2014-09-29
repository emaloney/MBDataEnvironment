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
@class MBDataFilter;
@class MBMLFunction;

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

// posted to NSNotificationCenter when a new function is declared in a variable space
extern NSString* const kMBVariableSpaceDidDeclareFunctionEvent;

/******************************************************************************/
#pragma mark -
#pragma mark MBVariableSpace class
/******************************************************************************/

@interface MBVariableSpace : MBEnvironmentLoader < MBInstanceVendor >

/*----------------------------------------------------------------------------*/
#pragma mark Accessing variable values
/*!    @name Accessing variable values                                        */
/*----------------------------------------------------------------------------*/

- (NSDictionary*) varDictionary;
- (id) variableForName:(NSString*)varName;
- (id) variableForName:(NSString*)varName defaultValue:(id)def;
- (NSString*) variableAsString:(NSString*)varName;
- (NSString*) variableAsString:(NSString*)varName defaultValue:(NSString*)def;

/*----------------------------------------------------------------------------*/
#pragma mark Modifying variable values
/*!    @name Modifying variable values                                        */
/*----------------------------------------------------------------------------*/

- (void) setVariable:(NSString*)varName value:(id)val;
- (void) pushVariable:(NSString*)varName value:(id)val;
- (id) popVariable:(NSString*)varName;
- (void) setMapVariable:(NSString*)varName mapKey:(NSString*)key value:(id)val;
- (void) setListVariable:(NSString*)varName listIndex:(NSUInteger)idx value:(id)val;
- (void) unsetVariable:(NSString*)varName;

/*----------------------------------------------------------------------------*/
#pragma mark Constructing variable-related names
/*!    @name Constructing variable-related names                              */
/*----------------------------------------------------------------------------*/

/*!
 Constructs a string for an variable-related name with the given suffix.

 @param     name The name to use for the root of the returned string. If
            `nil`, this method returns `nil`.

 @param     suffix The optional suffix to apply to `name`. If `nil`, this
            method returns `name`.

 @return    If `name` and `suffix` are both non-`nil`, the concatenation of
            `name`, `:` and `suffix` is returned. Otherwise, the value of the
            `name` parameter is returned.
 */
+ (NSString*) name:(NSString*)name withSuffix:(NSString*)suffix;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing variable information
/*!    @name Accessing variable information                                   */
/*----------------------------------------------------------------------------*/

- (BOOL) isReadOnlyVariable:(NSString*)varName;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing variable declarations
/*!    @name Accessing variable declarations                                  */
/*----------------------------------------------------------------------------*/

- (BOOL) declareVariable:(MBVariableDeclaration*)declaration;
- (MBVariableDeclaration*) declarationForVariable:(NSString*)varName;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing MBML functions
/*!    @name Accessing MBML functions                                         */
/*----------------------------------------------------------------------------*/

- (BOOL) declareFunction:(MBMLFunction*)function;
- (NSArray*) functionNames;
- (MBMLFunction*) functionWithName:(NSString*)name;

/*----------------------------------------------------------------------------*/
#pragma mark Observing changes to variables bound to `NSUserDefaults`
/*!    @name Observing changes to variables bound to `NSUserDefaults`         */
/*----------------------------------------------------------------------------*/

// allows observing changes to persistent user defaults
- (void) addObserverForUserDefault:(NSString*)userDefaultsName target:(id)target action:(SEL)action;
- (void) removeObserver:(id)observer forUserDefault:(NSString*)userDefaultsName;

/*----------------------------------------------------------------------------*/
#pragma mark Keyed subscripting support
/*!    @name Keyed subscripting support                                       */
/*----------------------------------------------------------------------------*/

/*!
 Allows accessing MBML variable values using the Objective-C keyed subscripting
 notation.
 
 For example, the following expression:
 
    [MBVariableSpace instance][@"email"]
 
 would yield the value of the MBML variable named `email`.
 
 @param     variableName The name of the MBML variable whose value is to be
            retrieved.
 
 @return    The value of the MBML variable named `variableName`.
 */
- (id) objectForKeyedSubscript:(NSString*)variableName;

/*!
 Allows setting an MBML variable value using the Objective-C keyed subscripting
 notation.
 
 For example, the following expression:
 
    [MBVariableSpace instance][@"title"] = @"MBML"

 would set the MBML variable named `title` to the string "`MBML`".
 
 @param     value The new value for the MBML variable.
 
 @param     variableName The name of the attribute whose value is to be set.
 */
- (void) setObject:(id)value forKeyedSubscript:(NSString*)variableName;

@end
