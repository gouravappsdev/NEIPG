//
//  AutoCompleteTextFieldViewController.h
//  AutoCompleteTextField
//
//  Created by Andrew Wimpy on 2/28/11.
//  Copyright 2011 nextPression. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoCompleteTextFieldViewController : UIViewController <UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource> {
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

//- (IBAction)textFieldDidBeginEditing:(UITextField *)textField;
//- (IBAction)textFieldDidEndEditing:(UITextField *)textField;
@property (nonatomic, copy) NSString *shortCutItemDrug;
- (void)setShortCutItemDrug:(NSString *)newString;

-(void) keyboardWillHide:(NSNotification *)note;
-(void) keyboardWillShow:(NSNotification *)note;

- (IBAction)unwindFromDisclaimertoHome:(UIStoryboardSegue *)segue;
@end

