//
//  PGDetailViewController.h
//  NEIPG
//
//  Created by Yaogeng Cheng on 11/7/13.
//  Copyright (c) 2013 Yaogeng Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGDetailViewController : UITableViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) NSMutableDictionary *objects;
//Holds our data.
@property (strong, nonatomic) NSMutableDictionary *names;
//Holds the sections sorted in alphabetical order.
@property (strong, nonatomic) NSArray *keys;

//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
