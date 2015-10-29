//
//  VerifyViewController.m
//  Go App_itri
//
//  Created by Madhawan Misra on 8/6/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import "VerifyViewController.h"

@interface VerifyViewController ()

@end

@implementation VerifyViewController
@synthesize uuid,routermacid,usermac,phonenumber;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title=NSLocalizedString(@"confirm_code",nil);
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
    
    self.pincodebackground.image=imagefirst1;
    UIEdgeInsets edgeInsets1 = UIEdgeInsetsMake(6, 6, 6, 6);
    UIImage *emailoginbutton = [[UIImage imageNamed:@"btn_orange_bg_normal.png"]
                                resizableImageWithCapInsets:edgeInsets1];
    UIImage *emailoginbutton2 = [[UIImage imageNamed:@"btn_orange_bg_pressed.png"]
                                 resizableImageWithCapInsets:edgeInsets1];
    self.pincode.delegate=self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    [self.resendcode setBackgroundImage:emailoginbutton forState:UIControlStateNormal];
    [self.resendcode setBackgroundImage:emailoginbutton2 forState:UIControlStateSelected];
    [self.resendcode setBackgroundImage:emailoginbutton2 forState:UIControlStateHighlighted];
    
    [self.codeconfirm setBackgroundImage:emailoginbutton forState:UIControlStateNormal];
    [self.codeconfirm setBackgroundImage:emailoginbutton2 forState:UIControlStateSelected];
    [self.codeconfirm setBackgroundImage:emailoginbutton2 forState:UIControlStateHighlighted];
    
    
    self.info.textColor=[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0];
    self.info2.textColor=[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0];
    self.info3.textColor=[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0];
    self.info4.textColor=[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0];
    // Do any additional setup after loading the view.
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)activate:(id)sender {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    NSString *actkey=self.pincode.text;
   NSString *email=@"";
    if ([actkey isEqualToString:@""]) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"checkpin",nil)
                                                           message:NSLocalizedString(@"pinnull",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
    }
    else
    {
    NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"appAuthSucces\",\"params\":{\"logintype\":\"smsActivate\",\"routerid\":\"%@\",\"usermac\":\"%@\",\"uuid\":\"%@\",\"useremail\":\"%@\",\"mobile\":\"%@\",\"actkey\":\"%@\"}}}",routermacid,usermac,uuid,email,phonenumber,actkey];
       
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
        if ([status isEqualToString:@"308"])
        {
            
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"act",nil)
                                                               message:NSLocalizedString(@"number_act",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            [theAlert setTag:1];
        }
        else if ([status isEqualToString:@"408"])
        {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                               message:NSLocalizedString(@"act_fail",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
        }

    }
    }
- (IBAction)resendcode:(id)sender {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
        NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"smsCoderesend\",\"params\":{\"mobile\":\"%@\"}}}",phonenumber];
        
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
        if ([status isEqualToString:@"802"])
        {
            
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"resent",nil)
                                                               message:NSLocalizedString(@"resent_desc",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            
        }
        else if ([status isEqualToString:@"803"])
        {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"act",nil)
                                                               message:NSLocalizedString(@"act_done",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            [theAlert setTag:1];
        }
        else if ([status isEqualToString:@"902"])
        {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                               message:NSLocalizedString(@"reg_error",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
        }
        
    }

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) { // UIAlertView with tag 1 detected
        if (buttonIndex == 0)
        {
            
            [self.tabBarController setSelectedIndex:0];
            // Any action can be performed here
        }
        
    }
}
@end
