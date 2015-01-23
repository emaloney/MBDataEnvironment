//
//  MBMLFileFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/30/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import "MBMLFunction.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFileFunctions class
/******************************************************************************/

/*!
 This class implements MBML functions for file management.
 
 These functions are exposed to the Mockingbird environment via 
 `<Function ... />` declarations in the <code>MBDataEnvironmentModule.xml</code>
 file.
 
 For more information on MBML functions, see the `MBMLFunction` class.
 */
@interface MBMLFileFunctions : NSObject

/*----------------------------------------------------------------------------*/
#pragma mark Working with file paths
/*!    @name Working with file paths                                          */
/*----------------------------------------------------------------------------*/

/*!
 Returns the `lastPathComponent` of a string containing a filesystem path.
 
 This Mockingbird function accepts a single parameter: a string expression
 yielding a filesystem path.

 #### Expression usage

    ^lastPathComponent(~/Library/Preferences/com.apple.Safari.plist)
 
 The expression above would return the string "`com.apple.Safari.plist`"

 @param     path The filesystem path.
 
 @return    The `lastPathComponent` of `path`.
 */
+ (id) lastPathComponent:(NSString*)path;

/*!
 Removes the `lastPathComponent` from a filesystem path and returns the
 resulting string.
 
 This Mockingbird function accepts a single parameter: a string expression
 yielding a filesystem path.

 #### Expression usage

    ^stripLastPathComponent(~/Library/Preferences/com.apple.Safari.plist)
 
 The expression above would return the string "`~/Library/Preferences`"

 @param     path The filesystem path.
 
 @return    The result of removing the `lastPathComponent` from `path`.
 */
+ (id) stripLastPathComponent:(NSString*)path;

/*!
 Returns the `pathExtension` of a string containing a filesystem path.
 
 This Mockingbird function accepts a single parameter: a string expression
 yielding a filesystem path.

 #### Expression usage

    ^pathExtension(~/Library/Preferences/com.apple.Safari.plist)
 
 The expression above would return the string "`plist`"

 @param     path The filesystem path.
 
 @return    The `pathExtension` of `path`.
 */
+ (id) pathExtension:(NSString*)path;

/*!
 Removes the `pathExtension` from a filesystem path and returns the
 resulting string.

 This Mockingbird function accepts a single parameter: a string expression
 yielding a filesystem path.

 #### Expression usage

    ^stripPathExtension(~/Library/Preferences/com.apple.Safari.plist)

 The expression above would return the string 
 "`~/Library/Preferences/com.apple.Safari`"

 @param     path The filesystem path.

 @return    The result of removing the `pathExtension` from `path`.
 */
+ (id) stripPathExtension:(NSString*)path;

/*!
 Splits a filesystem path into individual path components and returns the
 result in an array.

 This Mockingbird function accepts a single parameter: a string expression
 yielding a filesystem path.

 #### Expression usage

    ^pathComponents(~/Library/Preferences/com.apple.Safari.plist)

 The expression returns an array of strings containing: ["`~`", "`Library`",
 "`Preferences`", "`com.apple.Safari.plist`" ].

 @param     path The filesystem path.

 @return    An `NSArray` containing the path components of `path`.
 */
+ (id) pathComponents:(NSString*)path;

/*----------------------------------------------------------------------------*/
#pragma mark Getting paths for common directories
/*!    @name Getting paths for common directories                             */
/*----------------------------------------------------------------------------*/

/*!
 Returns the filesystem path of the `NSHomeDirectory`. On iOS, this is the
 filesystem path of the *application's* home.

 This Mockingbird function accepts no parameters.

 #### Expression usage

    ^directoryForHome()

 The expression above returns the filesystem path of the `NSHomeDirectory`.

 @return    The filesystem path of the directory.
 */
+ (id) directoryForHome;

/*!
 Returns the filesystem path of the `NSTemporaryDirectory`.

 This Mockingbird function accepts no parameters.

 #### Expression usage

    ^directoryForTempFiles()

 The expression above returns the filesystem path of the `NSTemporaryDirectory`.

 @return    The filesystem path of the directory.
 */
+ (id) directoryForTempFiles;

/*!
 Returns the filesystem path of the `NSCachesDirectory`.

 This Mockingbird function accepts no parameters.

 #### Expression usage

    ^directoryForCaches()

 The expression above returns the filesystem path of the `NSCachesDirectory`.

 @return    The filesystem path of the directory.
 */
+ (id) directoryForCaches;

/*!
 Returns the filesystem path of the `NSDocumentDirectory`.

 This Mockingbird function accepts no parameters.

 #### Expression usage

    ^directoryForDocuments()

 The expression above returns the filesystem path of the `NSDocumentDirectory`.

 @return    The filesystem path of the directory.
 */
+ (id) directoryForDocuments;

/*!
 Returns the filesystem path of the `NSDownloadsDirectory`.

 This Mockingbird function accepts no parameters.

 #### Expression usage

    ^directoryForDownloads()

 The expression above returns the filesystem path of the `NSDownloadsDirectory`.

 @return    The filesystem path of the directory.
 */
+ (id) directoryForDownloads;

/*!
 Returns the filesystem path of the `NSApplicationSupportDirectory`.

 This Mockingbird function accepts no parameters.

 #### Expression usage

    ^directoryForApplicationSupport()

 The expression above returns the filesystem path of the
 `NSApplicationSupportDirectory`.

 @return    The filesystem path of the directory.
 */
+ (id) directoryForApplicationSupport;

/*!
 Returns the filesystem path of the `NSMoviesDirectory`.

 This Mockingbird function accepts no parameters.

 #### Expression usage

    ^directoryForMovies()

 The expression above returns the filesystem path of the `NSMoviesDirectory`.

 @return    The filesystem path of the directory.
 */
+ (id) directoryForMovies;

/*!
 Returns the filesystem path of the `NSMusicDirectory`.

 This Mockingbird function accepts no parameters.

 #### Expression usage

    ^directoryForMusic()

 The expression above returns the filesystem path of the `NSMusicDirectory`.

 @return    The filesystem path of the directory.
 */
+ (id) directoryForMusic;

/*!
 Returns the filesystem path of the `NSPicturesDirectory`.

 This Mockingbird function accepts no parameters.

 #### Expression usage

    ^directoryForPictures()

 The expression above returns the filesystem path of the `NSPicturesDirectory`.

 @return    The filesystem path of the directory.
 */
+ (id) directoryForPictures;

/*!
 Returns the filesystem path of the `NSSharedPublicDirectory`.

 This Mockingbird function accepts no parameters.

 #### Expression usage

    ^directoryForPublicFiles()

 The expression above returns the filesystem path of the
 `NSSharedPublicDirectory`.

 @return    The filesystem path of the directory.
 */
+ (id) directoryForPublicFiles;

/*----------------------------------------------------------------------------*/
#pragma mark Listing directory contents
/*!    @name Listing directory contents                                       */
/*----------------------------------------------------------------------------*/

/*!
 Lists the filenames within a given directory.

 This Mockingbird function accepts a single parameter: a string expression
 yielding the filesystem path of the directory whose contents are sought.

 #### Expression usage

    ^listDirectory(^directoryForHome())
 
 The expression above returns an array containing the names of the files
 within `NSHomeDirectory`.

 @param     dir The filesystem path of the directory.
 
 @return    An `NSArray` containing the names of the files contained within
            `dir`.
 */
+ (id) listDirectory:(NSString*)dir;

/*----------------------------------------------------------------------------*/
#pragma mark Getting file information
/*!    @name Getting file information                                         */
/*----------------------------------------------------------------------------*/

/*!
 Tests whether an item exists at the specified filesystem path.
 
 This Mockingbird function accepts a single parameter: a string expression
 yielding the filesystem path.
 
 #### Expression usage

    ^fileExists(~/Downloads/MBToolbox.zip)

 If a file exists at the path `~/Downloads/MBToolbox.zip`, this expression will
 return `@YES`. Otherwise, `@NO` is returned.
 
 @param     filePath The filesystem path to test.
 
 @return    `@YES` if the file exists at `filePath`; `@NO` otherwise.
 */
+ (id) fileExists:(NSString*)filePath;

/*!
 Tests whether a readable item exists at the specified filesystem path.
 
 This Mockingbird function accepts a single parameter: a string expression
 yielding the filesystem path.
 
 #### Expression usage

    ^fileIsReadable(/etc/passwd)

 If a readable file exists at the path `/etc/passwd`, this expression will
 return `@YES`. Otherwise, `@NO` is returned.
 
 @param     filePath The filesystem path to test.
 
 @return    `@YES` if a readable file exists at `filePath`; `@NO` otherwise.
 */
+ (id) fileIsReadable:(NSString*)filePath;

/*!
 Tests whether a writable item exists at the specified filesystem path.
 
 This Mockingbird function accepts a single parameter: a string expression
 yielding the filesystem path.
 
 #### Expression usage

    ^fileIsWritable(/usr/bin/login)

 If a writable file exists at the path `/usr/bin/login`, this expression will
 return `@YES`. Otherwise, `@NO` is returned.
 
 @param     filePath The filesystem path to test.
 
 @return    `@YES` if a writable file exists at `filePath`; `@NO` otherwise.
 */
+ (id) fileIsWritable:(NSString*)filePath;

/*!
 Tests whether a deletable item exists at the specified filesystem path.
 
 This Mockingbird function accepts a single parameter: a string expression
 yielding the filesystem path.
 
 #### Expression usage

    ^fileIsDeletable(/tmp)

 If a deletable file exists at the path `/tmp`, this expression will
 return `@YES`. Otherwise, `@NO` is returned.
 
 @param     filePath The filesystem path to test.
 
 @return    `@YES` if a deletable file exists at `filePath`; `@NO` otherwise.
 */
+ (id) fileIsDeletable:(NSString*)filePath;

/*!
 Tests whether a directory exists at a given filesystem path.
 
 This Mockingbird function accepts a single parameter: a string expression
 yielding the filesystem path.
 
 #### Expression usage

    ^isDirectoryAtPath(~/Caches/com.gilt.ios)

 If a directory file exists at the path `~/Caches/com.gilt.ios`, this expression
 will return `@YES`. Otherwise, `@NO` is returned.
 
 @param     filePath The filesystem path to test.
 
 @return    `@YES` if a directory exists at `filePath`; `@NO` otherwise.
 */
+ (id) isDirectoryAtPath:(NSString*)filePath;

/*!
 Returns the size of the file at the given filesystem path.
 
 This Mockingbird function accepts a single parameter: a string expression
 yielding the filesystem path.
 
 #### Expression usage

 The expression:

    ^sizeOfFile(~/Caches/com.gilt.ios/Images/superhero.jpg)

 returns the size of the file at `~/Caches/com.gilt.ios/Images/superhero.jpg`
 in an `NSNumber` containing an `unsigned long long` value.

 @param     filePath The filesystem path.
 
 @return    An `NSNumber` containing the size of the file at `filePath`.
 */
+ (id) sizeOfFile:(NSString*)filePath;

/*----------------------------------------------------------------------------*/
#pragma mark Getting file content
/*!    @name Getting file content                                             */
/*----------------------------------------------------------------------------*/

/*!
 Returns an `NSData` instance with the content of the file at the specified
 filesystem path.
 
 This Mockingbird function accepts a single parameter: a string expression
 yielding the filesystem path.
 
 #### Expression usage

 The expression:

    ^fileData(~/Caches/com.gilt.ios/Images/superhero.jpg)

 returns the content of `~/Caches/com.gilt.ios/Images/superhero.jpg` as an
 `NSData` instance.

 If the file doesn't exist or couldn't be read, `nil` will be returned.

 @param     filePath The filesystem path.
 
 @return    An `NSData` instance containing the content of the file at
            `filePath`.
 */
+ (id) fileData:(NSString*)filePath;

/*!
 Returns a UTF-8 encoded `NSString` instance with the content of the file at
 the specified filesystem path.
 
 This Mockingbird function accepts a single parameter: a string expression
 yielding the filesystem path.
 
 #### Expression usage

 The expression:

    ^fileContents(~/Documents/README.txt)

 returns the content of `~/Documents/README.txt` as an `NSString` instance.

 If the file doesn't exist or couldn't be read, `nil` will be returned.

 @param     filePath The filesystem path.
 
 @return    An `NSString` instance containing the content of the file at
            `filePath`.
 */
+ (id) fileContents:(NSString*)filePath;

/*----------------------------------------------------------------------------*/
#pragma mark Removing files
/*!    @name Removing files                                                   */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to delete the item at the specified filesystem path.
 
 This Mockingbird function accepts a single parameter: a string expression
 yielding the filesystem path.
 
 #### Expression usage

 The expression:

    ^deleteFile(/tmp/download-in-progress)

 attempts to delete the file at `/tmp/download-in-progress`. If successful,
 `@YES` is returned; otherwise, `@NO` is returned.

 @param     filePath The filesystem path.
 
 @return    `@YES` if `filePath` was successfully deleted; `@NO` otherwise.
 */
+ (id) deleteFile:(NSString*)filePath;

@end
