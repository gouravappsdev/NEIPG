//
//  PGDrugListViewController.m
//  NEIPG
//
//  Created by Yaogeng Cheng on 1/14/14.
//  Copyright (c) 2014 Yaogeng Cheng. All rights reserved.
//

#import "PGDrugListViewController.h"
#import "PGWebViewController.h"
#import "UIViewController+ECSlidingViewController.h"
@interface PGDrugListViewController ()

@end

@implementation PGDrugListViewController

- (void)setDrugList:(NSMutableArray *)newList
{
    if (_drugList != newList) {
        _drugList = newList;
    }
    if (_drugList.count == 0) self.title =@"No results";
}

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
    
    self.title =@"Consider Reviewing:";
    
    if (_drugList.count == 0) self.title =@"No results";
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Look Up by Drug" style:UIBarButtonItemStyleBordered target:self action:@selector(nextView:)];
    //self.navigationItem.rightBarButtonItem = rightButton;
    [self setToolbarItems:[NSArray arrayWithObjects:flex,rightButton, nil] animated:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title =@"Consider Reviewing:";
    
    if (_drugList.count == 0) self.title =@"No results";
}
-(void)viewWillDisappear:(BOOL)animated
{
    //_drugList=nil;
    self.title = nil;
    [super viewWillDisappear:animated];
}

- (IBAction)nextView:(id)sender
{
    //UIViewController* myViewController = [[UIViewController alloc] init];
    //[[self navigationController] pushViewController:myViewController];
    
    UINavigationController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    
    self.slidingViewController.topViewController = newTopViewController;
    newTopViewController=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _drugList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }*/
    // Configure the cell...
    cell.textLabel.text = _drugList[indexPath.row];
    return cell;
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TestViewController *test = [self.storyboard instantiateViewControllerWithIdentifier:@"Testing"];
    [self performSegueWithIdentifier:@"Test" sender:self];
}*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //PGWebViewController *vc = (PGWebViewController *)[[segue destinationViewController] topViewController];
    PGWebViewController *vc = [segue destinationViewController];
    [vc setGenericDrug:_drugList[indexPath.row]];
    indexPath=nil;
    vc=nil;
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
