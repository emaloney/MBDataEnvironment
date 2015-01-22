//
//  MBEnvironment.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/23/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBSingleton.h>

#import "MBDataModel.h"

@class MBEnvironmentLoader;

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

extern NSString* const kMBMLManifestFilename;               // @"manifest.xml"

extern NSString* const kMBMLRootTagName;                    // @"MBML"
extern NSString* const kMBMLIncludeTagName;                 // @"Include"

/******************************************************************************/
#pragma mark -
#pragma mark MBEnvironment class
/******************************************************************************/

/*!
 The `MBEnvironment` class contains the state of the Mockingbird Data
 Environment.
 
 Typically, when an application starts, you would load an `MBEnvironment`
 using the `loadDefaultEnvironment` class method or one of the 
 `loadFromManifest` variants.

 Once an environment has been loaded, you can store data in the
 `MBVariableSpace` associated with the environment and reference that
 data with Mockingbird expressions using the `MBExpression` class.
*/
@interface MBEnvironment : MBDataModel <MBInstanceVendor>

/*----------------------------------------------------------------------------*/
#pragma mark Getting the current environment
/*!    @name Getting the current environment                                 */
/*----------------------------------------------------------------------------*/

/*!
 Retrieves the `MBEnvironment` instance representing the currently-active
 environment.

 @return    The currently-active environment.
 */
+ (instancetype) instance;

/*----------------------------------------------------------------------------*/
#pragma mark Managing the current environment
/*!    @name Managing the current environment                                 */
/*----------------------------------------------------------------------------*/

/*!
 Sets the active `MBEnvironment` instance. The active environment supplies
 the `MBVariableSpace` instance used to evaluate expressions by default.

 @param     env The `MBEnvironment` to set as the active environment.

 @return    The previously-active `MBEnvironment` instance, if any.
 */
+ (instancetype) setEnvironment:(MBEnvironment*)env;

/*!
 Sets the active `MBEnvironment` instance by pushing a new environment
 onto the environment stack.
 
 @param     env The `MBEnvironment` to set as the active environment.
 */
+ (void) pushEnvironment:(MBEnvironment*)env;

/*!
 Sets the active `MBEnvironment` instance by popping it from the environment
 stack.

 An `NSException` will be raised if the environment stack is empty.

 @return    The newly-active environment.
 */
+ (instancetype) popEnvironment;

/*!
 Returns (but does not remove) the `MBEnvironment` instance at the top of the
 environment stack. This is the environment that would become active if
 `popEnvironment` were called.
 
 @return    The environment at the top of the environment stack, or `nil` if
            there is nothing in the stack.
 */
+ (instancetype) peekEnvironment;

/*----------------------------------------------------------------------------*/
#pragma mark Loading the Mockingbird environment
/*!    @name Loading the Mockingbird environment                              */
/*----------------------------------------------------------------------------*/

/*!
 Loads a new default environment, bypassing any `manifest.xml` file that might
 exist in the application's resources. The default environment is the 
 environment that exists before any manifest file is processed.

 If loading is successful, the newly-loaded environment will become the
 active environment.

 @return    The newly-loaded, now-active `MBEnvironment` instance, or `nil`
            if the environment could not be loaded.
 */
+ (instancetype) loadDefaultEnvironment;

/*!
 Loads a new environment by processing the `manifest.xml` file found in the
 application's resources.

 If loading is successful, the newly-loaded environment will become the
 active environment.

 @return    The newly-loaded, now-active `MBEnvironment` instance, or `nil`
            if the environment could not be loaded.
 */
+ (instancetype) loadFromManifest;

/*!
 Loads a new environment by processing the `manifest.xml` file found in the
 specified search directory or in the application's resources.

 If loading is successful, the newly-loaded environment will become the
 active environment.

 @param     dirPath The path of a directory that will be searched when
            trying to locate the manifest and other MBML files. This directory
            will be the first one searched when MBML files are referenced. If
            a given file doesn't exist in `dirPath`, the `resourceSearchBundles`
            will then be searched.

 @return    The newly-loaded, now-active `MBEnvironment` instance, or `nil`
            if the environment could not be loaded.
 */
+ (instancetype) loadFromManifestWithSearchDirectory:(NSString*)dirPath;

/*!
 Loads a new environment by processing the manifest file with the given name
 found in the specified search directory or in the application's resources.

 If loading is successful, the newly-loaded environment will become the
 active environment.

 @param     manifestName The name of the manifest file.

 @param     dirPath The path of a directory that will be searched when
            trying to locate the manifest and other MBML files. This directory
            will be the first one searched when MBML files are referenced. If
            a given file doesn't exist in `dirPath`, the `resourceSearchBundles`
            will then be searched.

 @return    The newly-loaded, now-active `MBEnvironment` instance, or `nil`
            if the environment could not be loaded.
 */
+ (instancetype) loadFromManifestFile:(NSString*)manifestName
                  withSearchDirectory:(NSString*)dirPath;

/*!
 Loads a new environment by processing the `manifest.xml` file found in the
 specified search directories or in the application's resources.

 If loading is successful, the newly-loaded environment will become the
 active environment.

 @param     dirPaths An array containing the paths of directories that will be
            searched when trying to locate the manifest and other MBML files. 
            These directories will be searched first (and in the order specified
            by `dirPaths`) when MBML files are referenced. If a given file can't
            be found in the any of the directories specified by `dirPaths`,
            the `resourceSearchBundles` will then be searched.

 @return    The newly-loaded, now-active `MBEnvironment` instance, or `nil`
            if the environment could not be loaded.
 */
+ (instancetype) loadFromManifestWithSearchDirectories:(NSArray*)dirPaths;

/*!
 Loads a new environment by processing the manifest file with the given name
 found in the specified search directories or in the application's resources.

 If loading is successful, the newly-loaded environment will become the
 active environment.

 @param     manifestName The name of the manifest file.

 @param     dirPaths An array containing the paths of directories that will be
            searched when trying to locate the manifest and other MBML files. 
            These directories will be searched first (and in the order specified
            by `dirPaths`) when MBML files are referenced. If a given file can't
            be found in the any of the directories specified by `dirPaths`,
            the `resourceSearchBundles` will then be searched.

 @return    The newly-loaded, now-active `MBEnvironment` instance, or `nil`
            if the environment could not be loaded.
 */
+ (instancetype) loadFromManifestFile:(NSString*)manifestName
                withSearchDirectories:(NSArray*)dirPaths;

/*----------------------------------------------------------------------------*/
#pragma mark MBML loading
/*!    @name MBML loading                                                     */
/*----------------------------------------------------------------------------*/

/*!
 Attempts to load the specified MBML file.

 @param     fileName The name of the MBML file to load. Note that this is not
            a path name. MBML file loading follows a specific search order
            that allows files to reference each other by name without
            knowing precisely where they're located.

 @return    `YES` if `fileName` was loaded successfully; `NO` otherwise.
 */
- (BOOL) loadMBMLFile:(NSString*)fileName;

/*----------------------------------------------------------------------------*/
#pragma mark Controlling where resources are found
/*!    @name Controlling where resources are found                            */
/*----------------------------------------------------------------------------*/

/*!
 Adds the specified bundle as one that will be consulted whenever an 
 environment attempts to find a resource such as an MBML file.
 
 @param     bundle An `NSBundle` instance that should be searched when
            attempting to find resources.
 */
+ (void) addResourceSearchBundle:(NSBundle*)bundle;

/*!
 Returns the `NSBundle` instances that will be consulted whenever an
 environment attempts to find a resource such as an MBML file.
 
 @return    An array of `NSBundle`s. Will never be `nil`.
 */
+ (NSArray*) resourceSearchBundles;

/*----------------------------------------------------------------------------*/
#pragma mark Determining the state of the environment
/*!    @name Determining the state of the environment                         */
/*----------------------------------------------------------------------------*/

/*! Returns `YES` if the environment is loaded; `NO` otherwise. */
@property(nonatomic, assign, readonly) BOOL isLoaded;

/*! If the environment was loaded using a manifest file, this property will
    return the path of the manifest file. If the environment isn't loaded
    or if the environment was loaded without using a manifest file (such as
    through the `loadDefaultEnvironment` method), this value will be `nil`. */
@property(nonatomic, strong, readonly) NSString* manifestFilePath;

/*! This property contains the paths of the MBML files that have been loaded
    by the environment thusfar. */
@property(nonatomic, copy, readonly) NSArray* mbmlPathsLoaded;

/*!
 Determines if an MBML file with a specific path has been loaded by the
 receiver.
 
 @param     filePath The path of the file.
 
 @return    `YES` if the environment has loaded an MBML file at the path
            `filePath`; `NO` otherwise.
 */
- (BOOL) mbmlPathIsLoaded:(NSString*)filePath;

/*!
 Determines if an MBML file with a specific name has been loaded by the
 receiver.
 
 Because MBML is designed to be path-agnostic, the system does not support
 multiple files with the same name, even if their paths are different.
 Therefore, all MBML filenames are guaranteed to be unique.
 
 @param     fileName The filename, also known as the last path component.
 
 @return    `YES` if the environment has loaded an MBML file with the given
            name; `NO` otherwise.
 */
- (BOOL) mbmlFileIsLoaded:(NSString*)fileName;

/*----------------------------------------------------------------------------*/
#pragma mark Working with external libraries
/*!    @name Working with external libraries                                  */
/*----------------------------------------------------------------------------*/

/*!
 Allows the loading of environment classes from libraries whose class names
 begin with the specified prefix.

 @param     prefix The class prefix Mockingbird should support for dynamic
            class loading.
 */
+ (void) addSupportedLibraryClassPrefix:(NSString*)prefix;

/*!
 Returns an array containing the class prefixes that will be searched
 when attempting to load environment classes.
 
 @return    An array of strings containing the supported class prefixes.
            Will never be `nil` and will always contain at least one value,
            the string "`MB`".
 */
+ (NSArray*) supportedLibraryClassPrefixes;

/*!
 Uses the `supportedClassPrefixes` to find an available `Class` that implements
 the class with the specified name.
 
 Mockingbird uses this method to find classes that are dynamically loaded by
 name.
 
 First, a class with a name matching the `className` parameter is sought. If
 no such class exists, the system will then iterate over the 
 `supportedClassPrefixes` and, for each prefix, will attempt to find a class
 whose name is `className` with the given prefix. The first one found (if any) 
 is returned.

 @param     className The class name for which a `Class` is sought.
 
 @return    A `Class` for `className`, if a class exists among the supported
            class prefixes, or without any prefix. Returns `nil` if no class
            could be found.
 */
+ (Class) libraryClassForName:(NSString*)className;

/*----------------------------------------------------------------------------*/
#pragma mark Adding functionality through modules
/*!    @name Adding functionality through modules                             */
/*----------------------------------------------------------------------------*/

/*!
 Enables the `MBModule` represented by the specified class. When new
 `MBEnvironment` instances are created, they will gain support for the
 features added by the module implementation.
 
 @param     cls The implementing class of the `MBModule` to enable.

 @return    `YES` if `cls` represents an `MBModule` that is now enabled. Will
            be `NO` if `cls` does not conform to `MBModule`.
 */
+ (BOOL) enableModuleClass:(Class)cls;

/*!
 Returns an array containing the `MBModule` classes that will be enabled for all
 newly-created environments. Note when a given environment instance is loaded,
 additional modules not included in this array may be enabled through the
 manifest file.
 
 @return    The currently-enabled modules. Will always contain at least one
            item, because `MBDataEnvironmentModule` is always enabled.

 */
+ (NSArray*) enabledModuleClasses;

/*!
 Returns an array of `Class`es representing the `MBModule`s enabled in the
 receiver. 

 @return    The modules enabled in the receiving environment. Will always 
            contain at least one item, because `MBDataEnvironmentModule` is
            always enabled. Additional modules may also be enabled through the
            manifest file.
 */
- (NSArray*) enabledModuleClasses;

/*----------------------------------------------------------------------------*/
#pragma mark Accessing environment loaders
/*!    @name Accessing environment loaders                                    */
/*----------------------------------------------------------------------------*/

/*!
 Returns an array of `MBEnvironmentLoader` instances representing the
 environment loaders consulted when the receiving environment is loaded.
 
 @return    The environment loaders used by the receiver. Will never be `nil`.
 */
- (NSArray*) environmentLoaders;

/*!
 Returns the first `MBEnvironmentLoader` instance known to the receiver that
 is an instance of the given class.
 
 @param     cls The class for which an implementing `MBEnvironmentLoader`
            instance is sought.

 @return    The first `MBEnvironmentLoader` representing an instance of `cls`.
            Will be `nil` if no such environment loader was found.
 */
- (MBEnvironmentLoader*) environmentLoaderOfClass:(Class)cls;

@end
