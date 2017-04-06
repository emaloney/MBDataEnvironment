//
//  MBMLParameterDelimiterToken.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 7/15/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import "MBMLParameterDelimiterToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLParameterDelimiterToken implementation
/******************************************************************************/

@implementation MBMLParameterDelimiterToken

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self addKeyword:@"|"];
    }
    return self;
}

@end
