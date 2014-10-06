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

extern NSString* const kMBLibraryClassPrefix;

/******************************************************************************/
#pragma mark Constants - Mockingbird string constants
/******************************************************************************/

extern NSString* const kMBEmptyString;
extern NSString* const kMBWildcardString;

/******************************************************************************/
#pragma mark Constants - Interface orientation
/******************************************************************************/

extern NSString* const kMBInterfaceOrientationPortrait;
extern NSString* const kMBInterfaceOrientationLandscape;

/******************************************************************************/
#pragma mark Constants - MBML implicit variables
/******************************************************************************/

extern NSString* const kMBMLVariableItem;
extern NSString* const kMBMLVariableKey;
extern NSString* const kMBMLVariableRoot;
extern NSString* const kMBMLVariableRootKey;

/******************************************************************************/
#pragma mark Constants - MBML variable name suffixes
/******************************************************************************/

extern NSString* const kMBMLVariableSuffixRequestPending;
extern NSString* const kMBMLVariableSuffixLastRequestFailed;

/******************************************************************************/
#pragma mark Constants - MBML attribute names
/******************************************************************************/

extern NSString* const kMBMLAttributeName;
extern NSString* const kMBMLAttributeIf;
extern NSString* const kMBMLAttributeDataSource;
extern NSString* const kMBMLAttributeClass;             // consider deprecating in favor of className
extern NSString* const kMBMLAttributeValue;
extern NSString* const kMBMLAttributeBoolean;
extern NSString* const kMBMLAttributeLiteral;
extern NSString* const kMBMLAttributeVar;
extern NSString* const kMBMLAttributeMethod;
extern NSString* const kMBMLAttributeInput;
extern NSString* const kMBMLAttributeOutput;
extern NSString* const kMBMLAttributeDeprecated;
extern NSString* const kMBMLAttributeDeprecatedInFavorOf;
extern NSString* const kMBMLAttributeDeprecationMessage;
extern NSString* const kMBMLAttributeType;
extern NSString* const kMBMLAttributeMutable;
extern NSString* const kMBMLAttributeUserDefaultsName;
extern NSString* const kMBMLAttributeFile;
extern NSString* const kMBMLAttributeExpression;
extern NSString* const kMBMLAttributeModules;

/******************************************************************************/
#pragma mark Constants - MBML attribute names used by multiple external modules
/******************************************************************************/

extern NSString* const kMBMLAttributeURL;
extern NSString* const kMBMLAttributeMessage;
extern NSString* const kMBMLAttributeEvent;
extern NSString* const kMBMLAttributeTarget;
