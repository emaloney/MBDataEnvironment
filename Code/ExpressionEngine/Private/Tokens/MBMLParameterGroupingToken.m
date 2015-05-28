//
//  MBMLParameterGroupingToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/24/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBModuleLogMacros.h>

#import "MBMLParameterGroupingToken.h"
#import "MBExpression.h"
#import "MBMLLiteralToken.h"
#import "MBDataEnvironmentConstants.h"
#import "MBExpression+Internal.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLParameterGroupingToken implementation
/******************************************************************************/

@implementation MBMLParameterGroupingToken

+ (MBMLParameterGroupingToken*) parameterWithLiteralValue:(id)literal
{
    MBMLParameterGroupingToken* tok = [[self alloc] init];
    [tok addChildToken:[MBMLLiteralToken literalTokenWithValue:literal]];
    return tok;
}

+ (MBMLParameterGroupingToken*) parameterWithTokens:(NSArray*)tokens
{
    MBMLParameterGroupingToken* tok = [[self alloc] init];
    [tok addChildTokens:tokens];
    return tok;
}

- (BOOL) doesContainExpression
{
    return _childTokens.count > 0;
}

- (BOOL) isMatchCompleted
{
    return YES;
}

- (id) evaluateInVariableSpace:(MBVariableSpace*)space error:(inout MBExpressionError**)errPtr
{
    MBLogDebugTrace();

    return [MBExpression objectFromTokens:_childTokens inVariableSpace:space defaultValue:nil error:errPtr];
}

- (NSString*) containedExpression
{
    NSMutableString* normal = nil;
    for (MBMLParseToken* tok in _childTokens) {
        NSString* childRep = [tok normalizedRepresentation];
        if (childRep) {
            if (!normal) {
                normal = [NSMutableString string];
            }
            [normal appendString:childRep];
        }
    }
    return (normal ?: kMBEmptyString);
}

- (NSString*) normalizedRepresentation
{
    return [self containedExpression];
}

@end
