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
#pragma mark Retrieving tokens for expressions
/*!    @name Retrieving tokens for expressions                                */
/*----------------------------------------------------------------------------*/

/*!
 Returns the cached `MBMLParseToken`s for the given expression.

 @param     expr The expression for which the cached tokens are sought.

 @param     grammar The grammar used to tokenize the expression.

 @return    An array of the cached tokens for the passed-in expression, or
            `nil` if there are no cached tokens for the given expression.
 */
- (NSArray*) cachedTokensForExpression:(NSString*)expr
                          usingGrammar:(MBExpressionGrammar*)grammar;

/*!
 Returns an array of `MBMLParseToken` instances representing the tokenized
 version of the passed-in expression.
 
 If the expression is already in the cache, the cached tokens are returned.
 Otherwise, the expression is be tokenized using the specified grammar,
 the resulting tokens are added to the cache, and are then returned.

 @param     expr The expression to tokenize.
 
 @param     space The variable space that will be used to look up values for
            any variable references contained in the expression.
 
 @param     grammar The grammar to be used for tokenizing the expression.
 
 @param     errPtr An optional pointer to a memory location for storing an
            `MBExpressionError` instance. If this parameter is non-`nil`
            and an error occurs during tokenization, `errPtr` will be updated
            to point to an `MBExpressionError` instance describing the error.

 @return    An array of tokens representing the passed-in expression. Will be
            `nil` if an error occurs.
 */
- (NSArray*) tokensForExpression:(NSString*)expr
                 inVariableSpace:(MBVariableSpace*)space
                    usingGrammar:(MBExpressionGrammar*)grammar
                           error:(MBExpressionError**)errPtr;

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
 Determines whether the expression cache will utilize the filesystem for
 persisting the cached expression tokens.

 Cache persistence is disabled by default, and is turned on only after the
 `MBEnvironment` completes its initial load.
 */
@property(nonatomic, assign, getter=isPersistenceEnabled) BOOL persistenceEnabled;

/*!
 If an expression cache file is available, it is loaded, and the file's contents
 are used to replace the existing contents of the in-memory cache.
 
 If there is no cache file available in the filesystem, the cache will attempt
 to load a cache file from the app's resources.

 The memory cache is not modified if no file was loaded.
 
 @note      If the expression cache's `isPersistenceEnabled` property is `NO`,
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
 
 @note      If the expression cache's `isPersistenceEnabled` property is `NO`,
            calling this method does nothing.
 */
- (void) loadAndMergeCache;

/*!
 Saves the current in-memory expression cache to the filesystem.
 
 @note      If the expression cache's `isPersistenceEnabled` property is `NO`,
            calling this method does nothing.
 */
- (void) saveCache;

/*----------------------------------------------------------------------------*/
#pragma mark Controlling logging
/*!    @name Controlling logging                                              */
/*----------------------------------------------------------------------------*/

/*!
 By default, the expression cache will log status messages to the console
 when attempting to load or save cache files. This property can be set to `YES`
 to suppress those log messages.
 */
@property(nonatomic, assign) BOOL suppressConsoleLogging;

@end
