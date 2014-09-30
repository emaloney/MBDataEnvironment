//
//  MBExpressionCache.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/25/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBToolbox.h>

#import "MBExpressionCache.h"
#import "MBExpressionTokenizer.h"
#import "MBExpressionGrammar.h"
#import "MBMLFunction.h"
#import "MBVariableSpace.h"
#import "MBExpression.h"

#define DEBUG_LOCAL                 0
#define DEBUG_VERBOSE               0
#define DEBUG_BYPASS_CACHE          NO
#define DEBUG_DONT_PERSIST          NO

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

const NSUInteger kMBExpressionCacheSerializationVersion     = 13;  // increment if file schema changes
const NSTimeInterval kMBExpressionCacheDontAutopersistAfter = -1;  // optimize for fast startup by only autopersisting expressions encountered within X seconds of startup (-1 to disable)
const NSTimeInterval kMBExpressionCacheDelayBeforeFlushing  = 60;  // when a clean cache is first made dirty, we wait this long before autopersisting

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionCache implementation
/******************************************************************************/

@implementation MBExpressionCache
{
    NSDate* _cacheInstantiationTime;
    NSLock* _cacheLock;
    NSMutableDictionary* _grammarToTokenCache;
    BOOL _cacheDirty;
    NSTimer* _saveCacheTimer;
    NSString* _cacheFileName;
}

MBImplementSingleton();
                  
/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

// no corresponding dealloc since this is a singleton
// that will live for the life of the app
- (id) init
{
    self = [super init];
    if (self) {
        _cacheLock = [NSLock new];
        _grammarToTokenCache = [NSMutableDictionary new];

        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];

        // when a memory warning occurs, we clear the cache
		[nc addObserver:self
               selector:@selector(memoryWarning:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];

        // when a new MBML function is declared, we need to clear the in-memory
        // cache and reset the _cacheFileName since function parameter
        // tokenization may not be compatible with what it was previously
		[nc addObserver:self
               selector:@selector(_handlePossibleCacheKeyChange)
                   name:kMBVariableSpaceDidDeclareFunctionEvent
                 object:nil];
    }
    return self;
}

/******************************************************************************/
#pragma mark Memory management
/******************************************************************************/

- (void) memoryWarning:(id)sender
{
	debugTrace();

    [self clearMemoryCache];
}

/******************************************************************************/
#pragma mark Cache dirty & save timer handling
/******************************************************************************/

// this method should always be called when the cache lock is held
- (void) _setCacheDirty:(BOOL)setDirty
{
    if (!DEBUG_FLAG(DEBUG_DONT_PERSIST) && _cacheDirty != setDirty) {
        _cacheDirty = setDirty;
        
        if (kMBExpressionCacheDontAutopersistAfter > 0) {
            if (!_cacheInstantiationTime) {
                _cacheInstantiationTime = [NSDate new];
            }
            else {
                NSTimeInterval val = -[_cacheInstantiationTime timeIntervalSinceNow];
                if (val > kMBExpressionCacheDontAutopersistAfter) {
                    return;
                }
            }
        }
        
        if (setDirty && !_saveCacheTimer) {
            // if there isn't already a timer scheduled, set one to go off soon
            _saveCacheTimer = [NSTimer scheduledTimerWithTimeInterval:kMBExpressionCacheDelayBeforeFlushing 
                                                                target:self
                                                              selector:@selector(_saveTimerFired:)
                                                              userInfo:nil
                                                               repeats:NO];
        }
        else if (!setDirty && _saveCacheTimer) {
            [_saveCacheTimer invalidate];
            _saveCacheTimer = nil;
        }
    }
}

- (void) _saveTimerFired:(NSTimer*)timer
{
    debugTrace();
    
    NSOperation* saveOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                               selector:@selector(saveCache)
                                                                 object:nil];
    
    [[MBFilesystemOperationQueue instance] addOperation:saveOp];
    
}

/******************************************************************************/
#pragma mark Accessing cache files
/******************************************************************************/

- (void) _handlePossibleCacheKeyChange
{
    verboseDebugTrace();

    _cacheFileName = nil;

    [self clearMemoryCache];
}

- (NSString*) _cacheFileName
{
    //
    // because tokenized function parameters are stored in the cache, and
    // because the function's inputType determines the structure of those
    // tokens, we need to take this account when determining whether a cache
    // file is compatible with the current set of functions as described by
    // the variable space. if the list of functions changes, or if a
    // function's inputType changes, the tokens in the cache may not be
    // compatible. (See IPHONE-1076 and IOS-273)            --ECM 3/27/2014
    //
    if (!_cacheFileName) {
        MBVariableSpace* vars = [MBVariableSpace instance];
        NSArray* funcNames = [vars functionNames];
        NSArray* sortedFuncNames = [funcNames sortedArrayUsingSelector:@selector(compare:)];

        NSMutableArray* cacheKeyElements = [NSMutableArray new];
        [cacheKeyElements addObject:[NSString stringWithFormat:@"%@:%u", [self class], (unsigned int)kMBExpressionCacheSerializationVersion]];
        for (NSString* functionName in sortedFuncNames) {
            MBMLFunction* func = [vars functionWithName:functionName];
            MBMLFunctionInputType inputType = func.inputType;
            [cacheKeyElements addObject:[NSString stringWithFormat:@"%@:%lu", functionName, (unsigned long)inputType]];
        }
        NSString* cacheKeySrc = [cacheKeyElements componentsJoinedByString:@","];
        NSString* cacheKey = [cacheKeySrc MD5];
        
        _cacheFileName = [NSString stringWithFormat:@"%@-%@.tokenCache", [MBExpression class], cacheKey];
    }
    return _cacheFileName;
}

- (NSString*) _pathForPrebuiltCacheFile
{
    return [[NSBundle mainBundle] pathForResource:[self _cacheFileName] ofType:nil];
}

- (NSString*) _pathForUserCacheFile
{
    NSString* cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, NO) firstObject];
    NSString* exprCacheDir = [[cacheDir stringByAppendingPathComponent:[[self class] description]] stringByExpandingTildeInPath];

    NSError* err = nil;
    NSFileManager* mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:exprCacheDir]) {
        if (![mgr createDirectoryAtPath:exprCacheDir withIntermediateDirectories:YES attributes:nil error:&err]) {
            errorLog(@"Couldn't create directory <%@> for writing %@ due to error: %@", exprCacheDir, [self class], err);
            return nil;
        }
    }

    return [exprCacheDir stringByAppendingPathComponent:[self _cacheFileName]];
}

- (NSMutableDictionary*) _loadCacheFromFile:(NSString*)cacheFile isResource:(BOOL)rsrc
{
    NSError* err = nil;
    NSData* data = [NSData dataWithContentsOfFile:cacheFile options:NSDataReadingUncached error:&err];
    if (!data) {
        errorLog(@"%@ failed to read file <%@> due to error: %@", [self class], cacheFile, err);
        return nil;
    }
    
    @try {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException* ex) {
        errorLog(@"%@ failed to properly deserialize file <%@> (it may be corrupted and will be deleted); error: %@", [self class], cacheFile, ex);

        // if we're dealing with a regular file and not a compiled-in resource, 
        // delete the file that caused exception
        NSError* err = nil;
        if (![[NSFileManager defaultManager] removeItemAtPath:cacheFile error:&err]) {
            errorLog(@"%@ failed to delete (apparently) corrupted file <%@>: %@", [self class], cacheFile, err);
        }
    }
    
    return nil;
}

/******************************************************************************/
#pragma mark Cache persistence
/******************************************************************************/

- (NSMutableDictionary*) _cacheDataFromFilesystem
{
    NSMutableDictionary* cache = nil;
    if (!DEBUG_FLAG(DEBUG_DONT_PERSIST) && self.isPersistenceEnabled) {
        NSFileManager* fileMgr = [NSFileManager defaultManager];

        NSString* cacheFile = [self _pathForUserCacheFile];
        if ([fileMgr isReadableFileAtPath:cacheFile]) {
            cache = [self _loadCacheFromFile:cacheFile isResource:NO];
            if (cache) {
                if (!self.suppressConsoleLogging) consoleLog(@"%@ loaded from file: %@", [self class], cacheFile);
            }
        }

        if (!cache) {
            cacheFile = [self _pathForPrebuiltCacheFile];
            if ([fileMgr isReadableFileAtPath:cacheFile]) {
                cache = [self _loadCacheFromFile:cacheFile isResource:YES];
                if (cache) {
                    if (!self.suppressConsoleLogging) consoleLog(@"%@ loaded from file: %@", [self class], cacheFile);
                }
            }
        }

        if (!cache) {
            if (!self.suppressConsoleLogging) consoleLog(@"%@ did not find a cache file named %@", [self class], [self _cacheFileName]);
        }
    }
    return cache;
}

- (void) loadCache
{
    debugTrace();

    NSMutableDictionary* cache = [self _cacheDataFromFilesystem];
    if (cache) {
        [_cacheLock lock];
        _grammarToTokenCache = cache;
        [self _setCacheDirty:NO];
        [_cacheLock unlock];
    }
}

- (void) loadAndMergeCache
{
    debugTrace();

    NSMutableDictionary* cache = [self _cacheDataFromFilesystem];
    if (cache) {
        [_cacheLock lock];

        if (!_grammarToTokenCache.count) {
            _grammarToTokenCache = cache;
        }
        else {
            for (NSString* grammar in cache) {
                NSMutableDictionary* tokensFromFile = cache[grammar];
                NSMutableDictionary* tokensInMemory = _grammarToTokenCache[grammar];

                if (!tokensInMemory) {
                    _grammarToTokenCache[grammar] = tokensFromFile;
                }
                else {
                    for (NSString* expr in tokensFromFile) {
                        if (!tokensInMemory[expr]) {
                            debugLog(@"   Adding expression tokens from file to memory for: %@", expr);
                            tokensInMemory[expr] = tokensFromFile[expr];
                        }
                        else {
                            debugLog(@"Already in memory cache; won't overwrite tokens for: %@", expr);
                        }
                    }
                }
            }
        }

        [_cacheLock unlock];
    }
}

- (BOOL) _saveCache:(NSDictionary*)cache toFile:(NSString*)cacheFile suppressLog:(BOOL)suppress
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:cache];

    NSError* err = nil;
    if (![data writeToFile:cacheFile options:NSDataWritingAtomic error:&err]) {
        errorLog(@"%@ failed to write file <%@> due to error: %@", [self class], cacheFile, err);
        return NO;
    }
    else {
        if (!suppress) consoleLog(@"%@ written to file: %@", [self class], cacheFile);
        return YES;
    }
}

- (void) saveCache
{
    debugTrace();

    if (!DEBUG_FLAG(DEBUG_DONT_PERSIST) && self.isPersistenceEnabled) {
        NSDictionary* cacheCopy = nil;
        
        [_cacheLock lock];
                
        if (_grammarToTokenCache) {
            cacheCopy = [_grammarToTokenCache mutableCopy];
        }
        
        [self _setCacheDirty:NO];
        
        [_cacheLock unlock];
        
        if (cacheCopy) {
            [self _saveCache:cacheCopy toFile:[self _pathForUserCacheFile] suppressLog:self.suppressConsoleLogging];
        }
    }
}

/******************************************************************************/
#pragma mark Clearing the cache
/******************************************************************************/

- (void) removeFilesystemCache
{
    debugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSError* err = nil;
    NSString* cacheFile = [self _pathForUserCacheFile];

    if ([fileMgr fileExistsAtPath:cacheFile]) {
        [fileMgr removeItemAtPath:cacheFile error:&err];
        if (err) errorObj(err);
    }
}

- (void) resetFilesystemCache
{
    debugTrace();

    [self removeFilesystemCache];

    NSString* cacheFile = [self _pathForUserCacheFile];
    if ([self _saveCache:[NSMutableDictionary new] toFile:cacheFile suppressLog:YES]) {
        if (!self.suppressConsoleLogging) consoleLog(@"Reset filesystem cache; empty %@ written to file: %@", [self class], cacheFile);
    }
}

- (void) clearMemoryCache
{
    verboseDebugTrace();
    
    [_cacheLock lock];

    [_grammarToTokenCache removeAllObjects];

    [self _setCacheDirty:NO];

    [_cacheLock unlock];
}

- (void) clearCache
{
    debugTrace();

    [self removeFilesystemCache];
    [self clearMemoryCache];
}

/******************************************************************************/
#pragma mark Retrieving expression tokens
/******************************************************************************/

- (NSArray*) cachedTokensForExpression:(NSString*)expr
                          usingGrammar:(MBExpressionGrammar*)grammar
{
    verboseDebugTrace();

    if (!expr || !grammar) return nil;

    if (!DEBUG_FLAG(DEBUG_BYPASS_CACHE)) {
        NSString* grammarClassName = NSStringFromClass([grammar class]);
        if (grammarClassName) {
            NSArray* tokens = nil;

            [_cacheLock lock];

            tokens = _grammarToTokenCache[grammarClassName][expr];

            [_cacheLock unlock];

            return tokens;
        }
    }

    return nil;
}

- (NSArray*) tokensForExpression:(NSString*)expr
                 inVariableSpace:(MBVariableSpace*)space
                    usingGrammar:(MBExpressionGrammar*)grammar
                           error:(MBExpressionError**)errPtr
{
    verboseDebugTrace();
    
    if (!expr || !grammar || !space) return nil;

    NSArray* tokens = [self cachedTokensForExpression:expr usingGrammar:grammar];
    if (tokens) {
        return tokens;
    }

    // if we don't have tokens, we'll need to tokenize
    tokens = [[MBExpressionTokenizer tokenizerWithGrammar:grammar] tokenize:expr
                                                            inVariableSpace:space
                                                                      error:errPtr];

    if (!DEBUG_FLAG(DEBUG_BYPASS_CACHE)) {
        if (tokens) {
            NSString* grammarClassName = NSStringFromClass([grammar class]);
            if (grammarClassName) {
                [_cacheLock lock];

                NSMutableDictionary* tokenCache = _grammarToTokenCache[grammarClassName];
                if (!tokenCache) {
                    tokenCache = [NSMutableDictionary dictionary];
                    _grammarToTokenCache[grammarClassName] = tokenCache;
                }
                tokenCache[expr] = tokens;

                [self _setCacheDirty:YES];

                [_cacheLock unlock];
            }
        }
    }
    return tokens;
}

@end
