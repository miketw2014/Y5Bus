 
//   CoupontwoViewController.m
//   Go App_itri
// 
//   Created by Madhawan Misra on 8/13/15.
//   Copyright (c) 2015 Madhawan Misra. All rights reserved.


#import "CoupontwoViewController.h"
 @import SystemConfiguration.CaptiveNetwork;

@interface CoupontwoViewController ()

@end

@implementation CoupontwoViewController

bool received1;
@synthesize gender,loginType;
@synthesize age;
@synthesize mac;
NSString *ssid1;
bool have3g,firsttime ;
- (void)viewDidLoad {
 
    NSLog(@"the did load values of gender and age are %@ and %ld",gender,(long)age);
    
    [super viewDidLoad];
    self.navigationItem.title=NSLocalizedString(@"coupon",nil);
    [self.webView setDelegate:self];
  //  self.navigationController.hidesBarsOnTap=YES;
    
    [self.webView canGoBack];
    //self.tabBarController.delegate=self;
   self.automaticallyAdjustsScrollViewInsets = NO;

//    if (self.loginType==0) {
//        ssid1= [self fetchSSIDInfo1];
//        if ([ssid1 isEqualToString:@"Y5Bus_2.4G"])
//        {
//            [self connected];
//             self.connectedlbl.hidden=NO;
//             UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Please Login"
//                                                                message:@"Please go to homescreen and login!!"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                     otherButtonTitles:nil];
//            [self.loginindicator stopAnimating];
//            //   [theAlert show];
//         }
//         
//         else
//         {
//             if (![self connected])
//             {
//                 self.connectedlbl.hidden=NO;
//                 UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"NO internet"
//                                                                    message:@"Please connect to internet!!"
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"OK"
//                                                          otherButtonTitles:nil];
//                 //  [theAlert show];
//             }
//             else
//             {
//                 self.connectedlbl.hidden=YES;
//                 NSString *fullURL = [NSString stringWithFormat:@"http: y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age="];
//                  NSLog(@"The URLLL IS %@",fullURL);
//                 NSURL *url = [NSURL URLWithString:fullURL];
//                 NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//                 [self.webView loadRequest:requestObj];
//             }
//         }
//     }
//     
//     else
//     {
//         NSLog(@"LOGINTYPE IS %d",self.loginType);
//         self.connectedlbl.hidden=YES;
//         received1=true;
//         NSString *strage=[NSString stringWithFormat:@"%d", (int)age];
//         NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=%@&Age=%@",gender,strage];
//          NSLog(@"The URLLL IS %@",fullURL);
//         NSURL *url = [NSURL URLWithString:fullURL];
//         NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//         [self.webView loadRequest:requestObj];
//         
//    }
      //Do any additional setup after loading the view.
 }
//-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
//    if (inType == UIWebViewNavigationTypeLinkClicked) {
//        [[UIApplication sharedApplication] openURL:[inRequest URL]];
//        return NO;
//    }
//    
//    return YES;
//   
//}
 
- (void)loginnotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"login"])
    {
    NSLog(@"IS RECEIVEDDDDDDDD");
    
    if (received1) {
        
    }
    else{
        self.loginType=1;
        gender = [notification object];
        NSLog(@"gender is %@",gender);
        received1=true;
         NSString *strage=[NSString stringWithFormat:@"%d", (int)age];
        NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=%@&Age=%@&MacAddress=%@",gender,strage,mac];
        NSLog(@"The URLLL IS %@",fullURL);
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:requestObj];
        self.connectedlbl.hidden=YES;
    }
        
    }
}

- (IBAction)back:(id)sender {
    [self.webView goBack];

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
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                       message:NSLocalizedString(@"error_internet2",nil)
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    //[theAlert show];
    [self.loginindicator stopAnimating];

    
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
- (void)webviewlogin:(NSNotification *) notification {
    NSLog(@"IS CALLED");

}

 - (void)didReceiveMemoryWarning {
     [super didReceiveMemoryWarning];
       //Dispose of any resources that can be recreated.
 }
 
 -(void)viewWillAppear:(BOOL)animated {
     
     [super viewWillAppear:animated];
    
     
     NSLog(@"the second classLOGIN type is %d",loginType);
     
     NSLog(@"the second values of gender and age are %@ and %ld",gender,(long)age);
     
//     [[NSNotificationCenter defaultCenter] addObserver:self
//                                              selector:@selector(webviewlogin:)
//                                                  name:@"webviewlogin"
//                                                object:@"male"];
//     [[NSNotificationCenter defaultCenter] addObserver:self
//                                              selector:@selector(loginnotification:)
//                                                  name:@"loggedincheck"
//                                                object:nil];
//     if (received1) {
//         if (self.loginType==0) {
//             NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age=" ];
//             NSURL *url = [NSURL URLWithString:fullURL];
//             NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//             [self.webView loadRequest:requestObj];
//         }
//         else{
//          NSString *strage=[NSString stringWithFormat:@"%d", (int)age];
//         NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=male&Age=25" ];
//         NSURL *url = [NSURL URLWithString:fullURL];
//         NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//         [self.webView loadRequest:requestObj];
//         }
//     }
//     else
//     {
//         if (self.loginType==0) {
//             
//             
//             ssid1= [self fetchSSIDInfo1];
//             if ([ssid1 containsString:@"Y5Bus"])
//             {
//                 [self connected];
//                 
//                 if (have3g) {
//                     received1=TRUE;
//                     self.connectedlbl.hidden=YES;
//                     NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age="];
//                     NSURL *url = [NSURL URLWithString:fullURL];
//                     NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//                     [self.webView loadRequest:requestObj];
//                     
//                 }
//                 else
//                 {
//                     
//                     
//                     if (received1) {
//                         NSString *strage=[NSString stringWithFormat:@"%d", (int)age];
//                         NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age="];
//                         NSURL *url = [NSURL URLWithString:fullURL];
//                         NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//                           [self.webView loadRequest:requestObj];
//                         
//                     }
//                     else{
//                 UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"please_log",nil)
//                                                                    message:NSLocalizedString(@"login_desc2",nil)
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"OK"
//                                                          otherButtonTitles:nil];
//                 [theAlert show];
//                     [self.loginindicator stopAnimating];
//                     NSString *strage=[NSString stringWithFormat:@"%d", (int)age];
//                     NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age="];
//                     NSURL *url = [NSURL URLWithString:fullURL];
//                     NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//                    // [self.webView loadRequest:requestObj];
//                 [theAlert setTag:1];
//                     }
//                 //self.connectedlbl.hidden=NO;
//                 //self.connectedlbl.text=@"如果你在車上，請登入";
//                 }
//                 
//             }
//             
//             
//             
//             
//             
//             
//             
//             else
//             {
//                 if (![self connected])
//                 {
//                     
//                     if (received1) {
//                         UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
//                                                                            message:NSLocalizedString(@"error_internet",nil)
//                                                                           delegate:self
//                                                                  cancelButtonTitle:@"OK"
//                                                                  otherButtonTitles:nil];
//                         [theAlert show];
//                         NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age="];
//                         NSURL *url = [NSURL URLWithString:fullURL];
//                         NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//                         [self.webView loadRequest:requestObj];
//                         self.connectedlbl.text=@"無法上網";
//                         self.connectedlbl.hidden=NO;
//                     }
//                     else
//                     {
//                     UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
//                                                                        message:NSLocalizedString(@"error_internet",nil)
//                                                                       delegate:self
//                                                              cancelButtonTitle:@"OK"
//                                                              otherButtonTitles:nil];
//                     [theAlert show];
//                     self.connectedlbl.hidden=YES;
//                   
//                     }
//                 }
//                 else
//                 {
//                     received1=TRUE;
//                     self.connectedlbl.hidden=YES;
//                     self.connectedlbl.hidden=YES;
//                     NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age="];
//                     NSURL *url = [NSURL URLWithString:fullURL];
//                     NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//                     [self.webView loadRequest:requestObj];
//                 }
//             
//             }
//         }
//         else
//         {
//             self.connectedlbl.hidden=YES;
//             received1=TRUE;
//              NSString *strage=[NSString stringWithFormat:@"%d", (int)age];
//             if ([gender isEqualToString:@""] || gender.length==0) {
//                 NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age=%@&MacAddress=%@",strage,mac];
//                 NSLog(@"The URLLL IS %@",fullURL);
//                 NSURL *url = [NSURL URLWithString:fullURL];
//                 NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//                 [self.webView loadRequest:requestObj];
//             }
//             else
//             {
//             NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=%@&Age=%@&MacAddress=%@",gender,strage,mac];
//              NSLog(@"The URLLL IS %@",fullURL);
//             NSURL *url = [NSURL URLWithString:fullURL];
//             NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//             [self.webView loadRequest:requestObj];
//             }
//         }
//     NSLog(@"the gender is %@",gender);
     
     if (![self connected] )
     {
         
         
             UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                                message:NSLocalizedString(@"error_internet",nil)
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
             [theAlert show];
//             NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age="];
//             NSURL *url = [NSURL URLWithString:fullURL];
//             NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//             [self.webView loadRequest:requestObj];
             NSString *stringurl=[NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age="];
             NSURL *url=[NSURL URLWithString:stringurl];
             NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15.0];
             //[self.webView loadRequest:theRequest];
         [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];

             self.connectedlbl.text=@"無法上網";
             self.connectedlbl.hidden=NO;
              
         
     }
     
     else if (have3g)
     {
         
         received1=TRUE;
         self.connectedlbl.hidden=YES;
         NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age="];
         NSURL *url = [NSURL URLWithString:fullURL];
         NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
         [self.webView loadRequest:requestObj];
         
         //[[NSNotificationCenter defaultCenter] postNotificationName:@"relogin" object:self];
         
     }
     else
     {
         [self fetchSSIDInfo1];
         //this is how to check continous
         
         if ([ssid1 containsString:@"Y5Bus"]) {
             
             if (self.loginType==0) {
              
                 if (received1) {
//                     NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age="];
//                     NSURL *url = [NSURL URLWithString:fullURL];
//                     NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//                     [self.webView loadRequest:requestObj];
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
                 UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"please_log",nil)
                                                                    message:NSLocalizedString(@"login_desc2",nil)
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                 [theAlert show];
                     [theAlert setTag:1];
                     [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];

                 }
             }
             else
             {
                 self.connectedlbl.hidden=YES;
                              received1=TRUE;
                               NSString *strage=[NSString stringWithFormat:@"%d", (int)age];
                              if ([gender isEqualToString:@""] || gender.length==0) {
                                  NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age=%@&MacAddress=%@",strage,mac];
                                 NSLog(@"The URLLL IS %@",fullURL);
                                  NSURL *url = [NSURL URLWithString:fullURL];
                                  NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
                                  [self.webView loadRequest:requestObj];
                              }
                              else
                              {
                              NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=%@&Age=%@&MacAddress=%@",gender,strage,mac];
                               NSLog(@"The URLLL IS %@",fullURL);
                              NSURL *url = [NSURL URLWithString:fullURL];
                              NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
                              [self.webView loadRequest:requestObj];
                 
                              }
             }
             
         }
         
         else
         {
             received1=TRUE;
             self.connectedlbl.hidden=YES;
             
             NSString *fullURL = [NSString stringWithFormat:@"http://y5bus.chainyi.com/WebView/ZoneHome?Gender=&Age="];
             NSURL *url = [NSURL URLWithString:fullURL];
             NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
             [self.webView loadRequest:requestObj];
         
         }
         
         
     }
     
 }
 

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) { // UIAlertView with tag 1 detected
        if (buttonIndex == 0)
        {
            
           [self.tabBarController setSelectedIndex:0];
        }
    }
    

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

  In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
      Get the new view controller using [segue destinationViewController].
      Pass the selected object to the new view controller.
}
*/

@end
