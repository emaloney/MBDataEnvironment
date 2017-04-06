//
//  MBExpressionError.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/12/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

@import Foundation;

@class MBMLParseToken;
@class MBExpressionError;
@class MBParseError;
@class MBEvaluationError;
@class MBMLFunctionError;

/******************************************************************************/
#pragma mark Types
/******************************************************************************/

typedef MBExpressionError* __autoreleasing  __nullable * __nullable MBExpressionErrorPtrPtr;
typedef MBParseError* __autoreleasing  __nullable * __nullable MBParseErrorPtrPtr;
typedef MBEvaluationError* __autoreleasing  __nullable * __nullable MBEvaluationErrorPtrPtr;
typedef MBMLFunctionError* __autoreleasing  __nullable * __nullable MBMLFunctionErrorPtrPtr;

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionError class
/******************************************************************************/

/*!
 Represents errors that can occur during `MBExpression` parsing and evaluation.
 */
@interface MBExpressionError : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Properties
/*!    @name Properties                                                       */
/*----------------------------------------------------------------------------*/

/*! Returns a message explaining the error. */
@property(nullable, nonatomic, readonly) NSString* message;

/*! If the receiver was caused by an underlying `NSError`, this property will
    contain the original error. Otherwise, `nil`. */
@property(nullable, nonatomic, readonly) NSError* causedByError;

/*! If the receiver was caused by an underlying `NSException`, this property 
    will contain the original exception. Otherwise, `nil`. */
@property(nullable, nonatomic, readonly) NSException* causedByException;

/*! Returns an array of `MBExpressionError`s related to the receiver. May
    be `nil`. */
@property(nullable, nonatomic, readonly) NSArray* additionalErrors;

/*! Stores an arbitrary value related to the error. */
@property(nullable, nonatomic, strong) id value;

/*! Stores a reference to the MBML expression in which the error occurred. */
@property(nullable, nonatomic, strong) NSString* offendingExpression;

/*! Stores a reference to an `MBMLParseToken` involved in the error, which
    is useful for pinpointing the problematic portion of the 
    `offendingExpression`. */
@property(nullable, nonatomic, strong) MBMLParseToken* offendingToken;

/*----------------------------------------------------------------------------*/
#pragma mark Creating instances
/*!    @name Creating instances                                               */
/*----------------------------------------------------------------------------*/

/*!
 Creates a new `MBExpressionError` instance containing the specified message.
 
 @param     msg The error message.
 
 @return    A new `MBExpressionError`.
 */
+ (nonnull instancetype) errorWithMessage:(nonnull NSString*)msg;

/*!
 Creates a new `MBExpressionError` instance to represent an underlying
 `NSError`.

 @param     msg The error message.
 
 @param     nsErr The `NSError` instance.

 @return    A new `MBExpressionError`.
 */
+ (nonnull instancetype) errorWithMessage:(nonnull NSString*)msg error:(nullable NSError*)nsErr;

/*!
 Creates a new `MBExpressionError` instance to represent an underlying
 `NSException`.

 @param     msg The error message.
 
 @param     ex The `NSException` instance.

 @return    A new `MBExpressionError`.
 */
+ (nonnull instancetype) errorWithMessage:(nonnull NSString*)msg exception:(nullable NSException*)ex;

/*!
 Creates a new `MBExpressionError` instance containing a message constructed
 from the specified format string and parameters.

 @param     format The format for the error message, followed by zero or more
            format parameters.

 @param     ... A variable argument list of zero or more values referenced
            within the `format` string.

 @return    A new `MBExpressionError`.
 */
+ (nonnull instancetype) errorWithFormat:(nonnull NSString*)format, ...;

/*!
 Creates a new `MBExpressionError` instance to represent an underlying
 `NSError`.

 @param     nsErr The `NSError` instance.

 @return    A new `MBExpressionError`.
 */
+ (nonnull instancetype) errorWithError:(nonnull NSError*)nsErr;

/*!
 Creates a new `MBExpressionError` instance to represent an underlying
 `NSException`.

 @param     ex The `NSException` instance.

 @return    A new `MBExpressionError`.
 */
+ (nonnull instancetype) errorWithException:(nonnull NSException*)ex;

/*----------------------------------------------------------------------------*/
#pragma mark Error logging
/*!    @name Error logging                                                    */
/*----------------------------------------------------------------------------*/

/*!
 Returns a string containing the output that would be written to the console
 if `log` were to be called.
 
 @return    The log output.
 */
- (nonnull NSString*) logOutput;

/*!
 Logs the error to the console.
 */
- (void) log;

/*----------------------------------------------------------------------------*/
#pragma mark Reporting errors
/*!    @name Reporting errors                                                 */
/*----------------------------------------------------------------------------*/

/*!
 Reports the receiving error. The behavior of reporting depends on the contents
 of the `reportTo` parameter:
 
 * If `reportTo` is `nil`, the receiver will be logged to the console using
   the `log` method.
 
 * If `reportTo` is non-`nil` but `*reportTo` is `nil`, the memory location
   pointed to by `*reportTo` will be updated to contain the receiver.
 
 * If `reportTo` is a non-`nil` pointer to an `MBExpressionError` instance
   the receiver will be reported to that error, meaning the receiver becomes
   its `lastErrorReported`.
 
 @param     reportTo Determines where the receiver will be reported.
 */
- (void) reportErrorTo:(MBExpressionErrorPtrPtr)reportTo;

/*!
 Reports the receiving error. The behavior of reporting depends on the contents
 of the `reportTo` parameter:
 
 * If `reportTo` is `nil` and `suppressLog` is `NO`, the receiver will be logged
   to the console using the `log` method.
 
 * If `reportTo` is non-`nil` but `*reportTo` is `nil`, the memory location
   pointed to by `*reportTo` will be updated to contain the receiver.
 
 * If `reportTo` is a non-`nil` pointer to an `MBExpressionError` instance
   the receiver will be reported to that error, meaning the receiver becomes
   its `lastErrorReported`.
 
 @param     reportTo Determines where the receiver will be reported.
 
 @param     suppressLog If `YES`, calling this method will not result in a
            message being logged to the console.
 */
- (void) reportErrorTo:(MBExpressionErrorPtrPtr)reportTo suppressLog:(BOOL)suppressLog;

/*----------------------------------------------------------------------------*/
#pragma mark Checking for additional errors
/*!    @name Checking for additional errors                                   */
/*----------------------------------------------------------------------------*/

/*!
 Determines if an error has been reported since the last time the
 `clearErrorReported` method was called.
 
 Note that this flag starts out as `YES` when new object instances are created.
 
 @return    `YES` if an error has been reported, `NO` otherwise.
 */
- (BOOL) errorReported;

/*!
 Clears the flag returned by `errorReported` so that subsequent calls to
`errorReported` return `NO` until the next time the receiver's `reportErrorTo` 
 method is called.
 */
- (void) clearErrorReported;

/*!
 Returns the `MBExpressionError` most recently reported to the receiver, or
 `nil` if there isn't one.
 
 **Note:** Calling the `clearErrorReported` method does not affect the return 
 value of this method.
 
 @return    The most recently reported error.
 */
- (nullable MBExpressionError*) lastErrorReported;

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

