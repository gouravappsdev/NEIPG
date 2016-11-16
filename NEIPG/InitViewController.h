//
//  InitViewController.h
//  SlideMenu
//
//  Created by Kyle Begeman on 1/13/13.
//  Copyright (c) 2013 Indee Box LLC. All rights reserved.
//

#import "ECSlidingViewController.h"

@interface InitViewController : ECSlidingViewController
@property (nonatomic, copy) NSString *memberStatus;
- (void)setMasterItem:(NSString *)newString;

@property (nonatomic, copy) NSString *shortCutItem;
- (void)setShortCutItem:(NSString *)newString;
- (void)handleDynamicShortcutItem;

- (IBAction)unwindFromLogin:(UIStoryboardSegue *)segue;
@end
