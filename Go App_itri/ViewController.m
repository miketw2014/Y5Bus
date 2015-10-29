//
//  ViewController.m
//  Go App_itri
//
//  Created by Madhawan Misra on 5/25/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//
#define FACEBOOK_SCHEME  @"fb1484928761731211"
#define NSLocalizedFormatString(fmt, ...) [NSString stringWithFormat:NSLocalizedString(fmt, nil), __VA_ARGS__]
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#import "StoreKit/StoreKit.h"
#import "ViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <GooglePlus/GooglePlus.h>
//#import "WXApiObject.h"
#import "LoginViewController.h"
#import "CouponViewController.h"
#import "SettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RegisterViewController.h"
#import "DesktopViewController.h"
#import "CoupontwoViewController.h"
#import "AVFoundation/AVFoundation.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SDWebImage/UIImageView+WebCache.h"
 
@import SystemConfiguration.CaptiveNetwork;

@interface ViewController ()
<FBSDKLoginButtonDelegate>

-(void)toggleHiddenState:(BOOL)shouldHide;
@end

@implementation ViewController

{
    NSTimer *timer;
    bool loggedin,closed,have3g;
    NSString *contents;
    NSString *pic;
    NSString *gender;
    NSString *ssid ;
    NSString *username;
    NSString *usernamenew;
    NSString *email;
    NSString *venueid;
    NSString *uuid;
    NSString *routermacid;
    NSString *routermacidc;
    NSInteger age;
    NSString *userpoolId;
    NSString *usermac;
    NSString *useraccountid;
    NSString *size;
    NSString *userRecid;
    NSString *clickurl;

    bool likeid;
    bool facebook,showad,logout302;
    bool google;
    bool ownemail;
    bool ssidname;
    bool wechat,outrange,fleet;
    
    
}
MPMoviePlayerController *moviePlayer;
FBSDKLoginManager *login;
NSUserDefaults *defaults;
@synthesize loginButton;
//@synthesize loginindicator;
@synthesize likeButton;
 
GPPSignIn *signIn;
NSTimer *updateTimer;
int loginType;
bool call;
UIAlertView *ownlogin;
@synthesize signInButton;
static NSString * const kClientId = @"164304610763-71umi6kj6fopl31bqbrj5q3guhfkbl5g.apps.googleusercontent.com";
//534648
//164304610763-71umi6kj6fopl31bqbrj5q3guhfkbl5g.apps.googleusercontent.com

- (void)viewDidLoad {
    [super viewDidLoad];
    if ( IDIOM == IPAD ) {
    size=@"1";
    }
    else
    {
    size=@"0";
    }
    
    NSLog(@"size is %@",size);
    GPPSignIn *signIn;
     login  = [[FBSDKLoginManager alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:path];
   moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    [moviePlayer setControlStyle:MPMovieControlStyleNone];
    
    clickurl=@"http://www.y5bus.tw/EN/index";
    // Register this class as an observer instead
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    
    //initialise the ssidname as FALSE
    ssidname=FALSE;
self.automaticallyAdjustsScrollViewInsets = NO;
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkwififoreground:)
                                                 name:@"checkwifi"
                                               object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"logout"
                                               object:nil];
    
    [self fetchSSIDInfo];
    
    //fetch uuid of the device
   NSString *uuidinitial = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    uuid = [uuidinitial stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"ID: %@", uuid);
    loginType=0;
    
    //update ui
    [self updateUI];
    
    //first check if the user is connected to the right SSID
    
    if (![self connected] )
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_internet",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        [self logout];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"relogin" object:self];
    }
    
    else if (have3g)
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_threeg",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        [self logout];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"relogin" object:self];
        
    }
    else
    {
        [self fetchSSIDInfo];
        //this is how to check continous
        
        if ([ssid containsString:@"Y5Bus"]) {
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self testentryapi];
            });
            
        }
        else
        {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"wrong ssid",nil)
                                                               message:NSLocalizedString(@"error_ssid",nil)
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                                     otherButtonTitles:nil];
            [theAlert show];
            [self logout];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"relogin" object:self];
            
        }
        
    }
 



    self.loginButton.delegate=self;
    self.loginButton.readPermissions = @[@"public_profile", @"email",@"user_birthday",@"user_education_history",@"user_likes"];
    //self.loginButton.publishPermissions= @[@"publish_actions"];
    //login.
    
 // Uncomment to get the user's email
   // NSLog(@"email  is %@",signIn.shouldFetchGoogleUserEmail);
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    self.password.delegate = self;
    self.username.delegate=self;
   
    self.fleetimage.userInteractionEnabled=TRUE;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped1:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.fleetimage addGestureRecognizer:singleTap];

    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped2:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.fbimage addGestureRecognizer:singleTap1];
    // Do any additional setup after loading the view, typically from a nib.
}




-(void)updateUI
{
    
   // [self toggleHiddenState:YES];
    

    self.lblLoginStatus.text=@"";
    self.wechatb.hidden=YES;
    self.info.textColor=[UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
    self.info2.textColor=[UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
    //self.info.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"input_table_frist_bg.png"]];
    // self.info2.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"input_table_frist_bg.png"]];
    self.background.backgroundColor=[UIColor colorWithRed:252.0/255.0 green:248.0/255.0 blue:242.0/255.0 alpha:1.0];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(2, 16, 2, 16);
   
    UIImage *backgroundButtonImage = [[UIImage imageNamed:@"input_table_frist_bg.png"]
                                      resizableImageWithCapInsets:edgeInsets];
    UIImage *backgroundButtonImage1 = [[UIImage imageNamed:@"input_table_last_bg.png"]
                                       resizableImageWithCapInsets:edgeInsets];
     UIEdgeInsets edgeInsets1 = UIEdgeInsetsMake(6, 6, 6, 6);
    UIImage *emailoginbutton = [[UIImage imageNamed:@"btn_orange_bg_normal.png"]
                                resizableImageWithCapInsets:edgeInsets1];
    UIImage *emailoginbutton2 = [[UIImage imageNamed:@"btn_orange_bg_pressed.png"]
                                 resizableImageWithCapInsets:edgeInsets1];
    
    [self.loginemail setBackgroundImage:emailoginbutton forState:UIControlStateNormal];
    [self.loginemail setBackgroundImage:emailoginbutton2 forState:UIControlStateSelected];
    [self.loginemail setBackgroundImage:emailoginbutton2 forState:UIControlStateHighlighted];
    UIImage *normal = [[UIImage imageNamed:@"btn_white_bg_normal.png"]
                                 resizableImageWithCapInsets:edgeInsets1];
    UIImage *pressed = [[UIImage imageNamed:@"btn_white_bg_pressed.png"]
                                 resizableImageWithCapInsets:edgeInsets1];
    
    self.lblEmail.textColor=[UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0];
    self.lblLoginStatus.textColor=[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    self.firsttable.image=backgroundButtonImage;
    self.lasttable.image=backgroundButtonImage1;
    [self.loginemail setBackgroundImage:emailoginbutton forState:UIControlStateNormal];
    [self.loginemail setBackgroundImage:emailoginbutton2 forState:UIControlStateSelected];
    [self.loginemail setBackgroundImage:emailoginbutton2 forState:UIControlStateHighlighted];
    [self.fblogin setBackgroundImage:normal forState:UIControlStateNormal];
    [self.glogin setBackgroundImage:normal forState:UIControlStateNormal];
    [self.wechatb setBackgroundImage:normal forState:UIControlStateNormal];
    [self.fblogin setBackgroundImage:pressed forState:UIControlStateHighlighted];
    [self.glogin setBackgroundImage:pressed forState:UIControlStateHighlighted];
    [self.wechatb setBackgroundImage:pressed forState:UIControlStateHighlighted];
    [self.fblogin setBackgroundImage:pressed forState:UIControlStateSelected];
    [self.glogin setBackgroundImage:pressed forState:UIControlStateSelected];
    [self.wechatb setBackgroundImage:pressed forState:UIControlStateSelected];
    [self.forgotpassword setTitleColor:[UIColor colorWithRed:178.0/255.0 green:107.0/255.0 blue:0.0/255.0 alpha:1.0]
                              forState:UIControlStateNormal];
    [self.reg setTitleColor:[UIColor colorWithRed:178.0/255.0 green:107.0/255.0 blue:0.0/255.0 alpha:1.0]
                   forState:UIControlStateNormal];
    
    
    //advertisment
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString* path = [documentsDirectory stringByAppendingPathComponent:
//                      @"test.png" ];
    UIImage* image = [UIImage imageNamed:@"ss.jpg"];
       NSString *loginmethod= [defaults objectForKey:@"login"];
    if ([loginmethod isEqualToString:@""] || loginmethod.length==0) {
        self.advertimg.image=image;
        self.advertimg.hidden=NO;
        self.closeadvert.hidden=NO;
        self.closeadvert.enabled=NO;
        self.maskview.hidden=NO;
         
        showad=TRUE;
        
     timer= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setButtonEnabled) userInfo:nil repeats:NO];
  
    }
    
    else
    {
        showad=FALSE;
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    self.tabBarController.delegate=self;
    //self.delegate=self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
}
-(void)setButtonEnabled{
    
    self.closeadvert.enabled=YES;
    self.closevideo.enabled=YES;
    
}


- (void)imageTaped2:(UIGestureRecognizer *)gestureRecognizer {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://page/1631008317172626"]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://page/1631008317172626"]];
    } else {
        NSLog(@"Facebook isn't installed.");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/1631008317172626"]];

    
}
}

- (void)imageTaped1:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"the imageurl is %@",clickurl);
 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:clickurl]];
    
}

//check for correct ssid after the app again enters foreground from background
-(void)checkwififoreground:(NSNotification *) notification
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    [moviePlayer setControlStyle:MPMovieControlStyleNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    NSError *error;
    if ( ![[AVAudioSession sharedInstance] setActive:NO error:&error] ) {
        NSLog(@"Error encountered: %@", [error localizedDescription]);
    }
    

       if (![self connected] )
       {
           
           UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                              message:NSLocalizedString(@"error_internet",nil)
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
           [theAlert show];
           [self logout];
          // [[NSNotificationCenter defaultCenter] postNotificationName:@"relogin" object:self];
       }
    
    else if (have3g)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"desktoplogout" object:self];

        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_threeg",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        [self logout];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"relogin" object:self];
        
    }
        else
        {
            [self fetchSSIDInfo];
            //this is how to check continous
            
            if ([ssid containsString:@"Y5Bus"]) {
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self testentryapidemo];
                });
                
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"desktoplogout" object:self];

                UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"wrong ssid",nil)
                                                                   message:NSLocalizedString(@"error_ssid",nil)
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                                         otherButtonTitles:nil];
                [theAlert show];
                [self logout];
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"relogin" object:self];
                
            }
        
        }
        }


- (NSString *)fetchSSIDInfo
{
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
            
            
            NSLog(@"the ssid is %@" ,ssid);
            
        }
    }
    return ssid;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

//Implement resignOnTap:

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if(networkStatus == NotReachable)
    {
        have3g=FALSE;
        NSLog(@"network status is no");
    }
    else if (networkStatus == ReachableViaWiFi)
    {
        have3g=FALSE;
        NSLog(@"network status is wifi");
    }
    else if (networkStatus == ReachableViaWWAN)
    {
        NSLog(@"network status is 3g");
        have3g=TRUE;
    }
    return networkStatus != NotReachable;
}

//tabbar controller
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
   UINavigationController *navigationController = (UINavigationController *)[[tabBarController viewControllers] objectAtIndex:4];
    UINavigationController *navigationController2 = (UINavigationController *)[[tabBarController viewControllers] objectAtIndex:2];
    UINavigationController *navigationController3 = (UINavigationController *)[[tabBarController viewControllers] objectAtIndex:1];
    UINavigationController *navigationController1 = (UINavigationController *)[[tabBarController viewControllers] objectAtIndex:3];

   SettingViewController *setting1 = (SettingViewController *)[[navigationController viewControllers] objectAtIndex:0];
    DesktopViewController *desktop = (DesktopViewController *)[[navigationController2 viewControllers] objectAtIndex:0];
    CoupontwoViewController *coupon= (CoupontwoViewController *)[[navigationController3 viewControllers] objectAtIndex:0];
    CouponViewController *coupon2= (CouponViewController *)[[navigationController1 viewControllers] objectAtIndex:0];

    //NSUInteger indexOfTab = [tabBarController.viewControllers indexOfObject:viewController];
    //NSLog(@"Tab index = %u (%u)", indexOfTab);
   // UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:4];
    
    //self.setting = (SettingViewController *) [tabBarController.viewControllers objectAtIndex:4];
    
    //
    if (facebook) {
        //setting1.img=self.gpic.image;
        setting1.loginType=loginType;
        //NSLog(@"the user name and email is %@ %@",username,email);
        setting1.usernames=usernamenew;
        setting1.emails=email;
        desktop.gender=gender;
        desktop.loginType=loginType;
        coupon.gender=gender;
        coupon.loginType=loginType;
        coupon.mac=routermacidc;
        desktop.macaddress=routermacidc;
        desktop.age=age;
        coupon.age=age;
        coupon2.loginType=loginType;
        coupon2.mac=routermacidc;
        coupon2.gender=gender;
        coupon2.age=age;
        NSLog(@"the age is equal to %li",(long)age);
        
    }
    else if (google)
    {
    setting1.img=self.gpic.image;
    setting1.loginType=loginType;
   // NSLog(@"the user name and email is %@ %@",username,email);
    setting1.usernames=usernamenew;
    setting1.emails=email;
        desktop.gender=gender;
        desktop.loginType=loginType;
        coupon.loginType=loginType;
        coupon.gender=gender;
        desktop.age=age;
        coupon.age=age;
        coupon.mac=routermacidc;
        desktop.macaddress=routermacidc;
        coupon2.mac=routermacidc;
        coupon2.gender=gender;
        coupon2.age=age;
        coupon2.loginType=loginType;

        NSLog(@"the age is equal to %li",(long)age);
    }
    else if (ownemail)
    {
        setting1.img=self.gpic.image;
        setting1.loginType=loginType;
         NSLog(@"the user name and email is %@ %@", [defaults objectForKey:@"Name"],email);
        setting1.usernames=[defaults objectForKey:@"Name"];
        setting1.emails=email;
        desktop.gender=gender;
        desktop.loginType=loginType;
        coupon.gender=gender;
        coupon.loginType=loginType;
        coupon.age=age;
        desktop.age=age;
        coupon.mac=routermacidc;
        coupon2.loginType=loginType;
        desktop.macaddress=routermacidc;
        coupon2.mac=routermacidc;
        coupon2.gender=gender;
        coupon2.age=age;
    }
    else if (loginType==0)
    {
        
        desktop.gender=gender;
        desktop.loginType=0;
        coupon.gender=gender;
        coupon.loginType=0;
        coupon2.loginType=0;
        coupon2.gender=gender;
        
        
    }
    
 
}

//action which is expected when the user signs in
-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
 
        // Perform other actions here, such as showing a sign-out button
    } else {
         //sign out
        // Perform other actions here
    }
}


//google + login receive data
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    BOOL erroroccured;
    NSLog(@"Received error %@ and auth object %@",error, auth);
    
    

    if (error) {
        erroroccured=TRUE;
        [self.loginindicator stopAnimating];

       // self.SigninAuthStatus.text =
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error_login",nil)
                                                           message:NSLocalizedString(@"error_google_desc",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        [NSString stringWithFormat:@"Status: Authentication error: %@", error];
        
        self.glogin.enabled=YES;
        [self logout];
        self.loading.hidden=YES;
        return;
        
        
    }
    else{
    
    // getting the access token from auth
        
        [self refreshInterfaceBasedOnSignIn];
    NSString  *accessTocken = [auth valueForKey:@"accessToken"]; // access tocken pass in .pch file
        
      
    NSLog(@"%@",accessTocken);
    NSString *str=[NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?access_token=%@",accessTocken];
    NSString *escapedUrl = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",escapedUrl]];
    NSString *jsonData = [[NSString alloc] initWithContentsOfURL:url usedEncoding:nil error:nil];
         NSData* jsondata = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:&error];
    NSString *userId=[jsonDictionary objectForKey:@"id"];
        useraccountid=userId;
    // proDic=[jsonData JSONValue];
    
    NSLog(@" user deata %@",useraccountid);
        
        
    NSLog(@"Received Access Token:%@",auth);
    
    // NSLog(@"user google user id  %@",signIn.userEmail); //logged in user's email id
    
    

    GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
    plusService.retryEnabled = YES;
    [plusService setAuthorizer:auth];
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:userId];
    
    
    [plusService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,GTLPlusPerson*person,NSError *error) {
        
        if (error) {
           
            GTMLoggerError(@"Error: %@", error);
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error_login",nil)
                                                               message:NSLocalizedString(@"error_google_desc",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            [self.loginindicator stopAnimating];
            self.glogin.enabled=YES;
            [self logout];
            self.loading.hidden=YES;
            
        } else {
            
            // Retrieve the display name and "about me" text
            
            NSString *description = [NSString stringWithFormat:
                                     
                                     @"%@\n%@", person.displayName,
                                     
                                     person.aboutMe];
            
          
           
//            updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.51428 target:self selector:@selector(GameUpdate:) userInfo:nil repeats:NO];
           
            self.lblEmail.text=signIn.userEmail;
            email=signIn.userEmail;
            username=description;

           //GTLPlusPersonImage *image  =person.image;
          
              NSString *birthday=person.birthday;
           // NSString *birthdaytest=birthday;
          NSLog(@"the birthdayyyyy is %@",person.birthday);
            if (![birthday containsString:@"-"]) {
            
                
                birthday=@"";
                age=0;
                 NSLog(@"the birthdayyyyy again is %@",birthday);
            }
            else
            {
                NSDate *todayDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-mm-dd"];
                int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:birthday]];
                int allDays = (((time/60)/60)/24);
                int days = allDays%365;
                age = (allDays-days)/365;
                
                NSLog(@"You live since %li ",(long)age);
            }
            
            NSString *picture=[jsonDictionary valueForKey:@"picture"];
            NSString *email1=[jsonDictionary valueForKey:@"email"];
            NSString *name1=[jsonDictionary valueForKey:@"given_name"];
            
            
            self.gpic.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:person.image.url]]];
            
             self.lblUsername.text=name1;
            usernamenew=name1;
             gender=[jsonDictionary valueForKey:@"gender"];
            NSString  *genderstatus;
            if([gender isEqualToString:@"male"])
            {
                genderstatus=@"1";
            }
            else if ([gender isEqualToString:@"female"])
            {
                genderstatus=@"0";
            }
            else
            {
                genderstatus=@"2";
                gender=@"";
            }
            //self.gpic.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strimag]]];
            
            //when received 201 or already logged in line 3
            if (loggedin) {
                
                self.afterlogin.text=[NSString stringWithFormat:NSLocalizedString(@"g_desc",nil)];
                self.lblLoginStatus.text=NSLocalizedString(@"glogin",nil);
                loginType=2;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"glogin" object:self.lblUsername.text];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:routermacidc forKey:@"macid"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"desktoplogin" object:self userInfo:userInfo];
                self.lblUsername.hidden=NO;
                self.gpic.hidden=NO;
                self.lblLoginStatus.hidden=NO;
                self.afterlogin.hidden=NO;
                [self.loginindicator stopAnimating];
                self.loading.hidden=YES;
                //[self LoginState:YES];
            }
            
            else
            {
            
            //start the API call
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            
            NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"appAuthSucces\",\"params\":{\"logintype\":\"google\",\"routerid\":\"%@\",\"usermac\":\"%@\",\"uuid\":\"%@\",\"username\":\"%@\",\"usergender\":\"%@\",\"userbirthday\":\"%@\",\"useremail\":\"%@\",\"headimgurl\":\"%@\"}}}",routermacid,usermac,uuid,name1,genderstatus,birthday,email1,picture];
            
            
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
            
            
            
            //azure google plus webcall
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                
                NSString *s=[NSString stringWithFormat:@"key=null&type=Google&account=%@&password=null&name=%@&email=%@&gender=%@&birthday=%@",
                             userId,name1,email1,gender,birthday];
                
                
                NSData *postData = [s dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                NSLog(@"postdata: %@", postData);
                NSLog(@"postdata string: %@", s);
                NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
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
                
            });
            
            
      
            //response
            
            NSURLResponse *requestResponse;
            NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
            // NSLog(@"requesthandler: %@", requestHandler);
            
            NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
            NSLog(@"requestReply: %@", requestReply);
            NSData* jsondata = [requestReply dataUsingEncoding:NSASCIIStringEncoding];
            
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:NULL];
            NSLog(@"JSON DATA IS %@",jsondata);
            
            NSDictionary *mac=[jsonDictionary objectForKey:@"methodResponse"];
            NSDictionary *mac2=[mac objectForKey:@"params"];
            
            NSString *status=[mac2 objectForKey:@"status"];
            //NSString *userrecid=[mac2 objectForKey:@"userRecId"];
            NSString *routercmd=[mac2 objectForKey:@"routercmd"];
                self.loading.hidden=YES;
            if ([status isEqualToString:@"304"]) {
                NSString *userRecId=[mac2 objectForKey:@"userRecId"];
                
                [self routerpass:userRecId];
                
            }
                if ([status isEqualToString:@"201"]) {
                    NSString *userRecId=[mac2 objectForKey:@"userRecId"];
                    
                    [self routerpass:userRecId];
                    
                }
            else if ([status isEqualToString:@"404"])
            {
                [self logout];
                UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error_login",nil)
                                                                   message:NSLocalizedString(@"error_login_google",nil)
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                [theAlert show];
                 
                self.glogin.enabled=YES;
                [self.loginindicator stopAnimating];

            }
            
       }
        }
    }];
    
        
        
        
        
        
    // [self reportAuthStatus];
    }
    //[[GPPSignIn sharedInstance] signOut];
    
}

-(void)toggleHiddenState:(BOOL)shouldHide
{
    self.lblEmail.hidden=shouldHide;
    self.lblUsername.hidden=shouldHide;
    self.profilePicture.hidden=shouldHide;

}

-(void)testentryapidemo
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //NSString *post = [NSString stringWithFormat:@"test=Message&this=isNotReal"];
    NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"getRouterInfo\",\"uuid\":\"%@\"}}",uuid];
    
    NSData *postData = [s dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //  NSLog(@"postdata: %@", postData);
    // NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://1.1.1.1/appHandler.cgi"]];
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
    routermacid=[mac2 objectForKey:@"routerid"];
    usermac=[mac2 objectForKey:@"usermac"];
    NSLog(@"the usermac address is : %@", usermac);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (usermac==(id)[NSNull null] || usermac.length == 0)
        {
            outrange=TRUE;
            
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                               message:NSLocalizedString(@"error_range",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            [self logout];
            
            
        }
        else
            outrange=FALSE;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self stringToHex:routermacid];
            
        });
        {
            //[self testentryapi2:routermacid second:usermac];
        }
    });
    //  NSString *macstring=[mac objectForKey:@"routerid"];
    // NSLog(@"mac is %@",macstring);
    
    
    
}

//the first api called to get the router mac address
-(void)testentryapi
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
   
    //NSString *post = [NSString stringWithFormat:@"test=Message&this=isNotReal"];
    NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"getRouterInfo\",\"uuid\":\"%@\"}}",uuid];
    
    NSData *postData = [s dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  //  NSLog(@"postdata: %@", postData);
   // NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://1.1.1.1/appHandler.cgi"]];
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
    routermacid=[mac2 objectForKey:@"routerid"];
    usermac=[mac2 objectForKey:@"usermac"];
   
   NSLog(@"the usermac address is : %@", usermac);
    
    //[self updatefleetimage:routermacid];
    dispatch_async(dispatch_get_main_queue(), ^{
    if (usermac==(id)[NSNull null] || usermac.length == 0)
    {
        outrange=TRUE;
        
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                               message:NSLocalizedString(@"error_range",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
        [self logout];
       
        
    }
    else
        outrange=FALSE;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self stringToHex:routermacid];
            
        });
    {
    [self testentryapi2:routermacid second:usermac];
    }
    });
  //  NSString *macstring=[mac objectForKey:@"routerid"];
   // NSLog(@"mac is %@",macstring);
    
    
    
}

- (NSString *) stringToHex:(NSString *)str
{

    if ([str isEqualToString:@""] ||str.length==0) {
        
    
    }
    
    else
    {
        
    NSInteger intVal = strtol([str cStringUsingEncoding:NSASCIIStringEncoding], nil, 16);
    NSLog(@"%ld", (long)intVal);
   NSInteger newone= intVal-1;
    
    NSString *final=[NSString stringWithFormat:@"%016lX",(long)newone];
    NSString *finalresult = [final substringFromIndex:4];
    NSLog(@"the final value is %@",finalresult);
    routermacidc=finalresult;
        
    }
    return str;
}
-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}
//get mac address


//second api to get the login options existing
-(void)testentryapi2:(NSString *)macidi1 second:(NSString *)usermacid
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //NSString *post = [NSString stringWithFormat:@"test=Message&this=isNotReal"];
    NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"entry\",\"params\":{\"routerid\":\"%@\",\"usermac\":\"%@\",\"uuid\":\"%@\"}}}",macidi1,usermac,uuid];
    
    NSLog(@"string is %@",s);
    NSData *postData = [s dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSLog(@"postdata: %@", postData);
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
    //NSLog(@"requesthandler: %@", requestHandler);
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSLog(@"requestReply: %@", requestReply);
    NSData* jsondata = [requestReply dataUsingEncoding:NSASCIIStringEncoding];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:NULL];
    
    
    NSDictionary *mac=[jsonDictionary objectForKey:@"methodResponse"];
    NSDictionary *mac2=[mac objectForKey:@"params"];
    NSString *routercmd=[mac2 objectForKey:@"routercmd"];
    NSString *status=[mac2 objectForKey:@"status"];
    if ([status isEqualToString:@"402"]) {
        loggedin=FALSE;
       [self logout];
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_router",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
       // updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.51428 target:self selector:@selector(GameUpdate:) userInfo:nil repeats:NO];
    }
    
    else if ([status isEqualToString:@"302"])
    {
        loggedin=FALSE;
        venueid=[mac2 objectForKey:@"venuefbpageid"];
        NSString *loginmethod= [defaults objectForKey:@"login"];
        if (!logout302) {
           [self logout];
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"relogin",nil)
                                                               message:NSLocalizedString(@"please_login",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            logout302=TRUE;
        }
        else
        {
            NSLog(@"already loggedout");
        }
        
        if (!showad) {
            
        
        UIImage* image = [UIImage imageNamed:@"ss.jpg"];
        
        self.advertimg.image=image;
        self.advertimg.hidden=NO;
        self.closeadvert.hidden=NO;
        self.closeadvert.enabled=NO;
        self.maskview.hidden=NO;
            showad=TRUE;
        
        
        timer= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setButtonEnabled) userInfo:nil repeats:NO];
        }
        
//        if ([loginmethod isEqualToString:@"facebook"])
//        {
//            facebook=TRUE;
//            [self freeminutesapi];
//            NSString *repeat=@"no";
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"stoprepeat" object:repeat];
//
//            
//        }
//        else if ([loginmethod isEqualToString:@"google"])
//        {
//            google=TRUE;
//            self.glogin.enabled=NO;
//            [self freeminutesapi];
//        }
//        
//        else if([loginmethod isEqualToString:@"self"])
//        {
//            
//                // do work here
//                [self LoginState:NO];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"relogin" object:self];
//            [defaults setObject:@"" forKey:@"login"];
//            [defaults synchronize];
//            
//                self.profilePicture.hidden=YES;
//                self.gpic.hidden=YES;
//                self.gout.hidden=YES;
//                likeButton.hidden=YES;
//                self.afterlogin.hidden=YES;
//                self.lblUsername.hidden=YES;
//                self.lblEmail.hidden=YES;
//            self.lblLoginStatus.hidden=YES;
//                ownlogin= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"relogin",nil)
//                                                     message:NSLocalizedString(@"relogin_desc",nil)
//                                                    delegate:self
//                                           cancelButtonTitle:@"OK"
//                                           otherButtonTitles:nil];
//                [ownlogin show];
//           
//            
//            
//           
//        }
   
    }
    
    else if ([status isEqualToString:@"401"])
        
    {
        loggedin=FALSE;
        [self logout];
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                        message:NSLocalizedString(@"three_times",nil)
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [theAlert show];
        
        
    }
   
    if ([status isEqualToString:@"201"]) {
        loggedin=TRUE;
        NSString *userRecId=[mac2 objectForKey:@"userRecId"];
       
       NSString *loginmethod= [defaults objectForKey:@"login"];
        if ([loginmethod isEqualToString:@"facebook"]) {
            NSString *repeat=@"no";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stoprepeat" object:repeat];
            facebook=TRUE;
            [self.loginindicator startAnimating];
            self.loading.hidden=NO;
            [self routerpass:userRecId];
        }
        
        else if ([loginmethod isEqualToString:@"google"])
        {
            google=TRUE;
            self.glogin.enabled=NO;
            [self.loginindicator startAnimating];
            self.loading.hidden=NO;
            [self routerpass:userRecId];
        }
        
        else if ([loginmethod isEqualToString:@"self"])
        {
            ownemail=TRUE;
            [self routerpass:userRecId];
            
        }
        else if ([loginmethod isEqualToString:@""])
        {
            loggedin=FALSE;
            //ownemail=TRUE;
            
        }
        else
        {
          loggedin=FALSE;  
        }
        
       // [theAlert show];
        //[self routerpass:userRecId];
        
//        updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.51428 target:self selector:@selector(GameUpdate:) userInfo:nil repeats:NO];
        
    }
    
    
}

-(void)updatefleetimage:(NSString *)routermac
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *s=[NSString stringWithFormat:@"MacAddress=%@&Size=%@",routermacidc,size];
    
    NSLog(@"the USERLOGINLOG is %@",s);
    NSData *postData = [s dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //  NSLog(@"postdata: %@", postData);
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://y5bus.chainyi.com/WebServices/WebService.asmx/GetFleetAd"]];
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
    if ([match isEqualToString:@"0"]) {
        
 
        self.xmlParser2 = [[NSXMLParser alloc] initWithData:requestHandler];
        self.xmlParser2.delegate = self;
        
        // Initialize the mutable string that we'll use during parsing.
        self.foundValue2 = [[NSMutableString alloc] init];
        
        // Start parsing.
         [self.xmlParser2 parse];
   
    }
    
    else
    {
        
    
    }

    
}
 

-(void)LoginState:(BOOL)shouldHide
{
     //self.lblEmail.hidden=shouldHide;
    
   // self.profilePicture.hidden=shouldHide;
   // self.appLogin.hidden=shouldHide;
    self.fblogin.hidden=shouldHide;
    //self.profilePicture.hidden=shouldHide;
    //self.gpic.hidden=shouldHide;
    self.glogin.hidden=shouldHide;
    //self.wechatb.hidden=shouldHide;
    self.gout.hidden=shouldHide;
    self.reg.hidden=shouldHide;
    self.firsttable.hidden=shouldHide;
    self.lasttable.hidden=shouldHide;
    self.info.hidden=shouldHide;
    self.info2.hidden=shouldHide;
    self.username.hidden=shouldHide;
    self.password.hidden=shouldHide;
    self.loginemail.hidden=shouldHide;
    self.forgotpassword.hidden=shouldHide;
    self.registeracct.hidden=shouldHide;
    
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginViewShowingLoggedInUser:(FBSDKLoginManager *)loginView{
  
}

- (void)  loginButton:  (FBSDKLoginButton *)loginButton
didCompleteWithResult:  (FBSDKLoginManagerLoginResult *)result
                error:  (NSError *)error{
    
    NSLog(@"facebook login button test");
   
   // [self toggleHiddenState:NO];
   
    //disable since first provide 5 minutes
    
    // [self loginViewFetchedUserInfo];
    
    
    
}

//api for free 5 minutes of limited internet
-(void)freeminutesapi
{
    
    [self fetchSSIDInfo];
    if ([ssid containsString:@"Y5Bus"])
    
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
        if([status isEqualToString:@"301"])
        {
           
             //[theAlert show];
            if (facebook) {
                
                [self.loginindicator startAnimating];
                self.loading.hidden=NO;
                [self LoginState:YES];
                [self loginViewFetchedUserInfo];
            }
            else if (google)
            {
                [self.loginindicator startAnimating];
                self.loading.hidden=NO;
                [self LoginState:YES];
                [self googlefree];
            }
            else if (ownemail)
            {
                [self ownloginfree];
            }
            else if (wechat)
            {
                [self sendweburlToWeixin];
            }
           
            //if status is 301, fetch data
        }
        
        else if ([status isEqualToString:@"401"])
        {
            
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                               message:NSLocalizedString(@"temp_login_failed",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            [self logout];
            
           // [self loginViewFetchedUserInfo];

        }

    }
    else
    {
        [self.loginindicator stopAnimating];
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"wrong ssid",nil)
                                                           message:NSLocalizedString(@"error_ssid",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        [self.loginindicator stopAnimating];
        
    }
    
}


- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"facebook logout button test");
    [self toggleHiddenState:YES];
    self.lblLoginStatus.text = @"You logged out.";
    loginType=0;
}

//-(void)fetchlikes
//{
//    
//    if ([FBSDKAccessToken currentAccessToken]) {
//        
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/likes" parameters:nil]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//             if (!error) {
//                 
//                 //[self LoginState:YES];
//                 
//                 
//                 //self.lblLoginStatus.text = @"You are logged in.";
//                 
//                 //self.lblEmail.text=[result objectForKey:@"email"];
//                 
//                 
//                 
//                 NSDictionary *like=[result objectForKey:@"data"];
//                 bool likefound;
//                 //NSDictionary *categorty=[d objectForKey:@"category"];
//                 for (NSDictionary *d in like)
//                 {
//                    
//                     NSString *idlike=[d objectForKey:@"id"];
//                      NSLog(@"the id is %@",idlike);
//                     
//                     if ([idlike isEqualToString:@"248341475326959"]) {
//                        //
//                         likeid=YES;
//                         [self checklike:TRUE];
//                          likefound=TRUE;
//                        
//                         break;
//                         
//                         
//                         
//                     }
//                     else
//                     {
//                         likeid=FALSE;
//                         
//                         if(likefound)
//                             
//                         {
//                             likeid=TRUE;
//                             break;
//                         }
//                         
//                         
//                     }
//                     if (likefound) {
//                        
//                         [self checklike:likeid];
//                          break;
//                         
//                     }
//                    
//                     if (likefound) {
//                         
//                         [self checklike:likeid];
//                         break;
//                         
//                     }
//                 
//                 }
//                 
//                 
//                 
//             }
//         }
//         
//         ];
//    }
//}


-(void)loginViewFetchedUserInfo
{
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 
                 
                 NSString *education;
                 
                 
                 
                 
                 
                 self.lblEmail.text=[result objectForKey:@"email"];
          //       NSLog(@"the data is %@",result);
                 NSDictionary *a=[result objectForKey:@"education"];
                for(NSDictionary *a1 in a)
                {
                    NSLog(@"the education is %@",a1);
                    NSString *type=[a1 objectForKey:@"type"];
                    NSLog(@"the type is %@",type);
                    if ([type isEqualToString:@"College"]) {
                        education=@"2";
                    }
                    else if ([type isEqualToString:@"High School"])
                    {
                        education=@"1";
                    }
                    else if ([type isEqualToString:@"Graduate school"])
                    {
                        education=@"3";
                    }
                    else
                    {
                        education=@"0";
                    }
                    
                }
                 
                 //email
                 email=[result objectForKey:@"email"];
                 self.lblUsername.text = [NSString stringWithFormat:@"%@ %@",
                                          [result objectForKey:@"first_name"],
                                          [result objectForKey:@"last_name"]
                                          ];
                 usernamenew=[NSString stringWithFormat:@"%@ %@",
                              [result objectForKey:@"first_name"],
                              [result objectForKey:@"last_name"]
                              ];
             self.lblUsername.hidden=YES;
                 username=[NSString stringWithFormat:@"%@ %@",
                           [result objectForKey:@"first_name"],
                           [result objectForKey:@"last_name"]
                           ];
                 
                 //username
                 NSString *username1= [NSString stringWithFormat:@"%@%@",
                                                 [result objectForKey:@"first_name"],
                                                 [result objectForKey:@"last_name"]
                                                 ];
                // self.lblLoginStatus.text = username1;
                 //gender
                 
                  gender=[result objectForKey:@"gender"];
                 NSString *genderstatus;
                 if([gender isEqualToString:@"male"])
                 {
                     genderstatus=@"1";
                 }
                 else if ([gender isEqualToString:@"female"])
                 {
                     genderstatus=@"0";
                 }
                 else
                 {
                     genderstatus=@"2";
                 }
                 NSLog(@"the gender and education is %@ %@",gender,education);
                 //birthday
                 NSString *birthday=[result objectForKey:@"birthday"];
                 NSLog(@"the birthday is %@",birthday);
                 
                 if ([birthday isEqualToString:@""] || birthday.length==0) {
                     age=0;
                     
                 }
                 else
                 {
                     NSDate *todayDate = [NSDate date];
                     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                     [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                     int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:birthday]];
                     int allDays = (((time/60)/60)/24);
                     int days = allDays%365;
                     age = (allDays-days)/365;
                     
                     NSLog(@"You live since %li ",(long)age);
                 }
                 //id
                 NSString *id1=[result objectForKey:@"id"];
                 useraccountid=id1;
                 
                 
                 if (loggedin) {
                     
                     self.afterlogin.text=[NSString stringWithFormat:NSLocalizedString(@"fb_desc",nil)];
                     self.lblLoginStatus.text=NSLocalizedString(@"fblogin",nil);
                     loginType=1;
                     NSString *repeat=@"yes";
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"stoprepeat" object:repeat];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"fblogin" object:self.lblUsername.text];
                     NSDictionary *userInfo = [NSDictionary dictionaryWithObject:routermacidc forKey:@"macid"];

                     [[NSNotificationCenter defaultCenter] postNotificationName:@"desktoplogin" object:self userInfo:userInfo];
                     self.profilePicture.hidden=NO;
                     self.lblUsername.hidden=NO;
                     self.lblLoginStatus.hidden=NO;
                     self.afterlogin.hidden=NO;
                     [self LoginState:YES];
                     NSString *like= [defaults objectForKey:@"like"];
                     NSLog(@"the value for like is %@",like);
                     self.loading.hidden=YES;
                     [self.loginindicator stopAnimating];
                     if ([like isEqualToString:@"yes"]) {
                         likeButton.objectID = @" https://www.facebook.com/1631008317172626";
                         likeButton.hidden=NO;
                     }
                     else
                     {
                         likeButton.hidden=YES;
                     }
                  
                 }
                 
               else
               {
                 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                 
                
                 NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"appAuthSucces\",\"params\":{\"logintype\":\"facebook\",\"routerid\":\"%@\",\"usermac\":\"%@\",\"uuid\":\"%@\",\"userfabookid\":\"%@\",\"username\":\"%@\",\"usergender\":\"%@\",\"userbirthday\":\"%@\",\"useremail\":\"%@\",\"usereducation\":\"%@\"}}}",routermacid,usermac,uuid,id1,username1,genderstatus,birthday,email,education];
                 
                 
                 
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
                 
   

                 //azure xml call being made
                 
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     
                     
                     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                     
                     NSString *s=[NSString stringWithFormat:@"key=null&type=Facebook&account=%@&password=null&name=%@&email=%@&gender=%@&birthday=%@",
                                  id1,username1,email,gender,birthday];
                     
                     
                     NSData *postData = [s dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                     NSLog(@"postdata: %@", postData);
                     NSLog(@"postdata string: %@", s);
                     NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
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
    
                 });
                 
                 //response
                 
                 NSURLResponse *requestResponse;
                 NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
                 // NSLog(@"requesthandler: %@", requestHandler);
                 
                 NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
                   NSLog(@"requestReply: %@", requestReply);
                 NSData* jsondata = [requestReply dataUsingEncoding:NSASCIIStringEncoding];
//                 
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:&error];
                 NSLog(@"the error is %@",error);
                   if(error)
                   {
                       UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error_login",nil)
                                                                          message:NSLocalizedString(@"error_google_desc",nil)
                                                                         delegate:self
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                       [theAlert show];
                       [self logout];
                       
                   }
                   else
                   {
                       NSLog(@"NO ERROR");
                   }
                   
                 
                 NSDictionary *mac=[jsonDictionary objectForKey:@"methodResponse"];
                  NSDictionary *mac2=[mac objectForKey:@"params"];

                 NSString *status=[mac2 objectForKey:@"status"];
                 NSString *routercmd=[mac2 objectForKey:@"routercmd"];
                   
                   contents=[mac2 objectForKey:@"postcontent"];
                   pic=[mac2 objectForKey:@"accesspostpic"];
                   
                 if ([status isEqualToString:@"303"]) {
                     [self.loginindicator startAnimating];
                     self.loading.hidden=NO;
                     userpoolId=[mac2 objectForKey:@"userPoolId"];
                             NSString *like= [defaults objectForKey:@"like"];
                     NSLog(@"the value for like is %@",like);
                     
                     if ([like isEqualToString:@"yes"]) {
                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

                         [self shareapicheck:NO];
                         });
                         }
                     
                        else
                        {
                            
                     UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"like",nil)
                                                                        message:NSLocalizedString(@"like_desc",nil)
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:NSLocalizedString(@"skip",nil),nil];
                     [theAlert show];
                     [theAlert setTag:1];
                            
                     }
                     
                     
                 }
                else if ([status isEqualToString:@"201"] )
                {
                    NSString *userRecId=[mac2 objectForKey:@"userRecId"];

                    
                    //[theAlert show];
                    
                    [self routerpass:userRecId];
                }
                
               }
                 
                 
             }
             
          else if (error)
          {
              
              NSLog(@"there is error %@",error);
              [self logout];
              UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error_login",nil)
                                                                 message:NSLocalizedString(@"error_google_desc",nil)
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
              [theAlert show];
              
          }
         }];
    }
    else
    {
        NSLog(@"facebook has no token");
        [self facebookfree];
    }
}


-(void)azureapicall
{
    
    
    
}
-(void)shareapicheck:(BOOL)share
{
    NSString *sharefb;
    if (share==NO)
    {
        sharefb=@"0";
        
    }
    else if(share==YES)
    {
        
        sharefb=@"1";
       
        //return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"appPostStatus\",\"params\":{\"routerid\":\"%@\",\"usermac\":\"%@\",\"uuid\":\"%@\",\"userPoolId\":\"%@\",\"post\":\"%@\"}}}",routermacid,usermac,uuid,userpoolId,sharefb];
    
    NSData *postData = [s dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //  NSLog(@"postdata: %@", postData);
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
    NSLog(@"requestReply for line 9 : %@", requestReply);
    NSData* jsondata = [requestReply dataUsingEncoding:NSASCIIStringEncoding];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:NULL];
    
    
    NSDictionary *mac=[jsonDictionary objectForKey:@"methodResponse"];
    NSDictionary *mac2=[mac objectForKey:@"params"];
    
    NSString *status=[mac2 objectForKey:@"status"];
    
    
    if([status isEqualToString:@"203"])
    {
        NSString *userrecid=[mac2 objectForKey:@"userRecId"];
        dispatch_async(dispatch_get_main_queue(), ^{

        [self routerpass:userrecid];
        });
    }
    
    else
    {
        
    }

}

-(void)likeapicheck:(BOOL)like
{
   
    //NSString *post = [NSString stringWithFormat:@"test=Message&this=isNotReal"];
    NSString *likefb;
    if (like==NO)
    {
        likefb=@"0";
        
    }
        else if(like==YES)
        {
            
           likefb=@"1";
            dispatch_async(dispatch_get_main_queue(), ^{

            likeButton.hidden=NO;
            likeButton.objectID = @"https://www.facebook.com/1631008317172626";
                });
            //return;
        }
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"appLikeStatus\",\"params\":{\"routerid\":\"%@\",\"usermac\":\"%@\",\"uuid\":\"%@\",\"userPoolId\":\"%@\",\"like\":\"%@\"}}}",routermacid,usermac,uuid,userpoolId,likefb];
        
        NSData *postData = [s dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        //  NSLog(@"postdata: %@", postData);
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
        NSLog(@"requestReply for line 9 : %@", requestReply);
        NSData* jsondata = [requestReply dataUsingEncoding:NSASCIIStringEncoding];
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:NULL];
        
        
        NSDictionary *mac=[jsonDictionary objectForKey:@"methodResponse"];
        NSDictionary *mac2=[mac objectForKey:@"params"];
        
        NSString *status=[mac2 objectForKey:@"status"];
        
        
        if([status isEqualToString:@"202"])
        {
           NSString *userrecid=[mac2 objectForKey:@"userRecId"];
            dispatch_async(dispatch_get_main_queue(), ^{
            [self routerpass:userrecid];
            });
        }
  
}

-(void)checklike:(BOOL)like
{
    NSString *likefb;
    if (like==FALSE) {
        likefb=@"0";
    }
    else
    {
        likefb=@"1";
    }
    NSLog(@"the value of like fb %@",likefb);




 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

 NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"appLikeStatus\",\"params\":{\"routerid\":\"%@\",\"usermac\":\"%@\",\"uuid\":\"%@\",\"userPoolId\":\"%@\",\"like\":\"%@\"}}}",routermacid,usermac,uuid,userpoolId,likefb];
 
 NSData *postData = [s dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
 //  NSLog(@"postdata: %@", postData);
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

 NSString *routercmd=[mac2 objectForKey:@"routercmd"];
 NSString *userrecid=[mac2 objectForKey:@"userRecId"];
//can use both status 202 or cmd
 if([routercmd isEqualToString:@"pass"])
 {

 
     [self routerpass:userrecid];
 }
 
 

}

-(void)routerpass:(NSString *)recid
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    [self updatefleetimage:routermacidc];
    });
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"AppPass\",\"params\":{\"usermac\":\"%@\",\"uuid\":\"%@\",\"userRecId\":\"%@\"}}}",usermac,uuid,recid];
    
    userRecid=recid;
    NSData *postData = [s dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //  NSLog(@"postdata: %@", postData);
    // NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://1.1.1.1/appHandler.cgi"]];
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
      NSString *loginmethod= [defaults objectForKey:@"login"];
    NSLog(@"the loginmethod is %@",loginmethod);

    if([status isEqualToString:@"300"])    {
        logout302=FALSE;
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:routermacidc forKey:@"macid"];
        NSLog(@"the directory is %@",userInfo);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"desktoplogin" object:self userInfo:userInfo];
        [self LoginState:YES];
        if (facebook) {
           
            if (loggedin) {
                [defaults setObject:@"facebook" forKey:@"login"];
                [defaults synchronize];
                [self loginViewFetchedUserInfo];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"fblogin" object:self.lblUsername.text];
                
                [self.loginindicator stopAnimating];
                self.loading.hidden=YES;
                NSString *like= [defaults objectForKey:@"like"];
                NSLog(@"the value for like is %@",like);
                if ([like isEqualToString:@"yes"]) {
                    likeButton.objectID = @" https://www.facebook.com/1631008317172626";
                    likeButton.hidden=NO;
                }
                else
                {
                    likeButton.hidden=YES;
                }
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:routermacidc forKey:@"macid"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"desktoplogin" object:self userInfo:userInfo];
                [defaults setObject:@"facebook" forKey:@"login"];
            [defaults synchronize];
                loginType=1;
                NSString *repeat=@"yes";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"stoprepeat" object:repeat];
                
            NSLog(@"Data saved");
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self userloginlog:@"Facebook"];
                    
                });

//            self.afterlogin.text=[NSString stringWithFormat:@"您已經使用FACEBOOK帳號%@登入本服務,如果要登出請點擊登出按鈕",self.lblUsername.text];
//            self.lblLoginStatus.text=@"使用Facebook登入";
                
                self.afterlogin.text=[NSString stringWithFormat:NSLocalizedString(@"fb_desc",nil)];
                self.lblLoginStatus.text=NSLocalizedString(@"fblogin",nil);
                
                       
                        moviePlayer.repeatMode = NO; // for looping
                        [moviePlayer.view setFrame: self.videoSuper.bounds];
                        [self.videoSuper addSubview: moviePlayer.view];
                        [moviePlayer prepareToPlay];
                        self.videoSuper.hidden=NO;
                        self.closevideo.hidden=NO;
                        self.closevideo.enabled=NO;
                     timer=   [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setButtonEnabled) userInfo:nil repeats:NO];
                self.fleetimage.userInteractionEnabled=NO;
                        [moviePlayer play];
                        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"logged_in",nil)
                                                                           message:NSLocalizedString(@"Logged_in_desc",nil)
                                                                          delegate:self
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil];
                        //[theAlert show];
                        [theAlert setTag:3];
                        
        
            self.profilePicture.hidden=NO;
            self.lblUsername.hidden=NO;
            self.lblLoginStatus.hidden=NO;
            self.afterlogin.hidden=NO;
                
            }
        }
        else if (google)
        {
            self.glogin.enabled=YES;
            [ownlogin dismissWithClickedButtonIndex:0 animated:YES];

            if (loggedin) {
                
                    
                    [self googlefree];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:routermacidc forKey:@"macid"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"desktoplogin" object:self userInfo:userInfo];
                [defaults setObject:@"google" forKey:@"login"];
                [defaults synchronize];
            }
            else
            {
            [defaults setObject:@"google" forKey:@"login"];
            [defaults synchronize];
            
            NSLog(@"Data saved");
            
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self userloginlog:@"Google"];
                    
                });
                 [self.loginindicator stopAnimating];

                self.afterlogin.text=[NSString stringWithFormat:NSLocalizedString(@"g_desc",nil)];
                self.lblLoginStatus.text=NSLocalizedString(@"glogin",nil);
            loginType=2;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"glogin" object:self.lblUsername.text];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:routermacidc forKey:@"macid"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"desktoplogin" object:self userInfo:userInfo];
                        
                        
                       
                        moviePlayer.repeatMode = NO; // for looping
                        [moviePlayer.view setFrame: self.videoSuper.bounds];
                        [self.videoSuper addSubview: moviePlayer.view];
                        [moviePlayer prepareToPlay];
                        self.videoSuper.hidden=NO;
                        self.closevideo.hidden=NO;
                        self.closevideo.enabled=NO;
                        self.fleetimage.userInteractionEnabled=NO;
                        [moviePlayer play];
                   timer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setButtonEnabled) userInfo:nil repeats:NO];
                        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"logged_in",nil)
                                                                           message:NSLocalizedString(@"Logged_in_desc",nil)
                                                                          delegate:self
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil];
                       // [theAlert show];
                        [theAlert setTag:3];
 

            self.lblUsername.hidden=NO;
            self.gpic.hidden=NO;
            self.lblLoginStatus.hidden=NO;
            self.afterlogin.hidden=NO;
                
            }
        }
        
        else if (ownemail)
        {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getUserinfo:self.username.text];
            
            });
            
            if (loggedin) {
                //[self ownloginfree];
                NSLog(@" the diplay name is %@",[defaults objectForKey:@"displayname"]);
                self.lblUsername.text=[defaults objectForKey:@"displayname"];
                self.afterlogin.text=[NSString stringWithFormat:NSLocalizedString(@"self_desc",nil)];
                self.lblLoginStatus.text=NSLocalizedString(@"selflogin",nil);
                loginType=3;
                self.gpic.image=[UIImage imageNamed:@"avatar_default.png"];
                NSLog(@" the diplay name is %@",[defaults objectForKey:@"Name"]);

                usernamenew=[defaults objectForKey:@"Name"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"slogin" object:self.lblUsername.text];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:routermacidc forKey:@"macid"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"desktoplogin" object:self userInfo:userInfo];
                self.lblUsername.hidden=NO;
                self.lblLoginStatus.hidden=NO;
                self.afterlogin.hidden=NO;
                self.gpic.hidden=NO;

                [defaults setObject:@"self" forKey:@"login"];
                [defaults synchronize];
            }
            else
            {
                
                
                
            [defaults setObject:@"self" forKey:@"login"];
            [defaults synchronize];
            
            NSLog(@"Data saved");
                useraccountid=self.username.text;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self userloginlog:@"y5Bus"];
                    
                });
                

                self.afterlogin.text=[NSString stringWithFormat:NSLocalizedString(@"self_desc",nil)];
                self.lblLoginStatus.text=NSLocalizedString(@"selflogin",nil);
            loginType=3;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"slogin" object:self.username.text];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:routermacidc forKey:@"macid"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"desktoplogin" object:self userInfo:userInfo];
                    self.lblUsername.hidden=NO;
                    self.lblLoginStatus.hidden=NO;
                    self.afterlogin.hidden=NO;
                    self.gpic.hidden=NO;
                
                        
                        moviePlayer.repeatMode = NO; // for looping
                        [moviePlayer.view setFrame: self.videoSuper.bounds];
                        [self.videoSuper addSubview: moviePlayer.view];
                        [moviePlayer prepareToPlay];
               timer=            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setButtonEnabled) userInfo:nil repeats:NO];
                        self.videoSuper.hidden=NO;
                        self.closevideo.hidden=NO;
                        self.closevideo.enabled=NO;
                self.fleetimage.userInteractionEnabled=NO;
                        [moviePlayer play];
                            
                            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"logged_in",nil)
                                                                               message:NSLocalizedString(@"Logged_in_desc",nil)
                                                                              delegate:self
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil];
                            //[theAlert show];
                            [theAlert setTag:3];
                
  
            }
        }

    }
    
    else if ([status isEqualToString:@"400"])
    {
        self.glogin.enabled=YES;

        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        [self logout];
        [self.loginindicator stopAnimating];

        
    }
        
    
}


//alertdialog to let user like or skip
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) { // UIAlertView with tag 1 detected
        if (buttonIndex == 0)
        {
            
            [defaults setObject:@"yes" forKey:@"like"];
            [defaults synchronize];
            
            
            NSLog(@"user pressed Button Indexed 0");
            NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/248341475326959"];
//            if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
//                [[UIApplication sharedApplication] openURL:facebookURL];
//            } else {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/CoolbeeWiFi"]];
//            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self likeapicheck:YES];
            });
            
            

            // Any action can be performed here
        }
        else
        {
           [defaults setObject:@"no" forKey:@"like"];
            [defaults synchronize];
            NSLog(@"user pressed Button Indexed 1");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self likeapicheck:NO];
            });
            
        
            // Any action can be performed here
        }
    }
    //currentl disable since share function is not needed
    else if (alertView.tag==2)
    {
        if (buttonIndex == 0)
        {
            
           // [defaults setObject:@"yes" forKey:@"share"];
            //[defaults synchronize];
            NSLog(@"user pressed Button Indexed 0");
            
            [self shareapicheck:YES];
            
            
            [self sharecontent];
            
            // Any action can be performed here
        }
        else
        {
            [defaults setObject:@"no" forKey:@"share"];
            [defaults synchronize];
            NSLog(@"user pressed Button Indexed 1");
            [self shareapicheck:NO];
            
            // Any action can be performed here
        }

    }
    if (alertView.tag == 3) {
        // UIAlertView with tag 3 detected
       
        if (buttonIndex == 0)
        {
            
           

            [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(targetMethod)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
    if (alertView.tag == 4) {
        // UIAlertView with tag 3 detected
        
        if (buttonIndex == 0)
        {
            [self.tabBarController setSelectedIndex:0];

            
            
        }
    }

}

-(void)targetMethod
{
    
  
     
    self.tabBarController.delegate=self;
    
    
   // UINavigationController *navigationController3 = (UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:1];
    //UITabBarController *tabBarController;
    UINavigationController *navigationController3 = (UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:1];
    CoupontwoViewController *coupon= (CoupontwoViewController *)[[navigationController3 viewControllers] objectAtIndex:0];
    UINavigationController *navigationController = (UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:4];
    UINavigationController *navigationController2 = (UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:2];
    
    UINavigationController *navigationController1 = (UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:3];
    CouponViewController *coupon2= (CouponViewController *)[[navigationController1 viewControllers] objectAtIndex:0];
    SettingViewController *setting1 = (SettingViewController *)[[navigationController viewControllers] objectAtIndex:0];
    DesktopViewController *desktop = (DesktopViewController *)[[navigationController2 viewControllers] objectAtIndex:0];
    
    //NSUInteger indexOfTab = [tabBarController.viewControllers indexOfObject:viewController];
    //NSLog(@"Tab index = %u (%u)", indexOfTab);
    // UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:4];
    
    //self.setting = (SettingViewController *) [tabBarController.viewControllers objectAtIndex:4];
    
    //
    if (facebook) {
        //setting1.img=self.gpic.image;
        setting1.loginType=loginType;
        //NSLog(@"the user name and email is %@ %@",username,email);
        setting1.usernames=usernamenew;
        setting1.emails=email;
        desktop.gender=gender;
        desktop.loginType=loginType;
        desktop.macaddress=routermacidc;
        coupon2.mac=routermacidc;
        coupon2.gender=gender;
        coupon2.age=age;
        desktop.age=age;
        
        coupon2.loginType=loginType;
        NSLog(@"the age is equal to %li",(long)age);
        
    }
    else if (google)
    {
        setting1.img=self.gpic.image;
        setting1.loginType=loginType;
        // NSLog(@"the user name and email is %@ %@",username,email);
        setting1.usernames=usernamenew;
        setting1.emails=email;
        desktop.gender=gender;
        desktop.loginType=loginType;
        coupon2.loginType=loginType;
        desktop.macaddress=routermacidc;
        coupon2.mac=routermacidc;
        coupon2.gender=gender;
        coupon2.age=age;
        desktop.age=age;
        
        NSLog(@"the age is equal to %li",(long)age);
    }
    else if (ownemail)
    {
        setting1.img=self.gpic.image;
        setting1.loginType=loginType;
         NSLog(@"the user name and email is %@ %@",[defaults objectForKey:@"Name"],email);
        setting1.usernames=[defaults objectForKey:@"Name"];
        setting1.emails=email;
        desktop.gender=gender;
        desktop.loginType=loginType;
        coupon2.loginType=loginType;
        desktop.macaddress=routermacidc;
        coupon2.mac=routermacidc;
        coupon2.gender=gender;
        coupon2.age=age;
        desktop.age=age;
    }
    else if (loginType==0)
    {
        coupon2.loginType=0;

        desktop.gender=gender;
        desktop.loginType=0;
        coupon.gender=gender;
        coupon.loginType=0;
        
    }

     CoupontwoViewController *controller= self.tabBarController.viewControllers[1];
     CoupontwoViewController *controller1 = [self.storyboard instantiateViewControllerWithIdentifier:@"coupontwo"];
    NSLog(@"the PUSHCONTROLLER values are %@,%d and %li",gender,loginType,age);

    coupon.loginType=loginType;
   coupon.gender=gender;
    coupon.age=age;
    coupon.mac=routermacidc;
    coupon2.gender=gender;
    coupon2.age=age;
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"webviewlogin" object:@"male"];
    NSLog(@"the PUSHCONTROLLER values are %@,%d and %li and %@",gender,loginType,age,routermacid);
    [self.tabBarController setSelectedIndex:1];
   // self.fbimage.hidden=NO;
    //[self.tabBarController setSelectedViewController:controller1];
    //[self.navigationController pushViewController:controller1 animated:YES];
    //[self.tabBarController setSelectedViewController:controller];
}
-(void)sharecontent
{
    //*image1;
                     NSString *imageurl=[NSString stringWithFormat:@"http://apptest.coolbeewifi.net/%@",pic] ;
    NSLog(@"the imageurl is %@",imageurl);
                NSURL *url = [NSURL URLWithString:[imageurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:url];
                
          UIImage  *image1   =[UIImage imageWithData:data];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                            
                            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                            
                            [controller setInitialText:contents];
                            //[controller addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
                            [controller addImage:image1];
                            
                            [self presentViewController:controller animated:YES completion:Nil];
                        }
                        
                    });
    
                 });

  
    
}


-(void)GameUpdate:(NSTimer *)timer
{
    CouponViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"coupon"];
//    UINavigationController*  theNavController = [[UINavigationController alloc]
//                                                 initWithRootViewController:controller];
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void) sendweburlToWeixin
{
//    if (![WXApi isWXAppInstalled]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"we_chat_error",nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//        
//        return;
//    }
//else
//{
// //   LaunchFromWXReq* req1 = [[LaunchFromWXReq alloc] init];
//  //  [WXApi sendReq:req1];
//    self.wechatguide.hidden=NO;
//    self.launchwechat.hidden=NO;
//    self.cancellaunch.hidden=NO;
//    [self LoginState:YES];
    
    
//    WXWebpageObject* req1=[[WXWebpageObject alloc]init];
//    
//    WXMediaMessage *message = [WXMediaMessage message];
//    NSString *path=@"http://www.google.com";
//    NSString *url=[NSString stringWithFormat:path];
//    NSURL *URL = [NSURL URLWithString: url];
//    
//    
//    req1.webpageUrl=url;
//    message.title=@"opeb webpage";
//    message.description=@"open url";
//    message.mediaObject=req1;
    
    
    
    
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    LaunchFromWXReq* req1 = [[LaunchFromWXReq alloc] init];
//
//    JumpToBizWebviewReq *web=[[JumpToBizWebviewReq alloc]init];
//  //  SendAuthReq *a=[[SendAuthReq alloc]init];
//   // a.scope=@"uniqye";
//    
//    req1.country=@"TW";
//     
//    req.text = @"hello";
//   
//    req.bText = YES;
//   // req.scene = WXMPWebviewType_Ad;
////    
//    //[WXApi sendReq:web];
//    
////    SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
////    req.text = @"hello";
////    req.bText = YES;
//    req.scene = WXSceneSession;
//    [WXApi sendReq:req1];
//    
   // [WXApi handleOpenURL:URL delegate:req];

//}

}


//- (void) onReq:(BaseReq*)req
//
//{
//    req.openID=@"wx64443a1ce3647b28";
//}
//- (void) onResp:(BaseResp*)resp
//
//{
//    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
//        NSString *strMsg = [NSString stringWithFormat:@"Result:%d", resp.errCode];
//        NSLog(@"Response from Weixin was: %@",strMsg);
//    }
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"forgotpassword"]) {
        
       // UINavigationController *navigationController = segue.destinationViewController;
      //  LoginViewController *login = segue.destinationViewController;
       //login.delegate = self;
        LoginViewController *reg = [segue destinationViewController];
        reg.usermac=usermac;
        reg.routermacid=routermacid;
        reg.uuid=uuid;
    }
    if ([[segue identifier] isEqualToString:@"registerpage"])
    {
        // Get reference to the destination view controller
        RegisterViewController *reg = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        reg.usermac=usermac;
        reg.routermacid=routermacid;
        reg.uuid=uuid;
    }
   
}

-(void)logout
{
    [defaults setObject:@"" forKey:@"login"];
    [defaults synchronize];
    NSLog(@"the value for default is %@",[defaults objectForKey:@"login"]);
    loggedin=FALSE;
    [self LoginState:NO];
    loginType=0;
    
    self.profilePicture.hidden=YES;
    self.gpic.hidden=YES;
    self.gout.hidden=YES;
    likeButton.hidden=YES;
    self.afterlogin.hidden=YES;
    self.lblUsername.hidden=YES;
    self.lblEmail.hidden=YES;
    self.lblLoginStatus.hidden=YES;
    [self.loginindicator stopAnimating];
    self.loading.hidden=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"relogin" object:self];

}

//get notification from settings- logout
- (void)receivedNotification:(NSNotification *) notification {
    [defaults setObject:@"" forKey:@"login"];
    [defaults synchronize];
    NSLog(@"the value for default is %@",[defaults objectForKey:@"login"]);
    loggedin=FALSE;
    
    if ([[notification name] isEqualToString:@"logout"]) {
        
        [defaults setObject:@"" forKey:@"login"];
        [defaults synchronize];
        logout302=TRUE;
        [self LoginState:NO];
        self.profilePicture.hidden=YES;
        self.gpic.hidden=YES;
        self.gout.hidden=YES;
        likeButton.hidden=YES;
        self.afterlogin.hidden=YES;
        self.lblUsername.hidden=YES;
        self.lblEmail.hidden=YES;
        self.lblLoginStatus.hidden=YES;
        UINavigationController *navigationController3 = (UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:1];
        CoupontwoViewController *coupon= (CoupontwoViewController *)[[navigationController3 viewControllers] objectAtIndex:0];
        
        UINavigationController *navigationController2 = (UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:2];
        
        UINavigationController *navigationController1 = (UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:3];
        CouponViewController *coupon2= (CouponViewController *)[[navigationController1 viewControllers] objectAtIndex:0];
        DesktopViewController *desktop = (DesktopViewController *)[[navigationController2 viewControllers] objectAtIndex:0];
        coupon.loginType=0;
        desktop.loginType=0;
        coupon2.loginType=0;
        //self.lblLoginStatus.text = @"please log in.";
        if (loginType==1) {
            
            loginType=0;
            [defaults setObject:@"" forKey:@"login"];
            [defaults synchronize];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self logoutuserserver];
                
            });
            
        }
        else if (loginType==2)
        {
            loginType=0;
            [defaults setObject:@"" forKey:@"login"];
            [defaults synchronize];
            [[GPPSignIn sharedInstance] signOut];
            [signIn signOut];
            [signIn disconnect];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self logoutuserserver];
                
            });

        }
        
        else if (loginType==3)
        {
            loginType=0;
            [defaults setObject:@"" forKey:@"login"];
            [defaults synchronize];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self logoutuserserver];
                
            });
            
            
        }
}
}

- (IBAction)signout:(id)sender {
[[GPPSignIn sharedInstance] signOut];
    [self toggleHiddenState:YES];
    self.gpic.hidden=YES;
    self.lblLoginStatus.text=@"logged out";
    self.gout.hidden=YES;
    self.signInButton.hidden=NO;
    loginType=0;


}

//facebooklogin button for login
- (IBAction)test:(id)sender {
   
    if (![self connected])
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_internet",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
    }
    else if(have3g)
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_threeg",nil)
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
    else
    {
       
        
    facebook=TRUE;
    google=FALSE;
    ownemail=FALSE;
    wechat=FALSE;
    [self freeminutesapi];
    }
    }
    //checking for facebook, disable during api
    //[self facebookfree];


-(void)facebookfree
{


    [login logInWithReadPermissions:@[@"email",@"public_profile", @"email",@"user_birthday",@"user_education_history",@"user_likes"]
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            NSLog(@"error in facebook %@",error);
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error_login",nil)
                                                               message:NSLocalizedString(@"error_google_desc",nil)
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            [self logout];
            
            
        } else if (result.isCancelled) {
            NSLog(@"cancelled");
            [self logout];
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            //@"public_profile", @"email",@"user_birthday",@"user_education_history",@"user_likes"
            if ([result.grantedPermissions containsObject:@"email"]) {
                [self loginViewFetchedUserInfo];
    
                //enable this if you want to test fb login, but disable for testing API
                // [self loginViewFetchedUserInfo];
         }
        }
    }];
   // FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
 
    
}
- (IBAction)wechat:(id)sender {
    
    if (![self connected])
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_internet",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
    }
    else if(have3g)
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_threeg",nil)
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                 
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
    else
    {

    wechat=TRUE;
    google=FALSE;
    ownemail=FALSE;
    facebook=FALSE;
    [self freeminutesapi];
    }
    
}

-(void)googlefree
{
    //GPPSignInButton
    signIn = [GPPSignIn sharedInstance];
    signIn.delegate=self;
    signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    BOOL a=[signIn hasAuthInKeychain];
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    
    signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin,nil];
    signIn.actions = [NSArray arrayWithObjects:@"http://schemas.google.com/ListenActivity",nil];
    [signIn authenticate];
    
}

//googleplus login
- (IBAction)glogin:(id)sender {
    
    if (![self connected])
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_internet",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
    }
    else if(have3g)
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_threeg",nil)
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
    else
    {

    google=TRUE;
    facebook=FALSE;
    ownemail=FALSE;
    wechat=FALSE;
    [self.loginindicator startAnimating];
    [self freeminutesapi];
    
    }
    //disable during api testing
    //[self googlefree];
    [ownlogin dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)userloginlog:(NSString *)type
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *s=[NSString stringWithFormat:@"key=null&type=%@&account=%@&DeviceMAC=%@",type,useraccountid,routermacid];
    
    NSLog(@"the USERLOGINLOG is %@",s);
    NSData *postData = [s dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //  NSLog(@"postdata: %@", postData);
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://y5bus.chainyi.com/WebServices/WebService.asmx/UserLoginLog"]];
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
-(void)owndatabaselogin
{
    
    //[loginindicator startAnimating];
    NSString *username1=self.username.text;
    NSString *password=self.password.text;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *s=[NSString stringWithFormat:@"key=null&type=y5Bus&account=%@&password=%@",username1,password];
    
    NSData *postData = [s dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //  NSLog(@"postdata: %@", postData);
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://y5bus.chainyi.com/WebServices/WebService.asmx/UserLogin"]];
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
   // [loginindicator stopAnimating];
    
    if ([match isEqualToString:@"001"] || [match isEqualToString:@"102"] ) {
        
        NSLog(@"login is wrong");
    
        //[theAlert show];
    }
    
    else if ([match isEqualToString:@"0" ])
    {
        

       
        //[theAlert show];
    }
    
    else if ([match isEqualToString:@"100"])
    {
        NSLog(@"password is wrong");
 
        //[theAlert show];
    }
    
}

-(void)ownloginfree

{
    if (loggedin) {
        
        NSString *firstName1 = [defaults objectForKey:@"Name"];
        self.afterlogin.text=[NSString stringWithFormat:NSLocalizedString(@"self_desc",nil)];
        self.lblLoginStatus.text=NSLocalizedString(@"selflogin",nil);
        self.gpic.image=[UIImage imageNamed:@"avatar_default.png"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"desktoplogin" object:self];
         loginType=3;
        self.lblUsername.hidden=NO;
        self.lblLoginStatus.hidden=NO;
        self.afterlogin.hidden=NO;
        self.gpic.hidden=NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"slogin" object:self];
        
     
        }
    
    else
    {
        
        NSString *s;
        NSString *mobile;
        NSString *email1;
        NSString *logintype;
        //check if the user wants to use email or mobile phone for registraion
        if([self.username.text containsString:@"@"])
        {
            mobile=@"";
            email1=self.username.text;
            logintype=@"emailLogin";
            
            s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"appAuthSucces\",\"params\":{\"logintype\":\"%@\",\"routerid\":\"%@\",\"usermac\":\"%@\",\"uuid\":\"%@\",\"useremail\":\"%@\",\"pwd\":\"%@\"}}}",logintype,routermacid,usermac,uuid,self.username.text,self.password.text];
        }
        else
        {
            mobile=self.username.text;
            email1=@"";
            logintype=@"smsLogin";
          s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"appAuthSucces\",\"params\":{\"logintype\":\"%@\",\"routerid\":\"%@\",\"usermac\":\"%@\",\"uuid\":\"%@\",\"useremail\":\"%@\",\"mobile\":\"%@\",\"pwd\":\"%@\"}}}",logintype,routermacid,usermac,uuid,email1,self.username.text,self.password.text];
            
            
            
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
    //NSString *userrecid=[mac2 objectForKey:@"userRecId"];
    
    if ([status isEqualToString:@"306"] || [status isEqualToString:@"309"]) {
        NSString *preTel;
        NSString *userRecId=[mac2 objectForKey:@"userRecId"];
        
        if ([self.lblUsername.text containsString:@"@"]) {
            NSString *string =self.username.text;
            NSString *match = @"@";
            ;
            NSString *postTel;
            
            NSScanner *scanner = [NSScanner scannerWithString:string];
            [scanner scanUpToString:match intoString:&preTel];
            
            [scanner scanString:match intoString:nil];
            postTel = [string substringFromIndex:scanner.scanLocation];
            
            NSLog(@"preTel: %@", preTel);
            NSLog(@"postTel: %@", postTel);
            self.lblUsername.text=preTel;
            usernamenew=self.username.text;
            [defaults setObject:self.username.text forKey:@"Name"];
            [defaults synchronize];
            [defaults setObject:preTel forKey:@"displayname"];
            
            [defaults synchronize];
            
        }
        else
        {
            [defaults setObject:self.username.text forKey:@"Name"];
            [defaults synchronize];
            [defaults setObject:self.username.text forKey:@"displayname"];
            
            [defaults synchronize];
        self.lblUsername.text=self.username.text;
            usernamenew=self.username.text;
        }
       // usernamenew=self.username.text;
        
        self.gpic.image=[UIImage imageNamed:@"avatar_default.png"];
        // [theAlert show];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self owndatabaselogin];
        });
        
        [self routerpass:userRecId];
        
        
    }
  
        
if ([status isEqualToString:@"201"])

{
    NSString *preTel;

    if ([self.username.text containsString:@"@"]) {
        NSString *string =self.username.text;
        NSString *match = @"@";
        NSString *postTel;
        
        NSScanner *scanner = [NSScanner scannerWithString:string];
        [scanner scanUpToString:match intoString:&preTel];
        
        [scanner scanString:match intoString:nil];
        postTel = [string substringFromIndex:scanner.scanLocation];
        
        NSLog(@"preTel: %@", preTel);
        NSLog(@"postTel: %@", postTel);
        self.lblUsername.text=preTel;
        usernamenew=self.username.text;
        [defaults setObject:self.username.text forKey:@"Name"];
        [defaults synchronize];
        [defaults setObject:preTel forKey:@"displayname"];
        
        [defaults synchronize];
    }
    else
    {
        [defaults setObject:self.username.text forKey:@"Name"];
        [defaults synchronize];
        [defaults setObject:self.username.text forKey:@"displayname"];
        
        [defaults synchronize];
    self.lblUsername.text=self.username.text;
        usernamenew=self.username.text;
    }
    
   
    self.gpic.image=[UIImage imageNamed:@"avatar_default.png"];
                  NSString *userRecId=[mac2 objectForKey:@"userRecId"];
                  [self routerpass:userRecId];
                  
}
   
else if ([status isEqualToString:@"406"] || [status isEqualToString:@"409"] )
    {

        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_login",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        [self logout];
        
    }
        
    //self.xmlParser = [[NSXMLParser alloc] initWithData:requestHandler];
    //self.xmlParser.delegate = self;
    //[self.xmlParser parse];
    }
}


//ownlogin
- (IBAction)login:(id)sender {
    if ([self.password.text isEqualToString:@"" ] || [self.username.text isEqualToString:@""]) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"empty_username",nil)
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
        else if(have3g)
        {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                               message:NSLocalizedString(@"error_threeg",nil)
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                                     otherButtonTitles:nil];
            [theAlert show];
        }
        else
        {
   
    ownemail=TRUE;
    facebook=FALSE;
    google=FALSE;
        wechat=FALSE;
    
    [self freeminutesapi];
    //disable during api
    }
    //[self owndatabaselogin];
}
}


- (IBAction)registeracct:(id)sender {
    
}

- (IBAction)forgotpassword:(id)sender {
    
    
}


-(void)getUserinfo:(NSString *)account
{
    
    //[loginindicator startAnimating];
   
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *s=[NSString stringWithFormat:@"key=null&type=y5Bus&account=%@",account];
    
    NSData *postData = [s dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //  NSLog(@"postdata: %@", postData);
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://y5bus.chainyi.com/WebServices/WebService.asmx/GetUserInfo"]];
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
    if ([match isEqualToString:@"0"]) {
        
        
        self.xmlParser = [[NSXMLParser alloc] initWithData:requestHandler];
        self.xmlParser.delegate = self;
        
        // Initialize the mutable string that we'll use during parsing.
        self.foundValue = [[NSMutableString alloc] init];
        
        // Start parsing.
        [self.xmlParser parse];

    }
    
    else
    {
        
    }
    
}


-(void)parserDidStartDocument:(NSXMLParser *)parser{
    // Initialize the neighbours data array.
    if (parser==self.xmlParser) {
        
    
    self.arrNeighboursData = [[NSMutableArray alloc] init];
    }
    else if (parser==self.xmlParser2)
    {
        self.arrNeighboursData2 = [[NSMutableArray alloc] init];

    }
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
        
    
    // If the current element name is equal to "geoname" then initialize the temporary dictionary.
    if ([elementName isEqualToString:@"UserInfo"]) {
        self.dictTempDataStorage = [[NSMutableDictionary alloc] init];
        
    }
    self.currentElement = elementName;
    // Keep the current element.
    
        if ([elementName isEqualToString:@"FleetAd"]) {
            self.dictTempDataStorage2 = [[NSMutableDictionary alloc] init];
        }
        self.currentElement2 = elementName;
        // Keep the current element.
    
        
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    // When the parsing has been finished then simply reload the table view.
    if (parser==self.xmlParser2) {
        
        NSString *imageurl =[[self.arrNeighboursData2 objectAtIndex:0] objectForKey:@"ImageUL"];
        NSString *click =[[self.arrNeighboursData2 objectAtIndex:0] objectForKey:@"ClickURL"];
        if ([click isEqualToString:@""] || click.length==0) {
            
            clickurl=@"http://www.y5bus.tw/EN/index";
        }
        else
        {
            clickurl=[click substringFromIndex:5];
        }
        NSLog(@"clickurl is %@",clickurl);
        if ([imageurl isEqualToString:@""] || imageurl.length==0) {
            
        }
        else
        {
       // NSString *newstring=[imageurl stringByReplacingOccurrencesOfString:@" " withString:@""];
        //NSString *newString1 = [newstring substringFromIndex:1];
        NSString *newstring2=[NSString stringWithFormat:@"http://%@",imageurl];
        NSLog(@"the new string1 is %@",newstring2);
        NSURL *url = [NSURL URLWithString:[newstring2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        NSData *data = [NSData dataWithContentsOfURL :url];
//        UIImage *image1=[UIImage imageWithData:data];
//        self.fleetimage.image=image1;
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image && finished)
             {
                 // do something with image
                 self.fleetimage.image=image;
             }
         }];
        }
    }
    
    else if (parser==self.xmlParser)
    {
        
    }
    
    
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (parser==self.xmlParser) {
     if ([elementName isEqualToString:@"UserInfo"]){
        // If the country name element was found then store it.
         [self.arrNeighboursData addObject:[[NSDictionary alloc] initWithDictionary:self.dictTempDataStorage]];
         NSLog(@"the elements inside an array are %@",self.arrNeighboursData);

         gender =[[self.arrNeighboursData objectAtIndex:0] objectForKey:@"Gender"];
         NSString *birthday=[[self.arrNeighboursData objectAtIndex:0] objectForKey:@"Birthday"];
         
         if ([birthday length]==0 || [birthday isEqualToString:@""])
         {
             age=0;
         }
         else
         {
         //birthday = [newstring substringFromIndex:1];
         if ([birthday length]==0) {
             age=0;
         }
         else
         {
         NSLog(@"birthday length is %lu",(unsigned long)[birthday length]);
          
         
dispatch_async(dispatch_get_main_queue(), ^{
         NSDate *todayDate = [NSDate date];
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"yyyy-mm-dd"];
         int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:birthday]];
         int allDays = (((time/60)/60)/24);
         int days = allDays%365;
         age = (allDays-days)/365;
         NSLog(@"Your gender %@ ",gender);
    
         NSLog(@"Your age %li ",(long)age);
 
});
         
         }
     }
    }
    else if ([elementName isEqualToString:@"Gender"]){
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Gender"];

        // If the toponym name element was found then store it.
        
    }
    else if ([elementName isEqualToString:@"Birthday"]){
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Birthday"];
        
        // If the toponym name element was found then store it.
        
    }
   [self.foundValue setString:@""];
    }
    else if (parser==self.xmlParser2)
    {
        if ([elementName isEqualToString:@"FleetAd"]){
            // If the country name element was found then store it.
            [self.arrNeighboursData2 addObject:[[NSDictionary alloc] initWithDictionary:self.dictTempDataStorage2]];
            NSLog(@"the elements inside an array are %@",self.arrNeighboursData2);
            
           NSString *ImageUl =[[self.arrNeighboursData2 objectAtIndex:0] objectForKey:@"ImageUL"];
            if ([ImageUl isEqualToString:@""] || ImageUl.length==0) {
                
            }
            else{
            
            NSString *newstring=[ImageUl stringByReplacingOccurrencesOfString:@" " withString:@""];
             NSString *newString1 = [newstring substringFromIndex:1];
                NSURL *url = [NSURL URLWithString:[newString1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"imageurl is %@",url);

            NSLog(@"image is %@",newString1);
            }
            clickurl=[[self.arrNeighboursData2 objectAtIndex:0] objectForKey:@"ClickURL"];
            NSLog(@"clickurl is %@",clickurl);
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSData *data = [NSData dataWithContentsOfURL :url];
//                UIImage *image1=[UIImage imageWithData:data];
//                if (image1) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        self.fleetimage.image=image1;
//                        
//                    });
//                }
//            });
           
            
        }
        else if ([elementName isEqualToString:@"ImageUL"]){
            [self.dictTempDataStorage2 setObject:[NSString stringWithString:self.foundValue2] forKey:@"ImageUL"];
            NSLog(@"TGE INSIDE ELEMENT IS %@",elementName);
            // If the toponym name element was found then store it.
            
        }
        
         else if ([elementName isEqualToString:@"ClickURL"]){
         [self.dictTempDataStorage2 setObject:[NSString stringWithString:self.foundValue2] forKey:@"ClickURL"];
         
         // If the toponym name element was found then store it.
         
         }
        
        [self.foundValue2 setString:@""];
    }
    
    }


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // Store the found characters if only we're interested in the current element.
    if (parser==self.xmlParser) {
        if ([self.currentElement isEqualToString:@"Gender"] ||
            [self.currentElement isEqualToString:@"Birthday"])
              {
            if (![string isEqualToString:@"\n"]) {
                [self.foundValue appendString:string];
            }
        }
    }
    else if (parser==self.xmlParser2)
    {
        if ([self.currentElement2 isEqualToString:@"ImageUL"]
            
            ||[self.currentElement2 isEqualToString:@"ClickURL"])
        {
            if (![string isEqualToString:@"\n"]) {
                [self.foundValue2 appendString:string];
            }
        }
    }
    
    
}


//check if like button pressed or not
- (IBAction)likebutton:(id)sender {
    likeid=TRUE;
    
//    NSString *repeat=@"no";
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"stoprepeat" object:repeat];
    
}
- (IBAction)closeadvert:(id)sender {
    self.advertimg.hidden=YES;
    self.closeadvert.hidden=YES;
    self.maskview.hidden=YES;
}
- (IBAction)closevideo:(id)sender {
    
    closed=TRUE;

    self.videoSuper.hidden=YES;
    self.closevideo.hidden=YES;
    self.fleetimage.userInteractionEnabled=YES;
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"logged_in",nil)
                                                       message:NSLocalizedString(@"Logged_in_desc",nil)
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [theAlert show];
    [theAlert setTag:3];
    
}
-(void)playbackFinished:(NSNotification*)aNotification
{
    self.fleetimage.userInteractionEnabled=YES;
    if (closed) {
        closed=false;
        
    }
    else
    {
    self.videoSuper.hidden=YES;
    self.closevideo.hidden=YES;
  
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"logged_in",nil)
                                                       message:NSLocalizedString(@"Logged_in_desc",nil)
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [theAlert show];
    [theAlert setTag:3];
    }
}
- (IBAction)launchwechat:(id)sender {
    self.wechatguide.hidden=YES;
    self.launchwechat.hidden=YES;
    self.cancellaunch.hidden=YES;
    [self LoginState:NO];
//    LaunchFromWXReq* req1 = [[LaunchFromWXReq alloc] init];
//    [WXApi sendReq:req1];
    
    
}
- (IBAction)cancellaunch:(id)sender {
    self.wechatguide.hidden=YES;
    self.launchwechat.hidden=YES;
    self.cancellaunch.hidden=YES;
    [self LoginState:NO];
}




-(void)logoutuserserver
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //NSString *post = [NSString stringWithFormat:@"test=Message&this=isNotReal"];
    NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"userLogout\",\"params\":{\"routerid\":\"%@\",\"usermac\":\"%@\",\"uuid\":\"%@\",\"userRecId\":\"%@\"}}}",routermacid,usermac,uuid,userRecid];
    
    NSLog(@"string is %@",s);
    NSData *postData = [s dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //NSLog(@"postdata: %@", postData);
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
    //NSLog(@"requesthandler: %@", requestHandler);
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSLog(@"requestReply: %@", requestReply);
    NSData* jsondata = [requestReply dataUsingEncoding:NSASCIIStringEncoding];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:NULL];
    
    
    NSDictionary *mac=[jsonDictionary objectForKey:@"methodResponse"];
    NSDictionary *mac2=[mac objectForKey:@"params"];
    NSString *routercmd=[mac2 objectForKey:@"routercmd"];
    NSString *status=[mac2 objectForKey:@"status"];
    if ([status isEqualToString:@"806"]) {
        [self logoutrouter];
        
    }

}


-(void)logoutrouter
{
    NSLog(@"router logout");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //NSString *post = [NSString stringWithFormat:@"test=Message&this=isNotReal"];
    NSString *s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"AppLogout\",\"params\":{\"usermac\":\"%@\",\"uuid\":\"%@\",\"userRecId\":\"%@\"}}}",usermac,uuid,userRecid];
    NSLog(@"string is %@",s);
    
    NSData *postData = [s dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //  NSLog(@"postdata: %@", postData);
    // NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://1.1.1.1/appHandler.cgi"]];
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

    if ([status isEqualToString:@"807"]) {
        NSLog(@"LOGOUT SUCCESS");
        dispatch_async(dispatch_get_main_queue(), ^{

        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"logout",nil)
                                                           message:NSLocalizedString(@"logout_desc",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
            [theAlert setTag:4];
        });
    }
}



 @end
