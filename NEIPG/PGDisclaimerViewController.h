//
//  PGDisclaimerViewController.h
//  NEIPG
//
//  Created by Yaogeng Cheng on 4/3/14.
//  Copyright (c) 2014 Yaogeng Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGDisclaimerViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *dWebView;
- (IBAction)disagreePressed:(id)sender;

@end
