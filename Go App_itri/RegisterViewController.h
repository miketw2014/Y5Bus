//
//  RegisterViewController.h
//  Go App_itri
//
//  Created by Madhawan Misra on 5/28/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
@interface RegisterViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

{
    
     
     
}
@property (strong, nonatomic) NSArray *gendernames;
@property (strong, nonatomic) IBOutlet UILabel *rules;
@property (strong, nonatomic) IBOutlet UIImageView *background;
- (BOOL)connected;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityindicator;

@property (strong, nonatomic) IBOutlet UIImageView *imagefirst;
@property (strong, nonatomic) IBOutlet UIImageView *imagemiddle;

@property (strong, nonatomic) IBOutlet UIButton *loginemail;
@property (strong, nonatomic) IBOutlet UIImageView *imagelast;

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmpassword;
- (IBAction)send:(id)sender;
@property (nonatomic, assign) id currentResponder;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldBranchYear;
@property (strong,nonatomic)NSString *routermacid;
@property (strong,nonatomic)NSString *usermac;
@property (strong,nonatomic)NSString *uuid;
@property (strong, nonatomic) IBOutlet UILabel *secondbottom;
@property (strong, nonatomic) IBOutlet UILabel *lastbottom;
@property (strong, nonatomic) IBOutlet UITextField *gender;
@property (strong, nonatomic) IBOutlet UIImageView *imagegender;
@property (strong, nonatomic) IBOutlet UIImageView *imagebirthday;
@property (strong, nonatomic) IBOutlet UIImageView *imagename;
@property (strong, nonatomic) IBOutlet UITextField *namefield;
//
@property (strong, nonatomic) IBOutlet UIButton *terms;
@property (strong, nonatomic) IBOutlet UIButton *datapolicy;
- (IBAction)datapolicy:(id)sender;
- (IBAction)terms:(id)sender;




@end
