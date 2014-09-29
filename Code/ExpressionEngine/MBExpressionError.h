//
//  MBExpressionError.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/12/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBMLParseToken;

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionError class
/******************************************************************************/

/*!
 Used internally by the MBExpression engine to represent errors
 during expression parsing and evaluation.
 */
@interface MBExpressionError : NSObject

@property(nonatomic, strong) NSString* message;
@property(nonatomic, strong) NSError* error;
@property(nonatomic, strong) NSException* exception;
@property(nonatomic, strong, readonly) NSArray* additionalErrors;
@property(nonatomic, strong) id value;
@property(nonatomic, strong) MBMLParseToken* offendingToken;
@property(nonatomic, strong) NSString* offendingExpression;

+ (id) error;
+ (id) errorWithMessage:(NSString*)msg;
+ (id) errorWithMessage:(NSString*)msg error:(NSError*)nsErr;
+ (id) errorWithMessage:(NSString*)msg exception:(NSException*)ex;
+ (id) errorWithFormat:(NSString*)format, ...;
+ (id) errorWithError:(NSError*)nsErr;
+ (id) errorWithException:(NSException*)ex;
+ (id) errorWithExpressionErrors:(NSArray*)errors;

- (NSString*) logOutput;
- (void) log;

- (void) addError:(MBExpressionError*)error;

- (void) reportErrorTo:(MBExpressionError**)reportTo;
- (void) reportErrorTo:(MBExpressionError**)reportTo suppressLog:(BOOL)suppress;

- (BOOL) errorReported;
- (MBExpressionError*) lastErrorReported;
- (void) clearErrorReported;

- (NSString*) describeOffense;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBParseError class
/******************************************************************************/

/*!
 Used internally by the MBExpression engine to represent errors
 during expression parsing.
 */
@interface MBParseError : MBExpressionError
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBEvaluationError class
/******************************************************************************/

/*!
 Used internally by the MBExpression engine to represent errors
 during expression evaluation.
 */
@interface MBEvaluationError : MBExpressionError
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFunctionError class
/******************************************************************************/

/*!
 Used internally by the MBExpression engine to represent errors
 during calls to MBML functions.
 */
@interface MBMLFunctionError : MBExpressionError
@end

