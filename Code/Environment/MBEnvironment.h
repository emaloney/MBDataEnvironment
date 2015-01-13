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

@interface MBEnvironment : MBDataModel <MBInstanceVendor>

/*----------------------------------------------------------------------------*/
#pragma mark Managing the current environment
/*!    @name Managing the current environment                                 */
/*----------------------------------------------------------------------------*/

/*!
 Sets the active `MBEnvironment` instance. The active environment supplies
 the `MBVariableSpace` instance used to evaluate expressions by default.

 @param     env the `MBEnvironment` to set as the active environment.

 @return    The previously-active `MBEnvironment` instance, if any.
 */
+ (instancetype) setEnvironment:(MBEnvironment*)env;

/*!
 Sets the active `MBEnvironment` instance by pushing a new environment
 onto the environment stack.
 
 @param     env the `MBEnvironment` to set as the active environment.
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
            These directories be searched first (and in the order specified by
            `dirPaths`)  when MBML files are referenced. If a given file can't
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
            These directories be searched first (and in the order specified by
            `dirPaths`)  when MBML files are referenced. If a given file can't
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

 @return    `YES` on a successful load of the environment; NO otherwise.
 */
- (BOOL) loadMBMLFile:(NSString*)fileName;

/*----------------------------------------------------------------------------*/
#pragma mark Controlling where resources are found
/*!    @name Controlling where resources are found                            */
/*----------------------------------------------------------------------------*/

/*!
 Adds the specified bundle as one that will be consulted whenever an 
 environment attempts to find a resource.
 
 @param     bundle An `NSBundle` instance that should be searched when
            attempting to find resources.
 */
+ (void) addResourceSearchBundle:(NSBundle*)bundle;

/*!
 Returns the `NSBundle` instances that will be consulted whenever an
 environment attempts to find a resource.
 
 @return    An array of `NSBundle`s. Will never be `nil`.
 */
+ (NSArray*) resourceSearchBundles;

/*----------------------------------------------------------------------------*/
#pragma mark Determining the load state of the environment
/*!    @name Determining the load state of the environment                    */
/*----------------------------------------------------------------------------*/

@property(nonatomic, assign, readonly) BOOL isLoaded;
@property(nonatomic, strong, readonly) NSString* manifestFilePath;

@property(nonatomic, copy, readonly) NSArray* mbmlPathsLoaded;

- (BOOL) mbmlFileIsLoaded:(NSString*)fileName;

- (BOOL) mbmlPathIsLoaded:(NSString*)filePath;

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
 
 @return    An array of strings containing the supported class prefix.
 */
+ (NSArray*) supportedLibraryClassPrefixes;

/*!
 Uses the `supportedClassPrefixes` to find an available `Class` that implements
 the class with the specified name.
 
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

/*----------------------------------------------------------------------------*/
#pragma mark Environment state change hooks
/*!    @name Environment state change hooks                                   */
/*----------------------------------------------------------------------------*/

/*!
 Called when the receiving `MBEnvironment` is about to be loaded.
 
 Notifies the environment loaders known to the receiver by calling the 
 `environmentWillLoad:` method of each and passing the parameter `self`.
 */
- (void) environmentWillLoad;

/*!
 Called when the receiving `MBEnvironment` has been loaded.

 Notifies the environment loaders known to the receiver by calling the
 `environmentDidLoad:` method of each and passing the parameter `self`.
 */
- (void) environmentDidLoad;

/*!
 Called when the receiving `MBEnvironment` is about to become the active
 environment.

 Notifies the environment loaders known to the receiver by calling the
 `environmentWillActivate:` method of each and passing the parameter `self`.
 */
- (void) environmentWillActivate;

/*!
 Called when the receiving `MBEnvironment` has become the active
 environment.

 Notifies the environment loaders known to the receiver by calling the
 `environmentDidActivate:` method of each and passing the parameter `self`.
 */
- (void) environmentDidActivate;

/*!
 Called when the receiving `MBEnvironment` is about to be deactivated.

 Notifies the environment loaders known to the receiver by calling the
 `environmentWillActivate:` method of each and passing the parameter `self`.
 */
- (void) environmentWillDeactivate;

/*!
 Called when the receiving `MBEnvironment` has been deactivated.

 Notifies the environment loaders known to the receiver by calling the
 `environmentDidDeactivate:` method of each and passing the parameter `self`.
 */
- (void) environmentDidDeactivate;

@end
