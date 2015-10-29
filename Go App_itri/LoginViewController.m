//
//  LoginViewController.m
//  Go App_itri
//
//  Created by Madhawan Misra on 5/28/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import "LoginViewController.h"
#import "UpdatepasswordViewController.h"
@import SystemConfiguration.CaptiveNetwork;

@interface LoginViewController ()

@end

@implementation LoginViewController
bool remb;
NSString *ssid3;
@synthesize usermac,uuid,routermacid;
- (void)viewDidLoad {
    [super viewDidLoad];
    remb=YES;
    self.navigationItem.title=NSLocalizedString(@"forgot",nil);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@""
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    self.background.backgroundColor=[UIColor colorWithRed:252.0/255.0 green:248.0/255.0 blue:242.0/255.0 alpha:1.0];

    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(2, 16, 2, 16);
    UIImage *imagefirst1 = [[UIImage imageNamed:@"input_single_bg.png"]
                            resizableImageWithCapInsets:edgeInsets];
    self.forgot.image=imagefirst1;
    self.forgotpassword.delegate=self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    UIEdgeInsets edgeInsets1 = UIEdgeInsetsMake(6, 6, 6, 6);
    UIImage *emailoginbutton = [[UIImage imageNamed:@"btn_orange_bg_normal.png"]
                                resizableImageWithCapInsets:edgeInsets1];
    UIImage *emailoginbutton2 = [[UIImage imageNamed:@"btn_orange_bg_pressed.png"]
                                 resizableImageWithCapInsets:edgeInsets1];
    
    [signup setBackgroundImage:emailoginbutton forState:UIControlStateNormal];
    [signup setBackgroundImage:emailoginbutton2 forState:UIControlStateSelected];
    [signup setBackgroundImage:emailoginbutton2 forState:UIControlStateHighlighted];
     self.intro.textColor=[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0];
    // Do any additional setup after loading the view.
}


//check if active internet connection
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSString *)fetchSSIDInfo3
{
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            ssid3 = info[@"SSID"];
            NSLog(@"the ssid is %@",ssid3);
            
        }
    }
    return ssid3;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)forgotpassword:(id)sender {
    
 
    NSString *account=self.forgotpassword.text;
    if ([account isEqualToString:@""]) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"email_empty",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
    }
    else
    {
    
        
        if (![self connected])
        {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                               message:NSLocalizedString(@"error_internet",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            
        }
        else
        {
            ssid3= [self fetchSSIDInfo3];
            if ([ssid3 containsString:@"Y5Bus"])
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
                
                //if success then, call the register function
                if([status isEqualToString:@"301"])
                {
                    [self forgotapi];
                    
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
                     
                    // [self loginViewFetchedUserInfo];
                    
                }
                
            }
            
            else
            {
                
                [self forgotapi];
                
            }
        }
    }
   
        
        
    }
    



-(void)forgotapi
{
    NSString *s;
    NSString *email;
    NSString *mobile;
    NSString *logintype;
    if([self.forgotpassword.text containsString:@"@"])
    {
        mobile=@"";
        email=self.forgotpassword.text;
        logintype=@"emailUpdatepwd";
        s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"emailUpdatepwd\",\"params\":{\"useremail\":\"%@\"}}}",email];

    }
    else
    {
        mobile=self.forgotpassword.text;
        email=@"";
        logintype=@"smsUpdatepwd";
        
        
         s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"smsUpdatepwd\",\"params\":{\"mobile\":\"%@\"}}}",mobile];

        
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    
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
    if ([status isEqualToString:@"800"]) {
        
        
        
            
            
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"check_email",nil)
                                                               message:NSLocalizedString(@"check_email_pwd",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
        
            [theAlert show];
        UpdatepasswordViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"update"];
        controller.account=self.forgotpassword.text;
        [self.navigationController pushViewController:controller animated:YES];
        
        }
        else  if ([status isEqualToString:@"801"]) {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"check_phone",nil)
                                                               message:NSLocalizedString(@"check_phone_pwd",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
           
            UpdatepasswordViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"update"];
            controller.account=self.forgotpassword.text;
            [self.navigationController pushViewController:controller animated:YES];
            
        }
 
    else if ([status isEqualToString:@"900"])
    {
        
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"acct_err",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
        
        
    }
    else if ([status isEqualToString:@"901"])
    {
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"acct_err",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
        
    }
    else
    {
        
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                               message:NSLocalizedString(@"unknown",nil)
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                                     otherButtonTitles:nil];
            [theAlert show];
        
    }
}

@end
