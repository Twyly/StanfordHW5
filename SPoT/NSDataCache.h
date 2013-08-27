//
//  NSDataCache.h
//  SPoT
//
//  Created by Teddy Wyly on 8/27/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDataCache : NSObject

@property (nonatomic) NSUInteger maximumCacheSize;
@property (strong, nonatomic) NSString *cacheDirectory;
@property (nonatomic, readonly) NSUInteger cacheSize;

+ (NSDataCache *)sharedInstance;
- (BOOL)cacheData:(NSData *)data withIdentifier:(NSString *)identifier;
- (NSData *)dataInCacheForIdentifier:(NSString *)identifier;

@end
