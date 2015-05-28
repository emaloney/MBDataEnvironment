//
//  MBMLGroupingToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/29/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBModuleLogMacros.h>

#import "MBMLGroupingToken.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLGroupingToken implementation
/******************************************************************************/

@implementation MBMLGroupingToken
{
    unichar _openMarker;
    unichar _closeMarker;
    NSUInteger _innerUnmatchedOpenMarkers;
    BOOL _gotOpeningMarker;
    BOOL _gotClosingMarker;
}

- (void) setOpenMarker:(unichar)marker
{
    MBLogDebugTrace();

    _openMarker = marker;
}

- (void) setCloseMarker:(unichar)marker
{
    MBLogDebugTrace();

    _closeMarker = marker;
}

- (MBMLTokenMatchStatus) matchWhenAddingCharacter:(unichar)ch toExpression:(NSString*)accumExpr
{
    MBLogDebugTrace();

    NSUInteger pos = [accumExpr length];
    if (pos == 0) {
        if (ch == _openMarker) {
            [self setContainedExpressionStartAtPosition:pos+1];
            _gotOpeningMarker = YES;
            return MBMLTokenMatchPartial;
        }
    } else {
        if (_gotOpeningMarker) {
            if (ch == _openMarker) {
                _innerUnmatchedOpenMarkers++;
                return MBMLTokenMatchPartial;
            }
            else if (ch == _closeMarker) {
                if (_innerUnmatchedOpenMarkers == 0) {
                    [self setContainedExpressionEndBeforePosition:pos];
                    _gotClosingMarker = YES;
                    return MBMLTokenMatchFull;
                }
                else {
                    _innerUnmatchedOpenMarkers--;
                    return MBMLTokenMatchPartial;
                }
            }
            else if (_gotOpeningMarker && !_gotClosingMarker) {
                // match everything between the opening and closing marker
                return MBMLTokenMatchPartial;
            }
        }
    }
    return MBMLTokenMatchImpossible;
}

@end
