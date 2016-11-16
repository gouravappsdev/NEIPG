//
//  PGWebViewController.h
//  NEIPG
//
//  Created by Yaogeng Cheng on 12/3/13.
//  Copyright (c) 2013 Yaogeng Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGWebViewController : UIViewController <UIWebViewDelegate, UISplitViewControllerDelegate>
{
UIWebView *wvPopUp;
}
@property (nonatomic, copy) NSString *htmlString;
@property (nonatomic, copy) NSString *drugName;


- (IBAction)naviagationPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *viewWeb;
- (void)setMenuItem:(NSString *)newString;
- (void)setDrug:(NSString *)newString;
- (void)setGenericDrug:(NSString *)newString;
@end
