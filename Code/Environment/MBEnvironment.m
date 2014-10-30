//
//  MBEnvironment.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/23/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <RaptureXML@Gilt/RXMLElement.h>
#import <MBToolbox/MBToolbox.h>

#import "MBEnvironment.h"
#import "MBEnvironmentLoader.h"
#import "MBVariableSpace.h"
#import "MBExpression.h"
#import "MBDataEnvironmentModule.h"
#import "MBDataEnvironmentConstants.h"

#define DEBUG_LOCAL         0
#define DEBUG_VERBOSE       0

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

NSString* const kMBMLManifestFilename       = @"manifest.xml";

NSString* const kMBMLRootTagName            = @"MBML";
NSString* const kMBMLIncludeTagName         = @"Include";

/******************************************************************************/
#pragma mark MBEnvironment private
/******************************************************************************/

static dispatch_queue_t s_serializationQueue = nil;
static NSArray* s_libraryClassPrefixes = nil;
static MBEnvironment* s_currentEnvironment = nil;
static NSMutableArray* s_environmentStack = nil;
static NSMutableArray* s_registeredLoaderClasses = nil;

/******************************************************************************/
#pragma mark -
#pragma mark MBEnvironment implementation
/******************************************************************************/

@implementation MBEnvironment
{
    NSMutableArray* _modules;
    NSMutableArray* _loaders;
    NSMutableArray* _loadedFilePaths;
    NSMutableSet* _processedFileNames;
    NSMutableDictionary* _elementNamesToLoaders;
}

/******************************************************************************/
#pragma mark Class initializer
/******************************************************************************/

+ (void) initialize
{
    if (self == [MBEnvironment class]) {
        s_serializationQueue = dispatch_queue_create("MBEnvironment", DISPATCH_QUEUE_SERIAL);

        s_environmentStack = [NSMutableArray new];

        s_registeredLoaderClasses = [NSMutableArray new];

        [self addSupportedLibraryClassPrefix:kMBLibraryClassPrefix];
    }
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (id) init
{
    self = [super init];
    if (self) {
        _modules = [NSMutableArray arrayWithObject:[MBDataEnvironmentModule class]];    // this module is always included
        _loaders = [NSMutableArray new];
        _elementNamesToLoaders = [NSMutableDictionary new];

        for (Class extClass in [[self class] registeredEnvironmentLoaderClasses]) {
            [self addEnvironmentLoaderFromClass:extClass];
        }

        _loadedFilePaths = [NSMutableArray new];
        _processedFileNames = [NSMutableSet new];
    }
    return self;
}

/******************************************************************************/
#pragma mark Thread safety
/******************************************************************************/

+ (void) serialize:(dispatch_block_t)block
{
    debugTrace();

    dispatch_barrier_sync(s_serializationQueue, block);
}

/******************************************************************************/
#pragma mark Working with external libraries
/******************************************************************************/

+ (void) addSupportedLibraryClassPrefix:(NSString*)prefix
{
    debugTrace();

    if (!prefix)
        return;

    [self serialize:^{
        if (!s_libraryClassPrefixes) {
            s_libraryClassPrefixes = @[prefix];
        } else {
            s_libraryClassPrefixes = [s_libraryClassPrefixes arrayByAddingObject:prefix];
        }
    }];
}

+ (NSArray*) supportedLibraryClassPrefixes
{
    return s_libraryClassPrefixes;
}

+ (Class) libraryClassForName:(NSString*)className
{
    Class cls = NSClassFromString(className);
    if (cls)
        return cls;

    NSArray* classPrefixes = [MBEnvironment supportedLibraryClassPrefixes];
    for (NSString* prefix in classPrefixes) {
        NSString* derivedClassName = [prefix stringByAppendingString:className];
        cls = NSClassFromString(derivedClassName);
        if (cls)
            break;
    }

    return cls;
}

/******************************************************************************/
#pragma mark Code modules
/******************************************************************************/

- (NSArray*) enabledModuleClasses
{
    return [_modules copy];
}

/******************************************************************************/
#pragma mark Managing environment loaders
/******************************************************************************/

+ (BOOL) registerEnvironmentLoaderClass:(Class)extClass
{
    if (extClass && ![s_registeredLoaderClasses containsObject:extClass]) {
        if ([extClass isSubclassOfClass:[MBEnvironmentLoader class]]) {
            [s_registeredLoaderClasses addObject:extClass];
            return YES;
        }
    }
    return NO;
}

+ (NSArray*) registeredEnvironmentLoaderClasses
{
    return [s_registeredLoaderClasses copy];
}

- (MBEnvironmentLoader*) addEnvironmentLoaderFromClass:(Class)extClass
{
    if ([extClass isSubclassOfClass:[MBEnvironmentLoader class]]) {
        MBEnvironmentLoader* loader = [extClass new];
        if ([self addEnvironmentLoader:loader]) {
            return loader;
        }
    }
    return nil;
}

- (BOOL) addEnvironmentLoader:(MBEnvironmentLoader*)loader
{
    if (loader && ![_loaders containsObject:loader]) {
        [_loaders addObject:loader];
        [self _registerElementNamesForLoader:loader];
        return YES;
    }
    return NO;
}

- (NSArray*) environmentLoaders
{
    return [_loaders copy];
}

- (MBEnvironmentLoader*) environmentLoaderOfClass:(Class)extClass
{
    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        if ([loader isKindOfClass:extClass]) {
            return loader;
        }
    }
    return nil;
}

- (void) _registerElementNamesForLoader:(MBEnvironmentLoader*)loader
{
    NSArray* elementNames = [loader acceptedTagNames];
    for (NSString* name in elementNames) {
        assert(!_elementNamesToLoaders[name]);  // only one loader per tag, people!
        _elementNamesToLoaders[name] = loader;
    }
}

/******************************************************************************/
#pragma mark Loading the Mockingbird environment
/******************************************************************************/

+ (BOOL) isLoaded
{
    MBEnvironment* env = [MBEnvironment instance];
    return (env && env.isLoaded);
}

+ (MBEnvironment*) loadFromResources
{
    return [self loadFromManifestFile:kMBMLManifestFilename
                        baseDirectory:[[NSBundle bundleForClass:[self class]] resourcePath]];
}

+ (MBEnvironment*) loadFromDirectory:(NSString*)dirPath
{
    return [self loadFromManifestFile:kMBMLManifestFilename
                        baseDirectory:dirPath];
}

+ (MBEnvironment*) loadFromManifestFile:(NSString*)fileName
{
    return [self loadFromManifestFile:fileName
                        baseDirectory:[[NSBundle bundleForClass:[self class]] resourcePath]];
}

+ (MBEnvironment*) loadFromManifestFile:(NSString*)fileName
                          baseDirectory:(NSString*)dirPath
{
    debugTrace();

    MBEnvironment* env = [MBEnvironment new];

    MBEnvironment* prevEnv = [MBEnvironment setEnvironment:env];

    BOOL initialLoadFailed = NO;
    @try {
        if ([env loadFromManifestFile:fileName baseDirectory:dirPath]) {
            [MBEvents postEvent:kMBMLEnvironmentDidLoadNotification fromSender:self];
        }
        else {
            initialLoadFailed = (prevEnv == nil);
            if (!initialLoadFailed) {
                // if we had a previous environment, reset it and log an error.
                // however, if this was an attempt to load our initial environment,
                // there's nothing we can do; the app can't load, we'll throw an
                // exception later
                errorLog(@"Failed to load %@ environment; reverting to previous state", self);
            }
            [MBEnvironment setEnvironment:prevEnv];
        }
    }
    @catch (NSException* ex) {
        errorLog(@"Exception while attempting to load %@ environment: %@", self, ex);
    }

    if (initialLoadFailed) {
        [NSException raise:@"Failed to load initial app environment" format:@"The initial %@ application environment could not be loaded. Please check the console log for more information about the source of the problem.", self];
    }

    return [MBEnvironment instance];
}

+ (MBEnvironment*) reload
{
    debugTrace();

    MBEnvironment* env = [MBEnvironment instance];
    if (env) {
        return [self loadFromManifestFile:[env.manifestFilePath lastPathComponent]
                            baseDirectory:env.baseDirectory];
    }
    else {
        errorLog(@"%@ has no active %@ to reload", self, [MBEnvironment class]);
    }
    return [MBEnvironment instance];
}

/******************************************************************************/
#pragma mark Determining which MBML files have been loaded
/******************************************************************************/

- (NSArray*) mbmlPathsLoaded
{
    return [_loadedFilePaths copy];
}

- (BOOL) mbmlFileIsLoaded:(NSString*)fileName
{
    verboseDebugTrace();

    NSArray* paths = self.mbmlPathsLoaded;
    for (NSString* path in paths) {
        NSString* pathFile = [path lastPathComponent];
        if ([pathFile isEqualToString:fileName]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) mbmlPathIsLoaded:(NSString*)filePath
{
    verboseDebugTrace();
    
    NSString* filePathStandard = [filePath stringByStandardizingPath];
    NSArray* paths = self.mbmlPathsLoaded;
    for (NSString* path in paths) {
        NSString* standardPath = [path stringByStandardizingPath];
        if ([standardPath isEqualToString:filePathStandard]) {
            return YES;
        }
    }
    return NO;
}

/******************************************************************************/
#pragma mark Managing the current environment
/******************************************************************************/

+ (instancetype) instance
{
    return s_currentEnvironment;
}

+ (MBEnvironment*) setEnvironment:(MBEnvironment*)env
{
    debugTrace();
    
    MBEnvironment* deactivating = s_currentEnvironment;

    [deactivating environmentWillDeactivate];
    [env environmentWillActivate];
    
    s_currentEnvironment = env;
    
    [deactivating environmentDidDeactivate];
    [env environmentDidActivate];
        
    return deactivating;
}

+ (void) pushEnvironment:(MBEnvironment*)env
{
    debugTrace();
    
    MBEnvironment* previous = [self setEnvironment:env];
    [s_environmentStack addObject:previous];
}

+ (instancetype) popEnvironment
{
    debugTrace();
    
    if (s_environmentStack.count > 0) {
        MBEnvironment* popped = [s_environmentStack lastObject];
        [self setEnvironment:popped];
        [s_environmentStack removeLastObject];
        return popped;
    }
    else {
        [NSException raise:NSInternalInconsistencyException format:@"Attempt to pop an %@ when there aren't any on the stack right now", [MBEnvironment class]];
    }
    return nil;
}

+ (instancetype) peekEnvironment
{
    debugTrace();
    
    if (s_environmentStack.count > 0) {
        return [s_environmentStack lastObject];
    }
    return nil;
}

/******************************************************************************/
#pragma mark Environment loading
/******************************************************************************/

- (void) amendDataModelWithXML:(RXMLElement*)xml
{
    debugTrace();
    
    [xml iterate:@"*" usingBlock:^(RXMLElement* el) {
        @autoreleasepool {
            NSString* tag = el.tag;
            if (![tag isEqualToString:kMBMLIncludeTagName]) {
                BOOL parsed = NO;
                MBEnvironmentLoader* loader = _elementNamesToLoaders[tag];
                if (!loader) {
                    tag = kMBWildcardString;
                    loader = _elementNamesToLoaders[tag];
                }
                if (loader) {
                    parsed = [loader parseElement:el forMatch:tag];
                }
                if (parsed) {
                    verboseDebugLog(@"%@ successfully parsed: %@", [loader class], el.xml);
                }
                else {
                    errorLog(@"The following XML construct is not valid MBML: %@", el.xml);
                }
            }
        }
    }];
}

/******************************************************************************/
#pragma mark MBML loading
/******************************************************************************/

- (void) didAmendDataModelWithXMLFromFile:(NSString*)filePath
{
    debugTrace();

    NSString* fileName = [filePath lastPathComponent];
    if (![_loadedFilePaths containsObject:filePath]) {
        [_loadedFilePaths addObject:filePath];
        [_processedFileNames addObject:fileName];
    }

    // fire a generic event that a file has been loaded, and then a specific one
    NSDictionary* eventParams = @{@"filePath": filePath, @"fileName": fileName};
    [MBEvents postEvent:@"MBML:fileDidLoad" withUserInfo:eventParams];
    [MBEvents postEvent:[NSString stringWithFormat:@"MBML:%@:fileDidLoad", fileName] withUserInfo:eventParams];
}

- (RXMLElement*) mbmlFromFile:(NSString*)filePath
{
    debugLog(@"Attempting to load MBML from file: %@", filePath);
    
    NSError* err = nil;
    NSData* data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingUncached error:&err];
    if (data && !err) {
        RXMLElement* root = [RXMLElement elementFromXMLData:data];
        if (root && root.isValid) {
            NSString* rootTag = root.tag;
            if ([rootTag caseInsensitiveCompare:kMBMLRootTagName] == NSOrderedSame) {
                return root;
            }
            else {
                errorLog(@"Expecting XML root element name to be <%@>; instead got %@ in file: %@", kMBMLRootTagName, rootTag, filePath);
            }
        }
        else {
            errorLog(@"Failed to parse file as valid XML: %@", filePath);
        }
    }
    else {
        errorLog(@"Couldn't read file <%@> due to error: %@", filePath, err);
    }
    return nil;
}

- (NSString*) pathOfEnvironmentFile:(NSString*)fileName baseDirectory:(NSString*)dir
{
    NSString* path = [dir stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return path;
    }

    for (NSBundle* bundle in [NSBundle allBundles]) {
        NSString* path = [bundle pathForResource:fileName ofType:nil];
        if (path) {
            return path;
        }
    }
    return nil;
}

- (BOOL) _loadFromFile:(NSString*)filePath baseDirectory:(NSString*)dir includeDepth:(NSUInteger)depth
{
    if (depth == 0) {
        [self environmentWillLoad];
    }
    
    RXMLElement* xml = [self mbmlFromFile:filePath];
    if (!xml) {
        if (depth == 0) {
            [self environmentLoadFailed];
        }
        return NO;
    }
    
    if (depth == 0) {
        // keep track of the original manifest file
        [_loadedFilePaths addObject:filePath];
        [_processedFileNames addObject:[filePath lastPathComponent]];
    }
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSArray* attrNames = [xml attributeNames];
    for (NSString* attrName in attrNames) {
        NSString* val = [xml attribute:attrName];
        if ([attrName isEqualToString:kMBMLAttributeModules]) {
            if (depth == 0) {
                // the extensions attribute can be a comma-separated list
                NSArray* modules = [val componentsSeparatedByString:@","];
                for (__strong NSString* moduleClassName in modules) {
                    moduleClassName = MBTrimString(moduleClassName);
                    if (moduleClassName && moduleClassName.length > 0) {
                        Class moduleClass = NSClassFromString(moduleClassName);
                        if (moduleClass) {
                            if ([moduleClass conformsToProtocol:@protocol(MBModule)]) {
                                if (![_modules containsObject:moduleClass]) {
                                    [_modules addObject:moduleClass];
                                }
                            }
                            else {
                                errorLog(@"Invalid module class \"%@\"; must conform to the protocol %@", moduleClassName, NSStringFromProtocol(@protocol(MBModule)));
                            }
                        }
                        else {
                            errorLog(@"Couldn't load module class \"%@\"; no implementation found", moduleClassName);
                        }
                    }
                }
            }
            else {
                errorLog(@"Modules can only be specified in the top level environment file; the value for this \"%@\" attribute will be ignored: %@", kMBMLAttributeModules, val);
            }
        }
        else {
            // other attributes on the MBML tag will get stored as MBEnvironment attributes
            [self setAttribute:val forName:attrName];
        }
    }
    
    // figure out what include files we need to load
    NSMutableArray* includes = [NSMutableArray new];
    NSMutableDictionary* includeConditionals = [NSMutableDictionary new];
    
    if (depth == 0) {
        for (Class moduleClass in _modules) {
            // process each enable code modules
            if ([moduleClass respondsToSelector:@selector(environmentLoaderClasses)]) {
                NSArray* loaderClasses = [moduleClass environmentLoaderClasses];
                for (Class loaderClass in loaderClasses) {
                    if ([loaderClass isSubclassOfClass:[MBEnvironmentLoader class]]) {
                        if ([MBEnvironment registerEnvironmentLoaderClass:loaderClass]) {
                            MBEnvironmentLoader* loader = [self addEnvironmentLoaderFromClass:loaderClass];
                            if ([MBEnvironment instance] == self) {
                                // if we're the active environment, activate the new loader, too
                                [loader environmentWillActivate:self];
                                [loader environmentDidActivate:self];
                            }
                            // notify the loader that we're loading
                            [loader environmentWillLoad:self];
                        }
                    }
                    else {
                        errorLog(@"Invalid loader class \"%@\"; must be a subclass of %@", loaderClass, [MBEnvironmentLoader class]);
                    }
                }
            }
            
            // each code module may have its own environment file
            if ([moduleClass respondsToSelector:@selector(moduleEnvironmentFilename)]) {
                NSString* includeFile = [moduleClass moduleEnvironmentFilename];
                if (includeFile) {
                    [includes addObject:includeFile];
                    includeConditionals[includeFile] = @[kMBMLBooleanStringTrue];
                }
            }
        }
    }
    
    // process <Include file="..."/> tags
    for (RXMLElement* el in [xml children:kMBMLIncludeTagName]) {
        NSString* includeFile = [el attribute:kMBMLAttributeFile];
        if (includeFile) {
            NSString* shouldIncludeExpr = [el attribute:kMBMLAttributeIf];
            if (!shouldIncludeExpr) {
                shouldIncludeExpr = kMBMLBooleanStringTrue;
            }
            NSArray* conditionals = includeConditionals[includeFile];
            if (conditionals) {
                conditionals = [conditionals arrayByAddingObject:shouldIncludeExpr];
            } else {
                conditionals = @[shouldIncludeExpr];
            }
            includeConditionals[includeFile] = conditionals;
            if (![includes containsObject:includeFile]) {
                [includes addObject:includeFile];
            }
        }
        else {
            errorLog(@"Invalid <%@> tag: the \"%@\" attribute is required in: %@", kMBMLIncludeTagName, kMBMLAttributeFile, el.xml);
        }
    }
    
    // process each include
    for (NSString* includeFile in includes) {
        if ([_processedFileNames containsObject:includeFile]) {
            debugLog(@"Skipping <%@> of file \"%@\"; was previously included", kMBMLIncludeTagName, includeFile);
        }
        else {
            NSArray* conditionals = includeConditionals[includeFile];
            BOOL include = NO;
            for (NSString* conditional in conditionals) {
                if ([conditional evaluateAsBoolean]) {
                    debugLog(@"Will <%@> file \"%@\"", kMBMLIncludeTagName, includeFile);
                    include = YES;
                    break;
                }
            }
            if (!include) {
                debugLog(@"Skipping <%@> of file \"%@\"; failed %lu if tests: \"%@\"", kMBMLIncludeTagName, includeFile, (unsigned long)conditionals.count, [conditionals componentsJoinedByString:@"\", \""]);
            }
            else {
                NSString* includeFilePath = [dir stringByAppendingPathComponent:includeFile];
                BOOL hasFile = [fileMgr fileExistsAtPath:includeFilePath];
                
                // first, see if the file exists in the same parent directory
                if (!hasFile || ![self _loadFromFile:includeFilePath
                                       baseDirectory:dir
                                        includeDepth:(depth + 1)])
                {
                    // include file wasn't found there; check the resources
                    includeFilePath = [self pathOfEnvironmentFile:includeFile baseDirectory:dir];
                    if (includeFilePath) {
                        // looks like we've got a resource for the include file; try to load it
                        if (![self _loadFromFile:includeFilePath
                                   baseDirectory:dir
                                    includeDepth:(depth + 1)])
                        {
                            // couldn't load resource; report failure
                            errorLog(@"Failed to process MBML include file: \"%@\"", includeFile);
                        }
                        else {
                            // keep track of the file we just successfully loaded
                            [self didAmendDataModelWithXMLFromFile:includeFilePath];
                        }
                    }
                    else {
                        // didn't find a resource either
                        errorLog(@"Couldn't find MBML file \"%@\" in application resources or in directory: %@", includeFile, dir);
                    }
                }
                else {
                    // keep track of the file we just successfully loaded
                    [self didAmendDataModelWithXMLFromFile:includeFilePath];
                }
            }
        }
    }
    
    [self amendDataModelWithXML:xml];
    
    if (depth == 0) {
        [self environmentDidLoad];
    }
    
    return YES;
}

- (BOOL) loadFromManifestFile:(NSString*)manifestFileName
                baseDirectory:(NSString*)dir
{
    debugTrace();
    
    _manifestFilePath = [dir stringByAppendingPathComponent:manifestFileName];
    _baseDirectory = dir;
    [_loadedFilePaths removeAllObjects];
    [_processedFileNames removeAllObjects];
    
    _isLoaded = [self _loadFromFile:_manifestFilePath baseDirectory:_baseDirectory includeDepth:0];
    
    return _isLoaded;
}

- (BOOL) loadTemplateFile:(NSString*)fileName
            baseDirectory:(NSString*)dir
{
    debugTrace();
    
    NSString* templateFilePath = [dir stringByAppendingPathComponent:fileName];
    if ([self _loadFromFile:templateFilePath baseDirectory:dir includeDepth:1]) {
        [self didAmendDataModelWithXMLFromFile:templateFilePath];
        return YES;
    }
    return NO;
}

- (BOOL) loadTemplateFile:(NSString*)fileName
{
    debugTrace();
    
    return [self loadTemplateFile:fileName baseDirectory:_baseDirectory];
}

/******************************************************************************/
#pragma mark Environment state change hooks
/******************************************************************************/

- (void) environmentWillLoad
{
    debugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentWillLoad:self];
    }
}

- (void) environmentDidLoad
{
    debugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentDidLoad:self];
    }
}

- (void) environmentLoadFailed
{
    debugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentLoadFailed:self];
    }
}

- (void) environmentWillActivate
{
    debugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentWillActivate:self];
    }
}

- (void) environmentDidActivate
{
    debugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentDidActivate:self];
    }
}

- (void) environmentWillDeactivate
{
    debugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentWillDeactivate:self];
    }
}

- (void) environmentDidDeactivate
{
    debugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentDidDeactivate:self];
    }
}

@end
