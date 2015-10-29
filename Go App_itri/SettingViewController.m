//
//  SettingViewController.m
//  Go App_itri
//
//  Created by Madhawan Misra on 6/2/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import "SettingViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ResetpassViewController.h"
#import "UpdatepasswordViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController
BOOL repeating;
@synthesize loginType,profilePicture;
@synthesize usernames,emails;
@synthesize loginButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.loginButton.delegate=self;
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    //notification center observer
     self.navigationItem.title=NSLocalizedString(@"mine",nil);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"fblogin"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"glogin"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"slogin"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"relogin"
                                               object:nil];
    
    
    self.background.backgroundColor=[UIColor colorWithRed:252.0/255.0 green:248.0/255.0 blue:242.0/255.0 alpha:1.0];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(2, 16, 2, 16);
    UIImage *imagefirst1 = [[UIImage imageNamed:@"input_single_bg.png"]
                            resizableImageWithCapInsets:edgeInsets];
    
    self.userview.image=imagefirst1;
    self.aboutus.textColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.changepassword.textColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    userName.textColor=[UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0];
    logType.textColor=[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    UIEdgeInsets edgeInsets1 = UIEdgeInsetsMake(6, 6, 6, 6);
    UIImage *emailoginbutton = [[UIImage imageNamed:@"btn_orange_bg_normal.png"]
                                resizableImageWithCapInsets:edgeInsets1];
    UIImage *emailoginbutton2 = [[UIImage imageNamed:@"btn_orange_bg_pressed.png"]
                                 resizableImageWithCapInsets:edgeInsets1];
    
    [logout setBackgroundImage:emailoginbutton forState:UIControlStateNormal];
    [logout setBackgroundImage:emailoginbutton2 forState:UIControlStateSelected];
    [logout setBackgroundImage:emailoginbutton2 forState:UIControlStateHighlighted];
    [loginButton setBackgroundImage:emailoginbutton forState:UIControlStateNormal];
    [loginButton setBackgroundImage:emailoginbutton2 forState:UIControlStateSelected];
    [loginButton setBackgroundImage:emailoginbutton2 forState:UIControlStateHighlighted];

       // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"LOGIN is %@",usernames);
    NSLog(@"LOGINtype is %d",loginType);
    if (repeating) {
        
    }
    else
    {
        repeating=YES;
    userName.text=usernames;
    //Email.text=emails;
    }
    //    logType.text=_test;
    if (loginType==1)
    {
        self.lablelout.hidden=NO;
        logout.hidden=NO;
        userName.hidden=NO;
        loginButton.hidden=YES;
        profileImg.hidden=YES;
        profilePicture.hidden=NO;
        self.changepassword.hidden=YES;
        self.resetpassword.hidden=YES;
        self.passpic.hidden=YES;
        logType.text=NSLocalizedString(@"fblogins",nil);
    }
    else if(loginType==2)
    {
        self.lablelout.hidden=NO;
        userName.hidden=NO;
        logout.hidden=NO;
        profileImg.hidden=NO;
        profilePicture.hidden=YES;
        self.changepassword.hidden=YES;
        self.resetpassword.hidden=YES;
        self.passpic.hidden=YES;
        logType.text=NSLocalizedString(@"glogins",nil);
        [profileImg setImage:_img];
    }
    
    else if(loginType==3)
    {
        self.lablelout.hidden=NO;
        userName.hidden=NO;
        logout.hidden=NO;
        profileImg.hidden=NO;
        profilePicture.hidden=YES;
        self.changepassword.hidden=NO;
        self.resetpassword.hidden=NO;
        self.passpic.hidden=NO;
        logType.text=NSLocalizedString(@"selflogins",nil);
    }
    
    if (loginType==0) {
        profileImg.image=[UIImage imageNamed:@"avatar_default.png"];
        profilePicture.hidden=YES;
        profileImg.hidden=NO;
        logType.text=NSLocalizedString(@"please_login",nil);
        userName.hidden=YES;
        logout.hidden=YES;
        self.lablelout.hidden=YES;
        self.changepassword.hidden=NO;
        self.resetpassword.hidden=NO;
        self.passpic.hidden=NO;;

    }

    
    // Do any additional setup after
    
}

-(void)fblogin
{
    profileImg.hidden=YES;
    profilePicture.hidden=NO;
    self.lablelout.hidden=NO;
    loginButton.hidden=YES;
    logout.hidden=NO;
    userName.hidden=NO;
    logType.hidden=NO;
    self.lablelout.hidden=YES;
    loginType=1;
    self.changepassword.hidden=YES;
    self.resetpassword.hidden=YES;
    self.passpic.hidden=YES;

    //userName.text=usernames;
    //userName.text=usernames;
    //Email.text=emails;
    //logout.hidden=NO;
}

-(void)glogin
{
     [profileImg setImage:_img];
    profileImg.hidden=NO;
    profilePicture.hidden=YES;
    self.lablelout.hidden=NO;
   // userName.text=usernames;
    //Email.text=emails;
    logout.hidden=NO;
    userName.hidden=NO;
    logType.hidden=NO;
    loginButton.hidden=YES;
    loginType=2;
    self.changepassword.hidden=YES;
    self.resetpassword.hidden=YES;
    self.passpic.hidden=YES;

    //userName.text=usernames;
}

-(void)slogin
{
    profileImg.hidden=NO;
    profilePicture.hidden=YES;
    logout.hidden=NO;
    userName.hidden=NO;
    logType.hidden=NO;
    loginButton.hidden=YES;
    self.lablelout.hidden=NO;
    loginType=3;
    self.changepassword.hidden=NO;
    self.resetpassword.hidden=NO;
    self.passpic.hidden=NO;;

   // userName.text=usernames;
}


//notification received



- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"fblogin"]) {
        userName.text = [notification object];
        NSLog(@"the username text is %@",userName.text);

        [self fblogin];
        
        
        
    } else if ([[notification name] isEqualToString:@"glogin"]) {
        userName.text = [notification object];
        NSLog(@"the username text is %@",userName.text);

        [self glogin];
        
    }
    else if ([[notification name] isEqualToString:@"slogin"])
    {
        
        userName.text = [notification object];
        NSLog(@"the username text is %@",userName.text);
        [self slogin];
    }
    else if ([[notification name] isEqualToString:@"relogin"])
    {
        [self relogin];
    }
    
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton1{
    NSLog(@"facebook logout button test");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:self];
    loginType=0;
    logType.text=NSLocalizedString(@"please_login",nil);
    logout.hidden=YES;
    profileImg.image=[UIImage imageNamed:@"avatar_default.png"];
    profileImg.hidden=NO;
    profilePicture.hidden=YES;
    loginButton.hidden=YES;
    userName.hidden=YES;
    self.lablelout.hidden=YES;
    self.changepassword.hidden=NO;
    self.resetpassword.hidden=NO;
    self.passpic.hidden=NO;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)logout:(id)sender {
    

    if (loginType==1) {
        self.changepassword.hidden=NO;
        self.resetpassword.hidden=NO;
        FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
        [manager logOut];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:self];
        profileImg.image=[UIImage imageNamed:@"avatar_default.png"];
        logType.text=NSLocalizedString(@"please_login",nil);
        logout.hidden=YES;
        loginButton.hidden=YES;
        profileImg.hidden=NO;
        profilePicture.hidden=YES;
        self.lablelout.hidden=YES;
        self.passpic.hidden=NO;;

        userName.hidden=YES;
        loginType=0;
    }
    else
    {
        self.changepassword.hidden=NO;
        self.resetpassword.hidden=NO;
        self.passpic.hidden=NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:self];
      profileImg.image=[UIImage imageNamed:@"avatar_default.png"];
    logType.text=NSLocalizedString(@"please_login",nil);
    logout.hidden=YES;
    loginButton.hidden=YES;
    profileImg.hidden=NO;
    profilePicture.hidden=YES;
    self.lablelout.hidden=YES;
    userName.hidden=YES;
    loginType=0;
    }
    
    
}

-(void)relogin
{
    profileImg.image=[UIImage imageNamed:@"avatar_default.png"];
    logType.text=NSLocalizedString(@"please_login",nil);
    logout.hidden=YES;
    loginButton.hidden=YES;
    profileImg.hidden=NO;
    profilePicture.hidden=YES;
    self.lablelout.hidden=YES;
    userName.hidden=YES;
    loginType=0;
    self.changepassword.hidden=NO;
    self.resetpassword.hidden=NO;
    self.passpic.hidden=NO;

}

-(void)startapi

{
    
    NSString *s;
    NSString *email;
    NSString *mobile;
    NSString *logintype;

    if([usernames containsString:@"@"])
    {
        mobile=@"";
        email=usernames;
        logintype=@"emailUpdatepwd";
        s=[NSString stringWithFormat:@"{\"methodCall\":{\"methodName\":\"emailUpdatepwd\",\"params\":{\"useremail\":\"%@\"}}}",email];
        
    }
    else
    {
        mobile=userName.text;
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
    dispatch_async(dispatch_get_main_queue(), ^{
        self.resetpassword.enabled=YES;
        [self.indicator stopAnimating];
        self.loading.hidden=YES;
    if ([status isEqualToString:@"800"]) {
        
 
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"check_email",nil)
                                                           message:NSLocalizedString(@"check_email_pwd",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        
        [theAlert show];
        UpdatepasswordViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"update"];
        controller.account=userName.text;
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
        controller.account=userName.text;
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
    });
}
- (IBAction)changepassword:(id)sender {
//    UpdatepasswordViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"update"];
    //controller.account=userName.text;
    //[self.navigationController pushViewController:controller animated:YES];
    
    if (loginType==3) {
        [self.indicator startAnimating];
        self.loading.hidden=NO;
        self.resetpassword.enabled=NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self startapi];
            
        });
        }
//    ResetpassViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"reset"];
//    //    UINavigationController*  theNavController = [[UINavigationController alloc]
//    //                                                 initWithRootViewController:controller];
//    [self.navigationController pushViewController:controller animated:YES];
    
    else
    {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"login_method",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
    }
}
- (IBAction)aboutus:(id)sender {
    ResetpassViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"reset"];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
