//
//  PGLoginViewController.h
//  NEIPG
//
//  Created by Yaogeng Cheng on 11/12/13.
//  Copyright (c) 2013 Yaogeng Cheng. All rights reserved.
//
/*
If you want rounded corners just ctrl-drag from the button to your .h file, call it something like roundedButton and add this in your viewDidLoad:

CALayer *btnLayer = [roundedButton layer];
[btnLayer setMasksToBounds:YES];
[btnLayer setCornerRadius:5.0f];
*/
#import <UIKit/UIKit.h>

//@class PGMasterViewController;
@class InitViewController;
NSMutableData *myWebData;
NSXMLParser *myXMLParser;
NSMutableString *currentElementValue;
@interface PGLoginViewController : UIViewController <UITextFieldDelegate, NSXMLParserDelegate, UIScrollViewDelegate>

- (NSString *)encryptString:(NSString *) inStr;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *errorMsg;
@property (weak, nonatomic) IBOutlet UIButton *signIn;

@property (weak, nonatomic) IBOutlet UIScrollView *myscrooview;
//@property (weak, nonatomic) IBOutlet UIImageView *myImage;
- (IBAction)forgotPasswordPressed:(id)sender;

- (IBAction)unwindFromDisclaimer:(UIStoryboardSegue *)segue;

//- (IBAction)unwindFromDisagree:(UIStoryboardSegue *)segue;

@end
