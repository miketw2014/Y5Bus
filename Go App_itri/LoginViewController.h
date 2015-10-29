//
//  LoginViewController.h
//  Go App_itri
//
//  Created by Madhawan Misra on 5/28/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>


{

    IBOutlet UIButton *signup;
    
}

- (BOOL)connected;
@property (strong,nonatomic)NSString *routermacid;
@property (strong,nonatomic)NSString *usermac;
@property (strong,nonatomic)NSString *uuid;
@property (strong, nonatomic) IBOutlet UIImageView *forgot;
@property (strong, nonatomic) IBOutlet UITextField *forgotpassword;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UILabel *intro;
- (IBAction)forgotpassword:(id)sender;
@property (nonatomic, assign) id currentResponder;
@end
