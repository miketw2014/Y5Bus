//
//  UpdatepasswordViewController.h
//  Go App_itri
//
//  Created by Madhawan Misra on 8/26/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatepasswordViewController : UIViewController<UITextFieldDelegate>
{
    
}
@property (strong,nonatomic)NSString *account;
@property (strong, nonatomic) IBOutlet UITextField *code;
@property (strong, nonatomic) IBOutlet UITextField *newpassword;
@property (strong, nonatomic) IBOutlet UILabel *confirmpassword;
@property (strong, nonatomic) IBOutlet UITextField *confirm;
@property (nonatomic, assign) id currentResponder;

@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIImageView *firstimageview;

@property (strong, nonatomic) IBOutlet UIImageView *secondimageview;
@property (strong, nonatomic) IBOutlet UIImageView *thirdimageview;
@property (strong, nonatomic) IBOutlet UIButton *send;
- (IBAction)send:(id)sender;

@end
