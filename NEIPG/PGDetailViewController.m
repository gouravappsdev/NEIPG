//
//  PGDetailViewController.m
//  NEIPG
//
//  Created by Yaogeng Cheng on 11/7/13.
//  Copyright (c) 2013 Yaogeng Cheng. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "PGDetailViewController.h"
#import "PGCheckList.h"
#import "PGDataManager.h"
#import "PGDrugListViewController.h"
//#import "UIViewController+ECSlidingViewController.h"
//#import "MenuViewController.h"

@interface PGDetailViewController ()
//@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation PGDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

//    if (self.masterPopoverController != nil) {
 //       [self.masterPopoverController dismissPopoverAnimated:YES];
    //}
}

- (void)configureView
{
    // Update the user interface for the detail item.

    PGCheckList *args =self.detailItem;
        //NSLog(@"self.drugName is %@",args.itemId);
    NSLog(@"itemName is %@",args.itemName);
    NSLog(@"drugName is %@",args.drugName);
        //self.detailDescriptionLabel.text = [self.detailItem description];
        
        //1
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"names" ofType:@"plist"];
        
        //2
        //NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        //self.names = dict;
        
        //3
        //NSArray *array = [[_names allKeys] sortedArrayUsingSelector:@selector(compare:)];
        //NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
        //NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //[dict setObject: @"Wind in the Willows"  forKey: @"100-432112"];
    

    self.objects =[PGDataManager getConsiderationList:args.drugName];
    self.names =[PGDataManager getConsiderationKeys:args.drugName];
    self.keys = [self.names allKeys];
    
    if (self.objects.count == 0) self.title =@"No results";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title =@"Find Agents That:";
    if (self.objects.count == 0) self.title =@"No results";
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.title = nil;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
	// Do any additional setup after loading the view, typically from a nib.
    //[self configureView];
    //[[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont boldSystemFontOfSize:18]];
    
    
    self.title =@"Find Agents That:";
    if (self.objects.count == 0) self.title =@"No results";
    /**************************
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    UIButton  *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8, 10, 34, 24);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    //UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(revealMenu:)];
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.rightBarButtonItem = myButton;
     ***********************/
}
/*
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = UIColorFromRGB(0xB8CCE4);
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    //[header.textLabel setTextColor:[UIColor whiteColor]];
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
 */
#pragma mark - Split view
/*
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_keys count];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [_keys objectAtIndex:section];
    
    NSArray *object = [_objects objectForKey:key];
    
    return [object count];
    key=nil;
    object=nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    
    NSArray *object = [_objects objectForKey:key];
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    PGCheckList *item = object[indexPath.row];
    
    cell.textLabel.text = item.itemName;
    //cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    if(item.checked){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    key=nil;
    object=nil;
    item=nil;
    return cell;
    
}
/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *key = [_keys objectAtIndex:section];
    
    return [_names objectForKey:key];
    
}
 */
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont boldSystemFontOfSize:28]];
    //[[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    //[[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor colorWithWhite:0.5f alpha:1.0f]];
 
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 320, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:18];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
 
    UIView *headerView = [[UIView alloc] init];
    //[headerView addSubview:myLabel];
    
    return headerView;
}
*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *key = [_keys objectAtIndex:indexPath.section];
    
    NSArray *object = [_objects objectForKey:key];
    PGCheckList *item = object[indexPath.row];
    item.checked = !item.checked;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    key=nil;
    object=nil;
    item=nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *keyNames =[_names objectForKey:[_keys objectAtIndex:section]];
    NSString *sectionTitle = [keyNames objectAtIndex:0];
    NSString *sectionImage = [keyNames objectAtIndex:1];
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(34, 0, 284, 30);
    //label.textColor = [UIColor blackColor];
    //label.font = [UIFont fontWithName:@"Helvetica" size:14];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.text = sectionTitle;
    label.backgroundColor = [UIColor clearColor];
    //label.backgroundColor = UIColorFromRGB(0xB8CCE4);;
    
    UIImage *myImage = [UIImage imageNamed:sectionImage];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    imageView.frame = CGRectMake(0,0,30,30);
    
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    //view.tintColor = UIColorFromRGB(0xB8CCE4);
    view.backgroundColor= UIColorFromRGB(0xB8CCE4);
    [view addSubview:imageView];
    [view addSubview:label];
    
    
    keyNames=nil;
    sectionTitle=nil;
    sectionImage=nil;
    label=nil;
    myImage=nil;
    return view;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //SELECT GenericName FROM DrugConsiderations where CategoryCode='PRESCRIBE' and ConsiderationsID=5 and GenericName not in (SELECT GenericName FROM DrugConsiderations where (CategoryCode='SIDEEFFECTS' and ConsiderationsID=9 and RankID>3) or (CategoryCode='DRUGINT' and ConsiderationsID=14))
    BOOL isChecked = false;
    PGCheckList *args =self.detailItem;
    NSString *sql = [NSString stringWithFormat:@"%@%li", @"SELECT GenericName FROM DrugConsiderations where CategoryCode='PRESCRIBE' and ConsiderationsID=", (long)args.itemId];
    NSString *sql1 = @" and GenericName not in (SELECT GenericName FROM DrugConsiderations where ";
    //NSString stringWithFormat:@"%i ",i]
    NSMutableString* theString = [NSMutableString string];
    [theString appendString:sql];
    
    for (id key in _keys) {
        NSArray *arr = [_objects objectForKey:key];
        for (id object in arr) {
            PGCheckList *item =object;
            if(item.checked)
            {
                if(!isChecked)
                {
                    [theString appendString:sql1];
                    isChecked=!isChecked;
                }
                else{
                    [theString appendString:@" or "];
                }
                
                if(item.rankId>0)
                {
                    [theString appendString:[NSString stringWithFormat:@"%@%@%@%li%@%li%@",@"(CategoryCode='",key,@"' and ConsiderationsID=",(long)item.itemId,@" and RankID>=", (long)item.rankId, @")"]];
                }
                else
                {
                    [theString appendString:[NSString stringWithFormat:@"%@%@%@%li%@",@"(CategoryCode='",key,@"' and ConsiderationsID=",(long)item.itemId,@")"]];
                }
                /*
                if([key isEqualToString:@"SIDEEFFECTS"])
                {
                    //if(item.rankId>0)
                    [theString appendString:[NSString stringWithFormat:@"%@%@%@%i%@%i%@",@"(CategoryCode='",key,@"' and ConsiderationsID=",item.itemId,@" and RankID>=", item.rankId, @")"]];
                }
                else{
                    [theString appendString:[NSString stringWithFormat:@"%@%@%@%i%@",@"(CategoryCode='",key,@"' and ConsiderationsID=",item.itemId,@")"]];
                }*/
            }
            item=nil;
        }
        arr=nil;
    }
    if(isChecked) [theString appendString:@") order by GenericName"];
    else [theString appendString:@" order by GenericName"];
    NSLog(@"sql: %@", theString);
    [[segue destinationViewController] setDrugList:[PGDataManager getAlternateDrugList:theString]];
    theString=nil;
    args=nil;
    sql=nil;
    sql1=nil;
}
/*
You have to override

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
to give required height for the section title. Else it will overlap with the cell.
 */
@end
