//
//  AutoCompleteTextFieldViewController.h
//  AutoCompleteTextField
//
//  Created by Andrew Wimpy on 2/28/11.
//  Copyright 2011 nextPression. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoCompleteIndicationViewController : UIViewController <UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource> {
	NSMutableArray *autoCompleteArray; 
	NSMutableArray *elementArray, *lowerCaseElementArray;
	UITextField *txtField;
	UITableView *autoCompleteTableView;
    float tableHeight;
    float barHeightP;
    float barHeightL;
}
//@property (strong, nonatomic) UIButton *menuBtn;

//@property (strong, nonatomic) UIButton *searchBtn;
-(void) keyboardWillHide:(NSNotification *)note;
-(void) keyboardWillShow:(NSNotification *)note;

- (IBAction)unwindFromDisclaimertoHome:(UIStoryboardSegue *)segue;
@end

