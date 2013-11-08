//
//  PGDetailViewController.h
//  NEIPG
//
//  Created by Yaogeng Cheng on 11/7/13.
//  Copyright (c) 2013 Yaogeng Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
