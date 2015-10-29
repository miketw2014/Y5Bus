//
//  CouponViewController.h
//  Go App_itri
//
//  Created by Madhawan Misra on 5/28/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
@interface CouponViewController : UIViewController< UIWebViewDelegate>
{
    
}
@property(nonatomic)NSInteger age;
@property (nonatomic, strong) NSString *gender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginindicator;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic)int loginType;
@property (nonatomic, strong) NSString *mac;

- (BOOL)connected;



@end
