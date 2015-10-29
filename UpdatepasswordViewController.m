//
//  UpdatepasswordViewController.m
//  Go App_itri
//
//  Created by Madhawan Misra on 8/26/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import "UpdatepasswordViewController.h"

@interface UpdatepasswordViewController ()

@end

@implementation UpdatepasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.background.backgroundColor=[UIColor colorWithRed:252.0/255.0 green:248.0/255.0 blue:242.0/255.0 alpha:1.0];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(2, 16, 2, 16);
    UIImage *imagefirst1 = [[UIImage imageNamed:@"input_table_frist_bg.png"]
                            resizableImageWithCapInsets:edgeInsets];
    UIImage *imagemiddle1 = [[UIImage imageNamed:@"input_table_middle_bg.png"]
                             resizableImageWithCapInsets:edgeInsets];
    UIImage *imagelast1 = [[UIImage imageNamed:@"input_table_last_bg.png"]
                           resizableImageWithCapInsets:edgeInsets];
    
    self.firstimageview.image=imagefirst1;
    self.secondimageview.image=imagemiddle1;
    self.thirdimageview.image=imagelast1;
    UIEdgeInsets edgeInsets1 = UIEdgeInsetsMake(6, 6, 6, 6);
    UIImage *emailoginbutton = [[UIImage imageNamed:@"btn_orange_bg_normal.png"]
                                resizableImageWithCapInsets:edgeInsets1];
    UIImage *emailoginbutton2 = [[UIImage imageNamed:@"btn_orange_bg_pressed.png"]
                                 resizableImageWithCapInsets:edgeInsets1];
    
    [self.send setBackgroundImage:emailoginbutton forState:UIControlStateNormal];
    [self.send setBackgroundImage:emailoginbutton2 forState:UIControlStateSelected];
    [self.send setBackgroundImage:emailoginbutton2 forState:UIControlStateHighlighted];
    self.code.delegate=self;
    self.newpassword.delegate=self;
    self.confirm.delegate=self;
    [self.newpassword setSecureTextEntry:YES];
    [self.confirm setSecureTextEntry:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
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

- (IBAction)send:(id)sender {
     
    if ([self.newpassword.text length]<8)
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"charerror",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
        
    }
    
    else if (![self.newpassword.text isEqualToString:self.confirm.text])
        
    {
         
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"passmatch",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
        
    }
    else
    {
        NSString *s;
        
        if ([self.account containsString:@"@"]) {
                     s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"emailUpdatepwdDone\",\"params\":{\"useremail\":\"%@\",\"vcode\":\"%@\",\"pwd\":\"%@\"}}}",self.account,self.code.text,self.newpassword.text];
            
        }
        
        
        
        else
        {
                      s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"smsUpdatepwdDone\",\"params\":{\"mobile\":\"%@\",\"vcode\":\"%@\",\"pwd\":\"%@\"}}}",self.account,self.code.text,self.newpassword.text];
            
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

        if ([status isEqualToString:@"804"] || [status isEqualToString:@"805"]) {
            
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"success",nil)
                                                               message:NSLocalizedString(@"updatedone",nil)
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                                     otherButtonTitles:nil];
            [theAlert show];
            [theAlert setTag:1];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self updateinternaldatabase];
            });
        }
        
        else if ([status isEqualToString:@"(904"] || [status isEqualToString:@"905"])
        {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                               message:NSLocalizedString(@"updatefail",nil)
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                                     otherButtonTitles:nil];
            [theAlert show];
            
        }
        
        else if([status isEqualToString:@""])
        {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                               message:NSLocalizedString(@"unknown",nil)
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                                     otherButtonTitles:nil];
            [theAlert show];
        }
    
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)updateinternaldatabase
{
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *s=[NSString stringWithFormat:@"type=y5Bus&account=%@&newpassword=%@",
                 self.account,self.newpassword.text];
    
    
    NSData *postData = [s dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSLog(@"postdata: %@", postData);
    NSLog(@"postdata string: %@", s);
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://y5bus.chainyi.com/WebServices/WebService.asmx/UpdateUserPassword"]];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) { // UIAlertView with tag 1 detected
        if (buttonIndex == 0)
        {
            
            [self.tabBarController setSelectedIndex:0];
            [self.navigationController popToRootViewControllerAnimated:YES];

    // Any action can be performed here
        }

    }
}

@end
