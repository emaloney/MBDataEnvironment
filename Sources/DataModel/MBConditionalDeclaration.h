//
//  MBConditionalDeclaration.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 6/26/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MBDataModel.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBConditionalDeclaration class
/******************************************************************************/

/*!
 A data model representing a conditional declaration.
 
 Conditional declarations contain an `ifCondition` expression that gets
 evaluated in a boolean context. This condition is typically populated
 using the `if="`...`"` attribute on the associated MBML tag.
 */
@interface MBConditionalDeclaration : MBDataModel

/*!
 Returns the *if condition* associated with the receiver, a boolean
 expression indicating whether the variable declaration should be processed.
 contents of the `if="`...`"` attribute.
 */
@property(nullable, nonatomic, readonly) NSString* ifCondition;

/*!
 Determines whether the variable declaration should proceed. This returns
 `YES` if the `ifCondition` is `nil` or if the `ifCondition` evaluates
 to `YES` in a boolean context. Otherwise, returns `NO`, indicating that
 the variable declaration will be ignored.
 */
@property(nonatomic, readonly) BOOL shouldDeclare;

@end
