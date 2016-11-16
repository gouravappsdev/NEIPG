//
//  PGMasterViewController.m
//  NEIPG
//
//  Created by Yaogeng Cheng on 11/7/13.
//  Copyright (c) 2013 Yaogeng Cheng. All rights reserved.
//

#import "PGWebViewController.h"
#import "PGMasterViewController.h"
#import "PGDetailViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MenuViewController.h"
#import "PGDataManager.h"
#import "PGCheckList.h"

@interface PGMasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *itsToDoChecked;
}
@end

@implementation PGMasterViewController
-(id)init{
    self=[super init];
    //NSString * newS = @"MEMBER";
    //self.memberStatus = newS;
    return self;
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Find Agents For:";
    if (_objects.count == 0) self.title =@"No results";
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
    
    NSLog(@"self.drugName is %@",self.drugName);
    
    self.title =@"Find Agents For:";
    
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    //_objects = [self getMyWines];
    _objects = [PGDataManager getPresciribeList:self.drugName];
    
    if (_objects.count == 0) self.title =@"No results";
    
    //self.view.layer.shadowOpacity = 0.75f;
    //self.view.layer.shadowRadius = 10.0f;
    //self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    /*
     if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
     self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
     }
     */
    //to be able to touch screen swipe
    /*****************************
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    UIButton  *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8, 10, 34, 24);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    //UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(revealMenu:)];
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem = myButton;
    ******************************/
    //[self.view addSubview:self.menuBtn];
    
    
	// Do any additional setup after loading the view, typically from a nib.
    //if ([self.memberStatus isEqual:@"MEMBER"]){
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    //}
    
    //UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backView:)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Look Up by Drug" style:UIBarButtonItemStyleBordered target:self action:@selector(nextView:)];
    //self.navigationItem.rightBarButtonItem = rightButton;
    [self setToolbarItems:[NSArray arrayWithObjects:flex,rightButton, nil] animated:YES];
    
    self.detailViewController = (PGDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
        
}

- (IBAction)nextView:(id)sender
{
    //UIViewController* myViewController = [[UIViewController alloc] init];
    //[[self navigationController] pushViewController:myViewController];
    
    UINavigationController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];

    self.slidingViewController.topViewController = newTopViewController;
    
    newTopViewController=nil;
}

- (IBAction)backView:(id)sender
{

    UINavigationController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"webSID"];

    PGWebViewController *vc = (PGWebViewController *)[newTopViewController topViewController];
    //PGWebViewController *vc = (PGWebViewController *)newTopViewController;
    [vc setDrug:self.drugName];
    
    self.slidingViewController.topViewController = newTopViewController;
    vc=nil;
    newTopViewController=nil;
}
/*
- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
*/
/*
- (NSMutableArray *) getMyWines{
    NSMutableArray *wineArray = [[NSMutableArray alloc] init];
    if (!_codeObjects) {
        _codeObjects = [[NSMutableArray alloc] init];
    }
    
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"NEIPG.sqlite"];
        //NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"NEIPG.sqlite" ofType:nil];
        
        
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT c.ConsiderationsID,  c.Description FROM DrugConsiderations dc, Considerations c where dc.ConsiderationsID=c.ConsiderationsID and dc.CategoryCode='PRESCRIBE' and GenericName='sertraline'";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            //WineList *MyWine = [[WineList alloc]init];
            NSInteger pId = sqlite3_column_int(sqlStatement, 0);
            //NSString * pCode = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            NSString * pDescr  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            //const char *raw = sqlite3_column_blob(sqlStatement, 3);
            //int rawLen = sqlite3_column_bytes(sqlStatement, 3);
            //NSData *data = [NSData dataWithBytes:raw length:rawLen];
            //MyWine.photo = [[UIImage alloc] initWithData:data];
            [wineArray addObject:pDescr];
            [_codeObjects addObject:[NSNumber numberWithInteger:pId]];
            //[itsToDoChecked addObject:(FALSE)];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return wineArray;
    }
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    PGCheckList *object = _objects[indexPath.row];
    
    /**********************
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    BOOL checked =  [[itsToDoChecked objectAtIndex:indexPath.row] boolValue];
    UIImage *image = (checked) ? [UIImage imageNamed:@"checkbox-checked.png"] : [UIImage imageNamed:@"checkbox.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;   // match the button's size with the image size
    button.tag = indexPath.row;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    // set the button's target to this table view controller so we can interpret touch events and map that to a NSIndexSet
    [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;
    **********************/
    cell.textLabel.text = [object itemName];
    cell.textLabel.font = [UIFont systemFontOfSize:18]; //Change this value to adjust size
    //cell.textLabel.numberOfLines = 2; //Change this value to show more or less lines.
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    object=nil;
    return cell;
}
/*- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL checked = [[itsToDoChecked objectAtIndex:indexPath.row] boolValue];
    [itsToDoChecked removeObjectAtIndex:indexPath.row];
    [itsToDoChecked insertObject:(checked) ? @"FALSE":@"TRUE" atIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)cell.accessoryView;
    
    UIImage *newImage = (checked) ? [UIImage imageNamed:@"checkbox.png"] : [UIImage imageNamed:@"checkbox-checked.png"];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    
}
*/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        PGCheckList *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PGCheckList *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
        object=nil;
        indexPath=nil;
        
        //self.slidingViewController.topViewController = [segue destinationViewController];
    }
}
/*
- (IBAction)unwindToMaster:(UIStoryboardSegue *)segue
{
    
}

- (void)setMemberStatus:(NSString *)newString
{
    _memberStatus = [newString mutableCopy];
}
*/
- (void)setMasterItem:(NSString *)newString
{
    _drugName = newString;
}
@end
