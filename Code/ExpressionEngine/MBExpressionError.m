//
//  MBExpressionError.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/12/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "MBExpressionError.h"
#import "MBMLFunction.h"
#import "MBMLParseToken.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionError private interface
/******************************************************************************/

@interface MBExpressionError ()
@property(nonatomic, readwrite) NSString* message;
@property(nonatomic, readwrite) NSError* causedByError;
@property(nonatomic, readwrite) NSException* causedByException;
@end

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionError implementation
/******************************************************************************/

@implementation MBExpressionError
{
@protected
    BOOL _errorReportedSinceLastInquiry;
    NSMutableArray* _additionalErrors;
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (instancetype) init
{
    self = [super init];
    if (self) {
        _errorReportedSinceLastInquiry = YES;
    }
    return self;
}

+ (instancetype) error
{
    return [self new]; 
}

+ (instancetype) errorWithMessage:(NSString*)msg
{
    MBExpressionError* err = [self error];
    err.message = msg;
    return err;
}

+ (instancetype) errorWithMessage:(NSString*)msg error:(NSError*)nsErr
{
    MBExpressionError* err = [self error];
    err.message = msg;
    err.causedByError = nsErr;
    return err;
}

+ (instancetype) errorWithMessage:(NSString*)msg exception:(NSException*)ex
{
    MBExpressionError* err = [self error];
    err.message = msg;
    err.causedByException = ex;
    return err;
}

+ (instancetype) errorWithFormat:(NSString*)format, ...
{
    va_list args;
    va_start(args, format);
    NSString* errorMsg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    MBExpressionError* error = [self errorWithMessage:errorMsg];
    
    return error;
}

+ (instancetype) errorWithError:(NSError*)nsErr
{
    MBExpressionError* err = [self error];
    err.causedByError = nsErr;
    return err;
}

+ (instancetype) errorWithException:(NSException*)ex
{
    MBExpressionError* err = [self error];
    err.causedByException = ex;
    return err;
}

/******************************************************************************/
#pragma mark Debugging output
/******************************************************************************/

- (NSString*) description
{
    return [NSString stringWithFormat:@"<%@@%p> %@", [self class], self, [self logOutput]];
}

/******************************************************************************/
#pragma mark Error reporting 
/******************************************************************************/

- (void) setOffendingToken:(MBMLParseToken*)offendingTok
{
    // the first caller to set the offending token wins
    // this is because we bubble up errors from the most
    // specific to the least specific code
    if (!_offendingToken) {
        _offendingToken = offendingTok;
    }
}

- (void) setOffendingExpression:(NSString*)offendingExpr
{
    // the first caller to set the offending expression wins
    // this is because we bubble up errors from the most
    // specific to the least specific code
    if (!_offendingExpression) {
        _offendingExpression = offendingExpr;
    }
}

- (void) reportErrorTo:(inout MBExpressionError**)reportTo
{
    [self reportErrorTo:reportTo suppressLog:NO];
}

- (void) reportErrorTo:(inout MBExpressionError**)reportTo suppressLog:(BOOL)suppress
{
    if (!reportTo && !suppress) {
        [self log];
    }
    else if (reportTo) {
        if (!*reportTo) {
            *reportTo = self;
        }
        else {
            [*reportTo _reportError:self];
        }
    }
}

- (void) _reportError:(MBExpressionError*)error
{
    if (!_additionalErrors) {
        _additionalErrors = [NSMutableArray new];
    }
    [_additionalErrors addObject:error];
    _errorReportedSinceLastInquiry = YES;
}

- (BOOL) errorReported
{
    if (_errorReportedSinceLastInquiry) {
        _errorReportedSinceLastInquiry = NO;
        return YES;
    }
    return NO;
}

- (MBExpressionError*) lastErrorReported
{
    if (_additionalErrors && _additionalErrors.count > 0) {
        return [_additionalErrors lastObject];
    }
    return self;
}

- (void) clearErrorReported
{
    _errorReportedSinceLastInquiry = NO;
}

/******************************************************************************/
#pragma mark Error logging
/******************************************************************************/

- (NSString*) describeOffense
{
    BOOL hasClause = (_offendingToken != nil);
    BOOL hasExpression = (_offendingExpression != nil);
    NSString* clause = (hasClause ? [_offendingToken expression] : nil);
    BOOL clauseAndExprAreSame = (hasClause && hasExpression && [clause isEqualToString:_offendingExpression]);
    if (hasClause && hasExpression && !clauseAndExprAreSame) {
        return [NSString stringWithFormat:@"offending clause: \"%@\" in expression: \"%@\"", clause, _offendingExpression];
    }
    else if (hasExpression) {
        return [NSString stringWithFormat:@"offending expression: \"%@\"", _offendingExpression];
    }
    else if (hasClause) {
        return [NSString stringWithFormat:@"offending clause: \"%@\"", clause];
    }
    return nil;
}

- (NSString*) logOutput
{
    NSMutableString* log = [NSMutableString string];
    if (_message) {
        [log appendString:_message];
    }
    if (_causedByError) {
        if (log.length > 0) {
            [log appendString:@"; "];
        }
        [log appendFormat:@"%@: %@", [_causedByError class], [_causedByError description]];
    }
    if (_causedByException) {
        if (log.length > 0) {
            [log appendString:@"; "];
        }
        [log appendFormat:@"%@: %@", [_causedByException class], [_causedByException reason]];
    }
    if (_value) {
        if (log.length > 0) {
            [log appendString:@"; "];
        }
        [log appendFormat:@"value of type %@: %@", [_value class], [_value description]];
    }
    NSString* offense = [self describeOffense];
    if (offense) {
        if (log.length > 0) {
            [log appendString:@"; "];
        }
        [log appendString:offense];
    }
    return log;
}

- (void) log
{
    errorLog(@"%@", [self logOutput]);
    
    for (MBExpressionError* err in _additionalErrors) {
        [err log];
    }
}

- (NSArray*) additionalErrors
{
    return [_additionalErrors copy];
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBParseError implementation
/******************************************************************************/

@implementation MBParseError

- (NSString*) logOutput
{
    return [NSString stringWithFormat:@"Syntax error: %@", [super logOutput]];
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBEvaluationError implementation
/******************************************************************************/

@implementation MBEvaluationError

- (NSString*) logOutput
{
    return [NSString stringWithFormat:@"Evaluation error: %@", [super logOutput]];
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFunctionError implementation
/******************************************************************************/

@implementation MBMLFunctionError

- (NSString*) logOutput
{
    MBMLFunction* proxy = nil;
    if ([self.value isKindOfClass:[MBMLFunction class]]) {
        proxy = self.value;
    }
    
    NSMutableString* log = [NSMutableString stringWithString:@"Execution error: "];

    BOOL addSpacer = NO;
    if (proxy) {
        [log appendFormat:@"^%@()", proxy.name];
        addSpacer = YES;
    }
    
    NSString* msg = self.message;
    if (msg) {
        if (addSpacer) {
            [log appendString:@" "];
        }
        [log appendString:msg];
        addSpacer = YES;
    }
    
    NSError* err = self.causedByError;
    if (err) {
        if (addSpacer) {
            [log appendString:@"; "];
        }
        [log appendFormat:@"%@: %@", [err class], [err description]];
        addSpacer = YES;
    }
    
    NSException* ex = self.causedByException;
    if (ex) {
        if (addSpacer) {
            [log appendString:@"; "];
        }
        [log appendFormat:@"%@: %@", [ex class], [ex reason]];
        addSpacer = YES;
    }

    NSString* offense = [self describeOffense];
    if (offense) {
        if (addSpacer) {
            [log appendString:@"; "];
        }
        [log appendString:offense];
    }
    
    return log;
}

@end

