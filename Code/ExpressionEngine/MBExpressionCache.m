//
//  MBExpressionCache.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 11/25/10.
//  Copyright (c) 2010 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

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

NSString* const kMBExpressionCacheDidSerializeEvent             = @"MBExpressionCache:didSerialize";

const NSInteger kMBExpressionCacheCurrentSerializationVersion   = 2;    // increment whenever file schema changes
const NSInteger kMBExpressionCacheMinimumSerializationVersion   = 2;    // update when file schema changes in non-backwards-compatible way

NSString* const kMBExpressionCacheSerializationVersionKey       = @"serializationVersion";
NSString* const kMBExpressionCacheFunctionSignaturesKey         = @"functionSignatures";
NSString* const kMBExpressionCacheGrammarToTokenCacheKey        = @"grammarToTokenCache";

/******************************************************************************/
#pragma mark -
#pragma mark MBSerializedExpressionCache private class
/******************************************************************************/

@interface MBSerializedExpressionCache : NSObject < NSCoding >

@property(nonatomic, assign) NSInteger serializationVersion;
@property(nonatomic, strong) NSMutableDictionary* functionSignatures;
@property(nonatomic, strong) NSMutableDictionary* grammarToTokenCache;

+ (MBSerializedExpressionCache*) loadFromFileAtPath:(NSString*)filePath;    // may throw exception
- (BOOL) saveToFileAtPath:(NSString*)filePath;

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBSerializedExpressionCache implementation
/******************************************************************************/

@implementation MBSerializedExpressionCache

/******************************************************************************/
#pragma mark NSCoding support
/******************************************************************************/

- (instancetype) initWithCoder:(NSCoder*)coder
{
    MBLogDebugTrace();
    
    if ([coder allowsKeyedCoding]) {
        self = [self init];
        if (self) {
            _serializationVersion = [coder decodeIntegerForKey:kMBExpressionCacheSerializationVersionKey];
            
            _functionSignatures = [coder decodeObjectForKey:kMBExpressionCacheFunctionSignaturesKey];
            if (!_functionSignatures) {
                _functionSignatures = [NSMutableDictionary new];
            }
            
            _grammarToTokenCache = [coder decodeObjectForKey:kMBExpressionCacheGrammarToTokenCacheKey];
            if (!_grammarToTokenCache) {
                _grammarToTokenCache = [NSMutableDictionary new];
            }
        }
        return self;
    }
    else {
        [NSException raise:NSInvalidUnarchiveOperationException
                    format:@"The %@ class is only compatible with keyed coding", [self class]];
    }
    return nil;
}

- (void) encodeWithCoder:(NSCoder*)coder
{
    MBLogDebugTrace();
    
    if ([coder allowsKeyedCoding]) {
        [coder encodeInteger:kMBExpressionCacheCurrentSerializationVersion forKey:kMBExpressionCacheSerializationVersionKey];
        [coder encodeObject:_functionSignatures forKey:kMBExpressionCacheFunctionSignaturesKey];
        [coder encodeObject:_grammarToTokenCache forKey:kMBExpressionCacheGrammarToTokenCacheKey];
    }
    else {
        [NSException raise:NSInvalidArchiveOperationException
                    format:@"The %@ class is only compatible with keyed coding", [self class]];
    }
}

/******************************************************************************/
#pragma mark Loading & saving
/******************************************************************************/

+ (MBSerializedExpressionCache*) loadFromFileAtPath:(NSString*)filePath
{
    NSError* err = nil;
    NSData* data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingUncached error:&err];
    if (!data) {
        MBLogError(@"%@ failed to read file <%@> due to error: %@", [self class], filePath, err);
        return nil;
    }
    
    MBSerializedExpressionCache* cache = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!cache || ![cache isKindOfClass:[MBSerializedExpressionCache class]]) {
        [NSException raise:NSInvalidArchiveOperationException
                    format:@"Expected the file <%@> to contain an %@ instance", filePath, [self class]];
    }
    
    if (cache.serializationVersion < kMBExpressionCacheMinimumSerializationVersion) {
        MBLogError(@"%@ is ignoring the cache file <%@> because it was written using a version (%ld) that is older than the minimum compatible version (%ld)", [self class], filePath, (long)cache.serializationVersion, (long)kMBExpressionCacheMinimumSerializationVersion);
        return nil;
    }
    
    if (cache.serializationVersion > kMBExpressionCacheCurrentSerializationVersion) {
        MBLogError(@"%@ is ignoring the cache file <%@> because it was written using a version (%ld) that is newer than the one currently supported (%ld)", [self class], filePath, (long)cache.serializationVersion, (long)kMBExpressionCacheMinimumSerializationVersion);
        return nil;
    }
    
    return cache;
}

- (BOOL) saveToFileAtPath:(NSString*)filePath
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    NSError* err = nil;
    if (![data writeToFile:filePath options:NSDataWritingAtomic error:&err]) {
        MBLogError(@"%@ failed to write file <%@> due to error: %@", [self class], filePath, err);
        return NO;
    }
    [MBEvents postEvent:kMBExpressionCacheDidSerializeEvent fromSender:self];
    return YES;
}

@end

/******************************************************************************/
#pragma mark -
#pragma mark MBExpressionCache implementation
/******************************************************************************/

@implementation MBExpressionCache
{
    NSDate* _cacheInstantiationTime;
    NSLock* _cacheLock;
    NSMutableDictionary* _functionSignatures;
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
- (instancetype) init
{
    self = [super init];
    if (self) {
        _cacheFileName = [NSString stringWithFormat:@"%@.serialized", [self class]];
        _cacheLock = [NSLock new];
        _grammarToTokenCache = [NSMutableDictionary new];
        _functionSignatures = [NSMutableDictionary new];
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];

#if MB_BUILD_IOS
        // when a memory warning occurs, we clear the cache
        [nc addObserver:self
               selector:@selector(memoryWarning:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
#endif

        // because tokenized function parameters are stored in the cache, and
        // because the function's inputType determines the structure of those
        // tokens, we need to take this account when determining whether a cache
        // file is compatible with the current set of functions as described by
        // the variable space.
        //
        // as functions are declared, if an existing function is redefined with
        // a new inputType, we will invalidate the cache to prevent incorrect
        // results when passing function parameters from cached tokens
        [nc addObserver:self
               selector:@selector(_handlePossibleFunctionRedeclaration:)
                   name:kMBVariableSpaceDidDeclareFunctionEvent
                 object:nil];
    }
    return self;
}

/******************************************************************************/
#pragma mark Ensuring cache consistency
/******************************************************************************/

- (void) _handlePossibleFunctionRedeclaration:(NSNotification*)notif
{
    MBLogVerboseTrace();
    
    MBMLFunction* func = notif.object;
    NSString* funcName = func.name;
    NSNumber* inputType = @(func.inputType);
    
    [_cacheLock lock];
    
    if (![self _isFunctionNamed:funcName compatibleWithInputType:inputType]) {
        [self _clearMemoryCacheHoldingLock];
    }
    _functionSignatures[funcName] = inputType;
    
    [_cacheLock unlock];
}

- (BOOL) _isFunctionNamed:(NSString*)funcName compatibleWithInputType:(NSNumber*)inputType
{
    NSNumber* curInputType = _functionSignatures[funcName];
    return (!curInputType || [curInputType isEqualToNumber:inputType]);
}

- (BOOL) _isCacheDataCompatible:(MBSerializedExpressionCache*)cacheData
{
    MBLogDebugTrace();
    
    NSDictionary* signatures = cacheData.functionSignatures;
    for (NSString* funcName in signatures) {
        NSNumber* inputType = signatures[funcName];
        if (![self _isFunctionNamed:funcName compatibleWithInputType:inputType]) {
            return NO;
        }
    }
    return YES;
}

/******************************************************************************/
#pragma mark Memory management
/******************************************************************************/

#if MB_BUILD_IOS

- (void) memoryWarning:(id)sender
{
    MBLogDebugTrace();
    
    [self clearMemoryCache];
}

#endif

/******************************************************************************/
#pragma mark Cache dirty & save timer handling
/******************************************************************************/

// this method should always be called when the cache lock is held
- (void) _setCacheDirty:(BOOL)setDirty
{
    if (!DEBUG_FLAG(DEBUG_DONT_PERSIST) && _cacheDirty != setDirty) {
        _cacheDirty = setDirty;
        
        if (_cacheSerialization == MBExpressionCacheSerializationOptimizeForLaunch) {
            if (!_cacheInstantiationTime) {
                _cacheInstantiationTime = [NSDate new];
            }
            else {
                NSTimeInterval val = -[_cacheInstantiationTime timeIntervalSinceNow];
                if (val > _cacheSerializationInterval) {
                    return;
                }
            }
        }
        
        if (setDirty && !_saveCacheTimer) {
            // if there isn't already a timer scheduled, set one to go off soon
            _saveCacheTimer = [NSTimer scheduledTimerWithTimeInterval:_cacheSerializationInterval
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
    MBLogDebugTrace();
    
    NSOperation* saveOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                               selector:@selector(saveCache)
                                                                 object:nil];
    
    [[MBFilesystemOperationQueue instance] addOperation:saveOp];
    
}

/******************************************************************************/
#pragma mark Accessing cache files
/******************************************************************************/

- (NSString*) _pathForPrebuiltCacheFile
{
    return [[NSBundle mainBundle] pathForResource:_cacheFileName ofType:nil];
}

- (NSString*) _pathForUserCacheFile
{
    NSString* cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, NO) firstObject];
    NSString* expandedDir = [cacheDir stringByExpandingTildeInPath];
    
    NSError* err = nil;
    NSFileManager* mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:expandedDir]) {
        if (![mgr createDirectoryAtPath:expandedDir withIntermediateDirectories:YES attributes:nil error:&err]) {
            MBLogError(@"Couldn't create directory <%@> for writing %@ due to error: %@", expandedDir, [self class], err);
            return nil;
        }
    }
    
    return [expandedDir stringByAppendingPathComponent:_cacheFileName];
}

- (MBSerializedExpressionCache*) _loadCacheFromFile:(NSString*)cacheFile isResource:(BOOL)rsrc
{
    @try {
        return [MBSerializedExpressionCache loadFromFileAtPath:cacheFile];
    }
    @catch (NSException* ex) {
        MBLogError(@"%@ failed to properly deserialize file <%@> (it may be corrupted); error: %@", [self class], cacheFile, ex);
        
        // if we're dealing with a regular file and not a compiled-in resource, delete the file that caused exception
        if (!rsrc) {
            NSError* err = nil;
            if (![[NSFileManager defaultManager] removeItemAtPath:cacheFile error:&err]) {
                MBLogError(@"%@ failed to delete (apparently) corrupted file <%@>: %@", [self class], cacheFile, err);
            }
            else {
                MBLogError(@"%@ deleted (apparently) corrupted file <%@>", [self class], cacheFile);
            }
        }
    }
    
    return nil;
}

/******************************************************************************/
#pragma mark Cache persistence
/******************************************************************************/

- (void) setCacheSerialization:(MBExpressionCacheSerialization)serialization
                  withInterval:(NSTimeInterval)interval
{
    _cacheSerialization = serialization;
    if (serialization != MBExpressionCacheSerializationNone) {
        _cacheSerializationInterval = interval;
    } else {
        _cacheSerializationInterval = 0.0;
    }
}

- (BOOL) _shouldCache
{
    return (!DEBUG_FLAG(DEBUG_BYPASS_CACHE) && !self.disableCaching);
}

- (BOOL) _shouldPersist
{
    return ([self _shouldCache] && !DEBUG_FLAG(DEBUG_DONT_PERSIST) && !self.pausePersistence && self.cacheSerialization != MBExpressionCacheSerializationNone);
}

- (MBSerializedExpressionCache*) _cacheDataFromFilesystem
{
    MBSerializedExpressionCache* cacheData = nil;
    if ([self _shouldPersist]) {
        NSFileManager* fileMgr = [NSFileManager defaultManager];
        
        NSString* cacheFile = [self _pathForUserCacheFile];
        if ([fileMgr isReadableFileAtPath:cacheFile]) {
            cacheData = [self _loadCacheFromFile:cacheFile isResource:NO];
            if (cacheData) {
                if (!self.suppressConsoleLogging) MBLogInfo(@"%@ loaded from file: %@", [self class], cacheFile);
            }
        }
        
        if (!cacheData) {
            cacheFile = [self _pathForPrebuiltCacheFile];
            if ([fileMgr isReadableFileAtPath:cacheFile]) {
                cacheData = [self _loadCacheFromFile:cacheFile isResource:YES];
                if (cacheData) {
                    if (!self.suppressConsoleLogging) MBLogInfo(@"%@ loaded from resource: %@", [self class], cacheFile);
                }
            }
        }
        
        if (!cacheData) {
            if (!self.suppressConsoleLogging) MBLogInfo(@"%@ did not find a cache file named %@", [self class], _cacheFileName);
        }
    }
    return cacheData;
}

- (void) loadCache
{
    MBLogDebugTrace();
    
    MBSerializedExpressionCache* cacheData = [self _cacheDataFromFilesystem];
    if (cacheData) {
        [_cacheLock lock];
        
        if ([self _isCacheDataCompatible:cacheData]) {
            _functionSignatures = cacheData.functionSignatures;
            _grammarToTokenCache = cacheData.grammarToTokenCache;
            [self _setCacheDirty:NO];
        }
        
        [_cacheLock unlock];
    }
}

- (void) loadAndMergeCache
{
    MBLogDebugTrace();
    
    MBSerializedExpressionCache* cacheData = [self _cacheDataFromFilesystem];
    if (cacheData) {
        [_cacheLock lock];
        
        if ([self _isCacheDataCompatible:cacheData]) {
            NSMutableDictionary* newFunctionSignatures = cacheData.functionSignatures;
            if (_functionSignatures.count == 0) {
                _functionSignatures = newFunctionSignatures;
            }
            else {
                [_functionSignatures addEntriesFromDictionary:newFunctionSignatures];
            }
            
            NSMutableDictionary* newGrammarToTokenCache = cacheData.grammarToTokenCache;
            if (_grammarToTokenCache.count == 0) {
                _grammarToTokenCache = newGrammarToTokenCache;
            }
            else {
                for (NSString* grammar in newGrammarToTokenCache) {
                    NSMutableDictionary* tokensFromFile = newGrammarToTokenCache[grammar];
                    NSMutableDictionary* tokensInMemory = _grammarToTokenCache[grammar];
                    
                    if (!tokensInMemory) {
                        _grammarToTokenCache[grammar] = tokensFromFile;
                    }
                    else {
                        for (NSString* expr in tokensFromFile) {
                            if (!tokensInMemory[expr]) {
                                MBLogDebug(@"   Adding expression tokens from file to memory for: %@", expr);
                                tokensInMemory[expr] = tokensFromFile[expr];
                            }
                            else {
                                MBLogDebug(@"Already in memory cache; won't overwrite tokens for: %@", expr);
                            }
                        }
                    }
                }
            }
        }
        else {
            MBLogError(@"Incompatible cache data in file; not merging %@", [self class]);
        }
        
        [_cacheLock unlock];
    }
}

- (BOOL) _saveCache:(MBSerializedExpressionCache*)cacheData toFile:(NSString*)cacheFile suppressLog:(BOOL)suppress
{
    if ([cacheData saveToFileAtPath:cacheFile]) {
        if (!suppress) MBLogInfo(@"%@ written to file: %@", [self class], cacheFile);
        return YES;
    }
    return NO;
}

- (void) saveCache
{
    MBLogDebugTrace();
    
    if ([self _shouldPersist]) {
        MBSerializedExpressionCache* cacheData = [MBSerializedExpressionCache new];
        
        [_cacheLock lock];
        
        cacheData.functionSignatures = [_functionSignatures mutableCopy];
        cacheData.grammarToTokenCache = [_grammarToTokenCache mutableCopy];
        
        [self _setCacheDirty:NO];
        
        [_cacheLock unlock];
        
        [self _saveCache:cacheData toFile:[self _pathForUserCacheFile] suppressLog:self.suppressConsoleLogging];
    }
}

/******************************************************************************/
#pragma mark Clearing the cache
/******************************************************************************/

- (void) removeFilesystemCache
{
    MBLogDebugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSError* err = nil;
    NSString* cacheFile = [self _pathForUserCacheFile];
    
    if ([fileMgr fileExistsAtPath:cacheFile]) {
        [fileMgr removeItemAtPath:cacheFile error:&err];
        if (err) MBLogErrorObject(err);
    }
}

- (nullable NSNumber*) filesystemCacheSize
{
    MBLogDebugTrace();

    NSFileManager* fileMgr = [NSFileManager defaultManager];

    NSError* err = nil;
    NSString* cacheFile = [self _pathForUserCacheFile];
    if ([fileMgr fileExistsAtPath:cacheFile]) {
        NSDictionary* attrs = [fileMgr attributesOfItemAtPath:cacheFile error:&err];
        if (!err) {
            return attrs[NSFileSize];
        }
        MBLogError(@"%@ couldn't get file attributes for: %@", [self class], cacheFile);
    }
    return nil;
}

- (void) resetFilesystemCache
{
    MBLogDebugTrace();
    
    [self removeFilesystemCache];
    
    NSString* cacheFile = [self _pathForUserCacheFile];
    if ([self _saveCache:[MBSerializedExpressionCache new] toFile:cacheFile suppressLog:YES]) {
        if (!self.suppressConsoleLogging) MBLogInfo(@"Reset filesystem cache; empty %@ written to file: %@", [self class], cacheFile);
    }
}

- (void) _clearMemoryCacheHoldingLock
{
    MBLogVerboseTrace();
    
    [_grammarToTokenCache removeAllObjects];
    [self _setCacheDirty:NO];
}

- (void) clearMemoryCache
{
    MBLogDebugTrace();
    
    [_cacheLock lock];
    
    [self _clearMemoryCacheHoldingLock];
    
    [_cacheLock unlock];
}

- (void) resetMemoryCache
{
    MBLogDebugTrace();
    
    [_cacheLock lock];
    
    [_functionSignatures removeAllObjects];
    [self _clearMemoryCacheHoldingLock];
    
    [_cacheLock unlock];
}

- (void) clearCache
{
    MBLogDebugTrace();
    
    [self removeFilesystemCache];
    [self clearMemoryCache];
}

/******************************************************************************/
#pragma mark Retrieving expression tokens
/******************************************************************************/

- (NSArray*) cachedTokensForExpression:(NSString*)expr
                          usingGrammar:(MBExpressionGrammar*)grammar
{
    if (!expr || !grammar) return nil;
    
    if ([self _shouldCache]) {
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
                           error:(inout MBExpressionError**)errPtr
{
    if (!expr || !grammar || !space) return nil;
    
    NSArray* tokens = [self cachedTokensForExpression:expr usingGrammar:grammar];
    if (tokens) {
        return tokens;
    }
    
    // if we don't have tokens, we'll need to tokenize
    tokens = [[MBExpressionTokenizer tokenizerWithGrammar:grammar] tokenize:expr
                                                            inVariableSpace:space
                                                                      error:errPtr];
    
    if ([self _shouldCache]) {
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
