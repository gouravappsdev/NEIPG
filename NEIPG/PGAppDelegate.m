//
//  PGAppDelegate.m
//  NEIPG
//
//  Created by Yaogeng Cheng on 11/7/13.
//  Copyright (c) 2013 Yaogeng Cheng. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "PGAppDelegate.h"
#import "InitViewController.h"
@implementation PGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
     NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
     if ([[ver objectAtIndex:0] intValue] >= 7) {
     self.navigationController.navigationBar.barTintColor = [UIColor redColor];
     self.navigationController.navigationBar.translucent = NO;
     }else {
     self.navigationController.navigationBar.tintColor = [UIColor redColor];
     }
     */
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xE0E0E0)];
    [[UIToolbar appearance] setBarTintColor:UIColorFromRGB(0xE0E0E0)];
    [self createDynamicShortcutItems];
    //NSLog(@"current date 1 : %@", [NSDate date]);
    // Override point for customization after application launch.
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
     NSLog(@"current date 1.1: %@", [NSDate date]);
     //UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
     //UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
     //splitViewController.delegate = (id)navigationController.topViewController;
     }*/
    return YES;
}

- (void)createDynamicShortcutItems {
    //https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIApplicationShortcutIcon_Class/#//apple_ref/c/tdef/UIApplicationShortcutIconType
    /*
     typedef enum UIApplicationShortcutIconType : NSInteger {
     UIApplicationShortcutIconTypeCompose,
     UIApplicationShortcutIconTypePlay,
     UIApplicationShortcutIconTypePause,
     UIApplicationShortcutIconTypeAdd,
     UIApplicationShortcutIconTypeLocation,
     UIApplicationShortcutIconTypeSearch,
     UIApplicationShortcutIconTypeShare,
     UIApplicationShortcutIconTypeProhibit,
     UIApplicationShortcutIconTypeContact,
     UIApplicationShortcutIconTypeHome,
     UIApplicationShortcutIconTypeMarkLocation,
     UIApplicationShortcutIconTypeFavorite,
     UIApplicationShortcutIconTypeLove,
     UIApplicationShortcutIconTypeCloud,
     UIApplicationShortcutIconTypeInvitation,
     UIApplicationShortcutIconTypeConfirmation,
     UIApplicationShortcutIconTypeMail,
     UIApplicationShortcutIconTypeMessage,
     UIApplicationShortcutIconTypeDate,
     UIApplicationShortcutIconTypeTime,
     UIApplicationShortcutIconTypeCapturePhoto,
     UIApplicationShortcutIconTypeCaptureVideo,
     UIApplicationShortcutIconTypeTask,
     UIApplicationShortcutIconTypeTaskCompleted,
     UIApplicationShortcutIconTypeAlarm,
     UIApplicationShortcutIconTypeBookmark,
     UIApplicationShortcutIconTypeShuffle,
     UIApplicationShortcutIconTypeAudio,
     UIApplicationShortcutIconTypeUpdate
     } UIApplicationShortcutIconType;
     */
    
    
    
    
    //if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NEISHORTCUTITEMS"]!=nil)
    //{
    /*NSMutableArray *valueArray = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"NEISHORTCUTITEMS"];
     NSMutableArray *items = [[NSMutableArray alloc] init];
     UIApplicationShortcutIcon * photoIcon = [UIApplicationShortcutIcon iconWithTemplateImageName: @"pk.png"]; // your customize icon
     NSLog(@"valueArray[0]: %@", valueArray[0]);
     UIApplicationShortcutItem * item1 = [[UIApplicationShortcutItem alloc]initWithType: @"NEIAPPSHORTCUT2" localizedTitle: valueArray[0] localizedSubtitle: nil icon: photoIcon userInfo: nil];
     [items addObject:item1];
     if(valueArray.count>1)
     {
     NSLog(@"valueArray[1]: %@", valueArray[1]);
     UIApplicationShortcutItem * item2 = [[UIApplicationShortcutItem alloc]initWithType: @"NEIAPPSHORTCUT3" localizedTitle: valueArray[1] localizedSubtitle: nil icon: photoIcon userInfo: nil];
     [items addObject:item2];
     if(valueArray.count>2){
     NSLog(@"valueArray[2]: %@", valueArray[2]);
     UIApplicationShortcutItem * item3 = [[UIApplicationShortcutItem alloc]initWithType: @"NEIAPPSHORTCUT4" localizedTitle: valueArray[2] localizedSubtitle: nil icon: photoIcon userInfo: nil];
     [items addObject:item3];
     }
     }*/
    
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    UIApplicationShortcutIcon * photoIcon = [UIApplicationShortcutIcon iconWithTemplateImageName: @"next-cal.gif"]; // your customize icon
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *sitem1 = @"";
    NSString *sitem2 = @"";
    NSString *sitem3 = @"";
    if ([defaults objectForKey:@"NEISHORTCUTITEMS1"]!=nil)
    {
        sitem1=[defaults stringForKey:@"NEISHORTCUTITEMS1"];
        if(sitem1.length>0){
            UIApplicationShortcutItem * item1 = [[UIApplicationShortcutItem alloc]initWithType: @"NEIAPPSHORTCUT2" localizedTitle: sitem1 localizedSubtitle: nil icon: photoIcon userInfo: nil];
            if(item1!=nil) [items addObject:item1];
        }
    }
    if ([defaults objectForKey:@"NEISHORTCUTITEMS2"]!=nil)
    {
        sitem2=[defaults stringForKey:@"NEISHORTCUTITEMS2"];
        if(sitem2.length>0){
            UIApplicationShortcutItem * item2 = [[UIApplicationShortcutItem alloc]initWithType: @"NEIAPPSHORTCUT3" localizedTitle: sitem2 localizedSubtitle: nil icon: photoIcon userInfo: nil];
            if(item2!=nil) [items addObject:item2];
        }
    }
    if ([defaults objectForKey:@"NEISHORTCUTITEMS3"]!=nil)
    {
        sitem3=[defaults stringForKey:@"NEISHORTCUTITEMS3"];
        if(sitem3.length>0){
            UIApplicationShortcutItem * item3 = [[UIApplicationShortcutItem alloc]initWithType: @"NEIAPPSHORTCUT4" localizedTitle: sitem3 localizedSubtitle: nil icon: photoIcon userInfo: nil];
            if(item3!=nil) [items addObject:item3];
        }
    }
    
    NSLog(@"sitem1: %@", sitem1);
    NSLog(@"sitem2: %@", sitem2);
    NSLog(@"sitem3: %@", sitem3);
    //UIApplicationShortcutItem * item1 = [[UIApplicationShortcutItem alloc]initWithType: @"NEIAPPSHORTCUT3" localizedTitle: @"Selfie" localizedSubtitle: @"take selfie" icon: photoIcon userInfo: nil];
    //UIApplicationShortcutItem * item2 = [[UIApplicationShortcutItem alloc]initWithType: @"NEIAPPSHORTCUT4" localizedTitle: @"Video" localizedSubtitle: nil icon: [UIApplicationShortcutIcon iconWithType: UIApplicationShortcutIconTypePause] userInfo: nil];
    
    
    // create several (dynamic) shortcut items
    //UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]initWithType:@"Item 1" localizedTitle:@"Item 1"];
    //UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc]initWithType:@"Item 2" localizedTitle:@"Item 2"];
    
    // add all items to an array
    //NSArray *items = @[item1, item2];
    
    if(items.count>0)
    {
        // add this array to the potentially existing static UIApplicationShortcutItems
        [UIApplication sharedApplication].shortcutItems = items;
    }
    
    
    /*NSArray *existingItems = [UIApplication sharedApplication].shortcutItems;
     NSLog(@"existingItems: %lu", (unsigned long)existingItems.count);
     
     
     NSArray *updatedItems = [existingItems arrayByAddingObjectsFromArray:items];
     NSLog(@"updatedItems: %lu", (unsigned long)updatedItems.count);
     
     [UIApplication sharedApplication].shortcutItems = updatedItems;*/
    //}
}
/*
 @interface ViewController () <UIViewControllerPreviewingDelegate>
 @property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
 
 - (void)check3DTouch {
 
 // register for 3D Touch (if available)
 if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
 
 [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
 NSLog(@"3D Touch is available! Hurra!");
 
 // no need for our alternative anymore
 self.longPress.enabled = NO;
 
 } else {
 
 NSLog(@"3D Touch is not available on this device. Sniff!");
 
 // handle a 3D Touch alternative (long gesture recognizer)
 self.longPress.enabled = YES;
 
 }
 }
 
 - (UILongPressGestureRecognizer *)longPress {
 
 if (!_longPress) {
 _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showPeek)];
 [self.view addGestureRecognizer:_longPress];
 }
 return _longPress;
 }
 */


/*
 Called when the user activates your application by selecting a shortcut on the home screen, except when
 application(_:,willFinishLaunchingWithOptions:) or application(_:didFinishLaunchingWithOptions) returns `false`.
 You should handle the shortcut in those callbacks and return `false` if possible. If return true, this
 callback is used if your application is already launched in the background.
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    //UINavigationController *nav = (UINavigationController *) self.tabBarController.selectedViewController;
    
    //UIViewController *splitViewController = (UIViewController *)self.window.rootViewController;
    InitViewController *vc = (InitViewController *)self.window.rootViewController;
    [vc setShortCutItem:shortcutItem.localizedTitle];
    /*NSLog(@"%@", shortcutItem.localizedTitle);
     if ([shortcutItem.type isEqualToString:@"NEIAPPSHORTCUT1"]) {
     
     }
     if ([shortcutItem.type isEqualToString:@"NEIAPPSHORTCUT2"]) {
     
     NSLog(@"An exception occured: %@", shortcutItem.localizedTitle);
     
     }
     
     if ([shortcutItem.type isEqualToString:@"NEIAPPSHORTCUT3"]) {
     
     NSLog(@"An exception occured: %@", shortcutItem.localizedTitle);
     
     }
     
     if ([shortcutItem.type isEqualToString:@"NEIAPPSHORTCUT4"]) {
     
     NSLog(@"An exception occured: %@", shortcutItem.localizedTitle);
     
     }*/
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //NSLog(@"current date 2 : %@", [NSDate date]);
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self createDynamicShortcutItems];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //NSLog(@"current date 3 : %@", [NSDate date]);
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //NSLog(@"current date 4 : %@", [NSDate date]);
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
/*
 When waking up i.e. relaunching an app (either through springboard, app switching or URL) applicationWillEnterForeground: is called. It is only executed once when the app becomes ready for use, after being put into the background, while applicationDidBecomeActive: may be called multiple times after launch. This makes applicationWillEnterForeground: ideal for setup that needs to occur just once after relaunch.
 
 applicationWillEnterForeground: is called:
 
 when app is relaunched
 before applicationDidBecomeActive:
 applicationDidBecomeActive: is called:
 
 when app is first launched after application:didFinishLaunchingWithOptions:
 after applicationWillEnterForeground: if there's no URL to handle.
 after application:handleOpenURL: is called.
 after applicationWillResignActive: if user ignores interruption like a phone call or SMS.
 applicationWillResignActive: is called:
 
 when there is an interruption like a phone call.
 if user takes call applicationDidEnterBackground: is called.
 if user ignores call applicationDidBecomeActive: is called.
 when the home button is pressed or user switches apps.
 docs say you should
 pause ongoing tasks
 disable timers
 pause a game
 reduce OpenGL frame rates
 applicationDidEnterBackground: is called:
 
 after applicationWillResignActive:
 docs say you should:
 release shared resources
 save user data
 invalidate timers
 save app state so you can restore it if app is terminated.
 disable UI updates
 you have 5 seconds to do what you need to and return the method
 if you dont return within ~5 seconds the app is terminated.
 you can ask for more time with beginBackgroundTaskWithExpirationHandler:
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NEIAppLaunchCount"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:([[NSUserDefaults standardUserDefaults] integerForKey:@"NEIAppLaunchCount"] + 1) forKey:@"NEIAppLaunchCount"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"NEIAppLaunchCount"];
    }
    
    NSLog(@"launch times : %li", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"NEIAppLaunchCount"]);
    
    //NSLog(@"current date 5 : %@", [NSDate date]);
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //NSLog(@"current date 6: %@", [NSDate date]);
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
