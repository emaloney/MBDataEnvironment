//
//  MBMLWhitespaceToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/19/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLWhitespaceToken.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLWhitespaceToken implementation
/******************************************************************************/

@implementation MBMLWhitespaceToken

- (MBMLTokenMatchStatus) matchWhenAddingCharacter:(unichar)ch toExpression:(NSString*)accumExpr
{
    debugTrace();
    
    if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:ch]) {
        return MBMLTokenMatchFull;
    }
    return MBMLTokenMatchImpossible;
}

@end
