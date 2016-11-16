//
//  PGMasterViewController.h
//  NEIPG
//
//  Created by Yaogeng Cheng on 11/7/13.
//  Copyright (c) 2013 Yaogeng Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#import <sqlite3.h>


@class PGDetailViewController;

@interface PGMasterViewController : UITableViewController

//- (NSMutableArray *) getMyWines;

//@property (strong, nonatomic) UIButton *menuBtn;

@property (nonatomic, copy) NSString *drugName;
@property (strong, nonatomic) PGDetailViewController *detailViewController;
- (void)setMasterItem:(NSString *)newString;

@end
