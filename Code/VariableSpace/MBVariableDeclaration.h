//
//  MBVariableDeclaration.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 9/6/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MBDataModel.h"

@class MBVariableSpace;
@class MBExpressionError;

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

extern NSString* const kMBMLVariableTypeSingleton;  //!< @"singleton"
extern NSString* const kMBMLVariableTypeDynamic;    //!< @"dynamic"
extern NSString* const kMBMLVariableTypeMap;        //!< @"map"
extern NSString* const kMBMLVariableTypeList;       //!< @"list"

/******************************************************************************/
#pragma mark Type
/******************************************************************************/

typedef enum {
    MBConcreteVariableTypeUnknown = 0,
    MBConcreteVariableTypeSimple,
    MBConcreteVariableTypeMap,
    MBConcreteVariableTypeList,
} MBConcreteVariableType;

/******************************************************************************/
#pragma mark -
#pragma mark MBVariableDeclaration class
/******************************************************************************/

@interface MBVariableDeclaration : MBDataModel

/*! Returns the name of the variable. */
@property(nonatomic, readonly) NSString* name;

/*! Returns `YES` if the variable contains a read-only value. */
@property(nonatomic, readonly) BOOL isReadOnly;

/*! Returns `YES` if the variable's value should not be cached by the
    `MBVariableSpace`. By definition, such variables are also read-only. */
@property(nonatomic, readonly) BOOL disallowsValueCaching;

/******************************************************************************/
#pragma mark Accessing variable values
/******************************************************************************/

/*! 
 Returns the initial value of the variable in the given variable space. 
 
 @param     space The `MBVariableSpace` for which the initial value is to be
            retrieved.
 
 @param     errPtr If non-`nil` and an error occurs during retrival of the
            variable value, this value will be set to an `MBExpressionError`
            object describing the error.

 @note      This method should not be called for variables whose
            `disallowsValueCaching` property returns `YES`; in such
            cases, an exception is raised.
 */
- (id) initialValueInVariableSpace:(MBVariableSpace*)space
                             error:(out MBExpressionError**)errPtr;

/*!
 Returns the current value of the variable in the given variable space.
 
 @param     space The `MBVariableSpace` for which the current value is to be
            retrieved.

 @param     errPtr If non-`nil` and an error occurs during retrival of the
            variable value, this value will be set to an `MBExpressionError`
            object describing the error.
 */
- (id) currentValueInVariableSpace:(MBVariableSpace*)space
                             error:(out MBExpressionError**)errPtr;

/******************************************************************************/
#pragma mark Variable value change hook
/******************************************************************************/

/*! Called when a variable value has changed in a given variable space. */
- (void) valueChangedTo:(id)value inVariableSpace:(MBVariableSpace*)space;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBConcreteVariableDeclaration class
/******************************************************************************/

@interface MBConcreteVariableDeclaration : MBVariableDeclaration

@property(nonatomic, readonly) MBConcreteVariableType declaredType;
@property(nonatomic, readonly) id declaredValue;
@property(nonatomic, readonly) BOOL isLiteralValue;
@property(nonatomic, readonly) BOOL isBooleanValue;
@property(nonatomic, readonly) NSString* userDefaultsName;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBSingletonVariableDeclaration class
/******************************************************************************/

@interface MBSingletonVariableDeclaration : MBVariableDeclaration

@property(nonatomic, readonly) Class implementingClass;
@property(nonatomic, readonly) SEL singletonAccessor;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBDynamicVariableDeclaration class
/******************************************************************************/

@interface MBDynamicVariableDeclaration : MBVariableDeclaration

@property(nonatomic, readonly) NSString* expression;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBStringValueCoding protocol
/******************************************************************************/

/*!
 Classes that adopt this protocol gain the ability to be stored in the
 <code>NSUserDefaults</code> as strings. This allows native objects to be
 stored using the template &lt;Var&gt;'s <code>userDefaultsName</code>
 mechanism.
 */
@protocol MBStringValueCoding <NSObject>
/*!
 Constructs and returns a new, autoreleased instance of the receiver. The
 returned object's internal state will be set based on the value of the
 passed-in string.
 
 @param     str the input string
 
 @return    a new instance of the receiver
 */
@required
+ (id) fromStringValue:(NSString*)str;

/*!
 Returns a string representation of the object's internal state.
 
 @return    a string that, if passed to <code>fromStringValue:</code>, would
            return a new instance that <code>isEqual:</code> to this receiver.
 */
@optional
- (NSString*) stringValue;
@end
