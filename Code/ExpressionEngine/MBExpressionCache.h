//
//  MBExpressionCache.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/25/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBSingleton.h>

@class MBVariableSpace;
@class MBExpressionGrammar;
@class MBExpressionError;

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

extern NSString* const kMBExpressionCacheDidSerializeEvent;   // @"MBExpressionCache:didSerialize"

/******************************************************************************/
#pragma mark Types
/******************************************************************************/

/*!
 Specifies the serialization behavior for the `MBExpressionCache`.
 */
typedef NS_ENUM(NSUInteger, MBExpressionCacheSerialization)
{
    /*! The cache will not serialize any changes to the filesystem. This is
        the default value of the `MBExpressionCache`'s `cacheSerialization` 
        property. */
    MBExpressionCacheSerializationNone,

    /*! The cache will serialize only those changes occurring within a given
        period of time after application launch. Cache files will be smaller. */
    MBExpressionCacheSerializationOptimizeForLaunch,

    /*! The cache will periodically serialize changes to the filesystem.
        Over time, the cache will grow to encompass all expressions
        encountered at runtime, making expression evaluation quicker. 
        Cache files will be larger, however, which can affect application
        launch times in extreme cases. */
    MBExpressionCacheSerializationOptimizeForPerformance,
};

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionCache class
/******************************************************************************/

/*!
 
 @warning   You *must not* create instances of this class yourself; this class
            is a singleton. Call the `instance` class method (declared by the
            `MBSingleton` protocol) to acquire the singleton instance.
 */
@interface MBExpressionCache : NSObject <MBSingleton>

/*----------------------------------------------------------------------------*/
#pragma mark Controlling cache behavior
/*!    @name Controlling cache behavior                                       */
/*----------------------------------------------------------------------------*/

/*!
 Disables caching altogether when set to `YES`. Defaults to `NO`.
 */
@property(nonatomic, assign) BOOL disableCaching;

/*!
 By default, the expression cache will log status messages to the console
 when attempting to load or save cache files. This property can be set to `YES`
 to suppress those log messages.
 */
@property(nonatomic, assign) BOOL suppressConsoleLogging;

/*!
 Determines whether the expression cache will utilize the filesystem for
 persisting the cached expression tokens.

 This value is manipulated during the `MBEnvironment` load process. Typically,
 you would not change this property yourself; instead, consider using
 the `setCacheSerialization:withInterval:` if you wish to control how the
 cache handles persistence.
 */
@property(nonatomic, assign) BOOL enablePersistence;

/*!
 Controls whether and how the expression cache writes files to the filesystem.
 
 By default, the expression cache will not serialize.
 
 @param     serialization Specifies whether and how the cache should serialize
            persistent copies to the filesystem.

 @param     interval The time interval that applies to the `serialization`
            value. If `serialization` is 
            `MBExpressionCacheSerializationOptimizeForLaunch`, the cache
            will serialize at most once per run of the application, and only
            after `interval` seconds have elapsed. If `serialization` is
            `MBExpressionCacheSerializationOptimizeForPerformance`, then
            serialization may occur periodically, no more than every `interval`
            seconds. If `serialization` is `MBExpressionCacheSerializationNone`,
            this value is ignored.
 */
- (void) setCacheSerialization:(MBExpressionCacheSerialization)serialization
                  withInterval:(NSTimeInterval)interval;

/*!
 Specifies the cache's serialization behavior. The default value is 
 `MBExpressionCacheSerializationNone`, but it can be changed by calling
 `setCacheSerialization:withInterval:`.
 */
@property(nonatomic, readonly) MBExpressionCacheSerialization cacheSerialization;

/*!
 Specifies the cache serialization interval. The meaning of this value depends
 on the value of the `cacheSerialization` property. Will be `0.0` if
 `cacheSerialization` is `MBExpressionCacheSerializationNone`.
 */
@property(nonatomic, readonly) NSTimeInterval cacheSerializationInterval;

/*----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/
#pragma mark Clearing the cache
/*!    @name Clearing the cache                                               */
/*----------------------------------------------------------------------------*/

/*!
 Throws away the in-memory token cache.
 
 This method is called automatically during memory warnings.
 */
- (void) clearMemoryCache;

/*!
 Removes the expression cache's file if it was previously written to the
 filesystem.
 
 @note      This method does not remove any compiled-in resources
            representing an expression cache file. Next time `loadCache` is
            called, a compiled-in expression cache may be loaded. If you want
            to prevent this from happening, call the `resetFilesystemCache`
            method instead.
 */
- (void) removeFilesystemCache;

/*!
 Returns the size of the serialized filesystem cache, if any.
 
 This does not take into account the size of any compiled-in expression
 cache resource.
 
 @return    The filesystem cache size (in bytes), or `nil` if there is no
            filesystem cache.
 */
- (NSNumber*) filesystemCacheSize;

/*!
 Clears the in-memory cache and resets knowledge of data that could affect
 automatic cache invalidation.
 */
- (void) resetMemoryCache;

/*!
 Saves an empty cache file to the filesystem, replacing the existing
 cache file (if there is one).

 This method provides a way to override any compiled-in expression cache
 file resource; next time the `loadCache` method is called, the cache file
 in the filesystem will be loaded instead of the compiled-in resource.
 */
- (void) resetFilesystemCache;

/*!
 Clears the in-memory cache and removes the filesystem cache by calling
 `clearMemoryCache` and then `removeFilesystemCache`.
 */
- (void) clearCache;

/*----------------------------------------------------------------------------*/
#pragma mark Cache persistence
/*!    @name Cache persistence                                                */
/*----------------------------------------------------------------------------*/

/*!
 If an expression cache file is available, it is loaded, and the file's contents
 are used to replace the existing contents of the in-memory cache.
 
 If there is no cache file available in the filesystem, the cache will attempt
 to load a cache file from the app's resources.

 The memory cache is not modified if no file was loaded.
 
 @note      If the expression cache's `enablePersistence` property is `NO`,
            calling this method does nothing.
 */
- (void) loadCache;

/*!
 If an expression cache file is available, it is loaded, and the file's contents
 are merged with the current contents of the in-memory cache.
 
 During the merge process, cached expressions contained within the file are
 added to the memory cache only if the expression does not already exist
 in the memory cache.

 If there is no cache file available in the filesystem, the cache will attempt
 to load a cache file from the app's resources.

 The memory cache is not modified if no file was loaded.
 
 @note      If the expression cache's `enablePersistence` property is `NO`,
            calling this method does nothing.
 */
- (void) loadAndMergeCache;

/*!
 Saves the current in-memory expression cache to the filesystem.
 
 @note      If the expression cache's `enablePersistence` property is `NO`,
            calling this method does nothing.
 */
- (void) saveCache;

@end
