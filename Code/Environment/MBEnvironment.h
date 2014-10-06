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

@property(nonatomic, assign, readonly) BOOL isLoaded;
@property(nonatomic, strong, readonly) NSString* baseDirectory;
@property(nonatomic, strong, readonly) NSString* manifestFilePath;

/*******************************************************************************
 @name Working with external libraries
 ******************************************************************************/

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

/******************************************************************************/
#pragma mark Code modules
/******************************************************************************/

/*!
 Returns an array of `Class`es representing the `MBModule`s enabled in the
 receiver.
 
 @return    The enabled modules.
 */
- (NSArray*) enabledModuleClasses;

/******************************************************************************/
#pragma mark Managing environment loaders
/******************************************************************************/

+ (BOOL) registerEnvironmentLoaderClass:(Class)extClass;

+ (NSArray*) registeredEnvironmentLoaderClasses;

- (MBEnvironmentLoader*) addEnvironmentLoaderFromClass:(Class)extClass;

- (BOOL) addEnvironmentLoader:(MBEnvironmentLoader*)loader;

- (NSArray*) environmentLoaders;

- (MBEnvironmentLoader*) environmentLoaderOfClass:(Class)extClass;

/******************************************************************************/
#pragma mark Managing the current environment
/******************************************************************************/

/*! Replaces the current global environment.
 
    @param      env the MBEnvironment instance to use as the new global
                environment.
 
    @return     the previously-set global environment.
 */
+ (instancetype) setEnvironment:(MBEnvironment*)env;

/*! Replaces the current global environment by pushing a new environment onto
    the stack. The instance being replaced can later be restored as the current
    global environment by calling <code>popEnvironment</code>.
 
    @param      env the MBEnvironment instance to set as the new global
                environment, pushing the current one onto the stack
 */
+ (void) pushEnvironment:(MBEnvironment*)env;

/*! Restores as the current global environment the one that was active when the
    previous call to <code>pushEnvironment:</code> was issued.
 
    An NSException will be raised if there's nothing to pop.
 
    @return     The newly-active global environment.
 */
+ (instancetype) popEnvironment;

/*! If there is at least one environment on the stack as a result of a previous
    call to <code>pushEnvironment:</code>, this method returns the top item
    on the stack, the one that will become active at the next call to
    <code>popEnvironment</code>. Unlike with <code>popEnvironment</code>, the
    stack is not changed as a result of this call.
 
    @return     The top item on the environment stack, or nil if there are no
                items on the stack.
 */
+ (instancetype) peekEnvironment;

/*******************************************************************************
@name Loading the Mockingbird environment
******************************************************************************/

/*!
 Loads the Mockingbird environment using the manifest file whose name is
 identified by value of the constant kMBMLManifestFilename
 in the application's main resource bundle.
 
 @return    An `MBEnvironment` instance representing the active environment
            upon return from this method. If this method succeeded in loading
            a new environment, this will be the new environment.
 */
+ (instancetype) loadFromResources;

/*!
 Loads the Mockingbird environment using the manifest file whose name is
 identified by value of the constant kMBMLManifestFilename
 in the specified directory.
 
 @return    An `MBEnvironment` instance representing the active environment
            upon return from this method. If this method succeeded in loading
            a new environment, this will be the new environment.
*/
+ (instancetype) loadFromDirectory:(NSString*)dirPath;

/*!
 Loads the Mockingbird environment using the manifest file with the specified
 name in the application's main resource bundle.
 
 @return    An `MBEnvironment` instance representing the active environment
            upon return from this method. If this method succeeded in loading
            a new environment, this will be the new environment.
*/
+ (instancetype) loadFromManifestFile:(NSString*)fileName;

/*!
 Loads the Mockingbird environment using the manifest file with the name
 specified in the given base directory. 

 @return    An `MBEnvironment` instance representing the active environment
            upon return from this method. If this method succeeded in loading
            a new environment, this will be the new environment.
*/
+ (instancetype) loadFromManifestFile:(NSString*)fileName baseDirectory:(NSString*)dirPath;

/*!
 Reloads the Mockingbird environment from the previously-loaded file(s).

 @return    An `MBEnvironment` instance representing the active environment
            upon return from this method. If this method succeeded in loading
            a new environment, this will be the new environment.
*/
+ (instancetype) reload;

/******************************************************************************/
#pragma mark MBML loading
/******************************************************************************/

/*!
 Attempts to load the Mockingbird environment using the specified manifest file
 in the given directory.
 
 @return        YES on a successful load of the environment; NO otherwise.
 */
- (BOOL) loadFromManifestFile:(NSString*)manifestFileName
                baseDirectory:(NSString*)dir;

- (BOOL) loadTemplateFile:(NSString*)fileName
            baseDirectory:(NSString*)dir;

- (BOOL) loadTemplateFile:(NSString*)fileName;

/******************************************************************************/
#pragma mark Determining which MBML files have been loaded
/******************************************************************************/

@property(nonatomic, copy, readonly) NSArray* mbmlPathsLoaded;

- (BOOL) mbmlFileIsLoaded:(NSString*)fileName;

- (BOOL) mbmlPathIsLoaded:(NSString*)filePath;

/******************************************************************************/
#pragma mark Environment state change hooks
/******************************************************************************/

- (void) environmentWillLoad;
- (void) environmentDidLoad;
- (void) environmentWillActivate;
- (void) environmentDidActivate;
- (void) environmentWillDeactivate;
- (void) environmentDidDeactivate;

@end
