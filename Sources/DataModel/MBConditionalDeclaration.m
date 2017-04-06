//
//  MBConditionalDeclaration.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 6/26/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MBConditionalDeclaration.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBConditionalDeclaration implementation
/******************************************************************************/

@implementation MBConditionalDeclaration

+ (nullable NSSet*) supportedAttributes
{
    return [NSSet setWithObject:kMBMLAttributeIf];
}

- (nullable NSString*) ifCondition
{
    return [self stringValueOfAttribute:kMBMLAttributeIf];
}

- (BOOL) shouldDeclare
{
    return [self evaluateAsBoolean:kMBMLAttributeIf defaultValue:YES];
}

@end
