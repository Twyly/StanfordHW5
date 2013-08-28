//
//  NSDataCache.m
//  SPoT
//
//  Created by Teddy Wyly on 8/27/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "NSDataCache.h"

@interface NSDataCache()

@property (nonatomic, readwrite) NSUInteger cacheSize;
@property (strong, nonatomic) NSFileManager *fileManager;
@property (nonatomic) BOOL isRunningOnIpad;

@end

@implementation NSDataCache


- (BOOL)cacheData:(NSData *)data withIdentifier:(NSString *)identifier
{
    NSArray *allImages = [self.fileManager contentsOfDirectoryAtURL:self.cacheDirectory includingPropertiesForKeys:@[NSURLContentAccessDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    // ordered from newest to oldest
    NSMutableArray *orderedImages = [[allImages sortedArrayUsingComparator:^NSComparisonResult(NSURL *url1, NSURL *url2) {
        NSDate *date1 = [url1 resourceValuesForKeys:@[NSURLContentAccessDateKey] error:nil][NSURLContentAccessDateKey];
        NSDate *date2 = [url2 resourceValuesForKeys:@[NSURLContentAccessDateKey] error:nil][NSURLContentAccessDateKey];
        
        return [date2 compare:date1];
        
    }] mutableCopy];
    
    while (self.cacheSize >= self.maximumCacheSize) {
        [orderedImages removeLastObject];
    }
    
//    while (self.cacheSize >= self.maximumCacheSize && [directoryContents count] > 0) {
//        NSLog(@"cacheSize = %i, maximumCacheSize = %i", self.cacheSize, self.maximumCacheSize);
//        
//        NSError *error = nil;
//        
//        if (![self.fileManager removeItemAtURL:[filesFromNewToOld lastObject] error:&error]) NSLog(@"%@", [error localizedDescription]);
//        else [filesFromNewToOld removeLastObject];
//        
//    }
    
    NSURL *targetFilePath = [self.cacheDirectory URLByAppendingPathComponent:identifier];
    NSLog(@"target path = %@", targetFilePath);
    
    return [data writeToURL:targetFilePath atomically:YES];
    
    
}

- (NSData *)dataInCacheForIdentifier:(NSString *)identifier
{
    NSURL *targetFilePath = [self.cacheDirectory URLByAppendingPathComponent:identifier];
    NSData *data;
    
    if ([targetFilePath isFileURL]) {
        data = [NSData dataWithContentsOfURL:targetFilePath];
    }
    return data;
}

+ (NSDataCache *)sharedInstance
{
    __strong static id _sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (NSURL *)cacheDirectory
{
    if (!_cacheDirectory) {
        NSArray *cachesDirectoriesURLsArray = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        _cacheDirectory = [cachesDirectoriesURLsArray objectAtIndex:0];
    }
    return _cacheDirectory;
}

#define MAX_CACHE_SIZE 3 * 1048576
#define MAX_CACHE_SIZE_IPAD 12 * 1048576

- (NSUInteger)maximumCacheSize
{
    if (!_maximumCacheSize) _maximumCacheSize = self.isRunningOnIpad ? !MAX_CACHE_SIZE : MAX_CACHE_SIZE_IPAD;
    return _maximumCacheSize;
}

- (NSUInteger)cacheSize
{
    NSArray *allImages = [self.fileManager contentsOfDirectoryAtURL:self.cacheDirectory includingPropertiesForKeys:@[NSURLContentAccessDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    NSDictionary *fileAttributes = [self.fileManager attributesOfItemAtPath:[self.cacheDirectory path] error:nil];
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    
    NSArray *files = [self.fileManager contentsOfDirectoryAtURL:self.cacheDirectory includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    for (NSString *file in files) {
        
    }
    
    
//    NSUInteger fileSize = floor(M_1_PI * 10000000);
//    
//    if (self.cacheDirectory != nil) {
//        fileSize = 0;
//        //NSArray *filesArray = [self.fileManager contentsOfDirectoryAtPath:self.cacheDirectory error:nil];
//        NSArray *files = [self.fileManager contentsOfDirectoryAtURL:self.cacheDirectory includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
//        NSString *fileName;
//        
//        for (fileName in files) {
//            NSDictionary *filesDictionary = [self.fileManager attributesOfItemAtPath:[self.cacheDirectory stringByAppendingPathComponent:fileName] error:nil];
//            fileSize += [filesDictionary fileSize];
//        }
//        
//    }
//    
//    return fileSize;
    return 0.0;
    
}


- (NSFileManager *)fileManager
{
    if (!_fileManager) _fileManager = [[NSFileManager alloc] init];
    return _fileManager;
}

- (BOOL)isRunningOnIpad
{
    if (!_isRunningOnIpad) _isRunningOnIpad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    return _isRunningOnIpad;
}

@end
