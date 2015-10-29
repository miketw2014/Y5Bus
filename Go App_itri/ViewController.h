//
//  ViewController.h
//  Go App_itri
//
//  Created by Madhawan Misra on 5/25/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//
#import "SettingViewController.h"
//#import "WXApi.h"
#import "StoreKit/StoreKit.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>
@class GPPSignInButton;



@interface ViewController : UIViewController<FBSDKLoginButtonDelegate, GPPSignInDelegate,UITabBarControllerDelegate,UITextFieldDelegate,FBSDKSharingDelegate,FBSDKSharingDialog,FBSDKSharingContent,NSXMLParserDelegate,UIWebViewDelegate>
{
    
    IBOutlet UIButton *appLogin;
}
@property (nonatomic, strong) NSMutableArray *arrNeighboursData;
@property (nonatomic, strong) NSString *currentElement;
@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage;
@property (nonatomic, strong) NSMutableString *foundValue;
@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSMutableArray *arrNeighboursData2;
@property (nonatomic, strong) NSString *currentElement2;
@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage2;
@property (nonatomic, strong) NSMutableString *foundValue2;
@property (nonatomic, strong) NSXMLParser *xmlParser2;
 
- (IBAction)closeadvert:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *closeadvert;
@property (strong, nonatomic) IBOutlet UIView *videoSuper;
- (IBAction)closevideo:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *closevideo;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton  *loginButton;
@property (weak, nonatomic) IBOutlet FBSDKLikeButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *loading;
 
@property (weak, nonatomic) IBOutlet UILabel *lblLoginStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong,nonatomic)SettingViewController *setting;
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *profilePicture;
- (IBAction)likebutton:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *advertimg;
@property (strong, nonatomic) IBOutlet UILabel *afterlogin;
@property (strong, nonatomic) IBOutlet UIButton *fblogin;
@property (strong, nonatomic) IBOutlet UIButton *glogin;
- (IBAction)glogin:(id)sender;
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UIImageView *gpic;
@property (weak, nonatomic) IBOutlet UIButton *gout;
@property (weak, nonatomic) IBOutlet UIButton *appLogin;
- (IBAction)signout:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *wechatb;
- (IBAction)test:(id)sender;
- (IBAction)wechat:(id)sender;
- (BOOL)connected;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginindicator;
@property (strong, nonatomic) IBOutlet UILabel *info;
@property (strong, nonatomic) IBOutlet UILabel *info2;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *loginemail;
@property (strong, nonatomic) IBOutlet UIButton *registeracct;
@property (strong, nonatomic) IBOutlet UIButton *forgotpassword;
@property (strong, nonatomic) IBOutlet UIImageView *firsttable;
@property (strong, nonatomic) IBOutlet UIImageView *lasttable;
@property (strong, nonatomic) IBOutlet UIButton *reg;
- (IBAction)login:(id)sender;
- (IBAction)registeracct:(id)sender;
- (IBAction)forgotpassword:(id)sender;
@property (nonatomic, assign) id currentResponder;
@property (strong, nonatomic) IBOutlet UIImageView *wechatguide;
@property (strong, nonatomic) IBOutlet UIButton *launchwechat;
- (IBAction)launchwechat:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancellaunch;
- (IBAction)cancellaunch:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *fleetimage;
@property (strong, nonatomic) IBOutlet UIView *maskview;
@property (strong, nonatomic) IBOutlet UIImageView *fbimage;
 
@end
