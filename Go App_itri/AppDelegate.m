//
//  AppDelegate.m
//  Go App_itri
//
//  Created by Madhawan Misra on 5/25/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//
#define IS_DEVICE_RUNNING_IOS_7_AND_ABOVE() ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define iPhoneVersion ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 480 ? 4 : ([[UIScreen mainScreen] bounds].size.height == 667 ? 6 : ([[UIScreen mainScreen] bounds].size.height == 736 ? 61 : 999))))
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
//#import "WXApi.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GooglePlus/GooglePlus.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface AppDelegate ()

@end
NSString *repeat;
bool shouldrepeat;
@implementation AppDelegate


#define FACEBOOK_SCHEME  @"fb1484928761731211"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
//  NSLog(@"the height and width is %@ and %@",screenHeight,screenWidth);
   if ([UIScreen mainScreen].bounds.size.height == 667)
   {
       NSLog(@"iphone 6");
   }
    if (iPhoneVersion==4) {
        NSLog(@"This is 3.5 inch iPhone - iPhone 4s or below");
        UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"Main_ip4" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
    } else if (iPhoneVersion==5) {
        NSLog(@"This is 4 inch iPhone - iPhone 5 family");
        UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
    } else if (iPhoneVersion==6) {
        
        UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"Main_ip6" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
        NSLog(@"This is 4.7 inch iPhone - iPhone 6");
    } else if (iPhoneVersion==61) {
        NSLog(@"This is 5.5 inch iPhone - iPhone 6 Plus.. The BIGGER");
        UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"Main_iphone" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
    } else {
        NSLog(@"This is iPad");
        UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"Main_ipad" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
    }
    
    
    
    shouldrepeat=true;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification1:)
                                                 name:@"stoprepeat"
                                               object:nil];
    
    
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20.0], NSFontAttributeName, nil]];
    self.tabBarController = [[UITabBarController alloc]init];
   

    // [[UITabBar appearance] setTintColor:[UIColor colorWithRed:178.0/255.0 green:170.0/255.0 blue:0.0/255.0 alpha:1.0]];//selected
    //[[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:0.0/255.0 alpha:1.0]];//default
    UIImage *whiteBackground = [UIImage imageNamed:@"tabbar_btn_bg_pressed.png"];
    UIImage *white1Background = [UIImage imageNamed:@"tabbar_btn_bg_normal.png"];

    //[[UITabBar appearance] setSelectionIndicatorImage:whiteBackground];
    
//    [[UITabBarItem appearance] setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIColor whiteColor], NSForegroundColorAttributeName,
//      [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:12.0], NSFontAttributeName,
//      nil]
//                                             forState:UIControlStateNormal];
    if ( IDIOM == IPAD ) {
        /* do something specifically for iPad. */
        UIImage *def = [[UIImage imageNamed:@"tabbar_btn_bg_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        CGSize tabSize1 = CGSizeMake(CGRectGetWidth(self.tabBarController.view.frame)/6, 49);
        UIGraphicsBeginImageContext(tabSize1);
        [def drawInRect:CGRectMake(0, 0, tabSize1.width, tabSize1.height)];
        UIImage *reSizeImage1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImage *selTab = [[UIImage imageNamed:@"tabbar_btn_bg_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        CGSize tabSize = CGSizeMake(CGRectGetWidth(self.tabBarController.view.frame)/5.9, 49);
        UIGraphicsBeginImageContext(tabSize1);
        [selTab drawInRect:CGRectMake(0, 0, tabSize.width, tabSize.height)];
        UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        [[UITabBar appearance] setSelectionIndicatorImage:reSizeImage];
        [[UITabBar appearance] setBackgroundImage:reSizeImage1];
        
    } else {
        /* do something specifically for iPhone or iPod touch. */
        UIImage *def = [[UIImage imageNamed:@"tabbar_btn_bg_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        CGSize tabSize1 = CGSizeMake(CGRectGetWidth(self.tabBarController.view.frame)/5, 49);
        UIGraphicsBeginImageContext(tabSize1);
        [def drawInRect:CGRectMake(0, 0, tabSize1.width, tabSize1.height)];
        UIImage *reSizeImage1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImage *selTab = [[UIImage imageNamed:@"tabbar_btn_bg_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        CGSize tabSize = CGSizeMake(CGRectGetWidth(self.tabBarController.view.frame)/5, 49);
        UIGraphicsBeginImageContext(tabSize);
        [selTab drawInRect:CGRectMake(0, 0, tabSize.width, tabSize.height)];
        UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        [[UITabBar appearance] setSelectionIndicatorImage:reSizeImage];
        [[UITabBar appearance] setBackgroundImage:reSizeImage1];
        
    }

//    UIImage *def = [[UIImage imageNamed:@"tabbar_btn_bg_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    CGSize tabSize1 = CGSizeMake(CGRectGetWidth(self.tabBarController.view.frame)/5, 49);
//    UIGraphicsBeginImageContext(tabSize1);
//    [def drawInRect:CGRectMake(0, 0, tabSize1.width, tabSize1.height)];
//    UIImage *reSizeImage1 = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImage *selTab = [[UIImage imageNamed:@"tabbar_btn_bg_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    CGSize tabSize = CGSizeMake(CGRectGetWidth(self.tabBarController.view.frame)/5, 49);
//    UIGraphicsBeginImageContext(tabSize);
//    [selTab drawInRect:CGRectMake(0, 0, tabSize.width, tabSize.height)];
//    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
    //
    
    //[[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];

    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.translucent = true;
    

    
       //   UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
  //  [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    
    
    
   //  Change the title color of tab bar items
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor whiteColor], UITextAttributeTextColor,
//                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateHighlighted];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [FBSDKProfilePictureView class];
        [FBSDKLoginButton class];
    
//    if (![WXApi registerApp:@"wx64443a1ce3647b28"]) {
//        NSLog(@"Failed to register with Weixin");
//    }
    return YES;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     NSLog(@"terminated");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    if (shouldrepeat) {
        
    //should be enabled later on
        
        
     [[NSNotificationCenter defaultCenter] postNotificationName:@"checkwifi" object:self];

    }
    else
    {
        NSLog(@"no repeat");
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return [WXApi handleOpenURL:url delegate:self];
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[url scheme] isEqualToString:FACEBOOK_SCHEME])
    {
        
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    }
    
//    if ([[url scheme] isEqualToString:@"weixin"]) {
//        return [WXApi handleOpenURL:url delegate:self ];
//    }
    else
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    
    
    [FBSDKAppEvents activateApp];
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)receivedNotification1:(NSNotification *) notification {
    repeat=[notification object];
    if ([repeat isEqualToString:@"no"]) {
        shouldrepeat=false;
    }
    else if ([repeat isEqualToString:@"yes"])
    {
        shouldrepeat=true;
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"terminated");
}

@end
