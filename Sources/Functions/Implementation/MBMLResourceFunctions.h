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
 
 This Mockingbird function accepts no parameters.

 #### Expression usage
 
    ^directoryForMainBundle()
 
 The expression above would return the filesystem path of the resource
 directory for the main `NSBundle`.

 @return    The directory containing the main bundle's resource files, or 
            `nil` if it couldn't be found.
 */
+ (id) directoryForMainBundle;

/*!
 Determines the directory containing the resources for the `NSBundle` with the
 specified bundle identifier.

 This Mockingbird function accepts a single expression as a parameter,
 yielding the bundle identifier.

 #### Expression usage
 
    ^directoryForBundleWithIdentifier(com.gilt.ios)
 
 The expression above would return the filesystem path of the resource
 directory for the `NSBundle` with the identifier `com.gilt.ios` if it exists.
 If no such bundle exists, `nil` is returned.

 @param     bundleID The bundle identifier.

 @return    The directory containing the resources for the `NSBundle` with the
            identifier `bundleID`, or `nil` if it couldn't be found.
 */
+ (id) directoryForBundleWithIdentifier:(NSString*)bundleID;

/*!
 Determines the directory containing the resources for the `NSBundle` associated
 with the specified class.

 This Mockingbird function accepts a single expression as a parameter,
 yielding the class name.
 
 #### Expression usage
 
    ^directoryForClassBundle(MBEnvironment)
 
 The expression above would return the filesystem path of the resource
 directory for the `NSBundle` associated with the `MBEnvironment` class.

 @param     className The class name.

 @return    The directory containing the resources for the `NSBundle` associated
            with the class `className`, or `nil` if it couldn't be found.
 */
+ (id) directoryForClassBundle:(NSString*)className;

@end
