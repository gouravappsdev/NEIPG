//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Kyle Begeman on 1/13/13.
//  Copyright (c) 2013 Indee Box LLC. All rights reserved.
//

#import "MenuViewController.h"
//#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "PGWebViewController.h"
#import "PGDataManager.h"
//#import "ECSlidingSegue.h"
@interface MenuViewController ()
@property (strong, nonatomic) NSMutableDictionary *names;
@property (strong, nonatomic) NSMutableArray *menu;
@property (strong, nonatomic) NSMutableArray *menuKey;
@end

@implementation MenuViewController

@synthesize menu;
@synthesize menuKey;

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
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.names =[PGDataManager getContentHeader];
    self.menuKey = [self.names objectForKey: @"key"];
    self.menu = [self.names objectForKey: @"value"];
    [self.menuKey addObject:[self.menuKey objectAtIndex:0]];
    [self.menu addObject:@"Top"];
    //did not initilaize self.menuKey
    //not ordered
    /*
    for (id key in self.names) {
        [self.menuKey addObject:key];
        NSLog(@"Key: %@, Value %@", key, [self.names objectForKey: key]);
    }*/
    
    //self.menu = [NSArray arrayWithObjects:@"BOOK 1 1", @"CNS 2", @"EBK 3", @"PODCAST 4", nil];
    //self.menuKey = [NSArray arrayWithObjects:@"BOOK", @"CNS", @"EBK", @"POD", nil];
    
    [self.slidingViewController setAnchorRightRevealAmount:200.0f];
    //self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ECSlidingSegue *slidingSegue = (ECSlidingSegue *)segue;
    slidingSegue.skipSettingTopViewController = YES;
}
*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuKey count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:14]; //Change this value to adjust size
    //cell.textLabel.numberOfLines = 2; //Change this value to show more or less lines.
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menuKey objectAtIndex:indexPath.row]];
    
    
    //PGWebViewController *vc = (PGWebViewController *) self.slidingViewController.topViewController;
    UINavigationController *navController = (UINavigationController*) self.slidingViewController.topViewController;
    PGWebViewController *vc = (PGWebViewController *) [navController topViewController];
    
    //[vc reloadInputViews];
    [vc setMenuItem:identifier];
    //UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    //self.slidingViewController.topViewController = newTopViewController;
    
    [self.slidingViewController resetTopViewAnimated:YES];

}

@end
