//
//  MBEnvironment.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/23/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <RaptureXML/RaptureXML.h>
#import <MBToolbox/MBToolbox.h>

#import "MBEnvironment.h"
#import "MBEnvironmentLoader.h"
#import "MBVariableSpace.h"
#import "MBExpression.h"
#import "MBExpressionExtensions.h"
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

static MBConcurrentReadWriteCoordinator* s_readerWriter = nil;
static MBEnvironment* s_currentEnvironment = nil;
static NSMutableArray* s_environmentStack = nil;
static NSMutableArray* s_libraryClassPrefixes = nil;
static NSMutableArray* s_enabledModuleClasses = nil;
static NSMutableArray* s_resourceBundles = nil;

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
    NSMutableArray* _resourceBundles;
    NSArray* _additionalSearchDirectories;
}

/******************************************************************************/
#pragma mark Class initializer
/******************************************************************************/

+ (void) initialize
{
    if (self == [MBEnvironment class]) {
        s_readerWriter = [MBConcurrentReadWriteCoordinator new];

        s_environmentStack = [NSMutableArray new];
        s_libraryClassPrefixes = [NSMutableArray new];
        s_enabledModuleClasses = [NSMutableArray new];
        s_resourceBundles = [NSMutableArray new];

        NSBundle* myBundle = [NSBundle bundleForClass:self];
        if (myBundle) {
            [s_resourceBundles addObject:myBundle];
        }

        NSBundle* mainBundle = [NSBundle mainBundle];
        if (mainBundle && ![mainBundle isEqual:myBundle]) {
            [s_resourceBundles addObject:mainBundle];
        }

        [self addSupportedLibraryClassPrefix:kMBLibraryClassPrefix];

        [self enableModuleClass:[MBDataEnvironmentModule class]];
    }
}

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (instancetype) init
{
    self = [super init];
    if (self) {
        _modules = [NSMutableArray new];
        _loaders = [NSMutableArray new];
        _elementNamesToLoaders = [NSMutableDictionary new];
        _resourceBundles = [NSMutableArray arrayWithArray:[[self class] resourceSearchBundles]];

        _loadedFilePaths = [NSMutableArray new];
        _processedFileNames = [NSMutableSet new];

        for (Class cls in [[self class] enabledModuleClasses]) {
            [self _addModule:cls];
        }
    }
    return self;
}

/******************************************************************************/
#pragma mark Working with external libraries
/******************************************************************************/

+ (void) addSupportedLibraryClassPrefix:(nonnull NSString*)prefix
{
    MBLogDebugTrace();

    if (!prefix)
        return;

    [s_readerWriter enqueueWrite:^{
        [s_libraryClassPrefixes addObject:prefix];
    }];
}

+ (nonnull NSArray*) supportedLibraryClassPrefixes
{
    __block NSArray* array = nil;
    [s_readerWriter read:^{
        array = [s_libraryClassPrefixes copy];
    }];
    return array;
}

+ (nullable Class) libraryClassForName:(nonnull NSString*)className
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

+ (BOOL) enableModuleClass:(nonnull Class)cls
{
    if (!cls || ![cls conformsToProtocol:@protocol(MBModule)]) {
        return NO;
    }

    [s_readerWriter enqueueWrite:^{
        if (![s_enabledModuleClasses containsObject:cls]) {
            [s_enabledModuleClasses addObject:cls];
        }
    }];

    return YES;
}

+ (nonnull NSArray*) enabledModuleClasses
{
    __block NSArray* array = nil;
    [s_readerWriter read:^{
        array = [s_enabledModuleClasses copy];
    }];
    return array;
}

- (nonnull NSArray*) enabledModuleClasses
{
    return [_modules copy];
}

- (void) _addModule:(Class)moduleClass
{
    if ([moduleClass conformsToProtocol:@protocol(MBModule)]) {
        if (![_modules containsObject:moduleClass]) {
            [_modules addObject:moduleClass];

            if ([moduleClass respondsToSelector:@selector(environmentLoaderClasses)]) {
                NSArray* loaderClasses = [moduleClass environmentLoaderClasses];
                for (Class loaderClass in loaderClasses) {
                    if (![self addEnvironmentLoaderFromClass:loaderClass]) {
                        MBLogError(@"Invalid loader class \"%@\"; must be a subclass of %@", loaderClass, [MBEnvironmentLoader class]);
                    }
                }
            }

            if ([moduleClass respondsToSelector:@selector(resourceBundle)]) {
                NSBundle* bundle = [moduleClass resourceBundle];
                if (bundle) {
                    [_resourceBundles addObject:bundle];
                }
            }
        }
    }
    else {
        MBLogError(@"Invalid module class \"%@\"; must conform to the protocol %@", moduleClass, NSStringFromProtocol(@protocol(MBModule)));
    }
}

/******************************************************************************/
#pragma mark Managing environment loaders
/******************************************************************************/

- (BOOL) addEnvironmentLoaderFromClass:(Class)cls
{
    if ([cls isSubclassOfClass:[MBEnvironmentLoader class]]) {
        MBEnvironmentLoader* loader = [cls new];
        if ([self addEnvironmentLoader:loader]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) addEnvironmentLoader:(MBEnvironmentLoader*)loader
{
    if (loader) {
        if (![_loaders containsObject:loader]) {
            [_loaders addObject:loader];
            [self _registerElementNamesForLoader:loader];
        }
        return YES;
    }
    return NO;
}

- (nonnull NSArray*) environmentLoaders
{
    return [_loaders copy];
}

- (nullable MBEnvironmentLoader*) environmentLoaderOfClass:(nonnull Class)cls
{
    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        if ([loader isKindOfClass:cls]) {
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
#pragma mark Finding resources
/******************************************************************************/

+ (void) addResourceSearchBundle:(nonnull NSBundle*)bundle
{
    if (bundle) {
        [s_readerWriter enqueueWrite:^{
            if (![s_resourceBundles containsObject:bundle]) {
                [s_resourceBundles addObject:bundle];
            }
        }];
    }
}

+ (nonnull NSArray*) resourceSearchBundles
{
    __block NSArray* array = nil;
    [s_readerWriter read:^{
        array = [s_resourceBundles copy];
    }];
    return array;
}

- (NSString*) _findPathOfFileNamed:(NSString*)rsrcName
{
    if (_additionalSearchDirectories.count > 0) {
        NSFileManager* fileMgr = [NSFileManager defaultManager];
        for (NSString* dir in _additionalSearchDirectories) {
            NSString* filePath = [dir stringByAppendingPathComponent:rsrcName];
            if ([fileMgr fileExistsAtPath:filePath]) {
                return filePath;
            }
        }
    }

    for (NSBundle* bundle in _resourceBundles) {
        NSString* filePath = [bundle pathForResource:rsrcName ofType:nil];
        if (filePath) {
            return filePath;
        }
    }
    return nil;
}

/******************************************************************************/
#pragma mark Loading the Mockingbird environment
/******************************************************************************/

+ (BOOL) isLoaded
{
    MBEnvironment* env = [MBEnvironment instance];
    return (env && env.isLoaded);
}

- (BOOL) _loadFileAtPath:(NSString*)filePath includeDepth:(NSUInteger)depth
{
    if (!filePath && depth != 0) {
        // file path can only be omitted at depth = 0, where it represents
        // loading the default environment (i.e., one where no manifest is
        // processed)
        return NO;
    }

    RXMLElement* xml = nil;
    if (filePath) {
        xml = [self mbmlFromFile:filePath];
        if (!xml) {
            return NO;
        }

        if (depth == 0) {
            // keep track of the original manifest file
            [_loadedFilePaths addObject:filePath];
            [_processedFileNames addObject:[filePath lastPathComponent]];
        }

        NSArray* attrNames = [xml attributeNames];
        for (NSString* attrName in attrNames) {
            NSString* val = [xml attribute:attrName];
            if ([attrName isEqualToString:kMBMLAttributeModules]) {
                if (depth == 0) {
                    // the modules attribute can be a comma-separated list
                    NSArray* modules = [val componentsSeparatedByString:@","];
                    for (__strong NSString* moduleClassName in modules) {
                        moduleClassName = MBTrimString(moduleClassName);
                        if (moduleClassName && moduleClassName.length > 0) {
                            Class moduleClass = NSClassFromString(moduleClassName);
                            if (moduleClass) {
                                [self _addModule:moduleClass];
                            }
                            else {
                                MBLogError(@"Couldn't load module class \"%@\"; no implementation found", moduleClassName);
                            }
                        }
                    }
                }
                else {
                    MBLogError(@"Modules can only be specified in the top level environment file; the value for this \"%@\" attribute will be ignored: %@", kMBMLAttributeModules, val);
                }
            }
            else {
                // other attributes on the MBML tag will get stored as MBEnvironment attributes
                [self setAttribute:val forName:attrName];
            }
        }
    }

    if (depth == 0) {
        [MBEnvironment setEnvironment:self];
        [self environmentWillLoad];
    }

    // figure out what include files we need to load
    NSMutableArray* includes = [NSMutableArray new];
    NSMutableDictionary* includeConditionals = [NSMutableDictionary new];

    if (depth == 0) {
        for (Class moduleClass in _modules) {
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

    // xml won't exist at depth=0 when loading without a manifest
    if (xml) {
        // process <Include file="..."/> tags in any XML
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
                MBLogError(@"Invalid <%@> tag: the \"%@\" attribute is required in: %@", kMBMLIncludeTagName, kMBMLAttributeFile, el.xml);
            }
        }
    }

    // process each include
    for (NSString* includeFile in includes) {
        if ([_processedFileNames containsObject:includeFile]) {
            MBLogDebug(@"Skipping <%@> of file \"%@\"; was previously included", kMBMLIncludeTagName, includeFile);
        }
        else {
            NSArray* conditionals = includeConditionals[includeFile];
            BOOL include = NO;
            for (NSString* conditional in conditionals) {
                if ([conditional evaluateAsBoolean]) {
                    MBLogDebug(@"Will <%@> file \"%@\"", kMBMLIncludeTagName, includeFile);
                    include = YES;
                    break;
                }
            }
            if (!include) {
                MBLogDebug(@"Skipping <%@> of file \"%@\"; failed %lu if tests: \"%@\"", kMBMLIncludeTagName, includeFile, (unsigned long)conditionals.count, [conditionals componentsJoinedByString:@"\", \""]);
            }
            else {
                NSString* includeFilePath = [self _findPathOfFileNamed:includeFile];
                if (includeFilePath) {
                    if ([self _loadFileAtPath:includeFilePath includeDepth:(depth + 1)]) {
                        // keep track of the file we just successfully loaded
                        [self didAmendDataModelWithXMLFromFile:includeFilePath];
                    }
                    else {
                        // couldn't load resource; report failure
                        MBLogError(@"Failed to process MBML include file: \"%@\"", includeFilePath);
                    }
                }
                else {
                    // didn't find path for file
                    MBLogError(@"Couldn't find path of MBML file named \"%@\" in known resource bundles and search directories", includeFile);
                }
            }
        }
    }

    // xml won't exist at depth=0 when loading without a manifest
    if (xml) {
        [self amendDataModelWithXML:xml];
    }

    if (depth == 0) {
        [self environmentDidLoad];
    }

    return YES;
}

- (BOOL) _loadWithManifest:(NSString*)manifestName additionalSearchDirectories:(NSArray*)dirs
{
    MBLogDebugTrace();

    if (_isLoaded) {
        MBLogError(@"Can't load an already-loaded %@", [self class]);
        return NO;
    }

    [_loadedFilePaths removeAllObjects];
    [_processedFileNames removeAllObjects];

    _manifestFilePath = nil;
    _additionalSearchDirectories = dirs;

    if (manifestName) {
        NSString* manifestPath = [self _findPathOfFileNamed:manifestName];
        if (!manifestPath) {
            MBLogError(@"Couldn't find path for manifest file named: %@", manifestName);
            return NO;
        }
        _manifestFilePath = manifestPath;
    }

    _isLoaded = [self _loadFileAtPath:_manifestFilePath includeDepth:0];

    return _isLoaded;
}

+ (instancetype) loadDefaultEnvironment
{
    return [self loadFromManifestFile:nil
                withSearchDirectories:nil];
}

+ (nullable instancetype) loadFromManifest
{
    return [self loadFromManifestFile:kMBMLManifestFilename
                withSearchDirectories:nil];
}

+ (nullable instancetype) loadFromManifestWithSearchDirectory:(nonnull NSString*)dirPath
{
    return [self loadFromManifestFile:kMBMLManifestFilename
                withSearchDirectories:dirPath ? @[dirPath] : nil];
}

+ (nullable instancetype) loadFromManifestFile:(nonnull NSString*)manifestName
{
    return [self loadFromManifestFile:manifestName withSearchDirectory:nil];
}

+ (nonnull instancetype) loadFromManifestFile:(nonnull NSString*)manifestName
                          withSearchDirectory:(nullable NSString*)dirPath
{
    return [self loadFromManifestFile:manifestName
                withSearchDirectories:dirPath ? @[dirPath] : nil];
}

+ (nullable instancetype) loadFromManifestWithSearchDirectories:(nullable NSArray*)dirPaths
{
    return [self loadFromManifestFile:kMBMLManifestFilename
                withSearchDirectories:dirPaths];
}

+ (nullable instancetype) loadFromManifestFile:(nullable NSString*)manifestName
                         withSearchDirectories:(nullable NSArray*)dirPaths
{
    MBLogDebugTrace();

    MBEnvironment* env = [MBEnvironment new];

    MBEnvironment* revert = [MBEnvironment instance];
    @try {
        if ([env _loadWithManifest:manifestName additionalSearchDirectories:dirPaths]) {
            [MBEvents postEvent:kMBMLEnvironmentDidLoadNotification withObject:env];
            return env;
        }
    }
    @catch (NSException* ex) {
        MBLogError(@"Exception while attempting to load %@ environment: %@", self, ex);
    }

    [env environmentLoadFailed];

    // if we had a previous environment, reset it and log an error.
    // however, if this was an attempt to load our initial environment,
    // there's nothing we can do; the app can't load, we'll throw an
    // exception later
    if (revert) {
        MBLogError(@"Failed to load %@ environment; existing state will remain the same", self);
        [MBEnvironment setEnvironment:revert];
    }
    else {
        [NSException raise:@"Failed to load initial app environment" format:@"The initial %@ could not be loaded. Please check the console log for more information about the source of the problem.", self];
    }

    return nil;
}

/******************************************************************************/
#pragma mark Determining which MBML files have been loaded
/******************************************************************************/

- (nonnull NSArray*) mbmlPathsLoaded
{
    return [_loadedFilePaths copy];
}

- (BOOL) mbmlFileIsLoaded:(nonnull NSString*)fileName
{
    MBLogVerboseTrace();

    NSArray* paths = self.mbmlPathsLoaded;
    for (NSString* path in paths) {
        NSString* pathFile = [path lastPathComponent];
        if ([pathFile isEqualToString:fileName]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) mbmlPathIsLoaded:(nonnull NSString*)filePath
{
    MBLogVerboseTrace();
    
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

+ (nullable instancetype) instance
{
    __block MBEnvironment* env = nil;
    [s_readerWriter read:^{
        env = s_currentEnvironment;
    }];
    return env;
}

+ (nullable instancetype) setEnvironment:(nullable MBEnvironment*)env
{
    MBLogDebugTrace();
    
    MBEnvironment* deactivating = [self instance];
    if (deactivating != env) {
        [s_readerWriter enqueueWrite:^{
            [deactivating environmentWillDeactivate];
            [env environmentWillActivate];

            s_currentEnvironment = env;

            [deactivating environmentDidDeactivate];
            [env environmentDidActivate];
        }];
    }
    return deactivating;
}

+ (void) pushEnvironment:(nonnull MBEnvironment*)env
{
    MBLogDebugTrace();

    MBEnvironment* previous = [self setEnvironment:env];

    [s_readerWriter enqueueWrite:^{
        [s_environmentStack addObject:previous];
    }];
}

+ (nonnull instancetype) popEnvironment
{
    MBLogDebugTrace();

    MBEnvironment* popped = [self peekEnvironment];
    if (popped) {
        [s_readerWriter enqueueWrite:^{
            [s_environmentStack removeLastObject];
        }];

        [self setEnvironment:popped];
    }
    else {
        [NSException raise:NSInternalInconsistencyException format:@"Attempt to pop an %@ when there aren't any on the stack right now", [MBEnvironment class]];
    }
    return popped;
}

+ (nullable instancetype) peekEnvironment
{
    MBLogDebugTrace();

    __block MBEnvironment* peek = nil;

    [s_readerWriter read:^{
        peek = [s_environmentStack lastObject];
    }];

    return peek;
}

/******************************************************************************/
#pragma mark Environment loading
/******************************************************************************/

- (void) amendDataModelWithXML:(RXMLElement*)xml
{
    MBLogDebugTrace();
    
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
                    MBLogVerbose(@"%@ successfully parsed: %@", [loader class], el.xml);
                }
                else {
                    MBLogError(@"The following XML construct is not valid MBML: %@", el.xml);
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
    MBLogDebugTrace();

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
    MBLogDebug(@"Attempting to load MBML from file: %@", filePath);
    
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
                MBLogError(@"Expecting XML root element name to be <%@>; instead got %@ in file: %@", kMBMLRootTagName, rootTag, filePath);
            }
        }
        else {
            MBLogError(@"Failed to parse file as valid XML: %@", filePath);
        }
    }
    else {
        MBLogError(@"Couldn't read file <%@> due to error: %@", filePath, err);
    }
    return nil;
}

- (BOOL) loadMBMLFile:(nonnull NSString*)fileName
{
    MBLogDebugTrace();

    NSString* filePath = [self _findPathOfFileNamed:fileName];
    if (filePath) {
        if ([self _loadFileAtPath:filePath includeDepth:1]) {
            [self didAmendDataModelWithXMLFromFile:filePath];
            return YES;
        }
    }
    return NO;
}

/******************************************************************************/
#pragma mark Environment state change hooks
/******************************************************************************/

- (void) environmentWillLoad
{
    MBLogDebugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentWillLoad:self];
    }
}

- (void) environmentDidLoad
{
    MBLogDebugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentDidLoad:self];
    }
}

- (void) environmentLoadFailed
{
    MBLogDebugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentLoadFailed:self];
    }
}

- (void) environmentWillActivate
{
    MBLogDebugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentWillActivate:self];
    }
}

- (void) environmentDidActivate
{
    MBLogDebugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentDidActivate:self];
    }
}

- (void) environmentWillDeactivate
{
    MBLogDebugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentWillDeactivate:self];
    }
}

- (void) environmentDidDeactivate
{
    MBLogDebugTrace();

    for (MBEnvironmentLoader* loader in self.environmentLoaders) {
        [loader environmentDidDeactivate:self];
    }
}

@end
