//
//  MBMLObjectReferenceToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/12/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBMLObjectReferenceToken.h"
#import "MBMLObjectSubreferenceToken.h"
#import "MBExpression.h"
#import "MBExpressionError.h"
#import "MBExpressionTokenizer.h"
#import "MBVariableSpace.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

NSString* const kIdentifierInitialCharacters    = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";
NSString* const kIdentifierRemainingCharacters  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_:-";

/******************************************************************************/
#pragma mark Static variables
/******************************************************************************/

static NSCharacterSet* s_identifierInitialCharacters = nil;
static NSCharacterSet* s_identifierRemainingCharacters = nil;
static Class s_arrayCls = nil;
static Class s_stringCls = nil;
static Class s_objSubrefTokenCls = nil;

/******************************************************************************/
#pragma mark -
#pragma mark MBMLObjectReferenceToken implementation
/******************************************************************************/

@implementation MBMLObjectReferenceToken

/******************************************************************************/
#pragma mark Class initializer
/******************************************************************************/

+ (void) initialize
{
    if (self == [MBMLObjectReferenceToken class]) {
        s_identifierInitialCharacters = [NSCharacterSet characterSetWithCharactersInString:kIdentifierInitialCharacters];
        s_identifierRemainingCharacters = [NSCharacterSet characterSetWithCharactersInString:kIdentifierRemainingCharacters];
        s_arrayCls = [NSArray class];
        s_stringCls = [NSString class];
        s_objSubrefTokenCls = [MBMLObjectSubreferenceToken class];
    }
}

/******************************************************************************/
#pragma mark Validating object references
/******************************************************************************/

+ (BOOL) isValidObjectReferenceCharacter:(unichar)ch atPosition:(NSUInteger)pos
{
    debugTrace();
    
    if (pos == 0) {
        return [s_identifierInitialCharacters characterIsMember:ch];
    } else {
        return [s_identifierRemainingCharacters characterIsMember:ch];
    }
}

/******************************************************************************/
#pragma mark Object subreferences
/******************************************************************************/

- (NSArray*) subreferences
{
    NSMutableArray* subrefs = [NSMutableArray arrayWithCapacity:_childTokens.count];
    for (MBMLParseToken* tok in _childTokens) {
        if ([tok isKindOfClass:s_objSubrefTokenCls]) {
            [subrefs addObject:tok];
        }
    }
    return subrefs;
}

/******************************************************************************/
#pragma mark Token API
/******************************************************************************/

- (NSString*) subreferenceExpression
{
    NSMutableString* newNormal = nil;
    if (_childTokens.count > 0) {
        for (MBMLParseToken* tok in self.subreferences) {
            if (!newNormal) {
                newNormal = [NSMutableString string];
            }
            [newNormal appendString:[tok expression]];
        }
    }
    return newNormal;
}

- (NSString*) normalizedRepresentation
{
    debugTrace();

    NSString* normal = nil;
    if ([self doesContainExpression]) {
        normal = [self containedExpression];
    } else {
        normal = [self expression];
    }

    NSString* subrefs = [self subreferenceExpression];
    if (subrefs) {
        return [normal stringByAppendingString:subrefs];
    } else {
        return normal;
    }
}

/******************************************************************************/
#pragma mark Token evaluation
/******************************************************************************/

- (id) valueForKey:(NSString*)key valueContext:(id)ctxt error:(MBExpressionError**)errPtr
{
    debugTrace();
    
    if (key) {
        BOOL isKeyString = [key isKindOfClass:s_stringCls];
        if ([ctxt isKindOfClass:[MBVariableSpace class]]) {
            NSString* varName = (isKeyString ? key : [key description]);
            return [(MBVariableSpace*)ctxt variableForName:varName];
        }
        else if ([ctxt respondsToSelector:@selector(objectForKey:)]) {
            // note: shouldn't use modern Obj-C subscripting notation here
            id val = [ctxt objectForKey:key];
            if (!val && !isKeyString) {
                val = [ctxt objectForKey:[key description]];
            }
            return val;
        }
        else if ([ctxt respondsToSelector:@selector(count)] && [@"count" isEqualToString:(isKeyString ? key : [key description])]) {
            return @([ctxt count]);
        }
        else if ([ctxt isKindOfClass:s_arrayCls]) {
            if (![key respondsToSelector:@selector(integerValue)]) {
                key = [key description];
            }
            NSInteger idx = [key integerValue];
            if (idx < 0 || idx >= [ctxt count]) {
                return nil;
            }
            return ctxt[idx];
        }
        else {
            @try {
                return [ctxt valueForKey:(isKeyString ? key : [key description])];
            }
            @catch (NSException* ex) {
                [[MBEvaluationError errorWithFormat:@"No such key \"%@\" for object of type %@", key, [ctxt class]] reportErrorTo:errPtr];
            }
        }
    }
    return nil;
}

- (id) valueInVariableSpace:(MBVariableSpace*)space valueContext:(id)ctxt error:(MBExpressionError**)errPtr
{
    debugTrace();

    if (ctxt) {
        id key = nil;
        MBExpressionError* err = nil;
        if ([self doesContainExpression]) {
            key = [MBExpression objectFromTokens:_childTokens inVariableSpace:space defaultValue:nil error:&err];
            if (!err && !key) {
                err = [MBExpressionError errorWithMessage:@"Couldn't determine contained value of token"];
                err.offendingToken = self;
            }
        }
        if (!err) {
            if (!key) {
                key = [self tokenIdentifier];
            }
            if (key) {
                id retVal = [self valueForKey:key valueContext:ctxt error:&err];
                if (!err) {
                    return retVal;
                }
            }
            else {
                err = [MBExpressionError errorWithMessage:@"Couldn't determine key to use for obtaining value of token"];
                err.offendingToken = self;
            }
        }
        if (err) {
            [err reportErrorTo:errPtr];
        }
    }
    return nil;
}

- (id) evaluateInVariableSpace:(MBVariableSpace*)space error:(MBExpressionError**)errPtr
{
    debugTrace();
 
    id val = [self valueInVariableSpace:space
                           valueContext:space
                                  error:errPtr];
    if (val) {
        for (MBMLObjectSubreferenceToken* tok in self.subreferences) {
            val = [tok valueInVariableSpace:space valueContext:val error:errPtr];
            if (!val) {
                break;
            }
        }
    }
    return (val ? val : [NSNull null]);
}

@end
