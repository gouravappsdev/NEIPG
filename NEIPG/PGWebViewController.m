//
//  PGWebViewController.m
//  NEIPG
//
//  Created by Yaogeng Cheng on 12/3/13.
//  Copyright (c) 2013 Yaogeng Cheng. All rights reserved.
//

#import "PGWebViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MenuViewController.h"
#import "PGDataManager.h"
#import "PGMasterViewController.h"
@interface PGWebViewController ()
@property (strong, nonatomic) UIPopoverController *drugPopoverController;
@end

@implementation PGWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    /*if (self) {
        // Custom initialization
        _htmlString =@"2011_crm_article_tipsandpearls";
    }*/
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    /*
    UIButton  *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8, 10, 34, 24);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    //UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(revealMenu:)];
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    */
    //self.navigationItem.leftBarButtonItem = myButton;
    
    //UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Custom Considerations" style:UIBarButtonItemStyleBordered target:self action:@selector(nextView:)];
    //self.navigationController.toolbarHidden = NO;
    /*UIToolbar *boolbar = [UIToolbar new];
    boolbar.barStyle = UIBarStyleDefault;
    boolbar.tintColor = [UIColor orangeColor];
    [boolbar sizeToFit];*/

    //[self setToolbarItems:[NSArray arrayWithObjects:myButton, nil] animated:YES];
    
    
    //UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(nextView:)];
    //self.navigationItem.rightBarButtonItem = homeButton;
    //UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //[self.toolbarItems setItems:[NSArray arrayWithObjects:flexibleSpace, settingsButton,deleteButton,aboutButton, flexibleSpace, nil];
    //[flexibleSpace release];
    
    
	// Do any additional setup after loading the view.
    /*
    NSString *fullURL = @"http://conecode.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_viewWeb loadRequest:requestObj];
    */
    
    /*
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"2011_crm_approvedprog_definition" ofType:@"htm"];
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    //[_webView setBackgroundColor:[UIColor clearColor]];
    //[_webView setOpaque:NO];
    NSString *htmlBody = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF16StringEncoding error:nil];
    //htmlBody = [htmlBody stringByReplacingOccurrencesOfString:@"//marker_1//" withString:NSLocalizedString(@"localizedKey_1", nil)];
    //htmlBody = [htmlBody stringByReplacingOccurrencesOfString:@"//marker_2//" withString:NSLocalizedString(@"localizedKey_2", nil)];
    //htmlBody = [htmlBody stringByReplacingOccurrencesOfString:@"//marker_3//" withString:NSLocalizedString(@"localizedKey_3", nil)];
    [_viewWeb loadHTMLString:htmlBody baseURL:baseURL];
    */

    /*
    // Create new view
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0,768,200)];
    
    // Add to scrollView so that the added view scrolls with the UIWebView
    [webView.scrollView addSubview:view];
    */
    
    //self.htmlString=@"<html><head></head><body>This is a test page!<br><br><a href='IMG_0412.JPG' target='_blank'>image name</a></p></body></html>";

    if(self.drugName.length==0) self.htmlString=@"<html><head></head><body>No drug is selected!</body></html>";
    else
    {
        self.title =self.drugName;
        self.htmlString=[PGDataManager getContent:self.drugName];
        //self.htmlString=@"<html><head></head><body>No drug is selected!</body></html>";
        NSLog(@"self.drugName: %@", self.drugName);
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *item1 = @"";
        NSString *item2 = @"";
        NSString *item3 = @"";
        //NSInteger index = 0;
        
        if ([defaults objectForKey:@"NEISHORTCUTITEMS1"]!=nil)
        {
            item1=[defaults stringForKey:@"NEISHORTCUTITEMS1"];
        }
        if ([defaults objectForKey:@"NEISHORTCUTITEMS2"]!=nil)
        {
            item2=[defaults stringForKey:@"NEISHORTCUTITEMS2"];
        }
        if ([defaults objectForKey:@"NEISHORTCUTITEMS3"]!=nil)
        {
            item3=[defaults stringForKey:@"NEISHORTCUTITEMS3"];
        }
        
        if(![self.drugName isEqualToString:item1] && ![self.drugName isEqualToString:item2] && ![self.drugName isEqualToString:item3])
        {
            [defaults setObject:self.drugName forKey:@"NEISHORTCUTITEMS1"];
            [defaults setObject:item1 forKey:@"NEISHORTCUTITEMS2"];
            [defaults setObject:item2 forKey:@"NEISHORTCUTITEMS3"];
        }
        
        /*if(self.drugName!=item1 && self.drugName!=item2 && self.drugName!=item3)
        {
            if ([defaults integerForKey:@"NEISHORTCUTITEMSINDEX"])
            {
                index=[defaults integerForKey:@"NEISHORTCUTITEMSINDEX"];
                if(index==1)
                {
                    item2=self.drugName;
                    [defaults setObject:item2 forKey:@"NEISHORTCUTITEMS2"];
                    index = 2;
                }
                else if(index==2)
                {
                    item3=self.drugName;
                    [defaults setObject:item3 forKey:@"NEISHORTCUTITEMS3"];
                    index = 3;
                }
                else if(index==3)
                {
                    item1=self.drugName;
                    [defaults setObject:item1 forKey:@"NEISHORTCUTITEMS1"];
                    index = 1;
                }
                [defaults setInteger:index forKey:@"NEISHORTCUTITEMSINDEX"];
            }
            else
            {
                [defaults setInteger:1 forKey:@"NEISHORTCUTITEMSINDEX"];
                item1=self.drugName;
                [defaults setObject:item1 forKey:@"NEISHORTCUTITEMS1"];
            }
        }*/
        

        /*NSMutableArray *valueArray = [[NSMutableArray alloc] init];
        if ([defaults objectForKey:@"NEISHORTCUTITEMS"]!=nil)
        {
            NSMutableArray *valueArray = [defaults mutableArrayValueForKey:@"NEISHORTCUTITEMS"];
            [defaults removeObjectForKey:@"NEISHORTCUTITEMS"];
            if(valueArray.count==1)
            {
                if(self.drugName!=valueArray[0])
                {
                    [valueArray addObject:self.drugName];
                    [defaults setObject:valueArray forKey:@"NEISHORTCUTITEMS"];
                }
            }
            else if (valueArray.count==2)
            {
                if(self.drugName!=valueArray[0] && self.drugName!=valueArray[1])
                {
                    [valueArray addObject:self.drugName];
                    [defaults setObject:valueArray forKey:@"NEISHORTCUTITEMS"];
                }
            }
            else{
                NSLog(@"valueArray.count: %lu", (unsigned long)valueArray.count);
                NSLog(@"valueArray.count: %@", valueArray[0]);
                NSLog(@"valueArray.count: %@", valueArray[1]);
                NSLog(@"valueArray.count: %@", valueArray[2]);
                if(self.drugName!=valueArray[0] && self.drugName!=valueArray[1] && self.drugName!=valueArray[2])
                {
                    [valueArray insertObject:self.drugName atIndex:0];
                    [valueArray removeLastObject];
                    [defaults setObject:valueArray forKey:@"NEISHORTCUTITEMS"];
                }

            }
        }
        else{
            
            [valueArray addObject:self.drugName];
            [defaults setObject:valueArray forKey:@"NEISHORTCUTITEMS"];
        }
        [defaults synchronize];
        */
        
    }
    //NSLog(@"self.htmlString: %@", self.htmlString);
    
    //UIbar
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Look up by drug Name" style:UIBarButtonItemStyleBordered target:self action:@selector(nextView:)];
    //self.navigationItem.rightBarButtonItem = rightButton;
    
    
    /*
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"ACID.htm"];
    BOOL success = [fileMgr fileExistsAtPath:dbPath];
     NSLog(@"acid file '%@'.", dbPath);
    if(!success)
    {
        NSLog(@"Cannot locate acid file '%@'.", dbPath);
    }
    */
    //NSString *html = @"<html><head></head><body>The Meaning of Life<p>...really is <b>42</b>!</p></body></html>";
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [_viewWeb loadHTMLString:self.htmlString baseURL:baseURL];
    baseURL = nil;
    path = nil;
    //[_viewWeb loadHTMLString:self.htmlString baseURL:nil];
    
    
    
    //[_viewWeb loadHTMLString:self.htmlString baseURL:nil];
    //[_viewWeb loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.htmlString ofType:@"htm"]isDirectory:NO]]];
    [_viewWeb setDelegate:self];
    //self.htmlString=nil;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.drugName;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.title = nil;
    //_viewWeb=nil;
    _htmlString=nil;
    //_drugName=nil;
    [super viewWillDisappear:animated];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)nextView:(id)sender
{
    //UIViewController* myViewController = [[UIViewController alloc] init];
    //[[self navigationController] pushViewController:myViewController];
    
    UINavigationController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Test"];
    //UINavigationController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    
    
    PGMasterViewController *vc = (PGMasterViewController *)[newTopViewController topViewController];
    [vc setMasterItem:self.drugName];
    
    self.slidingViewController.topViewController = newTopViewController;
    vc= nil;
    newTopViewController=nil;
    //[self.slidingViewController ];
    //self.slidingViewController.newTopViewController = newTopViewController;
    //wrong: [[self navigationController] pushViewController:vc];
}

/*ios UIWebView  show different section
-(void)viewDidAppear:(BOOL)animated
{
    
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://stackoverflow.com/questions/13716234/how-to-load-only-a-specific-section-of-a-requested-uiwebview-url"] encoding:NSASCIIStringEncoding error:nil];
    
    NSLog(@"CNN String is %@",string);
    
    
    [self.wv loadHTMLString:string baseURL:nil];
    
    [self.wv setDelegate:self];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    NSString *testString = [self.wv stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"nav-tags\").innerHTML;"];
    
    NSLog(@"Test String is %@",testString);
}
*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    
    NSLog(@"request: %@", request.URL.relativePath);
    NSString *url = request.URL.absoluteString;
    NSLog(@"url: %@", url);
    
    // if we are selecting start or end time...
    if (([url rangeOfString:@".jpg"].location != NSNotFound) || ([url rangeOfString:@".png"].location != NSNotFound) || ([url rangeOfString:@".gif"].location != NSNotFound))
    {
        url=nil;
        // 2. we're loading it and have already created it, etc. so just let it load
        if (wvPopUp)
            return YES;
        
        // 1. we have a 'popup' request - create the new view and display it
        //UIWebView *wv =
        
        // Add to windows array and make active window
        wvPopUp = [self popUpWebview];
        [wvPopUp loadRequest:request];
        wvPopUp.autoresizingMask =UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        //imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self.view addSubview:wvPopUp];
        return NO;
    }
    url=nil;
    return YES;
}

- (UIWebView *) popUpWebview
{
    // Create a web view that fills the entire window, minus the toolbar height
    UIWebView *webView = [[UIWebView alloc]
                          initWithFrame:CGRectMake((float)self.view.bounds.origin.x, (float)self.view.bounds.origin.y, (float)self.view.bounds.size.width,
                                                   (float)self.view.bounds.size.height)];
    webView.scalesPageToFit = YES;
    webView.delegate = self;

    UIButton *acceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    acceptButton.frame = CGRectMake(0, 0, 22, 22);
    //[acceptButton setTitle:@"Close" forState:UIControlStateNormal];
    [acceptButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [acceptButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [webView.scrollView  addSubview:acceptButton];
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    return webView;
    
    /*
     UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     myView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
     myView.tag = 12345;
     [self.view addSubview:myView];
     
     UIButton *acceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     acceptButton.frame = CGRectMake(0, 0, 100, 44);
     [acceptButton setTitle:@"Click Me!" forState:UIControlStateNormal];
     [acceptButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
     [myView addSubview:acceptButton];
     */
}

- (void)buttonClicked{
    [wvPopUp removeFromSuperview];
    //[wvPopUp stopLoading];
    wvPopUp = nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //[_viewWeb sizeToFit];
    //[_viewWeb setFrame:CGRectMake(_viewWeb.frame.origin.x, _viewWeb.frame.origin.y, 300.0, _viewWeb.frame.size.height)];
    //detailsWebView.scrollView.contentSize = CGSizeMake(detailsWebView.scrollView.contentSize.width,[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]);
    
//[webView stringByEvaluatingJavaScriptFromString:@"window.location.hash='#CNS'"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"showContent\").style.display=\"none\";"];
    
    ///NSString *testString = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"showContent\").innerHTML;"];
    //NSLog(@"Test String is %@",testString);
    
    /*
    NSScanner* scanner = [NSScanner scannerWithString:yourHTML];
    while ([scanner scanUpToString:@"a href='" intoString:nil])
    {
        [scanner scanString:@"a href='" intoString:nil];
        NSString* result = nil;
        [scanner scanUpToString:@"'" intoString:&result];
        //Do something with result, which will equal 001, then 002, etc.
    }
     */
    // this is a pop-up window
    /*if (wvPopUp)
    {
        NSLog(@"web finish loading");
        // overwrite the 'window.close' to be a 'back://' URL (see above)
        NSError *error = nil;
        NSString *jsFromFile = [NSString stringWithContentsOfURL:[[NSBundle mainBundle]
                                                                  URLForResource:@"JS2" withExtension:@"txt"]
                                                        encoding:NSUTF8StringEncoding error:&error];
        __unused NSString *jsOverrides = [webView
                                          stringByEvaluatingJavaScriptFromString:jsFromFile];    
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMenuItem:(NSString *)newString
{
    //[self.viewWeb setNeedsDisplay];
    NSString *loadString =[NSString stringWithFormat:@"%@%@%@", @"window.location.hash='#",newString,@"'"];
    //[self.viewWeb reload];
    
    [self.viewWeb stringByEvaluatingJavaScriptFromString:loadString];
    NSLog(@"Test String is %@",loadString);
    loadString=nil;
}
- (void)setDrug:(NSString *)newString
{
    
    //NSLog(@"newString is %@",newString);
    _drugName = [PGDataManager getGenericDrugName:newString];
    //NSLog(@"_htmlString is %@",_htmlString);
    if (self.drugPopoverController != nil) {
        [self.drugPopoverController dismissPopoverAnimated:YES];
    }
    //NSString *htmlString =[NSString stringWithFormat:@"%@%@%@", @"window.location.hash='#",newString,@"'"];
}
- (void)setGenericDrug:(NSString *)newString
{
    
    _drugName = newString;
    //NSLog(@"_htmlString is %@",_htmlString);
    if (self.drugPopoverController != nil) {
        [self.drugPopoverController dismissPopoverAnimated:YES];
    }
    //NSString *htmlString =[NSString stringWithFormat:@"%@%@%@", @"window.location.hash='#",newString,@"'"];
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Drug", @"Drug");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.drugPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.drugPopoverController = nil;
}
- (IBAction)naviagationPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        PGMasterViewController *vc = [segue destinationViewController];
        [vc setMasterItem:self.drugName];
}
@end
