//
//  MBMLFileFunctionTests.m
//  Mockingbird Data Environment Unit Tests
//
//  Created by Evan Maloney on 1/24/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#import "MockingbirdTestSuite.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFileFunctionTests class
/******************************************************************************/

@interface MBMLFileFunctionTests : MockingbirdTestSuite
@end

@implementation MBMLFileFunctionTests

/*
    <Function class="MBMLFileFunctions" name="lastPathComponent" input="string"/>
    <Function class="MBMLFileFunctions" name="stripLastPathComponent" input="string"/>
    <Function class="MBMLFileFunctions" name="pathExtension" input="string"/>
    <Function class="MBMLFileFunctions" name="stripPathExtension" input="string"/>
    <Function class="MBMLFileFunctions" name="pathComponents" input="string"/>
    <Function class="MBMLFileFunctions" name="directoryForCaches" input="none"/>
    <Function class="MBMLFileFunctions" name="directoryForDocuments" input="none"/>
    <Function class="MBMLFileFunctions" name="directoryForDownloads" input="none"/>
    <Function class="MBMLFileFunctions" name="directoryForApplicationSupport" input="none"/>
    <Function class="MBMLFileFunctions" name="directoryForHome" input="none"/>
    <Function class="MBMLFileFunctions" name="directoryForTempFiles" input="none"/>
    <Function class="MBMLFileFunctions" name="directoryForMovies" input="none"/>
    <Function class="MBMLFileFunctions" name="directoryForMusic" input="none"/>
    <Function class="MBMLFileFunctions" name="directoryForPictures" input="none"/>
    <Function class="MBMLFileFunctions" name="directoryForPublicFiles" input="none"/>
    <Function class="MBMLFileFunctions" name="listDirectory" input="string"/>
    <Function class="MBMLFileFunctions" name="fileExists" input="string"/>
    <Function class="MBMLFileFunctions" name="fileIsReadable" input="string"/>
    <Function class="MBMLFileFunctions" name="fileIsWritable" input="string"/>
    <Function class="MBMLFileFunctions" name="fileIsDeletable" input="string"/>
    <Function class="MBMLFileFunctions" name="isDirectoryAtPath" input="string"/>
    <Function class="MBMLFileFunctions" name="sizeOfFile" input="string"/>
    <Function class="MBMLFileFunctions" name="fileData" input="string"/>
    <Function class="MBMLFileFunctions" name="fileContents" input="string"/>
    <Function class="MBMLFileFunctions" name="deleteFile" input="string"/>
 */

/******************************************************************************/
#pragma mark Setup / Teardown
/******************************************************************************/

- (void) setUpAppData
{
    consoleTrace();

    [super setUpAppData];

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"fileExtension"] = @"txt";
    scope[@"fileBasename"] = @"do-not-readme";
    scope[@"fileName"] = [@"${fileBasename}.${fileExtension}" evaluateAsString];
    scope[@"fileDirectory"] = @"/tmp";
    scope[@"filePath"] = [@"${fileDirectory}/${fileName}" evaluateAsString];
}

- (void) tearDown
{
    consoleTrace();

    [MBScopedVariables exitVariableScope];

    [super tearDown];
}

/******************************************************************************/
#pragma mark Setup / Teardown
/******************************************************************************/

- (void) testLastPathComponent
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* last = [MBExpression asString:@"^lastPathComponent($filePath)"];
    XCTAssertEqualObjects(last, @"do-not-readme.txt");
}

- (void) testStripLastPathComponent
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* stripped = [MBExpression asString:@"^stripLastPathComponent($filePath)"];
    XCTAssertEqualObjects(stripped, @"/tmp");
}

- (void) testPathExtension
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* extension = [MBExpression asString:@"^pathExtension($filePath)"];
    XCTAssertEqualObjects(extension, @"txt");
}

- (void) testStripPathExtension
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* stripped = [MBExpression asString:@"^stripPathExtension($filePath)"];
    XCTAssertEqualObjects(stripped, @"/tmp/do-not-readme");
}

- (void) testPathComponents
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSArray* components = [MBExpression asObject:@"^pathComponents($filePath)"];
    XCTAssertTrue([components isKindOfClass:[NSArray class]]);
    XCTAssertTrue(components.count == 3);
    XCTAssertEqualObjects(components[0], @"/");
    XCTAssertEqualObjects(components[1], @"tmp");
    XCTAssertEqualObjects(components[2], @"do-not-readme.txt");
}

- (void) testDirectoryForCaches
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* testDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString* dir = [MBExpression asString:@"^directoryForCaches()"];
    XCTAssertEqualObjects(dir, testDir);
}

- (void) testDirectoryForDocuments
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* testDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* dir = [MBExpression asString:@"^directoryForDocuments()"];
    XCTAssertEqualObjects(dir, testDir);
}

- (void) testDirectoryForDownloads
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* testDir = [NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES) firstObject];
    NSString* dir = [MBExpression asString:@"^directoryForDownloads()"];
    XCTAssertEqualObjects(dir, testDir);
}

- (void) testDirectoryForApplicationSupport
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* testDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSString* dir = [MBExpression asString:@"^directoryForApplicationSupport()"];
    XCTAssertEqualObjects(dir, testDir);
}

- (void) testDirectoryForHome
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* dir = [MBExpression asString:@"^directoryForHome()"];
    XCTAssertEqualObjects(dir, NSHomeDirectory());
}

- (void) testDirectoryForTempFiles
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* dir = [MBExpression asString:@"^directoryForTempFiles()"];
    XCTAssertEqualObjects(dir, NSTemporaryDirectory());
}

- (void) testDirectoryForMovies
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* testDir = [NSSearchPathForDirectoriesInDomains(NSMoviesDirectory, NSUserDomainMask, YES) firstObject];
    NSString* dir = [MBExpression asString:@"^directoryForMovies()"];
    XCTAssertEqualObjects(dir, testDir);
}

- (void) testDirectoryForMusic
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* testDir = [NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES) firstObject];
    NSString* dir = [MBExpression asString:@"^directoryForMusic()"];
    XCTAssertEqualObjects(dir, testDir);
}

- (void) testDirectoryForPictures
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* testDir = [NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES) firstObject];
    NSString* dir = [MBExpression asString:@"^directoryForPictures()"];
    XCTAssertEqualObjects(dir, testDir);
}

- (void) testDirectoryForPublicFiles
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSString* testDir = [NSSearchPathForDirectoriesInDomains(NSSharedPublicDirectory, NSUserDomainMask, YES) firstObject];
    NSString* dir = [MBExpression asString:@"^directoryForPublicFiles()"];
    XCTAssertEqualObjects(dir, testDir);
}

- (void) testListDirectory
{
    consoleTrace();

    //
    // test expected successes
    //
    NSArray* paths = [[MBEnvironment instance] mbmlPathsLoaded];
    XCTAssertTrue(paths.count == 2);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    for (NSUInteger i=0; i<paths.count; i++) {
        scope[@"testDirectory"] = [paths[i] stringByDeletingLastPathComponent];
        NSArray* dirList = [MBExpression asObject:@"^listDirectory($testDirectory)"];
        XCTAssertTrue([dirList isKindOfClass:[NSArray class]]);
        XCTAssertTrue(dirList.count >= 1);
        XCTAssertTrue([dirList containsObject:[paths[i] lastPathComponent]]);
    }
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^listDirectory()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^listDirectory($NULL)" error:&err];
    expectError(err);
}

- (void) testFileExists
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSArray* paths = [[MBEnvironment instance] mbmlPathsLoaded];
    XCTAssertTrue(paths.count == 2);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"testFilePaths"] = paths;
    BOOL exists = [MBExpression asBoolean:@"^fileExists($testFilePaths[0])"];
    XCTAssertTrue(exists);
    exists = [MBExpression asBoolean:@"^fileExists($testFilePaths[1])"];
    XCTAssertTrue(exists);
    exists = [MBExpression asBoolean:@"^fileExists(/tmp/foo/should-not-exist.txt)"];
    XCTAssertFalse(exists);
    exists = [MBExpression asBoolean:@"^fileExists()"];
    XCTAssertFalse(exists);
    [MBScopedVariables exitVariableScope];
}

- (void) testFileIsReadable
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSArray* paths = [[MBEnvironment instance] mbmlPathsLoaded];
    XCTAssertTrue(paths.count == 2);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"testFilePaths"] = paths;
    BOOL readable = [MBExpression asBoolean:@"^fileIsReadable($testFilePaths[0])"];
    XCTAssertTrue(readable);
    readable = [MBExpression asBoolean:@"^fileIsReadable($testFilePaths[1])"];
    XCTAssertTrue(readable);
    readable = [MBExpression asBoolean:@"^fileIsReadable(/tmp/foo/should-not-exist.txt)"];
    XCTAssertFalse(readable);
    readable = [MBExpression asBoolean:@"^fileIsReadable()"];
    XCTAssertFalse(readable);
    [MBScopedVariables exitVariableScope];
}

- (void) testFileIsWritable
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSArray* paths = [[MBEnvironment instance] mbmlPathsLoaded];
    XCTAssertTrue(paths.count == 2);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"testFilePaths"] = paths;
    BOOL writable = [MBExpression asBoolean:@"^fileIsWritable($testFilePaths[0])"];
    XCTAssertTrue(writable);
    writable = [MBExpression asBoolean:@"^fileIsWritable($testFilePaths[1])"];
    XCTAssertTrue(writable);
    writable = [MBExpression asBoolean:@"^fileIsWritable(/tmp/foo/should-not-exist.txt)"];
    XCTAssertFalse(writable);
    writable = [MBExpression asBoolean:@"^fileIsWritable()"];
    XCTAssertFalse(writable);
    [MBScopedVariables exitVariableScope];
}

- (void) testFileIsDeletable
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSArray* paths = [[MBEnvironment instance] mbmlPathsLoaded];
    XCTAssertTrue(paths.count == 2);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"testFilePaths"] = paths;
    BOOL deletable = [MBExpression asBoolean:@"^fileIsDeletable($testFilePaths[0])"];
    XCTAssertTrue(deletable);
    deletable = [MBExpression asBoolean:@"^fileIsDeletable($testFilePaths[1])"];
    XCTAssertTrue(deletable);
    deletable = [MBExpression asBoolean:@"^fileIsDeletable(/)"];
    XCTAssertFalse(deletable);
    [MBScopedVariables exitVariableScope];
}

- (void) testIsDirectoryAtPath
{
    consoleTrace();

    //
    // test expected successes
    //
    // (note: failures are not tested because this function doesn't
    //        have any error conditions; it won't return MBMLFunctionError)
    //
    NSArray* paths = [[MBEnvironment instance] mbmlPathsLoaded];
    XCTAssertTrue(paths.count == 2);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"testFilePaths"] = paths;
    BOOL isDir = [MBExpression asBoolean:@"^isDirectoryAtPath($testFilePaths[0])"];
    XCTAssertFalse(isDir);
    isDir = [MBExpression asBoolean:@"^isDirectoryAtPath($testFilePaths[1])"];
    XCTAssertFalse(isDir);
    isDir = [MBExpression asBoolean:@"^isDirectoryAtPath(/)"];
    XCTAssertTrue(isDir);
    isDir = [MBExpression asBoolean:@"^isDirectoryAtPath(^stripLastPathComponent($testFilePaths[0]))"];
    XCTAssertTrue(isDir);
    isDir = [MBExpression asBoolean:@"^isDirectoryAtPath(^stripLastPathComponent($testFilePaths[1]))"];
    XCTAssertTrue(isDir);
    [MBScopedVariables exitVariableScope];
}

- (void) testSizeOfFile
{
    consoleTrace();

    //
    // test expected successes
    //
    NSArray* paths = [[MBEnvironment instance] mbmlPathsLoaded];
    XCTAssertTrue(paths.count == 2);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    for (NSUInteger i=0; i<paths.count; i++) {
        scope[@"testFile"] = paths[i];
        NSNumber* sizeNum = [MBExpression asNumber:@"^sizeOfFile($testFile)"];
        XCTAssertTrue([sizeNum isKindOfClass:[NSNumber class]]);
        unsigned long long size = [sizeNum unsignedLongLongValue];
        XCTAssertTrue(size > 0);
        if ([[paths[i] lastPathComponent] isEqualToString:@"test-app-data.xml"]) {
            XCTAssertEqual(size, 7202);     // unit test will fail if file size changes; will need to keep this up-to-date
        }
        else if ([[paths[i] lastPathComponent] isEqualToString:@"MBDataEnvironmentModule.xml"]) {
            XCTAssertEqual(size, 17009);    // unit test will fail if file size changes; will need to keep this up-to-date
        }
    }
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asNumber:@"^sizeOfFile()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"^sizeOfFile($nameList)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"^sizeOfFile($NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asNumber:@"^sizeOfFile(/tmp/foo/nonexistent-file.xml)" error:&err];
    expectError(err);
}

- (void) testFileData
{
    consoleTrace();

    //
    // test expected successes
    //
    NSArray* paths = [[MBEnvironment instance] mbmlPathsLoaded];
    XCTAssertTrue(paths.count == 2);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    for (NSUInteger i=0; i<paths.count; i++) {
        scope[@"testFile"] = paths[i];
        NSData* data = [MBExpression asObject:@"^fileData($testFile)"];
        XCTAssertTrue([data isKindOfClass:[NSData class]]);
        XCTAssertTrue(data.length > 0);

        NSData* testData = [NSData dataWithContentsOfFile:paths[i]];
        XCTAssertEqualObjects(data, testData);

    }
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^fileData()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^fileData($NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^fileData(/////)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^fileData(/tmp/foo/nonexistent-file.xml)" error:&err];
    expectError(err);
}

- (void) testFileContents
{
    consoleTrace();

    //
    // test expected successes
    //
    NSArray* paths = [[MBEnvironment instance] mbmlPathsLoaded];
    XCTAssertTrue(paths.count == 2);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    for (NSUInteger i=0; i<paths.count; i++) {
        scope[@"testFile"] = paths[i];
        NSString* contents = [MBExpression asObject:@"^fileContents($testFile)"];
        XCTAssertTrue([contents isKindOfClass:[NSString class]]);
        XCTAssertTrue(contents.length > 0);

        NSString* testContents = [NSString stringWithContentsOfFile:paths[i] encoding:NSUTF8StringEncoding error:nil];
        XCTAssertEqualObjects(contents, testContents);
    }
    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^fileContents()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^fileContents($NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^fileContents(/////)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^fileContents(/tmp/foo/nonexistent-file.xml)" error:&err];
    expectError(err);
}

- (void) testDeleteFile
{
    consoleTrace();

    //
    // test expected successes
    //
    NSString* fileContent = @"This is my file.\nThere are many like it but this one is mine.";
    NSString* tempDir = [@"^directoryForTempFiles()" evaluateAsString];
    NSString* random = [@"^random(100000|999999)" evaluateAsString];
    NSString* tempFileName = [NSString stringWithFormat:@"%@-delete-file-unit-test-%@.txt", [self class], random];
    NSString* tempFile = [tempDir stringByAppendingPathComponent:tempFileName];

    NSError* nsErr = nil;
    BOOL success = [fileContent writeToFile:tempFile atomically:YES encoding:NSUTF8StringEncoding error:&nsErr];
    XCTAssertTrue(success);
    XCTAssertNil(nsErr);

    MBScopedVariables* scope = [MBScopedVariables enterVariableScope];
    scope[@"fileToDelete"] = tempFile;

    NSString* testFileContent = [MBExpression asString:@"^fileContents($fileToDelete)"];
    XCTAssertEqualObjects(fileContent, testFileContent);

    BOOL exists = [MBExpression asBoolean:@"^fileExists($fileToDelete)"];
    XCTAssertTrue(exists);
    BOOL readable = [MBExpression asBoolean:@"^fileIsReadable($fileToDelete)"];
    XCTAssertTrue(readable);
    BOOL deletable = [MBExpression asBoolean:@"^fileIsDeletable($fileToDelete)"];
    XCTAssertTrue(deletable);

    BOOL deleted = [MBExpression asBoolean:@"^deleteFile($fileToDelete)"];
    XCTAssertTrue(deleted);

    exists = [MBExpression asBoolean:@"^fileExists($fileToDelete)"];
    XCTAssertFalse(exists);
    readable = [MBExpression asBoolean:@"^fileIsReadable($fileToDelete)"];
    XCTAssertFalse(readable);

    [MBScopedVariables exitVariableScope];

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asObject:@"^deleteFile($NULL)" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asObject:@"^deleteFile(^directoryForTempFiles()/foo/nonexistent-file.xml)" error:&err];
    expectError(err);
}

@end