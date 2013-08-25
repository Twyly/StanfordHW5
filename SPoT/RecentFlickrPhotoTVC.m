//
//  RecentFlickrPhotoTVC.m
//  SPoT
//
//  Created by Teddy Wyly on 8/22/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "RecentFlickrPhotoTVC.h"
#define RECENT_PHOTOS_KEY @"Recent Photos From Flickr"

@interface RecentFlickrPhotoTVC ()

@end

@implementation RecentFlickrPhotoTVC

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
	self.photos = [[NSUserDefaults standardUserDefaults] arrayForKey:RECENT_PHOTOS_KEY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.photos = [[NSUserDefaults standardUserDefaults] arrayForKey:RECENT_PHOTOS_KEY];
}

@end
