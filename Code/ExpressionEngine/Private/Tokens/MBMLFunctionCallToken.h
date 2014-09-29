//
//  MBMLFunctionCallToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/24/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLObjectReferenceToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFunctionCallToken class
/******************************************************************************/

/*!
 An expression token representing a call to an <code>MBMLFunction</code>.
 */
@interface MBMLFunctionCallToken : MBMLObjectReferenceToken

@property(nonatomic, strong, readonly) NSArray* functionParameters;

@end
