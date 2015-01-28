//
//  MBMLObjectReferenceToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 1/12/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "OperationTokens.h"

@class MBMLObjectSubreferenceToken;
@class MBExpressionError;

/******************************************************************************/
#pragma mark -
#pragma mark MBMLObjectReferenceToken class
/******************************************************************************/

/*!
 An abstract expression token representing a reference to an object value
 determined through dynamic resolution in the context of a given variable space.
 Object references can also take subreferences, which allow access to the
 contents of <code>NSArray</code>s and <code>NSDictionary</code>s as well
 as the properties of other Objective-C objects (via key/value coding).
 */
@interface MBMLObjectReferenceToken : MBMLParseToken < MBMLOperandToken >

@property(nonatomic, strong, readonly) NSArray* subreferences;

- (NSString*) subreferenceExpression;

+ (BOOL) isValidObjectReferenceCharacter:(unichar)ch atPosition:(NSUInteger)pos;

- (id) valueForKey:(NSString*)key valueContext:(id)ctxt error:(inout MBExpressionError**)errPtr;
- (id) valueInVariableSpace:(MBVariableSpace*)space valueContext:(id)ctxt error:(inout MBExpressionError**)errPtr;

@end
