//
//  PageContentViewController.h
//  Go App_itri
//
//  Created by Madhawan Misra on 6/2/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
{
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UIImageView *backgroundImageView;
}
 
 
@property (strong, nonatomic) IBOutlet UIButton *startapp;
- (IBAction)appstart:(id)sender;

@property NSUInteger pageIndex;//current page index
@property NSString *titleText;//title
@property NSString *imageFile;//image
@end
