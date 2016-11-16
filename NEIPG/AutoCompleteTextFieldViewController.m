//
//  AutoCompleteTextFieldViewController.m
//  AutoCompleteTextField
//
//  Created by Andrew Wimpy on 2/28/11.
//  Copyright 2011 nextPression. All rights reserved.
//

#import "AutoCompleteTextFieldViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MenuViewController.h"
#import "PGWebViewController.h"
#import "PGDataManager.h"

@implementation AutoCompleteTextFieldViewController

//@synthesize menuBtn;
//@synthesize searchBtn;


- (void) finishedSearching {
	[txtField resignFirstResponder];
	autoCompleteTableView.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Look Up by Drug Name";
    //self.title =[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"AppLaunchCount"]];
    txtField.text = @"";
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    NSLog(@"screenWidth: %f", screenWidth);
    NSLog(@"screenHeight: %f", screenHeight);
    NSLog(@"barHeightP: %f", barHeightP);
    NSLog(@"barHeightL: %f", barHeightL);
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        barHeightP = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        txtField.frame =CGRectMake(5, barHeightP+5, screenWidth-10, 40);
        //autoCompleteTableView.frame = CGRectMake(0, 106, screenWidth-10, screenHeight-45-keyboardHeight);
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        barHeightL = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.width;
        //for 6s and before, the screen height and width does not change when rotate, but for 6s it does change when rotate.
        if(screenHeight>screenWidth) txtField.frame =CGRectMake(5, barHeightL+5, screenHeight-10, 40);
        else txtField.frame =CGRectMake(5, barHeightL+5, screenWidth-10, 40);
        //autoCompleteTableView.frame = CGRectMake(0, 106, screenHeight-10, screenWidth-45-keyboardHeight);
    }

    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    self.title = nil;
    [super viewWillDisappear:animated];
}

- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        barHeightP = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        txtField.frame =CGRectMake(5, barHeightP+5, screenWidth-10, 40);
        //autoCompleteTableView.frame = CGRectMake(0, 106, screenWidth-10, screenHeight-45-keyboardHeight);
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        barHeightL = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.width;
        if(screenHeight>screenWidth) txtField.frame =CGRectMake(5, barHeightL+5, screenHeight-10, 40);
        else txtField.frame =CGRectMake(5, barHeightL+5, screenWidth-10, 40);
        //autoCompleteTableView.frame = CGRectMake(0, 106, screenHeight-10, screenWidth-45-keyboardHeight);
    }
    NSLog(@"screenWidth 1 : %f", screenWidth);
    NSLog(@"screenHeight 1 : %f", screenHeight);
    NSLog(@"barHeightP: %f", barHeightP);
    NSLog(@"barHeightL: %f", barHeightL);
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    tableHeight = 40;
    barHeightP = 64;
    barHeightL = 52;
    
    // Register notification when the keyboard will be show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register notification when the keyboard will be hide
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
*/
    //[[self view] setClipsToBounds:YES];
    /*
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8, 10, 34, 24);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.menuBtn];
    */
    
	//Pull the content from the file into memory
	
    /*
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"elements1.txt" ofType:nil];
	NSData* data = [NSData dataWithContentsOfFile:filePath];

	//Convert the bytes from the file into a string
	NSString* string = [[NSString alloc] initWithBytes:[data bytes]
												 length:[data length] 
											   encoding:NSUTF8StringEncoding];
	
	//Split the string around newline characters to create an array
	NSString* delimiter = @"\n";
	NSArray *item = [string componentsSeparatedByString:delimiter];
	elementArray = [[NSMutableArray alloc] initWithArray:item];
    */
    //NSArray *item = [PGDataManager getDrugList];

    
    
    
	elementArray = [[NSMutableArray alloc] init];
    elementArray=[PGDataManager getDrugList];
	autoCompleteArray = [[NSMutableArray alloc] init];

	//Search Bar
	txtField = [[UITextField alloc] initWithFrame:CGRectMake(5, 70, 261, 40)];
	txtField.borderStyle = 3; // rounded, recessed rectangle
    
    //txtField.layer.borderWidth = 1;
    //txtField.layer.borderColor = [[UIColor redColor] CGColor];
    txtField.layer.cornerRadius=8.0f;
    txtField.layer.masksToBounds=YES;
    txtField.layer.borderColor=[[UIColor blackColor]CGColor];
    txtField.layer.borderWidth= 1.0f;
    
	
    txtField.autocorrectionType = UITextAutocorrectionTypeNo;
	//txtField.textAlignment = UITextAlignmentLeft;
	txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	txtField.returnKeyType = UIReturnKeyDone;
	txtField.font = [UIFont fontWithName:@"Trebuchet MS" size:22];
	txtField.textColor = [UIColor blackColor];
    
    
    [txtField setPlaceholder:@"Enter drug name here"];
    [txtField setDelegate:self];
	[self.view addSubview:txtField];


    NSString *icon_path1 = [[NSBundle mainBundle] pathForResource:@"nei_logo" ofType:@"png"];
    UIImage* m_icon1 = [[UIImage alloc]initWithContentsOfFile:icon_path1];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:m_icon1];
    //imageView.frame = CGRectMake(0,110,261, 40);
    CGRect frame1 = imageView1.frame;
    frame1.origin.x = CGRectGetMidX(self.view.bounds) - CGRectGetMidX(imageView1.bounds);
    
    // optionally change the size as well
    // frame.size.width = 100.0;
    // frame.size.height = 250.0;
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 110, 261, 40)];
    //imageView.image= m_icon;
    
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"NEIGroupName"];
    NSLog(@"%@", savedValue);
    if([savedValue length]>0){
        NSLog(@"%@", @"in");
        NSString *icon_path = [[NSBundle mainBundle] pathForResource:savedValue ofType:@"gif"];
        UIImage* m_icon = [[UIImage alloc]initWithContentsOfFile:icon_path];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:m_icon];
        CGRect frame = imageView.frame;
        frame.origin.x = CGRectGetMidX(self.view.bounds) - CGRectGetMidX(imageView.bounds);
        frame.origin.y = 210.0 - m_icon.size.height-10;
        imageView.frame = frame;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self.view addSubview:imageView];
        icon_path=nil;
        m_icon=nil;
        imageView=nil;
        frame1.origin.y = 250;
    }
    else{
        frame1.origin.y = 210;
    }
    imageView1.frame = frame1;
    imageView1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:imageView1];
    
    icon_path1=nil;
    m_icon1=nil;
    imageView1=nil;
    /*
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(267, 40, 34, 24);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchBtn];
	*/
    
	//Autocomplete Table
	autoCompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 106, 259, 4*tableHeight) style:UITableViewStylePlain];
	autoCompleteTableView.delegate = self;
	autoCompleteTableView.dataSource = self;
	autoCompleteTableView.scrollEnabled = YES;
	autoCompleteTableView.hidden = YES;
	autoCompleteTableView.rowHeight = tableHeight;
    
    [autoCompleteTableView setSeparatorColor:[UIColor clearColor]];
    //[self.tableView setSeparatorColor:[UIColor clearColor]];
    
    
	[self.view addSubview:autoCompleteTableView];

    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        barHeightP = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        txtField.frame =CGRectMake(5, barHeightP+5, screenWidth-10, 40);
        //autoCompleteTableView.frame = CGRectMake(0, 106, screenWidth-10, screenHeight-45-keyboardHeight);
    }
    else
    {
        barHeightL = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.width;
        //txtField.frame =CGRectMake(5, barHeightL+5, screenHeight-10, 40);
        if(screenHeight>screenWidth) txtField.frame =CGRectMake(5, barHeightL+5, screenHeight-10, 40);
        else txtField.frame =CGRectMake(5, barHeightL+5, screenWidth-10, 40);
        //autoCompleteTableView.frame = CGRectMake(0, 106, screenHeight-10, screenWidth-45-keyboardHeight);
    }
    NSLog(@"screenWidth 1 : %f", screenWidth);
    NSLog(@"screenHeight 1 : %f", screenHeight);
    NSLog(@"barHeightP: %f", barHeightP);
    NSLog(@"barHeightL: %f", barHeightL);
    self.navigationItem.backBarButtonItem.title = @"Drug";
	
    
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)unwindFromDisclaimertoHome:(UIStoryboardSegue *)segue
{
    //NSLog(@"current date000: %@", [NSDate date]);
    if (![self.presentedViewController isBeingDismissed])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    // Do something after unwinding
    //[self dismissViewControllerAnimated:YES completion:NULL];
    /*[self dismissViewControllerAnimated:YES completion:^{
     [(UINavigationController *)self.presentingViewController popToRootViewControllerAnimated:YES];
     }];*/
}

// Take string from Search Textfield and compare it with autocomplete array
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
	
	// Put anything that starts with this substring into the autoCompleteArray
	// The items in this array is what will show up in the table view
	
	[autoCompleteArray removeAllObjects];
		
	for(NSString *curString in elementArray) {
		/*NSRange substringRangeLowerCase = [curString rangeOfString:[substring lowercaseString]];
		NSRange substringRangeUpperCase = [curString rangeOfString:[substring uppercaseString]];
				
		if (substringRangeLowerCase.location == 0 || substringRangeUpperCase.location == 0) {
			[autoCompleteArray addObject:curString];
		}*/
        
        NSRange substringRangeUpperCase = [[curString uppercaseString] rangeOfString:[substring uppercaseString]];
        
		if (substringRangeUpperCase.location == 0) {
			[autoCompleteArray addObject:curString];
		}
        
	}
	
	autoCompleteTableView.hidden = NO;
	[autoCompleteTableView reloadData];
}

// Close keyboard if the Background is touched
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
	[self finishedSearching];
}

#pragma mark UITextFieldDelegate methods

// Close keyboard when Enter or Done is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {    
	BOOL isDone = YES;
	
	if (isDone) {
		[self finishedSearching];
		return YES;
	} else {
		return NO;
	}	
} 

// String in Search textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *substring = [NSString stringWithString:textField.text];
	substring = [substring stringByReplacingCharactersInRange:range withString:string];
	[self searchAutocompleteEntriesWithSubstring:substring];
	return YES;
}

#pragma mark UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return autoCompleteArray.count;
/*
	//Resize auto complete table based on how many elements will be displayed in the table
	if (autoCompleteArray.count >=4) {
		//autoCompleteTableView.frame = CGRectMake(0, 106, 259, tableHeight*(autoCompleteArray.count));
        //autoCompleteTableView.frame = CGRectMake(0, 106, 259, tableHeight*4);
		return autoCompleteArray.count;
	}
	
	else if (autoCompleteArray.count == 2) {
		autoCompleteTableView.frame = CGRectMake(0, 106, 259, tableHeight*2);
		return autoCompleteArray.count;
	}
	
	else {
		//autoCompleteTableView.frame = CGRectMake(0, 106, 259, tableHeight);
        //autoCompleteTableView.frame = CGRectMake(0, 106, 259, tableHeight*(autoCompleteArray.count));
		return autoCompleteArray.count;
	}*/
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
	cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
	}
		
	cell.textLabel.text = [autoCompleteArray objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	txtField.text = selectedCell.textLabel.text;
	[self finishedSearching];
    [self performSegueWithIdentifier:@"showDrug" sender:self];
    selectedCell=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"showDrug"]) {
        if(txtField.text.length==0)
        {
            txtField.text=@"Please select a drug name.";
            return NO;
        }
        if([txtField.text isEqual:(@"Please select a drug name.")]) return NO;
        }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDrug"]) {
        
        //UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        //PGMasterViewController *eventsController = [navController topViewController];
        
        NSLog(@"textfield: %@", txtField.text);

        //PGWebViewController *vc = (PGWebViewController *)[[segue destinationViewController] topViewController];
        PGWebViewController *vc = [segue destinationViewController];
        
        if(txtField.text.length>0){
            [vc setDrug:txtField.text];
        }
        else{
            [vc setDrug:_shortCutItemDrug];
        }
        vc = nil;
        //vc.memberStatus = self.loginStatus;
        
    }
}
- (void)setShortCutItemDrug:(NSString *)newString
{
    _shortCutItemDrug = newString;
}

/*
// To be link with your TextField event "Editing Did Begin"
//  memoryze the current TextField
- (IBAction)textFieldDidBeginEditing:(UITextField *)textFieldBegin
{
    txtField = textFieldBegin;
}

// To be link with your TextField event "Editing Did End"
//  release current TextField
- (IBAction)textFieldDidEndEditing:(UITextField *)textFieldEnd
{
    txtField = nil;
}
*/

-(void) keyboardWillShow:(NSNotification *)note
{
    //barHeight = self.navigationController.navigationBar.frame.size.height;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    //CGRect frame = autoCompleteTableView.frame;
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        //txtField.frame =CGRectMake(5, 70, screenWidth-10, 41);
        barHeightP = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        autoCompleteTableView.frame = CGRectMake(0, barHeightP+45, screenWidth-10, screenHeight-barHeightP-45-keyboardBounds.size.height);
    }
    else
    {
        barHeightL = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.width;
        if(screenHeight>screenWidth) autoCompleteTableView.frame = CGRectMake(0, barHeightL+45, screenHeight-10, screenWidth-barHeightL-45- keyboardBounds.size.width);
        else autoCompleteTableView.frame = CGRectMake(0, barHeightL+45, screenWidth-10, screenHeight-barHeightL-45- keyboardBounds.size.height);
        
        NSLog(@"screenWidth-10: %f", screenWidth-10);
        NSLog(@"barHeightL+45: %f", barHeightL+45);
        NSLog(@"NcreenHeight-barHeightL-45- keyboardBounds.size.width: %f",screenHeight-barHeightL-45- keyboardBounds.size.width);

        //txtField.frame =CGRectMake(5, 70, screenHeight-10, 41);
    }
    /*
    NSLog(@"keyboardBounds.size.height: %f", keyboardBounds.size.height);
    NSLog(@"kkeyboardBounds.size.width: %f", keyboardBounds.size.width);
    NSLog(@"Navframe Height=%f",self.navigationController.navigationBar.frame.size.height);
    NSLog(@"Navframe Width=%f",self.navigationController.navigationBar.frame.size.width);
    
    NSLog(@"Status Height=%f",[UIApplication sharedApplication].statusBarFrame.size.height);
    NSLog(@"Status Width=%f",[UIApplication sharedApplication].statusBarFrame.size.width);
     */
    // Apply new size of table view
    //autoCompleteTableView.frame = frame;
    
    
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
 /*
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = autoCompleteTableView.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height += keyboardBounds.size.height;
    else
        frame.size.height += keyboardBounds.size.width;
    
    // Apply new size of table view
    autoCompleteTableView.frame = frame;
    
    [UIView commitAnimations];*/
}

@end
