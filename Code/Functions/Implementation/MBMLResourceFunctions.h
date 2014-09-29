//
//  MBMLResourceFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/30/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBMLResourceFunctions class
/******************************************************************************/

@interface MBMLResourceFunctions : NSObject

/*!
 Returns the path of the filesystem directory containing the main bundle's
 resources.
 */
+ (id) directoryForMainBundle;

/*!
 Returns the path of the filesystem directory containing the resources of
 the bundle with the specified identifier.
 */
+ (id) directoryForBundleWithIdentifier:(NSString*)bundleName;

/*!
 Returns the path of the filesystem directory containing the resources of
 the bundle associated with the specified class.
 */
+ (id) directoryForClassBundle:(NSString*)className;

@end
