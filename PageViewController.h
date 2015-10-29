//
//  PageViewController.h
//  Go App_itri
//
//  Created by Madhawan Misra on 6/2/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface PageViewController : UIViewController<UIPageViewControllerDataSource>
{
    
    
}
- (IBAction)start:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *start;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@end
