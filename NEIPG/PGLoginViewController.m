//
//  PGLoginViewController.m
//  NEIPG
//
//  Created by Yaogeng Cheng on 11/12/13.
//  Copyright (c) 2013 Yaogeng Cheng. All rights reserved.
//

#import "PGLoginViewController.h"
#import "PGMasterViewController.h"
#import "InitViewController.h"
#import "MBProgressHUD.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "PGDataManager.h"
#import "KeychainItemWrapper.h"

#import "PGDisclaimerViewController.h"

@interface PGLoginViewController (){
    KeychainItemWrapper *keychainItem;
    NSString *encryptpassword;
    NSString *encryptusername;
}
@property NSString *loginStatus;
@property (weak, nonatomic) IBOutlet UIButton *roundbutton;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PGLoginViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CALayer *btnLayer = [_roundbutton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    

    self.email.layer.cornerRadius=8.0f;
    self.email.layer.masksToBounds=YES;
    self.email.layer.borderColor=[[UIColor blackColor]CGColor];
    self.email.layer.borderWidth= 1.0f;
    
    self.password.layer.cornerRadius=8.0f;
    self.password.layer.masksToBounds=YES;
    self.password.layer.borderColor=[[UIColor blackColor]CGColor];
    self.password.layer.borderWidth= 1.0f;
    /*
    NSString * _secret = @"ycheng1";
	NSString * _key = @"22515216714613359164620314164148123127244177";
	
	StringEncryption *crypto = [[StringEncryption alloc] init];
	NSData *_secretData = [_secret dataUsingEncoding:NSUTF8StringEncoding];
	CCOptions padding = kCCOptionPKCS7Padding;
	NSData *encryptedData = [crypto encrypt:_secretData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
	
	NSLog(@"encrypted data string for export: %@",[encryptedData base64EncodingWithLineLength:0]);
    */
	// Do any additional setup after loading the view.
    
    
    
    // 1
    //UIImage *image = [UIImage imageNamed:@"IMG_0412.JPG"];
    //self.imageView = [[UIImageView alloc] initWithImage:image];
    //self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    //[self.myscrooview addSubview:self.imageView];
    
    //self.myImage.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    //[self.myscrooview addSubview:self.myImage];
    // 2
    //self.myscrooview.contentSize = image.size;

}

- (void)viewWillAppear:(BOOL)animated {
    
    /*UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        NSLog(@"screenWidth: %f", screenWidth);
        NSLog(@"screenHeight: %f", screenHeight);
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"screenWidth: %f", screenWidth);
        NSLog(@"screenHeight: %f", screenHeight);
    }
    */
    
    //self.myscrooview.contentSize=CGSizeMake(320, 400);
    [super viewWillAppear:YES];
    
/*
    CGRect scrollViewFrame = self.myscrooview.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.myscrooview.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.myscrooview.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.myscrooview.minimumZoomScale = minScale;
    self.myscrooview.maximumZoomScale = 1.0f;
    self.myscrooview.zoomScale = minScale;*/
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*CGRect viewFrame = self.myscrooview.frame;
    viewFrame.size.height -= 100;
    self.myscrooview.frame = viewFrame;*/
    
    //StringEncryption *crypto = [[StringEncryption alloc] init];
    //[crypto testSymmetricEncryption];
    
    
    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"NEIPG" accessGroup:nil];
    NSData *passData = [keychainItem objectForKey:(__bridge id)kSecValueData];
    encryptpassword = [[NSString alloc] initWithBytes:[passData bytes] length:[passData length] encoding:NSUTF8StringEncoding];
    
    encryptusername = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    NSDate *lastdate = [keychainItem objectForKey:(__bridge id)kSecAttrModificationDate];
    NSDate *createdate = [keychainItem objectForKey:(__bridge id)kSecAttrCreationDate];
    
    NSLog(@"encryptpassword: %@", encryptpassword);
    NSLog(@"encryptusername: %@", encryptusername);
    NSLog(@"mod date: %@", lastdate);
    NSLog(@"creat date: %@", createdate);
    //NSLog(@"mod date: %@", lastdate);
    //NSLog(@"creat date: %@", createdate);
    
    //if(false){
    if(createdate != nil && lastdate!=nil){
        /*
         NSDateFormatter *df= [[NSDateFormatter alloc] init];
         [df setDateFormat:@"yyyy-MM-dd"];
         NSDate *dt1 = [[NSDate alloc] init];
         NSDate *dt2 = [[NSDate alloc] init];
         dt1=[df dateFromString:@"2011-02-25"];
         dt2=[df dateFromString:@"2011-03-25"];
         NSComparisonResult result = [dt1 compare:dt2];
         switch (result)
         {
         case NSOrderedAscending: NSLog(@"%@ is greater than %@", dt2, dt1); break;
         case NSOrderedDescending: NSLog(@"%@ is less %@", dt2, dt1); break;
         case NSOrderedSame: NSLog(@"%@ is equal to %@", dt2, dt1); break;
         default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
         }
         
         NSDateFormatter *df= [[NSDateFormatter alloc] init];
         [df setDateFormat:@"yyyy-MM-dd"];
         yyyy-MM-dd HH:mm:ss
         NSDate *dt1 = [[NSDate alloc] init];
         NSDate *dt2 = [[NSDate alloc] init];
         dt1=[df dateFromString:@"2014-02-10"];
         dt2=[df dateFromString:@"2010-01-03"];
         NSTimeInterval secondsBetween = [dt2 timeIntervalSinceDate:dt1];
         int numberOfDays = secondsBetween / 86400;
         NSLog(@"There are %d days in between the two dates.", numberOfDays);
         */
        
        
        //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat: @"yyyy-MM-dd"];
        //NSDate * then = [dateFormatter dateFromString:lastdate];
        //auto log in
        
        //[self logIn:encryptusername:encryptpassword];
        if(encryptusername != nil && encryptusername.length>0){
            //encryptpassword = @"11";
            self.password.text = encryptpassword;
            self.email.text = encryptusername;
            //[self.signIn sendActionsForControlEvents:UIControlEventTouchUpInside];
            [self logIn:encryptusername:encryptpassword];
        }
        
    }
    else{
        PGDisclaimerViewController *dViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"disclaimer"];
        [self presentViewController:dViewController animated:NO completion:nil];
    }
    
    

}
/*- (void)centerScrollViewContents {
    CGSize boundsSize = self.myscrooview.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}*/
- (IBAction)forgotPasswordPressed:(id)sender {
    
    if ([self.email.text length] ) {
        
        if(![self emailValidation:self.email.text])
        {
            self.errorMsg.text = @"Invalid email address.";
        }
        else{
            [currentElementValue setString:@""];
            NSString *soapMessage=[NSString stringWithFormat:@"%@%@%@", @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                   "<soap:Body>\n"
                                   "<requestPassword xmlns=\"http://www.neiglobal.com/\" >\n"
                                   "<email>", self.email.text, @"</email>\n"
                                   "</requestPassword>\n"
                                   "</soap:Body>\n"
                                   "</soap:Envelope>"];
            NSLog(@"esoapMessage: %@",soapMessage);
            // create a url to your asp.net web service.
            //NSURL *tmpURl=[NSURL URLWithString:[NSString stringWithFormat:@"http://wca4lxrcp1/NEIWebServices/Service1.asmx"]];
            NSURL *tmpURl=[NSURL URLWithString:[NSString stringWithFormat:@"https://nws.neiglobal.com/Service1.asmx"]];
            
            // create a request to your asp.net web service.
            NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:tmpURl];
            
            // add http content type - to your request
            [theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            
            // add  SOAPAction - webMethod that is going to be called
            [theRequest addValue:@"http://www.neiglobal.com/requestPassword" forHTTPHeaderField:@"SOAPAction"];
            
            // count your soap message lenght - which is required to be added in your request
            NSString *msgLength=[NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
            // add content length
            [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
            
            // set method - post
            [theRequest setHTTPMethod:@"POST"];
            
            // set http request - body
            [theRequest setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
            
            // establish connection with your request & here delegate is self, so you need to implement connection's methods
            NSURLConnection *con=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
            
            // if connection is established
            if(con)
            {
                myWebData=[NSMutableData data];
                // here -> NSMutableData *myWebData; -> declared in .h file
            }
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Requesting password...";
        }
    }
    else
    {
        self.errorMsg.text = @"Enter email address.";
    }

}

- (IBAction)unwindFromDisclaimer:(UIStoryboardSegue *)segue
{
    [keychainItem setObject:[NSDate date] forKey:(__bridge id)kSecAttrModificationDate];

    NSLog(@"unwindFromDisclaimer current date000: %@", [NSDate date]);
    
    //the following code caused trouble in 6s. It will close login view too.
    /*if (![self.presentedViewController isBeingDismissed])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }*/
    
    
    // Do something after unwinding
    //[self dismissViewControllerAnimated:YES completion:NULL];
    /*[self dismissViewControllerAnimated:YES completion:^{
     [(UINavigationController *)self.presentingViewController popToRootViewControllerAnimated:YES];
     }];*/
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)encryptString:(NSString *) inStr{
    NSString * _secret = inStr;
    NSString * _key = @"22515216714613359164620314164148123127244177";
    StringEncryption *crypto = [[StringEncryption alloc] init];
    NSData *_secretData = [_secret dataUsingEncoding:NSUTF8StringEncoding];
    CCOptions padding = kCCOptionPKCS7Padding;
    NSData *encryptedData = [crypto encrypt:_secretData key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
    
    return [encryptedData base64EncodingWithLineLength:0];
}

-(BOOL) emailValidation:(NSString *)emailTxt
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailTxt];
    
}


-(void) logIn:(NSString *)encryptEmailin :(NSString *)encryptPasswordin
{
    //NSLog(@"url: %@", encryptPassword);
    //NSLog(@"encryptEmailin: %@", encryptEmailin);
    
    NSString * encryptPassword = [self encryptString:encryptPasswordin];
    //NSLog(@"encrypted data string for export: %@",encryptPassword);
    NSString * encryptEmail = [self encryptString:encryptEmailin];
    //NSLog(@"encrypted data string for export: %@",encryptEmail);
    
    [currentElementValue setString:@""];
    NSString *soapMessage=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%li%@", @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                           "<soap:Body>\n"
                           "<logIn xmlns=\"http://www.neiglobal.com/\" >\n"
                           "<email>", encryptEmail, @"</email>\n"
                           "<password>", encryptPassword, @"</password>\n"
                           "<deviceId>", [[[UIDevice currentDevice] identifierForVendor] UUIDString], @"</deviceId>\n"
                           "<launchCount>", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"NEIAppLaunchCount"], @"</launchCount>\n"
                           "</logIn>\n"
                           "</soap:Body>\n"
                           "</soap:Envelope>"];
    NSLog(@"esoapMessage: %@",soapMessage);
    // create a url to your asp.net web service.
    //NSURL *tmpURl=[NSURL URLWithString:[NSString stringWithFormat:@"http://wca4lxrcp1/NEIWebServices/Service1.asmx"]];
    NSURL *tmpURl=[NSURL URLWithString:[NSString stringWithFormat:@"https://nws.neiglobal.com/Service1.asmx"]];
    
    // create a request to your asp.net web service.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:tmpURl];
    
    // add http content type - to your request
    [theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // add  SOAPAction - webMethod that is going to be called
    [theRequest addValue:@"http://www.neiglobal.com/logIn" forHTTPHeaderField:@"SOAPAction"];
    
    // count your soap message lenght - which is required to be added in your request
    NSString *msgLength=[NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    // add content length
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    // set method - post
    [theRequest setHTTPMethod:@"POST"];
    
    // set http request - body
    [theRequest setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    // establish connection with your request & here delegate is self, so you need to implement connection's methods
    NSURLConnection *con=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    // if connection is established
    if(con)
    {
        myWebData=[NSMutableData data];
        // here -> NSMutableData *myWebData; -> declared in .h file
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Logging in...";
    
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    if ([self.email.text length] && [self.password.text length]) {
        

        
         if(![self emailValidation:self.email.text])
         {
             self.errorMsg.text = @"Invalid email address.";
             return NO;
         }
        
        encryptpassword = self.password.text;
        NSLog(@"encrypted data string for export: %@",encryptpassword);
        encryptusername = self.email.text;
        NSLog(@"encrypted data string for export: %@",encryptusername);
        
        [self logIn:encryptusername:encryptpassword];
        
        
        // do not return YES becasue it is ascrynous method, do perform sequl in connectionDidFinishLoading
        return NO;
    }
    
    self.errorMsg.text = @"Enter email and password.";
    return NO;
}



// a method when connection receives response from asp.net web server
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [myWebData setLength: 0];
}
// when web-service sends data to iPhone
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [myWebData appendData:data];
}
// when there is some error with web service
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //[connection release];
    self.errorMsg.text =[error localizedDescription];
}
// when connection successfully finishes
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    // check out your web-service retrieved data on log screen
    //NSString *theXML = [[NSString alloc] initWithBytes: [myWebData mutableBytes] length:[myWebData length] encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",theXML);
    
    // supply your responded data to xmlParser - xmlParser will parse xmlData & then you can use it
    myXMLParser = [[NSXMLParser alloc] initWithData: myWebData];
    
    // here delegate self means implement xmlParse methods
    [myXMLParser setDelegate: self];
    
    [myXMLParser setShouldResolveExternalEntities: YES];
    
    // parse method - will invoke xmlParserMethods
    [myXMLParser parse];
    
    NSLog(@"%@", currentElementValue);
    if([currentElementValue isEqual:@"FAILED"]){
        self.errorMsg.text = @"Log in failed.";
    }
    else if([[currentElementValue substringToIndex:6] isEqual:@"MEMBER"])
    {
        //NSLog([@"MEMBERadfkjadf" substringFromIndex:6]);
        //NSLog([@"MEMBERadfkjadf" substringToIndex:6]);
        //NSLog([@"MEMBERadfkjadf" substringWithRange:NSMakeRange(0, 6)]);
        //NSLog(@"%@", currentElementValue);
        
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"NEIAppLaunchCount"];
        
        if([currentElementValue length]>6){
            NSString *valueToSave = [currentElementValue substringFromIndex:6];
            //NSLog(@"%@", valueToSave);
            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"NEIGroupName"];
            //[[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NEIGroupName"];
        }
        
        
        
        self.loginStatus = [currentElementValue substringToIndex:6];
        
        //save info
        [keychainItem resetKeychainItem];
        
        //[keychainItem setObject:encryptpassword forKey:@"NEIPGPASSWORD"];
        //[keychainItem setObject:encryptusername forKey:@"NEIPGUSERNAME"];
        //[keychainItem setObject:@"2014-02-10" forKey:@"NEIPGLASTDATE"];
        
        [keychainItem setObject:encryptpassword forKey:(__bridge id)kSecValueData];
        [keychainItem setObject:encryptusername forKey:(__bridge id)kSecAttrAccount];
        [keychainItem setObject:[NSDate date] forKey:(__bridge id)kSecAttrModificationDate];
        
        [self performSegueWithIdentifier:@"showMaster" sender:self];
        //[self dismissViewControllerAnimated: YES completion: nil];
    }
    else if([currentElementValue isEqual:@"CUSTOMER"])
    {
        self.errorMsg.text = @"You must be a member. Please join today.";
    }
    else if([currentElementValue isEqual:@"DUPLICATE"])
    {
        self.errorMsg.text = @"You have had a free trial already.";
    }
    else if([currentElementValue isEqual:@"SUCCESS"])
    {
        self.errorMsg.text = @"Password sent. Please check your email.";
    }
    else if([currentElementValue isEqual:@"NOTFOUND"])
    {
        self.errorMsg.text = @"Email address does not match the User Name on Records.";
    }
    else if([currentElementValue isEqual:@"MAILERROR"])
    {
        self.errorMsg.text = @"Email could not be sent out, please contact customer service.";
    }
    else if([currentElementValue isEqual:@"ERROR"])
    {
        self.errorMsg.text = @"There is an error, please contact customer service.";
    }//web service is not there
    else
    {
        self.errorMsg.text = currentElementValue;
        NSLog(@"currentElementValue: %@", currentElementValue);
        [self performSegueWithIdentifier:@"showMaster" sender:self];
        //[self dismissViewControllerAnimated: YES completion: nil];
    }
    
}

// suppose <myDataTag>myData</endmyDataTag> is the xmlData
// this function will read "myData" & tag attributes
-(void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string
{
    // here currentElementValue is an NSMutableString declared in .h file
    // store read characters in that mutable string & then add to your object.
    if(!currentElementValue)
    {
        currentElementValue=[[NSMutableString alloc] initWithString:string];
    }
    else
    {
        [currentElementValue appendString:string];
    }
}
/*

//#pragma mark xmlParser
// suppose <myDataTag>myData</endmyDataTag> is the xmlData
// this function will read "<myDataTag>" & tag attributes
-(void)parser:(NSXMLParser*)parser
didStartElement:(NSString*)elementName
 namespaceURI:(NSString*)namespaceURI
qualifiedName:(NSString*)qualifiedName
   attributes:(NSDictionary*)attributeDict
{
    if([elementName isEqualToString:@"GetCategoryResult"])
    {
        // here categoryArray is NSMutable array declared in .h file.
        // init your array when root element / document element is found
        CategoryArray=[[NSMutableArray alloc]init];
    }
    else if([elementName isEqualToString:@"Prop_Category"])
    {
        aCategory=[[Category alloc] init];
        // if a tag has attribues like <myDataTag id="sagar">
        //aCategory.ID=[attributeDict objectForKey:@"id"];
    }
}

// suppose <myDataTag>myData</endmyDataTag> is the xmlData
// this function will read "myData" & tag attributes
-(void)parser:(NSXMLParser*)parser
foundCharacters:(NSString*)string
{
    // here currentElementValue is an NSMutableString declared in .h file
    // store read characters in that mutable string & then add to your object.
    if(!currentElementValue)
    {
        currentElementValue=[[NSMutableString alloc] initWithString:string];
    }
    else
    {
        [currentElementValue appendString:string];
    }
}

// suppose <myDataTag>myData</endmyDataTag> is the xmlData
// this function will read "</endmyDataTag>" & tag attributes
-(void)parser:(NSXMLParser*)parser
didEndElement:(NSString*)elementName
 namespaceURI:(NSString*)namespaceURI
qualifiedName:(NSString*)qualifiedName
{
    if([elementName isEqualToString:@"GetCategoryResult"])
    {
        // if end of root element is found- i.e. end of your xml file.
        return;
    }
    else if([elementName isEqualToString:@"Prop_Category"])
    {
        // end of a single data element
        // suppose <category>
        //             <id>10</id>
        //             <name><sagar></name>
        //         </category>
        // when we found </category> we have finished entire category object.
        // here we have an object aCategory -> created custom class "Category"
        // CategoryClass -> NSString *name; NSInteger id;
        // Note: "important"
        //->class variables must be same as tag
        
        // now after reading entire object add to your mutable array
        // now this mutable array can be used for Table, UIPicker
        [CategoryArray addObject:aCategory];
        [aCategory release];
        aCategory=nil;
        [CategoryTable reloadData];
    }
    else
    {
        // which is equivalent to aCategory.id=10 & aCategory.name=@"sagar"
        [aCategory setValue:currentElementValue forKey:elementName];
        
        // remove previously read data
        [currentElementValue release];
        currentElementValue=nil;
    }
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    /*if ([[segue identifier] isEqualToString:@"showMaster"]) {
        
        //UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        //PGMasterViewController *eventsController = [navController topViewController];

        //PGMasterViewController *vc = (PGMasterViewController *)[[segue destinationViewController] topViewController];
        InitViewController *vc = [segue destinationViewController];
        [vc setMasterItem:self.loginStatus];
        //vc.memberStatus = self.loginStatus;

    }*/
    //[self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.myscrooview setContentOffset:CGPointMake(0,0) animated:YES];
    
    if ((textField == self.email) || (textField == self.password)) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        [self.myscrooview setContentOffset:CGPointMake(0,self.signIn.center.y-140) animated:YES];
    }
    else{
        [self.myscrooview setContentOffset:CGPointMake(0,0) animated:YES];
    }
    
    /*
    if (textField == self.email) {
        [self.myscrooview setContentOffset:CGPointMake(0,textField.center.y-70) animated:YES];//you can set your  y cordinate as your req also
    }
    else{
        [self.myscrooview setContentOffset:CGPointMake(0,textField.center.y-140) animated:YES];
    }*/
}
/*
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.myscrooview setContentOffset:CGPointMake(0,0) animated:YES];
    
    
    return YES;
}
*/
@end
