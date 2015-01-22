//
//  MBMLEnvironmentFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/15/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBMLEnvironmentFunctions class
/******************************************************************************/

/*!
 This class implements MBML functions for accessing Mockingbird runtime
 environment information.

 These functions are exposed to the Mockingbird environment via
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.
 
 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLEnvironmentFunctions : NSObject

/*!
 Returns an array of the full pathnames of the MBML files that have been loaded
 into the current Mockingbird environment.

 This Mockingbird function accepts no parameters.

 #### Expression usage

 The expression:

    ^mbmlLoadedPaths()

 returns an array containing the full pathnames of the files that have already
 been loaded.

 @return    An array containing the paths of the files that have been loaded
            into the current environment.
 */
+ (NSArray*) mbmlLoadedPaths;

/*!
 Returns an array of the names (i.e., the `lastPathComponent`s of the file
 paths) for the files that have been loaded into the current Mockingbird 
 environment.

 This Mockingbird function accepts no parameters.

 #### Expression usage

 The expression:

    ^mbmlLoadedFiles()

 returns an array containing the file names of the files that have already been
 loaded.

 @return    An array containing the names of the files that have been loaded
            into the current environment.
 */
+ (NSArray*) mbmlLoadedFiles;

/*!
 Determines whether an MBML file with the given pathname has been loaded into
 the current Mockingbird environment.

 This Mockingbird function accepts a single parameter: a string expression
 yielding the full path of the file being tested.

 #### Expression usage

 Assume `$path` evaluates to the full file path of the initial `manifest.xml`
 file. The expression:

    ^mbmlPathIsLoaded($path)

 would return `@YES` if the path represented by the expression `$path`
 has already been loaded.

 @param     pathName The full pathname of the file.

 @return    `@YES` if the specified file has been loaded into the current
            environment, `@NO` otherwise.
 */
+ (NSNumber*) mbmlPathIsLoaded:(NSString*)pathName;

/*!
 Determines whether a given MBML file has been loaded into the current
 Mockingbird environment.

 This Mockingbird function accepts a single parameter: a string expression
 yielding the file name (i.e., the `lastPathComponent`) of the file being 
 tested.

 #### Expression usage

 The expression:

    ^mbmlFileIsLoaded(manifest.xml)

 would return a boolean `YES` if any file named `manifest.xml` (at any path)
 has already been loaded.

 @param     fileName The name of the file.

 @return    `@YES` if the specified file has been loaded into the current
            environment, `@NO` otherwise.
 */
+ (NSNumber*) mbmlFileIsLoaded:(NSString*)fileName;

@end
