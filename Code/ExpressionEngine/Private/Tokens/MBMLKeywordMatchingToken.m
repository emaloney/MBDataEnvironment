//
//  MBMLKeywordMatchingToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/25/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

#import "MBMLKeywordMatchingToken.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLKeywordMatchingToken implementation
/******************************************************************************/

@implementation MBMLKeywordMatchingToken
{
    NSMutableSet* _keywords;
    NSMutableSet* _possibleKeywords;
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (instancetype) init
{
    self = [super init];
    if (self) {
        _keywords = [NSMutableSet new];
        _possibleKeywords = [NSMutableSet new];
    }
    return self;
}

/******************************************************************************/
#pragma mark Keyword handling
/******************************************************************************/

- (void) addKeyword:(NSString*)keyword
{
    debugTrace();
    
    [_keywords addObject:keyword];
    
    if (![self isMatchCompleted]) {
        NSString* accumStr = [self accumulatedString];
        if (!accumStr || [keyword length] >= [accumStr length]) {
            if (!accumStr || [keyword hasPrefix:accumStr]) {
                [_possibleKeywords addObject:keyword];
            }
        }
    }
}

/******************************************************************************/
#pragma mark Token implementation
/******************************************************************************/

- (void) freeze
{
    debugTrace();
    
    if (![self isFrozen]) {
        _keywords = nil;
        _possibleKeywords = nil;
        
        [super freeze];
    }
}

- (MBMLTokenMatchStatus) matchWhenAddingCharacter:(unichar)ch toExpression:(NSString*)accumExpr
{
    debugTrace();
    
    NSMutableSet* newlyInvalidKeywords = nil;
    NSString* invalidateKeyword = nil;
    
    NSUInteger pos = [accumExpr length];
    for (NSString* keyword in _possibleKeywords) {
        NSUInteger keywordLen = [keyword length];
        if (keywordLen > pos) {
            unichar expected = [keyword characterAtIndex:pos];
            if (expected != ch) {
                invalidateKeyword = keyword;
            }
        }
        else if (pos >= keywordLen) {
            invalidateKeyword = keyword;
        }
        if (invalidateKeyword) {
            if (!newlyInvalidKeywords) {
                newlyInvalidKeywords = [NSMutableSet set];
            }
            [newlyInvalidKeywords addObject:invalidateKeyword];
            invalidateKeyword = nil;
        }
    }
    
    [_possibleKeywords minusSet:newlyInvalidKeywords];
    
    if ([_possibleKeywords count] == 0) {
        return MBMLTokenMatchImpossible;
    }
    
    NSString* fullExpr = [accumExpr stringByAppendingFormat:@"%C", ch];
    for (NSString* keyword in _possibleKeywords) {
        if ((pos == [keyword length] - 1) && [keyword isEqualToString:fullExpr]) {
            return MBMLTokenMatchFull;
        }
    }
    return MBMLTokenMatchPartial;
}

@end
