//
//  MBVariableDeclaration.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 9/6/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MBConditionalDeclaration.h"
#import "MBExpressionError.h"

@class MBVariableSpace;
@class MBExpressionError;

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

extern NSString* const __nonnull kMBMLVariableTypeSingleton;  //!< @"singleton"
extern NSString* const __nonnull kMBMLVariableTypeDynamic;    //!< @"dynamic"
extern NSString* const __nonnull kMBMLVariableTypeMap;        //!< @"map"
extern NSString* const __nonnull kMBMLVariableTypeList;       //!< @"list"

/******************************************************************************/
#pragma mark Type
/******************************************************************************/

/*!
 Specifies the type of variable declared by an `MBConcreteVariableDeclaration`.
 */
typedef NS_ENUM(NSUInteger, MBConcreteVariableType)
{
    /*! The variable type is not yet known. */
    MBConcreteVariableTypeUnknown = 0,

    /*! The variable type is declared as a simple `NSObject` instance. */
    MBConcreteVariableTypeSimple,

    /*! The variable type is declared as a *map* (the underlying type is
        `NSDictionary`). */
    MBConcreteVariableTypeMap,

    /*! The variable type is declared as a *list* (the underlying type is
        `NSArray`). */
    MBConcreteVariableTypeList
};

/******************************************************************************/
#pragma mark -
#pragma mark MBVariableDeclaration class
/******************************************************************************/

/*!
 A partially-implemented root class that represents a variable declared in MBML.
 
 The `MBConcreteVariableDeclaration`, `MBSingletonVariableDeclaration`, and 
 `MBDynamicVariableDeclaration` classes provide specific implementations.
 */
@interface MBVariableDeclaration : MBConditionalDeclaration

/*----------------------------------------------------------------------------*/
#pragma mark Variable information
/*!    @name Variable information                                             */
/*----------------------------------------------------------------------------*/

/*! Returns the name of the variable. */
@property(nullable, nonatomic, readonly) NSString* name;

/*! Returns `YES` if the variable contains a read-only value. */
@property(nonatomic, readonly) BOOL isReadOnly;

/*! Returns `YES` if the variable's value should not be cached by the
    `MBVariableSpace`. By definition, such variables are also read-only. */
@property(nonatomic, readonly) BOOL disallowsValueCaching;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing variable values
/*!    @name Accessing variable values                                        */
/*----------------------------------------------------------------------------*/

/*! 
 Returns the initial value of the variable in the given variable space. 
 
 @param     space The `MBVariableSpace` for which the initial value is to be
            retrieved.
 
 @param     errPtr If non-`nil` and an error occurs during retrival of the
            variable value, `*errPtr` will be set to an `MBExpressionError`
            object describing the error.

 @note      This method should not be called for variables whose
            `disallowsValueCaching` property returns `YES`; in such
            cases, an exception is raised.
 */
- (nullable id) initialValueInVariableSpace:(nonnull MBVariableSpace*)space
                                      error:(MBExpressionErrorPtrPtr)errPtr;

/*!
 Returns the current value of the variable in the given variable space.
 
 @param     space The `MBVariableSpace` for which the current value is to be
            retrieved.

 @param     errPtr If non-`nil` and an error occurs during retrival of the
            variable value, `*errPtr` will be set to an `MBExpressionError`
            object describing the error.
 */
- (nullable id) currentValueInVariableSpace:(nonnull MBVariableSpace*)space
                                      error:(MBExpressionErrorPtrPtr)errPtr;

/*----------------------------------------------------------------------------*/
#pragma mark Variable value change hook
/*!    @name Variable value change hook                                       */
/*----------------------------------------------------------------------------*/

/*!
 Called when a mutable variable value has changed.
 
 @param     value The new value of the variable.
 
 @param     space The `MBVariableSpace` instance that owns the receiver.
 */
- (void) valueChangedTo:(nullable id)value inVariableSpace:(nonnull MBVariableSpace*)space;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBConcreteVariableDeclaration class
/******************************************************************************/

/*!
 An `MBVariableDeclaration` that represents a concrete variable. Concrete
 variables are those whose values are `NSObject` instances stored in the
 `MBVariableSpace`.
 */
@interface MBConcreteVariableDeclaration : MBVariableDeclaration

/*! Returns an `MBConcreteVariableType` value indicating the variable's type
    as declared by the **`type="`***type***`"`** attribute in MBML.
    Defaults to `MBConcreteVariableTypeSimple` if no type attribute is
    specified. */
@property(nonatomic, readonly) MBConcreteVariableType declaredType;

/*! Returns the variable value as it was originally declared in MBML. Note
    that this may not necessarily be the same as the current value. */
@property(nullable, nonatomic, readonly) id declaredValue;

/*! Indicates whether the receiver represents a *literal value*. Literal values
    are not evaluated as expressions when they are set. In MBML, a literal
    value is specified using the **`literal="`***expr***`"`** attribute
    where *expr* is an arbitrary text string. */
@property(nonatomic, readonly) BOOL isLiteralValue;

/*! Indicates whether the receiver represents a *boolean value*. Boolean values
    are evaluated as boolean expressions when they are set. In MBML, a boolean
    value is specified using the **`boolean="`***expr***`"`** attribute
    where *expr* is an Mockingbird expression evaluated in a boolean context. */
@property(nonatomic, readonly) BOOL isBooleanValue;

/*! If the receiver is bound to an `NSUserDefaults` value, this property
    returns the name of the value (also known as the *key*) within the
    `NSUserDefaults`'s `standardUserDefaults`. Will be `nil` is there is
    no `NSUserDefaults` value associated with the receiver. */
@property(nullable, nonatomic, readonly) NSString* userDefaultsName;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBSingletonVariableDeclaration class
/******************************************************************************/

/*!
 An `MBVariableDeclaration` that represents a singleton object.

 A singleton can be declared from any class method that takes no arguments
 and returns an object instance. Typically, singleton variables are used
 to expose objects like `UIDevice` and `UIScreen` to the variable space.
 */
@interface MBSingletonVariableDeclaration : MBVariableDeclaration

/*! Returns the `Class` that implements the singleton. */
@property(nullable, nonatomic, readonly) Class implementingClass;

/*! Returns the method selector for the singleton's accessor. */
@property(nullable, nonatomic, readonly) SEL singletonAccessor;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBDynamicVariableDeclaration class
/******************************************************************************/

/*!
 An `MBVariableDeclaration` that represents a dynamic variable.

 Dynamic variables are those whose values are supplied by a Mockingbird
 expression. When a dynamic variable's value is requested, the expression
 associated with the dynamic variable is evaluated in an object context,
 and the resulting value is returned.
 */
@interface MBDynamicVariableDeclaration : MBVariableDeclaration

/*! This property returns the Mockingbird expression that will provide the
    variable's value when it is requested. */
@property(nullable, nonatomic, readonly) NSString* expression;

@end
