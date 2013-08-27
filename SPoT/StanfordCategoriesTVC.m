//
//  StanfordCategoriesTVC.m
//  SPoT
//
//  Created by Teddy Wyly on 8/23/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "StanfordCategoriesTVC.h"
#import "FlickrFetcher.h"

@interface StanfordCategoriesTVC ()

@property (strong, nonatomic) NSArray *photos;

@end

@implementation StanfordCategoriesTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLatestStanfordPhotos];
    [self.refreshControl addTarget:self
                            action:@selector(loadLatestStanfordPhotos)
                  forControlEvents:UIControlEventValueChanged];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLatestStanfordPhotos
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t loaderQ = dispatch_queue_create("stanford latest loader", NULL);
    dispatch_async(loaderQ, ^{
        NSArray *latestPhotos = [FlickrFetcher stanfordPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = latestPhotos;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[self tagsFromFlickr] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Stanford Category";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *category = [self tagsFromFlickr][indexPath.row];
    cell.textLabel.text = [category capitalizedString];
    cell.detailTextLabel.text = [@([[self photosWithTag:category] count]) stringValue];
    
    return cell;
}

- (NSArray *)tagsFromFlickr
{
    NSMutableArray *allTags = [[NSMutableArray alloc] init];
    for (NSDictionary *photo in self.photos) {
        NSArray *tags = [photo[FLICKR_TAGS] componentsSeparatedByString:@" "];
        for (NSString *tag in tags) {
            if (![allTags containsObject:tag] && ![tag isEqualToString:@"cs193pspot"] && ![tag isEqualToString:@"portrait"] && ![tag isEqualToString:@"landscape"]) {
                [allTags addObject:tag];
            }
        }
    }
    
    NSArray *sortedArray = [allTags sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return sortedArray;
    
}


- (NSArray *)photosWithTag:(NSString *)tag
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *photo in self.photos) {
        NSArray *tags = [photo[FLICKR_TAGS] componentsSeparatedByString:@" "];
        if ([tags containsObject:tag]) {
            [array addObject:photo];
        }
    }
    
    return [array copy];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Photos For Cateogry"]) {
                SEL setPhotoSelector = sel_registerName("setPhotos:");
                if ([segue.destinationViewController respondsToSelector:setPhotoSelector]) {
                    NSString *category = [self tagsFromFlickr][indexPath.row];
                    NSArray *photosForTag = [self photosWithTag:category];
                    [segue.destinationViewController performSelector:setPhotoSelector withObject:photosForTag];
                    [segue.destinationViewController setTitle:[category capitalizedString]];
                    
                }
            }
        }
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
