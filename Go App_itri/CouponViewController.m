//
//  CouponViewController.m
//  Go App_itri
//
//  Created by Madhawan Misra on 5/28/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import "CouponViewController.h"
@import SystemConfiguration.CaptiveNetwork;

@interface CouponViewController ()

@end

@implementation CouponViewController
{
    BOOL first,have3g;
    NSString *ssid1;
    
}

@synthesize mac;
@synthesize age;
@synthesize gender;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
 
    
    [self.webView setDelegate:self];
    //  self.navigationController.hidesBarsOnTap=YES;
    
    [self.webView canGoBack];
   
    // Do any additional setup after loading the view.
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if(networkStatus == NotReachable)
    {
        NSLog(@"network status is no");
        have3g=FALSE;
    }
    else if (networkStatus == ReachableViaWiFi)
    {
        NSLog(@"network status is wifi");
        have3g=FALSE;
    }
    else if (networkStatus == ReachableViaWWAN)
    {
        NSLog(@"network status is 3g");
        have3g=TRUE;
    }
    
    return networkStatus != NotReachable;
}
- (NSString *)fetchSSIDInfo1
{
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            ssid1 = info[@"SSID"];
            NSLog(@"the ssid is %@",ssid1);
            
        }
    }
    return ssid1;
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (![self connected] )
    {
        
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_internet",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        
    }
    else if (have3g)
    {
        
        
        NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/SpotHome?MacAddress=&Gender=&Age="];
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:requestObj];
        
    }
    else
    {
        [self fetchSSIDInfo1];
        //this is how to check continous
        
        if ([ssid1 containsString:@"Y5Bus"]) {
            
            if (self.loginType==0) {
 
                UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"please_log",nil)
                                                                   message:NSLocalizedString(@"login_desc2",nil)
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                [theAlert show];
                [theAlert setTag:1];
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];

                
            }
            
        else
        {
            NSString *fullURL;
            NSString *strage=[NSString stringWithFormat:@"%d", (int)age];
            if ([gender isEqualToString:@""] || gender.length==0) {

            fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/SpotHome?MacAddress=%@&Gender=&Age=%@",mac,strage];
            }
            else
            {
                fullURL=[NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/SpotHome?MacAddress=%@&Gender=%@&Age=%@",mac,gender,strage];
            }
            NSLog(@"The URLLL IS %@",fullURL);
            NSURL *url = [NSURL URLWithString:fullURL];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:requestObj];
        }
 
        }
        else
        
        {
    
    NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/SpotHome?MacAddress=&Gender=&Age="];
                         NSURL *url = [NSURL URLWithString:fullURL];
                         NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
                         [self.webView loadRequest:requestObj];
                         
                         }
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self.loginindicator startAnimating];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.loginindicator stopAnimating];
    // JS Injection hack to solve the target="_blank" issue and open a real browser in such case.
    NSString *JSInjection = @"javascript: var allLinks = document.getElementsByTagName('a'); if (allLinks) {var i;for (i=0; i<allLinks.length; i++) {var link = allLinks[i];var target = link.getAttribute('target'); if (target && target == '_blank') {link.setAttribute('target','_self');link.href = 'newtab:'+link.href;}}}";
    [webView stringByEvaluatingJavaScriptFromString:JSInjection];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    [self.loginindicator stopAnimating];
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                       message:NSLocalizedString(@"error_internet2",nil)
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    //[theAlert show];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request     navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString hasPrefix:@"newtab:"])
    {
        // JS-hacked URl is a target=_blank url - manually open the browser.
        NSURL *url = [NSURL URLWithString:[request.URL.absoluteString substringFromIndex:7]];
        [[UIApplication sharedApplication] openURL:url];
        
        return true;
    }
    
    return true;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) { // UIAlertView with tag 1 detected
        if (buttonIndex == 0)
        {
            
            [self.tabBarController setSelectedIndex:0];
        }
    }
}

@end
