//
//  StanfordFlickrPhotoTVC.m
//  SPoT
//
//  Created by Teddy Wyly on 8/22/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "StanfordFlickrPhotoTVC.h"
#import "FlickrFetcher.h"

#define RECENT_PHOTOS_KEY @"Recent Photos From Flickr"

@interface StanfordFlickrPhotoTVC ()

@end

@implementation StanfordFlickrPhotoTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    [super prepareForSegue:segue sender:sender];
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        NSMutableArray *recentPhotos = [[[NSUserDefaults standardUserDefaults] arrayForKey:RECENT_PHOTOS_KEY] mutableCopy];
        if (!recentPhotos) recentPhotos = [[NSMutableArray alloc] init];
        
        NSDictionary *photo = self.photos[path.row];
        
        
        // Remove photo if it exists and add it to the top of recents
        if ([recentPhotos containsObject:photo]) [recentPhotos removeObject:photo];
        [recentPhotos insertObject:photo atIndex:0];
        
        // Make sure there is no more than 10 most recent photos
        while ([recentPhotos count] > 10) {
            [recentPhotos removeLastObject];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[recentPhotos copy]  forKey:RECENT_PHOTOS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
}

- (NSArray *)photos
{
    return [self alphabetizedPhotosFromPhotos:[super photos]];
}


- (NSArray *)alphabetizedPhotosFromPhotos:(NSArray *)array
{
    NSSortDescriptor *titleSortDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PHOTO_TITLE ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor *subtitleSortDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PHOTO_DESCRIPTION ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortedPhotos = [array sortedArrayUsingDescriptors:@[titleSortDescriptor, subtitleSortDescriptor]];
    
    return sortedPhotos;
}




@end
