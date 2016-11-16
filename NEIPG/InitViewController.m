//
//  InitViewController.m
//  SlideMenu
//
//  Created by Kyle Begeman on 1/13/13.
//  Copyright (c) 2013 Indee Box LLC. All rights reserved.
//

#import "InitViewController.h"
//for other transition
#import "MEDynamicTransition.h"
#import "METransitions.h"
#import "PGLoginViewController.h"
#import "AutoCompleteTextFieldViewController.h"
//for other transition end
#import "KeychainItemWrapper.h"

@interface InitViewController (){
    KeychainItemWrapper *keychainItem;
}

//**********************for other transition
@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
//**********************for other transition end

@end

@implementation InitViewController

//**********************for other transition
- (METransitions *)transitions {
    if (_transitions) return _transitions;
    
    _transitions = [[METransitions alloc] init];
    
    return _transitions;
}
- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name = %@", METransitionNameDynamic];
    NSArray *transitionsData = [self.transitions.all filteredArrayUsingPredicate:namePredicate];
    MEDynamicTransition *dynamicTransition = transitionsData[0][@"transition"];
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}
//**********************for other transition end

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
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    self.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    
    //**********************for other transition
    NSDictionary *transitionData = self.transitions.all[0];
    id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
    if (transition == (id)[NSNull null]) {
        self.delegate = nil;
    } else {
        self.delegate = transition;
    }
    
    NSString *transitionName = transitionData[@"name"];
    if ([transitionName isEqualToString:METransitionNameDynamic]) {
        MEDynamicTransition *dynamicTransition = (MEDynamicTransition *)transition;
        dynamicTransition.slidingViewController = self;
        
        self.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
        self.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
        [self.navigationController.view removeGestureRecognizer:self.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    } else {
        self.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
        self.customAnchoredGestures = @[];
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.panGesture];
    }
    //**********************for other transition end
    /**********************
    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"NEIPG" accessGroup:nil];
    
    //For QA login and disclaimer
    //[keychainItem resetKeychainItem];
    
    NSDate *lastdate = [keychainItem objectForKey:(__bridge id)kSecAttrModificationDate];
    NSDate *createdate = [keychainItem objectForKey:(__bridge id)kSecAttrCreationDate];
    NSLog(@"mod date: %@", lastdate);
    NSLog(@"creat date: %@", createdate);
    //NSLog(@"current date: %@", [NSDate date]);
    if(createdate != nil && lastdate!=nil){
        NSDate * then = lastdate;
        NSDate * now = [NSDate date];
        
        NSTimeInterval secondsBetween = [now timeIntervalSinceDate:then];
        int numberOfDays = secondsBetween / 86400;
        //For QA login and disclaimer
        //if(numberOfDays>=0)
        if(numberOfDays>31)
        {
            PGLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [self presentViewController:loginViewController animated:NO completion:nil];
            
        }
    }
    else{
        PGLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self presentViewController:loginViewController animated:NO completion:nil];
        
    }
    ************************/
    //************************
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMasterItem:(NSString *)newString
{
    _memberStatus = newString;
}
- (void)setShortCutItem:(NSString *)newString
{
    _shortCutItem = newString;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Do other viewWillAppear stuff...
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    
    // Do other viewWillDisappear stuff...
    
    [super viewWillDisappear:animated];
}


/*
 You cannot present another view as long as the dismissing of your 1st view is not complete. The animation of dismissing view should be completed before presenting new view. So, either you can set its animation to NO while dismissing, or use  performSelector:withObject:afterDelay: and present the next view after 2-3 seconds.
 */
- (void)applicationDidBecomeActive
{
    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"NEIPG" accessGroup:nil];
    
    //For QA login and disclaimer
    //[keychainItem resetKeychainItem];
    
    NSDate *lastdate = [keychainItem objectForKey:(__bridge id)kSecAttrModificationDate];
    NSDate *createdate = [keychainItem objectForKey:(__bridge id)kSecAttrCreationDate];
    //NSData *passData = [keychainItem objectForKey:(__bridge id)kSecValueData];
    //NSData *userName = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    
    NSString *encryptusername=[keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    
    NSLog(@"mod date: %@", lastdate);
    NSLog(@"creat date: %@", createdate);
    NSLog(@"encryptusername: %@", encryptusername);
    //NSLog(@"current date: %@", [NSDate date]);
    if(createdate != nil && lastdate!=nil && (encryptusername != nil && encryptusername.length>0)){
    //if(createdate != nil && lastdate!=nil){
        NSDate * then = lastdate;
        NSDate * now = [NSDate date];
        
        NSTimeInterval secondsBetween = [now timeIntervalSinceDate:then];
        int numberOfDays = secondsBetween / 86400;
        //For QA login and disclaimer
        //if(numberOfDays>=0)
        if(numberOfDays>31)
        {
            PGLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [self presentViewController:loginViewController animated:NO completion:nil];

        }
    }
    else{
        PGLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self presentViewController:loginViewController animated:NO completion:nil];

    }
    
    //NSLog(@"_shortCutItem: %@", _shortCutItem);
    if(_shortCutItem.length>0)
    {
        [self handleDynamicShortcutItem];
        _shortCutItem = @"";
    }
    
 }

- (void)handleDynamicShortcutItem {
    UINavigationController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    if ([_shortCutItem isEqualToString:@"Search"]) {
        self.topViewController = newTopViewController;
    }
    else{
        self.topViewController = newTopViewController;
        AutoCompleteTextFieldViewController *vc = (AutoCompleteTextFieldViewController *)newTopViewController.topViewController;
        [vc setShortCutItemDrug:_shortCutItem];
        [vc performSegueWithIdentifier:@"showDrug" sender:vc];
    }
    
}
- (IBAction)unwindFromLogin:(UIStoryboardSegue *)segue
{
    NSLog(@"unwindFromLogin current date000: %@", [NSDate date]);
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
@end
