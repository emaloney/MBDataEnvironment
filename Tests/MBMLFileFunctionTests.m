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

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

- (void) testFileExists
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

- (void) testFileIsReadable
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

- (void) testFileIsWritable
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

- (void) testFileIsDeletable
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

- (void) testIsDirectoryAtPath
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

- (void) testSizeOfFile
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

- (void) testFileData
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

- (void) testFileContents
{
    consoleTrace();

    //
    // test expected successes
    //

    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);

    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

- (void) testDeleteFile
{
    consoleTrace();

    //
    // test expected successes
    //
    
    //
    // test expected failures
    //
    MBExpressionError* err = nil;
    [MBExpression asBoolean:@"^q()" error:&err];
    expectError(err);
    
    err = nil;
    [MBExpression asBoolean:@"^q($nameList)" error:&err];
    expectError(err);
}

@end