//
//  PageContentViewController.m
//  Go App_itri
//
//  Created by Madhawan Misra on 6/2/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import "PageContentViewController.h"
#import "PageViewController.h"
@interface PageContentViewController ()

@end

@implementation PageContentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    titleLabel.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"buttonvisible"
                                               object:nil];
    self.startapp.hidden=NO;
    //PageViewController *pagecontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"Pageview"];

   // pagecontroller.start.hidden=NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receivedNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"buttonvisible"])
    {
        [self nothidden];

    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)nothidden
{
    self.startapp.hidden=NO;
}

- (IBAction)appstart:(id)sender {
    NSLog(@"called");
    
}
@end
