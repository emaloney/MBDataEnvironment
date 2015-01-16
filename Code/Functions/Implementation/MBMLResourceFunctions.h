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

/*!
 This class implements MBML functions for obtaining information about
 `NSBundle` resources.
 
 These functions are exposed to the Mockingbird environment via 
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.
 
 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLResourceFunctions : NSObject

/*!
 Determines the directory containing the resources for the main `NSBundle`.
 
 Within a Mockingbird expression, this function is called as
 `^directoryForMainBundle()`.

 @return    The path of the filesystem directory containing the main bundle's
            resource files, or `nil` if it couldn't be found.
 */
+ (id) directoryForMainBundle;

/*!
 Determines the directory containing the resources for the `NSBundle` with the
 specified name.

 Within a Mockingbird expression, this function takes a single parameter:
 the bundle identifier.
 
 #### Expression usage
 
    ^directoryForBundleWithIdentifier(com.gilt.ios)
 
 The expression above would return the resource directory for the `NSBundle`
 with the identifier `com.gilt.ios` if it exists. Otherwise, `nil` is returned.

 @param     bundleID The bundle identifier.

 @return    The directory containing the resources for the `NSBundle` with the
            identifier `bundleID`, or `nil` if it couldn't be found.
 */
+ (id) directoryForBundleWithIdentifier:(NSString*)bundleID;

/*!
 Determines the directory containing the resources for the `NSBundle` associated
 with the specified class.

 Within a Mockingbird expression, this function takes a single parameter:
 the class name.
 
 #### Expression usage
 
    ^directoryForClassBundle(MBEnvironment)
 
 The expression above would return the resource directory for the `NSBundle`
 associated with the `MBEnvironment` class.

 @param     className The class name.

 @return    The directory containing the resources for the `NSBundle` associated
            with the class `className`, or `nil` if it couldn't be found.
 */
+ (id) directoryForClassBundle:(NSString*)className;

@end
