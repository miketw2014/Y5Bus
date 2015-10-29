//
//  PageViewController.m
//  Go App_itri
//
//  Created by Madhawan Misra on 6/2/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import "PageViewController.h"
#import "PageContentViewController.h"
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define iPhoneVersion ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 480 ? 4 : ([[UIScreen mainScreen] bounds].size.height == 667 ? 6 : ([[UIScreen mainScreen] bounds].size.height == 736 ? 61 : 999))))
@interface PageViewController ()

@end

@implementation PageViewController

@synthesize start;
- (void)viewDidLoad {
    [super viewDidLoad];
    
       self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    if ( IDIOM == IPAD ) {
    _pageImages = @[@"Tutorial-01-1536x2048.png", @"Tutorial-02-1536x2048.png"];
    }
    else
    {
        if (iPhoneVersion==4) {
            NSLog(@"This is 3.5 inch iPhone - iPhone 4s or below tutorial");
            _pageImages = @[@"Tutorial-01-640x960.png", @"Tutorial-02-640x960.png"];
            
        } else if (iPhoneVersion==5) {
            NSLog(@"This is 4 inch iPhone - iPhone 5 family tutorial");
            _pageImages = @[@"Tutorial-01-640x1136.png", @"Tutorial-02-640x1136.png"];
        } else if (iPhoneVersion==6) {
            NSLog(@"This is 4.7 inch iPhone - iPhone 6 tutorial");
            _pageImages = @[@"Tutorial-01-750x1334.png", @"Tutorial-02-750x1334.png"];
        } else if (iPhoneVersion==61) {
            _pageImages = @[@"Tutorial-01-1242x2208.png", @"Tutorial-02-1242x2208.png"];
            NSLog(@"This is 5.5 inch iPhone - iPhone 6 Plus.. The BIGGER tutorial");
            
        }
      
    }
    _pageTitles = @[@"", @""];
   // _pageImages = @[@"page1.png", @"page2.png"];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor yellowColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    pageControl.contentVerticalAlignment=UIControlContentVerticalAlignmentBottom;
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
  
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
   // self.pageViewController.view.frame = CGRectMake(5, 0, self.view.frame.size.width+15, self.view.frame.size.height+15);
     start.hidden=YES;
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
   
   // [self.view bringSubviewToFront:self.btnSkip];

   // [self.view bringSubviewToFront:pageControl];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Page View Controller Data Source

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return [self.pageTitles count];
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}
- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
   
    
    // Create a new view controller and pass suitable data.
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_ipad" bundle:nil];

    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if(index==2)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"buttonvisible" object:self];

        //start.hidden=NO;
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"buttonvisible" object:self];

    }
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
   
    if (index == NSNotFound) {
        //start.hidden=NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"buttonvisible" object:self];

        return nil;

        
    }
    
    index++;
    if(index==2 )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"buttonvisible" object:self];

       // start.hidden=NO;
    }
    if(index==1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"buttonvisible" object:self];
        
        // start.hidden=NO;
    }
    if (index == [self.pageTitles count]) {
        NSLog(@"the index is %lu",(unsigned long)index);
        
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (IBAction)start:(id)sender {
}
@end
