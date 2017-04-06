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

extern NSString* const __nonnull kMBExpressionCacheDidSerializeEvent;   // @"MBExpressionCache:didSerialize"

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
 The `MBExpressionCache` class is used to cache tokenized versions of
 Mockingbird expressions.

 ### How expression caching works

 The process of evaluating an expression consists of two parts:
 
 * **Tokenization:** First, the expression is parsed, resulting in a set of
   *tokens* that represent the grammatical structure of an expression.
 
 * **Evaluation:** Then, once the expression has been tokenized, the tokens are
   *evaluted*, yielding an *expression result*.
 
 Tokenization only needs to occur once for a given expression. Once the tokens
 have been created, they can be reused any number of times for evaluation.
 
 To optimize the process of evaluating expressions, Mockingbird caches 
 expression tokens in memory by default.
 
 And to be respectful of memory usage, if your application receives a
 `UIApplicationDidReceiveMemoryWarningNotification`, the in-memory portion of
 the expression cache clears itself automatically.

 ### Cache serialization

 The `MBExpressionCache` can also be configured to serialize the token cache
 to the filesystem.
 
 Storing the expression cache in the filesystem can provide performance benefits
 for applications that rely heavily on Mockingbird expressions.

 Serialization allows the cache to be pre-filled with tokenized expressions
 when the `MBEnvironment` is loaded. With a serialized cache, expressions
 in the cache won't ever need to be re-tokenized, even after a fresh launch of
 your application.

 To enable cache serialization, call `setCacheSerialization:withInterval:`.

 ### Where cache files are stored
 
 If serialization is used, the cache file will be stored in your application's
 `Caches` directory, in a file named `MBExpressionCache.serialized`.

 During development, you can inspect this file to get a sense of what's
 ending up in the cache.

 ### Filesystem cache management strategies

 Typical applications won't need to worry about the size of the expression
 cache. However, if your application is likely to encounter tens or hundreds
 of thousands of unique expressions, your cache file may grow large and
 you may want to consider:
 
 * Limiting cache serialization using 
   `MBExpressionCacheSerializationOptimizeForLaunch`. Instead of serializing
   every expression ever encountered, your application can be set to
   serialize only those encountered only within a certain period of time
   from application launch.

 * Manually managing the size of the filesystem cache. Listen for the
   `NSNotification` event named "`MBExpressionCache:didSerialize`", and
   when it is fired, check the return value of the `filesystemCacheSize` method
   and call `removeFilesystemCache` as needed.

 ### Shipping with a compiled-in cache file
 
 When developing your application in the simulator, if you're relying on 
 cache serialization, you can copy the `MBExpressionCache.serialized` file
 into your application's resources. This will allow you to ship your
 application with a pre-built cache file.
 
 **Note:** The pre-built expression cache must be included in the main
 `NSBundle`'s resources in order to be found.

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
 Allows expression cache serialization to be temporarily disabled.

 This value is manipulated during the `MBEnvironment` load process. Typically,
 you would not change this property yourself; instead, consider using
 the `setCacheSerialization:withInterval:` method if you wish to control how 
 persistence is handled.
 */
@property(nonatomic, assign) BOOL pausePersistence;

/*!
 Controls whether and how the expression cache serializes cached tokens
 to the filesystem.
 
 The expression cache will not serialize by default. This method must be
 called with the appropriate parameters to enable serialization.

 @param     serialization Specifies the serialization strategy to use

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
#pragma mark Clearing and resetting the cache
/*!    @name Clearing and resetting the cache                                 */
/*----------------------------------------------------------------------------*/

/*!
 Throws away the in-memory token cache.
 
 This method is called automatically in response to the
 `UIApplicationDidReceiveMemoryWarningNotification` event being fired.
 */
- (void) clearMemoryCache;

/*!
 Removes the serialized expression cache file, if any.
  
 The next time `loadCache` is called, a compiled-in expression cache may be
 loaded. If you want to prevent this from happening, call `resetFilesystemCache`
 instead.
 */
- (void) removeFilesystemCache;

/*!
 Returns the size of the serialized filesystem cache, if any.
 
 This does not take into account the size of any compiled-in expression
 cache resource.
 
 @return    The filesystem cache size (in bytes), or `nil` if there is no
            filesystem cache.
 */
- (nullable NSNumber*) filesystemCacheSize;

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
 to load a file named `MBExpressionCache.serialized` from the application's
 main `NSBundle`.

 The memory cache is not modified if no file was loaded.
 
 @note      Calling this method has no effect if `cacheSerialization` is
            `MBExpressionCacheSerializationNone` or if `pausePersistence`
            is `YES`.
 */
- (void) loadCache;

/*!
 If an expression cache file is available, it is loaded, and the file's contents
 are merged with the current contents of the in-memory cache.
 
 During the merge process, cached expressions contained within the file are
 added to the memory cache only if the expression does not already exist
 in the memory cache.

 If there is no cache file available in the filesystem, the cache will attempt
 to load a file named `MBExpressionCache.serialized` from the application's
 main `NSBundle`.

 The memory cache is not modified if no file was loaded.
 
 @note      Calling this method has no effect if `cacheSerialization` is
            `MBExpressionCacheSerializationNone` or if `pausePersistence`
            is `YES`.
 */
- (void) loadAndMergeCache;

/*!
 Saves the current in-memory expression cache to the filesystem.
 
 @note      Calling this method has no effect if `cacheSerialization` is
            `MBExpressionCacheSerializationNone` or if `pausePersistence`
            is `YES`.
 */
- (void) saveCache;

@end
