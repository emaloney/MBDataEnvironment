//
//  MBDataEnvironment.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 3/18/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

#ifndef __OBJC__

#error Mockingbird Data Environment requires Objective-C

#else

#import <Foundation/Foundation.h>

//! Project version number for MBDataEnvironment.
FOUNDATION_EXPORT double MBDataEnvironmentVersionNumber;

//! Project version string for MBDataEnvironment.
FOUNDATION_EXPORT const unsigned char MBDataEnvironmentVersionString[];

//
// NOTE: This header file is indended for external use. It should *not* be
//       included from within code in the Mockingbird Data Environment itself.
//

// import headers from inherited modules
#import <MBToolbox/MBToolbox.h>

// import the public headers
#import <MBDataEnvironment/MBAttributeValidator.h>
#import <MBDataEnvironment/MBDataModel.h>
#import <MBDataEnvironment/MBDevice.h>
#import <MBDataEnvironment/MBEnvironment.h>
#import <MBDataEnvironment/MBEnvironmentLoader.h>
#import <MBDataEnvironment/MBEvents+DataLoading.h>
#import <MBDataEnvironment/MBExpression.h>
#import <MBDataEnvironment/MBExpressionCache.h>
#import <MBDataEnvironment/MBExpressionError.h>
#import <MBDataEnvironment/MBExpressionExtensions.h>
#import <MBDataEnvironment/MBMLCollectionFunctions.h>
#import <MBDataEnvironment/MBMLDataProcessingFunctions.h>
#import <MBDataEnvironment/MBMLDateFunctions.h>
#import <MBDataEnvironment/MBMLDebugFunctions.h>
#import <MBDataEnvironment/MBMLEncodingFunctions.h>
#import <MBDataEnvironment/MBMLEnvironmentFunctions.h>
#import <MBDataEnvironment/MBMLFileFunctions.h>
#import <MBDataEnvironment/MBMLFontFunctions.h>
#import <MBDataEnvironment/MBMLGeometryFunctions.h>
#import <MBDataEnvironment/MBMLLogicFunctions.h>
#import <MBDataEnvironment/MBMLMathFunctions.h>
#import <MBDataEnvironment/MBMLRegexFunctions.h>
#import <MBDataEnvironment/MBMLResourceFunctions.h>
#import <MBDataEnvironment/MBMLRuntimeFunctions.h>
#import <MBDataEnvironment/MBMLStringFunctions.h>
#import <MBDataEnvironment/MBMLFunction.h>
#import <MBDataEnvironment/MBDataEnvironmentConstants.h>
#import <MBDataEnvironment/MBDataEnvironmentModule.h>
#import <MBDataEnvironment/MBStringConversions.h>
#import <MBDataEnvironment/TypeCoercionSupport.h>
#import <MBDataEnvironment/MBScopedVariables.h>
#import <MBDataEnvironment/MBVariableDeclaration.h>
#import <MBDataEnvironment/MBVariableSpace.h>

#endif

