//
//  FlickrPhotoTVC.h
//  SPoT
//
//  Created by Teddy Wyly on 8/22/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//
// Will Call setImageURL: as part of of any "Show Image" Segue

#import <UIKit/UIKit.h>

@interface FlickrPhotoTVC : UITableViewController

@property (strong, nonatomic) NSArray *photos; //of NSDictionary

@end
