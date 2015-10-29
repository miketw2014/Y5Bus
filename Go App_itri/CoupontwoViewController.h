//
//  CoupontwoViewController.h
//  Go App_itri
//
//  Created by Madhawan Misra on 8/13/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "ViewController.h"
@interface CoupontwoViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *mac;

@property(nonatomic)int loginType;
@property(nonatomic)NSInteger age;
@property (strong, nonatomic) IBOutlet UILabel *connectedlbl;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginindicator;

- (IBAction)back:(id)sender;

- (BOOL)connected;
@end
