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
    
    while (self.cacheSize >= self.maximumCacheSize && [allImages count] > 0) {
        NSLog(@"Object Removed");
        [self.fileManager removeItemAtURL:[orderedImages lastObject] error:nil]; //:[orderedImages lastObject] error:nil];
        [orderedImages removeLastObject];
    }
    
    NSURL *targetFilePath = [self.cacheDirectory URLByAppendingPathComponent:identifier];
    return [data writeToURL:targetFilePath atomically:YES];
    
}

- (NSData *)dataInCacheForIdentifier:(NSString *)identifier
{
    NSURL *targetFilePath;
    NSData *data;
    if (identifier) targetFilePath = [self.cacheDirectory URLByAppendingPathComponent:identifier];
    
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

#define MAX_CACHE_SIZE 3 * 500000
#define MAX_CACHE_SIZE_IPAD 12 * 500000

- (NSUInteger)maximumCacheSize
{
    if (!_maximumCacheSize) _maximumCacheSize = !self.isRunningOnIpad ? MAX_CACHE_SIZE : MAX_CACHE_SIZE_IPAD;
    return _maximumCacheSize;
}

- (NSUInteger)cacheSize
{
    NSArray *allImages = [self.fileManager contentsOfDirectoryAtURL:self.cacheDirectory includingPropertiesForKeys:@[NSURLContentAccessDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    long long totalSize = 0.0;
    
    for (NSURL *image in allImages) {
        NSDictionary *fileAttributes = [self.fileManager attributesOfItemAtPath:[image path] error:nil];
        long long fileSize = [[fileAttributes objectForKey:NSFileSize] longLongValue];
        totalSize += fileSize;
        NSLog(@"file size is %lld while total size is %lld", fileSize, totalSize);
    }
    
    return totalSize;
    
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
