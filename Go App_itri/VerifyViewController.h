//
//  VerifyViewController.h
//  Go App_itri
//
//  Created by Madhawan Misra on 8/6/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyViewController : UIViewController<UITextFieldDelegate>

{
    
}

- (IBAction)resendcode:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *pincode;
- (IBAction)activate:(id)sender;
@property (strong,nonatomic)NSString *routermacid;
@property (strong,nonatomic)NSString *usermac;
@property (strong,nonatomic)NSString *uuid;
@property (strong,nonatomic)NSString *phonenumber;
@property (strong, nonatomic) IBOutlet UILabel *info;
@property (strong, nonatomic) IBOutlet UILabel *info2;
@property (strong, nonatomic) IBOutlet UILabel *info3;
@property (strong, nonatomic) IBOutlet UILabel *info4;
@property (strong, nonatomic) IBOutlet UIButton *codeconfirm;
@property (strong, nonatomic) IBOutlet UIButton *resendcode;
@property (strong, nonatomic) IBOutlet UIImageView *pincodebackground;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (nonatomic, assign) id currentResponder;
@end
