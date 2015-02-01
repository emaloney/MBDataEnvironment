//
//  MBMLVariableReferenceToken.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/22/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import "MBMLObjectReferenceToken.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLVariableReferenceToken class
/******************************************************************************/

/*!
 An expression token representing the value of a variable.
 */
@interface MBMLVariableReferenceToken : MBMLObjectReferenceToken

/*!
 Given the name of an MBML variable, returns a string containing a variable
 expression referencing that variable.
 
 @param     varName The name of the variable as it would be retrieved from
            the `MBVariableSpace`.
 
 @return    A string containing an expression referencing the MBML variable
            `varName`.
 */
+ (NSString*) expressionForReferencingVariableNamed:(NSString*)varName;

@end
