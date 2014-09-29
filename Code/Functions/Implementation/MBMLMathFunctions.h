//
//  MBMLMathFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 2/9/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark Types
/******************************************************************************/

typedef NSDecimalNumber* (^MathTransformationFunctionBlock)(NSDecimalNumber* lVal, NSDecimalNumber* rVal);

/******************************************************************************/
#pragma mark -
#pragma mark MBMLMathFunctions class
/******************************************************************************/

@interface MBMLMathFunctions : NSObject

// available for performing math functions externally from MBML parameter lists
+ (id) performMathFunction:(MathTransformationFunctionBlock)funcBlock
            withParameters:(NSArray*)params;

+ (id) mod:(NSArray*)params;

+ (id) modFloat:(NSArray*)params;

// must be declared input="pipedMath" in <Function> tag
+ (id) percent:(NSArray*)params;

// must be declared input="math" in <Function> tag
+ (id) ceil:(id)number;

// must be declared input="math" in <Function> tag
+ (id) floor:(id)number;

// must be declared input="math" in <Function> tag
+ (id) round:(id)number;

// must be declared input="pipedMath" in <Function> tag
+ (id) max:(NSArray*)params;

// must be declared input="pipedMath" in <Function> tag
+ (id) min:(NSArray*)params;

+ (id) randomPercent;

+ (id) random:(NSArray*)params;

// params: ($startNum|$count|$step)
+ (id) arrayFilledWithIntegers:(NSArray*)params;

@end
