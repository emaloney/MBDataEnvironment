//
//  MBMLFileFunctions.m
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/30/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import <MBToolbox/MBDebug.h>

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
    debugTrace();
    
    return [input lastPathComponent];
}

+ (id) stripLastPathComponent:(NSString*)input
{
    debugTrace();
    
    return [input stringByDeletingLastPathComponent];
}

+ (id) pathExtension:(NSString*)input
{
    debugTrace();
    
    return [input pathExtension];
}

+ (id) stripPathExtension:(NSString*)input
{
    debugTrace();
    
    return [input stringByDeletingPathExtension];
}

+ (id) pathComponents:(NSString*)input
{
    debugTrace();
    
    return [input pathComponents];
}

+ (id) directoryForHome
{
    debugTrace();
    
    return NSHomeDirectory();
}

+ (id) directoryForTempFiles
{
    debugTrace();
    
    return NSTemporaryDirectory();
}

+ (id) _directoryForSearchPath:(NSSearchPathDirectory)directory
{
    return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) firstObject];
}

+ (id) directoryForCaches
{
    debugTrace();

    return [self _directoryForSearchPath:NSCachesDirectory];
}

+ (id) directoryForDocuments
{
    debugTrace();
    
    return [self _directoryForSearchPath:NSDocumentDirectory];
}

+ (id) directoryForDownloads
{
    debugTrace();
    
    return [self _directoryForSearchPath:NSDownloadsDirectory];
}

+ (id) directoryForApplicationSupport
{
    debugTrace();
    
    return [self _directoryForSearchPath:NSApplicationSupportDirectory];
}

+ (id) directoryForMovies
{
    debugTrace();
    
    return [self _directoryForSearchPath:NSMoviesDirectory];
}

+ (id) directoryForMusic
{
    debugTrace();
    
    return [self _directoryForSearchPath:NSMusicDirectory];
}

+ (id) directoryForPictures
{
    debugTrace();
    
    return [self _directoryForSearchPath:NSPicturesDirectory];
}

+ (id) directoryForPublicFiles
{
    debugTrace();
    
    return [self _directoryForSearchPath:NSSharedPublicDirectory];
}

+ (id) listDirectory:(NSString*)dir
{
    debugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSError* err = nil;
    NSArray* files = [fileMgr contentsOfDirectoryAtPath:dir error:&err];
    if (!err) {
        return files;
    }

    return [MBMLFunctionError errorWithMessage:[err localizedDescription]];
}

+ (id) fileExists:(NSString*)filePath
{
    debugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    return @([fileMgr fileExistsAtPath:filePath]);
}

+ (id) fileIsReadable:(NSString*)filePath
{
    debugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    return @([fileMgr isReadableFileAtPath:filePath]);
}

+ (id) fileIsWritable:(NSString*)filePath
{
    debugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    return @([fileMgr isWritableFileAtPath:filePath]);
}

+ (id) fileIsDeletable:(NSString*)filePath
{
    debugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    return @([fileMgr isDeletableFileAtPath:filePath]);
}

+ (id) isDirectoryAtPath:(NSString*)filePath
{
    debugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];

    BOOL isDir = NO;
    if ([fileMgr fileExistsAtPath:filePath isDirectory:&isDir]) {
        return @(isDir);
    }
    return @NO;
}

+ (id) sizeOfFile:(NSString*)filePath
{
    debugTrace();

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
    debugTrace();
    
    NSError* err = nil;
    NSData* data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&err];
    if (err) return [MBMLFunctionError errorWithMessage:[err localizedDescription]];
    
    return data;
}

+ (id) fileContents:(NSString*)filePath
{
    debugTrace();
    
    NSError* err = nil;
    NSString* contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    if (err) return [MBMLFunctionError errorWithMessage:[err localizedDescription]];
    
    return contents;
}

+ (id) deleteFile:(NSString*)filePath
{
    debugTrace();
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSError* err = nil;
    if (![fileMgr removeItemAtPath:filePath error:&err]) {
        return [MBMLFunctionError errorWithMessage:[err localizedDescription]];
    }
    return @YES;
}

@end

