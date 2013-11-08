//
//  PGMasterViewController.h
//  NEIPG
//
//  Created by Yaogeng Cheng on 11/7/13.
//  Copyright (c) 2013 Yaogeng Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGDetailViewController;

@interface PGMasterViewController : UITableViewController

@property (strong, nonatomic) PGDetailViewController *detailViewController;

@end
