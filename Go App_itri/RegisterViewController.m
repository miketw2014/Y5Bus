//
//  RegisterViewController.m
//  Go App_itri
//
//  Created by Madhawan Misra on 5/28/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import "RegisterViewController.h"
#import "VerifyViewController.h"

@import SystemConfiguration.CaptiveNetwork;

@interface RegisterViewController ()

@end

@implementation RegisterViewController

bool check,selfuse;
NSString *gender;
NSString *genderstring;
NSTextContainer *textContainer;
NSLayoutManager *layoutManager;
NSString *ssid2;

@synthesize uuid,routermacid,usermac;
@synthesize imagefirst,imagelast,imagemiddle;
- (void)viewDidLoad {
    [super viewDidLoad];
    genderstring=@"2";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title=NSLocalizedString(@"regis",nil);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@""
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
     self.navigationItem.backBarButtonItem.title=@"";
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    //textview delegate for dismising keyboard
    
    self.email.delegate=self;
    self.password.delegate=self;
    self.confirmpassword.delegate=self;
    self.txtFieldBranchYear.delegate=self;
    
    //datepicker for birthday
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.txtFieldBranchYear setInputView:datePicker];
    UIPickerView *genderpicker=[[UIPickerView alloc]init];
    genderpicker.delegate=self;
    self.gendernames=@[NSLocalizedString(@"male",nil),NSLocalizedString(@"female",nil)];
    [self.gender setInputView:genderpicker];
    
      self.background.backgroundColor=[UIColor colorWithRed:252.0/255.0 green:248.0/255.0 blue:242.0/255.0 alpha:1.0];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(2, 16, 2, 16);
  UIImage *imagefirst1 = [[UIImage imageNamed:@"input_table_frist_bg.png"]
                                      resizableImageWithCapInsets:edgeInsets];
    UIImage *imagemiddle1 = [[UIImage imageNamed:@"input_table_middle_bg.png"]
                           resizableImageWithCapInsets:edgeInsets];
    UIImage *imagelast1 = [[UIImage imageNamed:@"input_table_last_bg.png"]
                           resizableImageWithCapInsets:edgeInsets];
    
    imagefirst.image=imagefirst1;
    imagemiddle.image=imagemiddle1;
    imagelast.image=imagelast1;
    self.imagegender.image=imagefirst1;
    self.imagebirthday.image=imagemiddle1;
    self.imagename.image=imagelast1;
self.secondbottom.textColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.lastbottom.textColor=[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0];
    UIEdgeInsets edgeInsets1 = UIEdgeInsetsMake(6, 6, 6, 6);
    UIImage *emailoginbutton = [[UIImage imageNamed:@"btn_orange_bg_normal.png"]
                                resizableImageWithCapInsets:edgeInsets1];
    UIImage *emailoginbutton2 = [[UIImage imageNamed:@"btn_orange_bg_pressed.png"]
                                 resizableImageWithCapInsets:edgeInsets1];
    
    [self.loginemail setBackgroundImage:emailoginbutton forState:UIControlStateNormal];
    [self.loginemail setBackgroundImage:emailoginbutton2 forState:UIControlStateSelected];
    [self.loginemail setBackgroundImage:emailoginbutton2 forState:UIControlStateHighlighted];
    
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"the language is %@",language);
    if ([language containsString:@"en"]) {
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:@"By clicking Register, you agree to our Terms and that you have read our Data Policy。"];
        
        self.rules.lineBreakMode = NSLineBreakByWordWrapping;
        self.rules.numberOfLines = 2;
        self.rules.textColor=[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0];

        //link color
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithRed:178.0/255.0 green:107.0/255.0 blue:0/255.0 alpha:1.0]
                     range:NSMakeRange(72, 11)];
        [text addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(72, 11)];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithRed:178.0/255.0 green:107.0/255.0 blue:0/255.0 alpha:1.0]
                     range:NSMakeRange(35, 9)];
        [text addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(35, 9)];
        //font color
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140/255.0 alpha:1.0]
                     range:NSMakeRange(0, 18)];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140/255.0 alpha:1.0]
                     range:NSMakeRange(27, 7)];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140/255.0 alpha:1.0]
                     range:NSMakeRange(45, 2)];
        
        
        [self.rules setAttributedText:text];
        self.rules.userInteractionEnabled = YES;
        [self.rules addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)]];
        
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        layoutManager = [[NSLayoutManager alloc] init];
        textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:text];
        
        // Configure layoutManager and textStorage
        [layoutManager addTextContainer:textContainer];
        [textStorage addLayoutManager:layoutManager];
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0;
        textContainer.lineBreakMode = NSLineBreakByWordWrapping;
        textContainer.maximumNumberOfLines = 2;
        
    }
    else
    {
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:@"點擊「註冊」按鈕後，即表示您已同意「Y5Bus使用條款」，並已閱讀「Y5Bus隱私權政策」。"];

   self.rules.lineBreakMode = NSLineBreakByWordWrapping;
    self.rules.numberOfLines = 2;
    //link color
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:178.0/255.0 green:107.0/255.0 blue:0/255.0 alpha:1.0]
                 range:NSMakeRange(18, 9)];
    [text addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(18, 9)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:178.0/255.0 green:107.0/255.0 blue:0/255.0 alpha:1.0]
                 range:NSMakeRange(34, 10)];
    [text addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(34, 10)];
    //font color
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140/255.0 alpha:1.0]
                 range:NSMakeRange(0, 18)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140/255.0 alpha:1.0]
                 range:NSMakeRange(27, 7)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140/255.0 alpha:1.0]
                 range:NSMakeRange(44, 2)];
    
   
    [self.rules setAttributedText:text];
    self.rules.userInteractionEnabled = YES;
    [self.rules addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)]];
     
    // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
     layoutManager = [[NSLayoutManager alloc] init];
    textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:text];
    
    // Configure layoutManager and textStorage
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    // Configure textContainer
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    textContainer.maximumNumberOfLines = 2;
    }
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return self.gendernames.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return self.gendernames[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
        self.gender.text=self.gendernames[row];
   
    gender=self.gender.text;
    if (row==0) {
        gender=@"male";
        genderstring=@"1";
    }
    else if (row==1)
    {
        gender=@"female";
        genderstring=@"0";
    }
     NSLog(@"the gender is %@",gender);
    
}
- (NSString *)fetchSSIDInfo2
{
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            ssid2 = info[@"SSID"];
            NSLog(@"the ssid is %@",ssid2);
            
        }
    }
    return ssid2;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    textContainer.size=self.rules.bounds.size;
}
- (void)handleTapOnLabel:(UITapGestureRecognizer *)tapGesture
{
    CGPoint locationOfTouchInLabel = [tapGesture locationInView:tapGesture.view];
    CGSize labelSize = tapGesture.view.bounds.size;
    CGRect textBoundingBox = [layoutManager usedRectForTextContainer:textContainer];
    CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                         locationOfTouchInLabel.y - textContainerOffset.y);
    NSInteger indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                            inTextContainer:textContainer
                                   fractionOfDistanceBetweenInsertionPoints:nil];
    NSRange linkRange = NSMakeRange(10, 18); // it's better to save the range somewhere when it was originally used for marking link in attributed string
   if(NSLocationInRange(indexOfCharacter, linkRange))
   {
       NSLog(@"the string is selected");
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://stackoverflow.com/"]];

   }
    
        
        

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}
-(void) dateTextField:(id)sender
{
    //specify the date format
    
    UIDatePicker *picker = (UIDatePicker*)self.txtFieldBranchYear.inputView;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    self.txtFieldBranchYear.text = [NSString stringWithFormat:@"%@",dateString];
}
//Implement resignOnTap:

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//method to verify length of password 
-(void)check
{
    if ([self.email.text isEqualToString:@""]) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"emptyerror",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        check=false;
        [self.activityindicator stopAnimating];
    }
    
    else if ([self.password.text length]<8)
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"charerror",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        check=false;
        [self.activityindicator stopAnimating];
    }
    
    else if (![self.password.text isEqualToString:self.confirmpassword.text])

    {
                   UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                                      message:NSLocalizedString(@"passmatch",nil)
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                   [theAlert show];
        check=false;
        [self.activityindicator stopAnimating];
    }
    else
    {
        check=true;
    }
}

-(void)registerapi
{
    NSString *s;
    
    VerifyViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"verify"];
    
    //    UINavigationController*  theNavController = [[UINavigationController alloc]
    //                                                 initWithRootViewController:controller];
    
    //[self.navigationController pushViewController:controller animated:YES];
    //call the api to register the user to be enabled to use the free wifi,
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *mobile;
    NSString *email;
    NSString *logintype;
    //check if the user wants to use email or mobile phone for registraion
    if([self.email.text containsString:@"@"])
    {
        mobile=@"";
        email=self.email.text;
        logintype=@"emailRegister";
    }
    else
    {
        mobile=self.email.text;
        email=@"";
        logintype=@"smsRegister";
        
        
        
        
    }
    if (selfuse) {
        selfuse=false;
        routermacid=@"";
        usermac=@"";
         s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"appAuthSucces\",\"params\":{\"logintype\":\"%@\",\"routerid\":\"%@\",\"usermac\":\"%@\",\"uuid\":\"%@\",\"username\":\"%@\",\"usergender\":\"%@\",\"userbirthday\":\"%@\",\"useremail\":\"%@\",\"pwd\":\"%@\",\"mobile\":\"%@\"}}}",logintype,routermacid,usermac,uuid,self.email.text,genderstring,self.txtFieldBranchYear.text,email,self.password.text,mobile];
    }
    else
    {
    //based on above, pass the parameters
     s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"appAuthSucces\",\"params\":{\"logintype\":\"%@\",\"routerid\":\"%@\",\"usermac\":\"%@\",\"uuid\":\"%@\",\"username\":\"%@\",\"usergender\":\"%@\",\"userbirthday\":\"%@\",\"useremail\":\"%@\",\"pwd\":\"%@\",\"mobile\":\"%@\"}}}",logintype,routermacid,usermac,uuid,self.email.text,genderstring,self.txtFieldBranchYear.text,email,self.password.text,mobile];
    }
    
    NSData *postData = [s dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSLog(@"postdata: %@", s);
    // NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://apptest.coolbeewifi.net/app/entry"]];
    [request setHTTPMethod:@"POST"];
    //[request setHttp]
    [request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    //[request ]
    // [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    // NSLog(@"request url: %@", request);
    
    
    
    //response
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    // NSLog(@"requesthandler: %@", requestHandler);
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSLog(@"requestReply: %@", requestReply);
    NSData* jsondata = [requestReply dataUsingEncoding:NSASCIIStringEncoding];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:NULL];
    
    
    NSDictionary *mac=[jsonDictionary objectForKey:@"methodResponse"];
    NSDictionary *mac2=[mac objectForKey:@"params"];
    
    NSString *status=[mac2 objectForKey:@"status"];
    NSString *activated=[mac2 objectForKey:@"activated"];
    NSLog(@"the statusregister is %@",status);
    //NSString *userrecid=[mac2 objectForKey:@"userRecId"];
    
    if ([status isEqualToString:@"305"]) {
          [self.activityindicator stopAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self registerowndatabase];
        });
        
        if ([activated isEqualToString:@"1"]) {
            
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"reg_succ",nil)
                                                           message:NSLocalizedString(@"act_done",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
            [self.activityindicator stopAnimating];
        }
        else  if ([activated isEqualToString:@"0"]) {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"reg_succ",nil)
                                                               message:NSLocalizedString(@"con_email",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            [self.activityindicator stopAnimating];
            
            
        }
        
        
        
    }
 
    else if ([status isEqualToString:@"307"])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self registerowndatabase];
        });
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"reg_succ",nil)
                                                           message:NSLocalizedString(@"con_phone",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        [self.activityindicator stopAnimating];
        VerifyViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"verify"];
        //    UINavigationController*  theNavController = [[UINavigationController alloc]
        //                                                 initWithRootViewController:controller];
        controller.uuid=uuid;
        controller.routermacid=routermacid;
        controller.usermac=usermac;
        controller.phonenumber=self.email.text;
        [self.navigationController pushViewController:controller animated:YES];
        
        
    }
    else if ([status isEqualToString:@"407"] || [status isEqualToString:@"405"])
    {
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"reg_fail",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        [self.activityindicator stopAnimating];
        
    }
    else if ([status isEqualToString:@"201"])
    {
         
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"whyneedregister",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
        [self.activityindicator stopAnimating];
        
    }
   

    
}

-(void)registerowndatabase
{
    NSString *s;
    //this should be called in background, not on the main thread
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *password=self.password.text;
    NSString *username=self.email.text;
    NSString *birthday=self.txtFieldBranchYear.text;
    if ([gender isEqualToString:@""] || gender.length==0)
    {
         s=[NSString stringWithFormat:@"key=null&type=y5Bus&account=%@&password=%@&name=%@&email=%@&gender=&birthday=%@",
                     username,password,username,username,birthday];
    }
    else
    {
     s=[NSString stringWithFormat:@"key=null&type=y5Bus&account=%@&password=%@&name=%@&email=%@&gender=%@&birthday=%@",
username,password,username,username,gender,birthday];
    }
    
     NSData *postData = [s dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
       NSLog(@"postdata: %@", postData);
    NSLog(@"postdata string: %@", s);
     NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
     [request setURL:[NSURL URLWithString:@"http://y5bus.chainyi.com/WebServices/WebService.asmx/AddUser"]];
     [request setHTTPMethod:@"POST"];
     //[request setHttp]
     //[request setValue:@"text/xml" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
     //[request ]
     [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
     [request setHTTPBody:postData];
     // NSLog(@"request url: %@", request);
     
     
     
     //response
     
     NSURLResponse *requestResponse;
     NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
     // NSLog(@"requesthandler: %@", requestHandler);
     
     NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSUTF8StringEncoding];
     NSLog(@"requestReply: %@", requestReply);
     NSString *pattern = @"<ErrorCode>(\\d+)</ErrorCode>";
     NSString *xml = requestReply;
     
     NSRegularExpression *regex = [NSRegularExpression
     regularExpressionWithPattern:pattern
     options:NSRegularExpressionCaseInsensitive
     error:nil];
     NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:xml options:0 range:NSMakeRange(0, xml.length)];
     
     NSRange matchRange = [textCheckingResult rangeAtIndex:1];
     NSString *match = [xml substringWithRange:matchRange];
     NSLog(@"Found string '%@'", match);
     

}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

//action for send button

- (IBAction)send:(id)sender {
    
    [self.activityindicator startAnimating];
    
    //initially perform check whether the combination of password and email is valid
    [self check];
    
    if (check) {
        if (![self connected])
        {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                               message:NSLocalizedString(@"error_internet",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
             [theAlert show];
            [self.activityindicator stopAnimating];
        }
        else
        {
            ssid2= [self fetchSSIDInfo2];
            if ([ssid2 containsString:@"Y5Bus"])
            {
              
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                
                
                //NSString *post = [NSString stringWithFormat:@"test=Message&this=isNotReal"];
                NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"clickLogin\",\"params\":{\"usermac\":\"%@\",\"uuid\":\"%@\"}}}",usermac,uuid];
                
                
                NSData *postData = [s dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                //  NSLog(@"postdata: %@", postData);
                // NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
                [request setURL:[NSURL URLWithString:@"http://1.1.1.1/appHandler.cgi"]];
                [request setHTTPMethod:@"POST"];
                //[request setHttp]
                [request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
                // [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                [request setHTTPBody:postData];
                // NSLog(@"request url: %@", request);
                
                
                //response
                
                NSURLResponse *requestResponse;
                NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
                // NSLog(@"requesthandler: %@", requestHandler);
                NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
                NSLog(@"requestReply: %@", requestReply);
                NSData* jsondata = [requestReply dataUsingEncoding:NSASCIIStringEncoding];
                
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:NULL];
                
                
                NSDictionary *mac=[jsonDictionary objectForKey:@"methodResponse"];
                NSDictionary *mac2=[mac objectForKey:@"params"];
                
                NSString *status=[mac2 objectForKey:@"status"];
                NSLog(@"status is %@",status);
                //if success then, call the register function
                if([status isEqualToString:@"301"])
                {
                    [self registerapi];
    
                    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Temp. Logged in"
                                                                       message:@"You have limited WIFI for 5 minutes, fetching personal information, please wait!!"
                                                                      delegate:self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
                    // [theAlert show];
                    
                    
                }
                
                else if ([status isEqualToString:@"401"])
                {
                    
                    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                                       message:NSLocalizedString(@"temp_login_failed",nil)
                                                                      delegate:self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
                    [theAlert show];
                    [self.activityindicator stopAnimating];
                    // [self loginViewFetchedUserInfo];
                    
                }
                
                else if ([status isEqualToString:@"201"])
                {
                    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                                       message:NSLocalizedString(@"whyneedregister",nil)
                                                                      delegate:self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
                    [theAlert show];
                    [self.activityindicator stopAnimating];
                    
                }

                
            }
            
            else
            {
                
                selfuse=true;
             [self registerapi];
                
                
                
            
            }
        }
    }
    
}

- (IBAction)datapolicy:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://y5bus.chainyi.com/TW/privacy"]];
}

- (IBAction)terms:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://y5bus.chainyi.com/TW/rule"]];

}
@end