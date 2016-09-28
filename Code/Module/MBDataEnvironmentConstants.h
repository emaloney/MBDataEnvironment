//
//  MBDataEnvironmentConstants.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 8/9/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark Constants - Mockingbird class prefix
/******************************************************************************/

extern NSString* const __nonnull kMBLibraryClassPrefix;

/******************************************************************************/
#pragma mark Constants - Mockingbird string constants
/******************************************************************************/

extern NSString* const __nonnull kMBEmptyString;
extern NSString* const __nonnull kMBWildcardString;

/******************************************************************************/
#pragma mark Constants - Interface orientation
/******************************************************************************/

extern NSString* const __nonnull kMBInterfaceOrientationPortrait;
extern NSString* const __nonnull kMBInterfaceOrientationLandscape;

/******************************************************************************/
#pragma mark Constants - MBML implicit variables
/******************************************************************************/

extern NSString* const __nonnull kMBMLVariableItem;
extern NSString* const __nonnull kMBMLVariableKey;
extern NSString* const __nonnull kMBMLVariableRoot;
extern NSString* const __nonnull kMBMLVariableRootKey;

/******************************************************************************/
#pragma mark Constants - MBML variable name suffixes
/******************************************************************************/

extern NSString* const __nonnull kMBMLVariableSuffixRequestPending;
extern NSString* const __nonnull kMBMLVariableSuffixLastRequestFailed;

/******************************************************************************/
#pragma mark Constants - MBML attribute names
/******************************************************************************/

extern NSString* const __nonnull kMBMLAttributeName;
extern NSString* const __nonnull kMBMLAttributeIf;
extern NSString* const __nonnull kMBMLAttributeDataSource;
extern NSString* const __nonnull kMBMLAttributeClass;             // consider deprecating in favor of className
extern NSString* const __nonnull kMBMLAttributeObject;
extern NSString* const __nonnull kMBMLAttributeValue;
extern NSString* const __nonnull kMBMLAttributeBoolean;
extern NSString* const __nonnull kMBMLAttributeLiteral;
extern NSString* const __nonnull kMBMLAttributeVar;
extern NSString* const __nonnull kMBMLAttributeMethod;
extern NSString* const __nonnull kMBMLAttributeInput;
extern NSString* const __nonnull kMBMLAttributeOutput;
extern NSString* const __nonnull kMBMLAttributeDeprecated;
extern NSString* const __nonnull kMBMLAttributeDeprecatedInFavorOf;
extern NSString* const __nonnull kMBMLAttributeDeprecationMessage;
extern NSString* const __nonnull kMBMLAttributeType;
extern NSString* const __nonnull kMBMLAttributeMutable;
extern NSString* const __nonnull kMBMLAttributeUserDefaultsName;
extern NSString* const __nonnull kMBMLAttributeFile;
extern NSString* const __nonnull kMBMLAttributeExpression;
extern NSString* const __nonnull kMBMLAttributeModules;

/******************************************************************************/
#pragma mark Constants - MBML attribute names used by multiple external modules
/******************************************************************************/

extern NSString* const __nonnull kMBMLAttributeURL;
extern NSString* const __nonnull kMBMLAttributeMessage;
extern NSString* const __nonnull kMBMLAttributeEvent;
extern NSString* const __nonnull kMBMLAttributeTarget;
