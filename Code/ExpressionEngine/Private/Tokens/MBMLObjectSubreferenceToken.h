//
//  MBMLObjectSubreferenceToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/24/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLObjectReferenceToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLObjectSubreferenceToken class
/******************************************************************************/

/*!
 An expression token representing a reference to a value contained within
 another object. The container may be an <code>NSArray</code> or 
 <code>NSDictionary</code> (in which case the values extracted are the
 contents of the container), or another Objective-C object (in which case
 values are retrieved via key/value coding).
 */
@interface MBMLObjectSubreferenceToken : MBMLObjectReferenceToken
@end
