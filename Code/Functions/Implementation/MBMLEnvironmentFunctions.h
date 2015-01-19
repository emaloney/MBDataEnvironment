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
 A class providing a MBML functions for accessing Mockingbird runtime
 environment information.
 
 See `MBMLFunction` for more information on MBML functions and how they're used.
 */
@interface MBMLEnvironmentFunctions : NSObject

/*!
 An MBML function implementation returns an array of the full paths of the files
 that have been loaded into the current Mockingbird environment.

 This function accepts no parameters.

 #### Expression usage

 The expression:

    ^mbmlLoadedPaths()

 returns an array containing the full paths of the files that have already been
 loaded.

 @return    An array containing the paths of the files that have been loaded
            into the current environment.
 */
+ (NSArray*) mbmlLoadedPaths;

/*!
 An MBML function implementation returns an array of the names (i.e., the
 `lastPathComponent`s of the file paths) for the files that have been loaded
 into the current Mockingbird environment.

 This function accepts no parameters.

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
 An MBML function implementation that determines whether a given MBML file has
 been loaded into the current Mockingbird environment.

 This function accepts a single parameter: the full path of the file being
 tested.

 #### Expression usage

 Assume `$file` evaluates to the full file path of the initial `manifest.xml`
 file. The expression:

    ^mbmlPathIsLoaded($file)

 would return a boolean `YES` if the path represented by the expression `$file`
 has already been loaded.

 @param     templateName The function's input parameter.

 @return    An `NSNumber` wrapping a boolean value indicating whether the
            specified file has been loaded into the current environment.
 */
+ (NSNumber*) mbmlPathIsLoaded:(NSString*)templateName;

/*!
 An MBML function implementation that determines whether a given MBML file has
 been loaded into the current Mockingbird environment.

 This function accepts a single parameter: the file name (i.e., the
 `lastPathComponent`) of the file being tested.

 #### Expression usage

 The expression:

    ^mbmlFileIsLoaded(manifest.xml)

 would return a boolean `YES` if any file named `manifest.xml` (at any path)
 has already been loaded.

 @param     templateName The function's input parameter.

 @return    An `NSNumber` wrapping a boolean value indicating whether the
            specified file has been loaded into the current environment.
 */
+ (NSNumber*) mbmlFileIsLoaded:(NSString*)templateName;

@end
