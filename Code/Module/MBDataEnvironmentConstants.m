//
//  MBDataEnvironmentConstants.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 8/9/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MBDataEnvironmentConstants.h"

/******************************************************************************/
#pragma mark Constants - Mockingbird class prefix
/******************************************************************************/

NSString* const kMBLibraryClassPrefix = @"MB";

/******************************************************************************/
#pragma mark Constants - Mockingbird string constants
/******************************************************************************/

NSString* const kMBEmptyString      = @"";
NSString* const kMBWildcardString   = @"*";

/******************************************************************************/
#pragma mark Constants - Interface orientation
/******************************************************************************/

NSString* const kMBInterfaceOrientationPortrait         = @"portrait";
NSString* const kMBInterfaceOrientationLandscape        = @"landscape";

/******************************************************************************/
#pragma mark Constants - MBML implicit variables
/******************************************************************************/

NSString* const kMBMLVariableItem                       = @"item";
NSString* const kMBMLVariableKey                        = @"key";
NSString* const kMBMLVariableRoot                       = @"root";
NSString* const kMBMLVariableRootKey                    = @"rootKey";
NSString* const kMBMLVariableError                      = @"error";

/******************************************************************************/
#pragma mark Constants - MBML variable name suffixes
/******************************************************************************/

NSString* const kMBMLVariableSuffixRequestPending       = @"requestPending";
NSString* const kMBMLVariableSuffixLastRequestFailed    = @"lastRequestFailed";

/******************************************************************************/
#pragma mark Constants - MBML attribute names
/******************************************************************************/

NSString* const kMBMLAttributeName                              = @"name";
NSString* const kMBMLAttributeIf                                = @"if";
NSString* const kMBMLAttributeDataSource                        = @"dataSource";
NSString* const kMBMLAttributeClass                             = @"class";
NSString* const kMBMLAttributeObject                            = @"object";
NSString* const kMBMLAttributeValue                             = @"value";
NSString* const kMBMLAttributeBoolean                           = @"boolean";
NSString* const kMBMLAttributeLiteral                           = @"literal";
NSString* const kMBMLAttributeVar                               = @"var";
NSString* const kMBMLAttributeMethod                            = @"method";
NSString* const kMBMLAttributeInput                             = @"input";
NSString* const kMBMLAttributeOutput                            = @"output";
NSString* const kMBMLAttributeDeprecated                        = @"deprecated";
NSString* const kMBMLAttributeDeprecatedInFavorOf               = @"deprecatedInFavorOf";
NSString* const kMBMLAttributeDeprecationMessage                = @"deprecationMessage";
NSString* const kMBMLAttributeType                              = @"type";
NSString* const kMBMLAttributeMutable                           = @"mutable";
NSString* const kMBMLAttributeUserDefaultsName                  = @"userDefaultsName";
NSString* const kMBMLAttributeFile                              = @"file";
NSString* const kMBMLAttributeExpression                        = @"expression";
NSString* const kMBMLAttributeModules                           = @"modules";

/******************************************************************************/
#pragma mark Constants - MBML attribute names used by multiple external modules
/******************************************************************************/

NSString* const kMBMLAttributeURL                               = @"url";
NSString* const kMBMLAttributeMessage                           = @"message";
NSString* const kMBMLAttributeEvent                             = @"event";
NSString* const kMBMLAttributeTarget                            = @"target";
