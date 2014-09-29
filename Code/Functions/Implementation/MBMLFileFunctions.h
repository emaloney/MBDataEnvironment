//
//  MBMLFileFunctions.h
//  Mockingbird Data Environment
//
//  Created by Evan Coyne Maloney on 4/30/13.
//  Copyright (c) 2013 Gilt Groupe. All rights reserved.
//

#import "MBMLFunction.h"

/******************************************************************************/
#pragma mark -
#pragma mark MBMLFileFunctions class
/******************************************************************************/

@interface MBMLFileFunctions : NSObject

+ (id) lastPathComponent:(NSString*)input;

+ (id) stripLastPathComponent:(NSString*)input;

+ (id) pathExtension:(NSString*)input;

+ (id) stripPathExtension:(NSString*)input;

+ (id) pathComponents:(NSString*)input;

+ (id) directoryForUserHome;
+ (id) directoryForTempFiles;
+ (id) directoryForCaches;
+ (id) directoryForDocuments;
+ (id) directoryForDownloads;
+ (id) directoryForApplicationSupport;
+ (id) directoryForMovies;
+ (id) directoryForMusic;
+ (id) directoryForPictures;
+ (id) directoryForPublicFiles;

+ (id) listDirectory:(NSString*)dir;

+ (id) fileExists:(NSString*)filePath;
+ (id) fileIsReadable:(NSString*)filePath;
+ (id) fileIsWritable:(NSString*)filePath;
+ (id) fileIsDeletable:(NSString*)filePath;
+ (id) isDirectoryAtPath:(NSString*)filePath;

+ (id) sizeOfFile:(NSString*)filePath;
+ (id) fileData:(NSString*)filePath;
+ (id) fileContents:(NSString*)filePath;

+ (id) deleteFile:(NSString*)filePath;

@end
