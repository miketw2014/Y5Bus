//
//  SettingViewController.h
//  Go App_itri
//
//  Created by Madhawan Misra on 6/2/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface SettingViewController : UIViewController<FBSDKLoginButtonDelegate>


{
    //UIImage *img;
    
    IBOutlet UIButton *logout;
    IBOutlet UILabel *logType;
    IBOutlet UILabel *userName;
    IBOutlet UILabel *Email;
    IBOutlet UIImageView *profileImg;
}
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton  *loginButton;

- (IBAction)logout:(id)sender;
@property (nonatomic,retain) UIImage *img;
@property(nonatomic,retain)NSString *test;
@property(nonatomic,retain)NSString *usernames;
@property(nonatomic,retain)NSString *emails;
@property(nonatomic)int loginType;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIImageView *userview;
@property (strong, nonatomic) IBOutlet UILabel *changepassword;
@property (strong, nonatomic) IBOutlet UILabel *aboutus;
@property (strong, nonatomic) IBOutlet UILabel *lablelout;
- (IBAction)changepassword:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *resetpassword;
- (IBAction)aboutus:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UILabel *loading;
@property (strong, nonatomic) IBOutlet UIImageView *passpic;
 

@end
