//
//  MBMLRegexFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBMLRegexFunctions : NSObject

// must be declared input="pipedStrings" in <Function> tag
+ (id) stripRegex:(NSArray*)params;

// must be declared input="pipedStrings" in <Function> tag
+ (id) replaceRegex:(NSArray*)params;

// must be declared input="pipedStrings" in <Function> tag
+ (id) matchesRegex:(NSArray*)params;

@end
