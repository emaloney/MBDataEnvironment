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

extern NSString* const __nullable kMBLibraryClassPrefix;

/******************************************************************************/
#pragma mark Constants - Mockingbird string constants
/******************************************************************************/

extern NSString* const __nullable kMBEmptyString;
extern NSString* const __nullable kMBWildcardString;

/******************************************************************************/
#pragma mark Constants - Interface orientation
/******************************************************************************/

extern NSString* const __nullable kMBInterfaceOrientationPortrait;
extern NSString* const __nullable kMBInterfaceOrientationLandscape;

/******************************************************************************/
#pragma mark Constants - MBML implicit variables
/******************************************************************************/

extern NSString* const __nullable kMBMLVariableItem;
extern NSString* const __nullable kMBMLVariableKey;
extern NSString* const __nullable kMBMLVariableRoot;
extern NSString* const __nullable kMBMLVariableRootKey;

/******************************************************************************/
#pragma mark Constants - MBML variable name suffixes
/******************************************************************************/

extern NSString* const __nullable kMBMLVariableSuffixRequestPending;
extern NSString* const __nullable kMBMLVariableSuffixLastRequestFailed;

/******************************************************************************/
#pragma mark Constants - MBML attribute names
/******************************************************************************/

extern NSString* const __nullable kMBMLAttributeName;
extern NSString* const __nullable kMBMLAttributeIf;
extern NSString* const __nullable kMBMLAttributeDataSource;
extern NSString* const __nullable kMBMLAttributeClass;             // consider deprecating in favor of className
extern NSString* const __nullable kMBMLAttributeValue;
extern NSString* const __nullable kMBMLAttributeBoolean;
extern NSString* const __nullable kMBMLAttributeLiteral;
extern NSString* const __nullable kMBMLAttributeVar;
extern NSString* const __nullable kMBMLAttributeMethod;
extern NSString* const __nullable kMBMLAttributeInput;
extern NSString* const __nullable kMBMLAttributeOutput;
extern NSString* const __nullable kMBMLAttributeDeprecated;
extern NSString* const __nullable kMBMLAttributeDeprecatedInFavorOf;
extern NSString* const __nullable kMBMLAttributeDeprecationMessage;
extern NSString* const __nullable kMBMLAttributeType;
extern NSString* const __nullable kMBMLAttributeMutable;
extern NSString* const __nullable kMBMLAttributeUserDefaultsName;
extern NSString* const __nullable kMBMLAttributeFile;
extern NSString* const __nullable kMBMLAttributeExpression;
extern NSString* const __nullable kMBMLAttributeModules;

/******************************************************************************/
#pragma mark Constants - MBML attribute names used by multiple external modules
/******************************************************************************/

extern NSString* const __nullable kMBMLAttributeURL;
extern NSString* const __nullable kMBMLAttributeMessage;
extern NSString* const __nullable kMBMLAttributeEvent;
extern NSString* const __nullable kMBMLAttributeTarget;
