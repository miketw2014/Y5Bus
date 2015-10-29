//
//  DesktopViewController.h
//  Go App_itri
//
//  Created by Madhawan Misra on 7/24/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import <UIKit/UIKit.h>
# import "AppDelegate.h"
#include <CoreFoundation/CoreFoundation.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface DesktopViewController : UIViewController<NSXMLParserDelegate,UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *records;
}
@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSXMLParser *xmlParser2;

@property (nonatomic, strong) NSMutableArray *arrNeighboursData;
@property (nonatomic, strong) NSMutableArray *arrNeighboursData2;

@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage;
@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage2;
@property (nonatomic, strong) NSString *macaddress;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginindicator;
@property (nonatomic, strong) NSMutableString *foundValue;
@property (nonatomic, strong) NSMutableString *foundValue2;
@property(nonatomic)NSInteger age;
@property (nonatomic, strong) NSString *currentElement;
@property (nonatomic, strong) NSString *currentElement2;
@property (nonatomic, strong) NSString *gender;
@property(nonatomic)int loginType;
- (BOOL)connected;
@property (strong, nonatomic) IBOutlet UILabel *connectedlbl;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UICollectionView *collection;
@property (strong, nonatomic) IBOutlet UIImageView *advertisment;

- (IBAction)refresh:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *refresh;



-(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;

 
@end
