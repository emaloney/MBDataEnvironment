//
//  MBMLFileFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/30/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

@import MBToolbox;

#import "MBMLFileFunctions.h"

#define DEBUG_LOCAL             0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFileFunctions implementation
/******************************************************************************/

@implementation MBMLFileFunctions

/******************************************************************************/
#pragma mark MBML function API
/******************************************************************************/

+ (id) lastPathComponent:(NSString*)input
{
    MBLogDebugTrace();
    
    return [input lastPathComponent];
}

+ (id) stripLastPathComponent:(NSString*)input
{
    MBLogDebugTrace();
    
    return [input stringByDeletingLastPathComponent];
}

+ (id) pathExtension:(NSString*)input
{
    MBLogDebugTrace();
    
    return [input pathExtension];
}

+ (id) stripPathExtension:(NSString*)input
{
    MBLogDebugTrace();
    
    return [input stringByDeletingPathExtension];
}

+ (id) pathComponents:(NSString*)input
{
    MBLogDebugTrace();
    
    return [input pathComponents];
}

+ (id) directoryForHome
{
    MBLogDebugTrace();
    
    return NSHomeDirectory();
}

+ (id) directoryForTempFiles
{
    MBLogDebugTrace();
    
    return NSTemporaryDirectory();
}

+ (id) _directoryForSearchPath:(NSSearchPathDirectory)directory
{
    return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) firstObject];
}

+ (id) directoryForCaches
{
    MBLogDebugTrace();

    return [self _directoryForSearchPath:NSCachesDirectory];
}

+ (id) directoryForDocuments
{
    MBLogDebugTrace();
    
    return [self _directoryForSearchPath:NSDocumentDirectory];
}

+ (id) directoryForDownloads
{
    MBLogDebugTrace();
    
    return [self _directoryForSearchPath:NSDownloadsDirectory];
}

+ (id) directoryForApplicationSupport
{
    MBLogDebugTrace();
    
    return [self _directoryForSearchPath:NSApplicationSupportDirectory];
}

+ (id) directoryForMovies
{
    MBLogDebugTrace();
    
    return [self _directoryForSearchPath:NSMoviesDirectory];
}

+ (id) directoryForMusic
{
    MBLogDebugTrace();
    
    return [self _directoryForSearchPath:NSMusicDirectory];
}

+ (id) directoryForPictures
{
    MBLogDebugTrace();
    
    return [self _directoryForSearchPath:NSPicturesDirectory];
}

+ (id) directoryForPublicFiles
{
    MBLogDebugTrace();
    
    return [self _directoryForSearchPath:NSSharedPublicDirectory];
}

+ (id) listDirectory:(NSString*)dir
{
    MBLogDebugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSError* err = nil;
    NSArray* files = [fileMgr contentsOfDirectoryAtPath:dir error:&err];
    if (!err) {
        return files;
    }

    return [MBMLFunctionError errorWithError:err];
}

+ (id) fileExists:(NSString*)filePath
{
    MBLogDebugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    return @([fileMgr fileExistsAtPath:filePath]);
}

+ (id) fileIsReadable:(NSString*)filePath
{
    MBLogDebugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    return @([fileMgr isReadableFileAtPath:filePath]);
}

+ (id) fileIsWritable:(NSString*)filePath
{
    MBLogDebugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    return @([fileMgr isWritableFileAtPath:filePath]);
}

+ (id) fileIsDeletable:(NSString*)filePath
{
    MBLogDebugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    return @([fileMgr isDeletableFileAtPath:filePath]);
}

+ (id) isDirectoryAtPath:(NSString*)filePath
{
    MBLogDebugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];

    BOOL isDir = NO;
    if ([fileMgr fileExistsAtPath:filePath isDirectory:&isDir]) {
        return @(isDir);
    }
    return @NO;
}

+ (id) sizeOfFile:(NSString*)filePath
{
    MBLogDebugTrace();

    NSFileManager* fileMgr = [NSFileManager defaultManager];

    NSError* err = nil;
    NSDictionary* attrs = [fileMgr attributesOfItemAtPath:filePath error:&err];
    if (err) {
        return [MBMLFunctionError errorWithError:err];
    }

    return attrs[NSFileSize];
}

+ (id) fileData:(NSString*)filePath
{
    MBLogDebugTrace();
    
    NSError* err = nil;
    NSData* data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&err];
    if (err) return [MBMLFunctionError errorWithError:err];
    
    return data;
}

+ (id) fileContents:(NSString*)filePath
{
    MBLogDebugTrace();
    
    NSError* err = nil;
    NSString* contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    if (err) return [MBMLFunctionError errorWithError:err];
    
    return contents;
}

+ (id) deleteFile:(NSString*)filePath
{
    MBLogDebugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSError* err = nil;
    if (![fileMgr removeItemAtPath:filePath error:&err]) {
        return [MBMLFunctionError errorWithError:err];
    }
    return @YES;
}

@end

