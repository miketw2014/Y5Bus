//
//  DesktopViewController.m
//  Go App_itri
//
//  Created by Madhawan Misra on 7/24/15.
//  Copyright (c) 2015 Madhawan Misra. All rights reserved.
//

#import "DesktopViewController.h"
#import "MyCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#include <CoreFoundation/CoreFoundation.h>
#import "SDWebImage/UIImageView+WebCache.h"

@import SystemConfiguration.CaptiveNetwork;

@interface DesktopViewController ()

@end

@implementation DesktopViewController

@synthesize gender;
@synthesize age;
NSString *imageclickurl;
NSString *ssid;
@synthesize macaddress;
UIActivityIndicatorView *spinner;
bool have4g;
bool received,repeatwrong;
- (void)viewDidLoad {
    [super viewDidLoad];
     self.collection.userInteractionEnabled=NO;
    //[self downloadNeighbourCountries];
    self.collection.backgroundColor=[UIColor colorWithRed:252.0/255.0 green:248.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.background.backgroundColor=[UIColor colorWithRed:252.0/255.0 green:248.0/255.0 blue:242.0/255.0 alpha:1.0];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:spinner];
    spinner.hidesWhenStopped=YES;
  //  [spinner startAnimating];
    self.navigationItem.title=NSLocalizedString(@"desktop",nil);
    NSLog(@"the gender is %@",gender);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification4:)
                                                 name:@"desktoplogin"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification4:)
                                                 name:@"desktoplogout"
                                               object:nil];
//    if (self.loginType==0) {
//        ssid= [self fetchSSIDInfo];
//        if ([ssid containsString:@"Y5Bus"])
//        {
//            //self.connectedlbl.hidden=NO;
//            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"acct_err",nil)
//                                                               message:@"Please go to homescreen and login!!"
//                                                              delegate:self
//                                                     cancelButtonTitle:@"OK"
//                                                     otherButtonTitles:nil];
//           // [theAlert show];
//        }
//        
//        else
//        {
//          if (![self connected])
//          {
//              //self.connectedlbl.hidden=NO;
//              UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"NO internet"
//                                                                 message:@"Please connect to internet!!"
//                                                                delegate:self
//                                                       cancelButtonTitle:@"OK"
//                                                       otherButtonTitles:nil];
//             // [theAlert show];
//          }
//           else
//           {
//               self.connectedlbl.hidden=YES;
//               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                  // [self downloadbackground];
//                  // [self downloadNeighbourCountries];
//               });
//           }
//        }
//    }
//    
//    else
//    {
//        self.connectedlbl.hidden=YES;
//        
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//       // [self downloadbackground];
//        //[self downloadNeighbourCountries];
//    });
//    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.advertisment addGestureRecognizer:singleTap];
     
    
    // Do any additional setup after loading the view.
}

- (NSString *)fetchSSIDInfo
{
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
            NSLog(@"the ssid is %@",ssid);
            
        }
    }
    return ssid;
}

- (void)receivedNotification4:(NSNotification *) notification
{
    
    NSLog(@"IS ALSO RECEIVEDDDDDDDD");
    if ([[notification name] isEqualToString:@"desktoplogin"]) {
        
        repeatwrong=false;
       if (received)
        {
            self.collection.userInteractionEnabled=NO;
            NSMutableDictionary * dateDict = [[NSMutableDictionary alloc] initWithDictionary:[notification userInfo]];
            macaddress=[dateDict objectForKey:@"macid"];
            NSLog(@"gender is %@",gender);
            //received=true;
            self.connectedlbl.hidden=YES;
            self.loginType=1;
            [self.loginindicator startAnimating];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self downloadbackground];
                [self downloadNeighbourCountries];
            });
        }
    
        else
        {
        //self.collection.hidden=YES;
        self.collection.userInteractionEnabled=NO;
            NSDictionary *userInfo = notification.userInfo;
            macaddress=[userInfo objectForKey:@"macid"];
            NSLog(@"gender is %@",gender);
            //received=true;
            self.connectedlbl.hidden=YES;
             self.loginType=1;
        [self.loginindicator startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self downloadbackground];
            [self downloadNeighbourCountries];
        });
        
        }
    }
    
    else if ([[notification name] isEqualToString:@"desktoplogout"])
    {
        if (repeatwrong) {
            
        }
        else
        {
        repeatwrong=true;
        
        self.collection.userInteractionEnabled=NO;
        macaddress=@"";
        NSLog(@"gender is %@",gender);
        //received=true;
        self.connectedlbl.hidden=YES;
        self.loginType=1;
        [self.loginindicator startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self downloadbackground];
            [self downloadNeighbourCountries];
        });
        }
    }
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if(networkStatus == NotReachable)
    {
        NSLog(@"network status is no");
        have4g=FALSE;

    }
    else if (networkStatus == ReachableViaWiFi)
    {
        NSLog(@"network status is wifi");
        have4g=FALSE;
    }
    else if (networkStatus == ReachableViaWWAN)
    {
        NSLog(@"network status is 3g");
        have4g=TRUE;
    }
    return networkStatus != NotReachable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.loginindicator startAnimating];
    
    if (![self connected] )
    {
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error",nil)
                                                           message:NSLocalizedString(@"error_internet",nil)
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        self.collection.hidden=YES;
        self.advertisment.hidden=YES;
            [self.loginindicator stopAnimating];
        
    }
    else if (have4g)
    {
        self.collection.hidden=NO;
        self.advertisment.hidden=NO;
        if (received) {
    [self.loginindicator stopAnimating];
        }
        else
        {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self downloadbackground];
            [self downloadNeighbourCountries];
            
        });
        }
        
    }
    else
    {
        [self fetchSSIDInfo];
        //this is how to check continous
        
        if ([ssid containsString:@"Y5Bus"]) {
            
            if (self.loginType==0) {
                
                UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"please_log",nil)
                                                                   message:NSLocalizedString(@"login_desc2",nil)
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                [theAlert show];
                [theAlert setTag:1];
                
                self.collection.hidden=YES;
                self.advertisment.hidden=YES;
                    [self.loginindicator stopAnimating];
            }
            
            else
            {
                
                self.collection.hidden=NO;
                self.advertisment.hidden=NO;
                if (received) {
                        [self.loginindicator stopAnimating];
                }
                else
                {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [self downloadbackground];
                    [self downloadNeighbourCountries];
                
                    
                });
                }
            }
            
        }
        
        else
            
        {
            self.collection.hidden=NO;
            self.advertisment.hidden=NO;
            if (received) {
                    [self.loginindicator stopAnimating];
            }
            else
            {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self downloadbackground];
                [self downloadNeighbourCountries];
                
            });
            }
            
        }

    NSLog(@"the gender is %@",gender);
    
}
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    float width = collectionView.frame.size.width;
    float spacing = [self collectionView:collectionView layout:self.collection minimumInteritemSpacingForSectionAtIndex:section];
    int numberOfCells = (width + spacing) / (60 + spacing);
    int inset = (width + spacing - numberOfCells * (60 + spacing) ) / 2;
    
    return UIEdgeInsetsMake(0, inset, 0, inset);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)downloadNeighbourCountries{
    // Prepare the URL that we'll get the neighbour countries from.
    [self.loginindicator startAnimating];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *s=[NSString stringWithFormat:@"MacAddress=%@",macaddress];
    
    
    NSData *postData = [s dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSLog(@"postdata: %@", postData);
    NSLog(@"postdata string: %@", s);
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://y5bus.chainyi.com/WebServices/WebService.asmx/GetiOSAppList"]];
    [request setHTTPMethod:@"POST"];
    //[request setHttp]
    //[request setValue:@"text/xml" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
    //[request ]
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    // NSLog(@"request url: %@", request);
    
    
    
    //response
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    // NSLog(@"requesthandler: %@", requestHandler);
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSUTF8StringEncoding];
    NSLog(@"requestReply: %@", requestReply);
    
    self.xmlParser2 = [[NSXMLParser alloc] initWithData:requestHandler];
    self.xmlParser2.delegate = self;
    
    // Initialize the mutable string that we'll use during parsing.
    self.foundValue2 = [[NSMutableString alloc] init];
    
    // Start parsing.
    [self.xmlParser2 parse];
    NSString *pattern = @"<ErrorCode>(\\d+)</ErrorCode>";
    
    NSString *xml = requestReply;
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:xml options:0 range:NSMakeRange(0, xml.length)];
    
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *match = [xml substringWithRange:matchRange];
    NSLog(@"Found string '%@'", match);
    
     }


-(void)downloadbackground{
    // Prepare the URL that we'll get the neighbour countries from.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSLog(@"age is %ld",(long)age);
     NSString *strage=[NSString stringWithFormat:@"%d", (int)age];
    NSString *s=[NSString stringWithFormat:@"gender=%@&age=%@",gender,strage];
    
    NSLog(@"gender download is %@ and %@",gender,strage);
    
    NSData *postData = [s dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://y5bus.chainyi.com/WebServices/WebService.asmx/GetDeskTopAd"]];
    [request setHTTPMethod:@"POST"];
    //[request setHttp]
    //[request setValue:@"text/xml" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
    //[request ]
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    // NSLog(@"request url: %@", request);
    
    
    
    //response
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
         
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSUTF8StringEncoding];
    NSLog(@"requestReply: %@", requestReply);

    
    
    self.xmlParser = [[NSXMLParser alloc] initWithData:requestHandler];
    self.xmlParser.delegate = self;
    
    // Initialize the mutable string that we'll use during parsing.
    self.foundValue = [[NSMutableString alloc] init];
    
    // Start parsing.
    [self.xmlParser parse];
    
    NSString *pattern = @"<ErrorCode>(\\d+)</ErrorCode>";
    NSString *xml = requestReply;
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:xml options:0 range:NSMakeRange(0, xml.length)];
    
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *match = [xml substringWithRange:matchRange];
    //NSLog(@"Found string '%@'", match);
    

    
}
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    // Initialize the neighbours data array.
    self.arrNeighboursData = [[NSMutableArray alloc] init];
    self.arrNeighboursData2 = [[NSMutableArray alloc] init];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    // If the current element name is equal to "geoname" then initialize the temporary dictionary.
    if ([elementName isEqualToString:@"AdExtend"]) {
        self.dictTempDataStorage = [[NSMutableDictionary alloc] init];
        
    }
    self.currentElement = elementName;

    
        if ([elementName isEqualToString:@"AppExtendList"]) {
            self.dictTempDataStorage2 = [[NSMutableDictionary alloc] init];
             self.currentElement2 = elementName;
        }
    self.currentElement2 = elementName;
    // Keep the current element.
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

    if (parser==self.xmlParser) {

    if ([elementName isEqualToString:@"AdExtend"]) {
        // If the closing element equals to "geoname" then the all the data of a neighbour country has been parsed and the dictionary should be added to the neighbours data array.
        [self.arrNeighboursData addObject:[[NSDictionary alloc] initWithDictionary:self.dictTempDataStorage]];
       // NSLog(@"the elements inside an array are %@",self.arrNeighboursData);
        NSString *imageurl =[[self.arrNeighboursData objectAtIndex:0] objectForKey:@"AdImgUrl"];
        NSString *newimage=[NSString stringWithFormat:@"http://%@",imageurl];
        imageclickurl =[[self.arrNeighboursData objectAtIndex:0] objectForKey:@"Url"];

        NSURL *url = [NSURL URLWithString:[newimage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.advertisment.userInteractionEnabled=true;
        
        
//            NSData *data = [NSData dataWithContentsOfURL :url];
//      UIImage *image1=[UIImage imageWithData:data];
            //if (image1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.advertisment sd_setImageWithURL:url];

//                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                                         NSUserDomainMask, YES);
//                    NSString *documentsDirectory = [paths objectAtIndex:0];
//                    NSString* path = [documentsDirectory stringByAppendingPathComponent:
//                                      @"test.png" ];
//                    NSData* data = UIImagePNGRepresentation(image1);
//                    [data writeToFile:path atomically:YES];
                    
                });
            //}
   
    }
    
    
    else if ([elementName isEqualToString:@"Title"]){
        // If the country name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Title"];
    }
    else if ([elementName isEqualToString:@"AdImgUrl"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"AdImgUrl"];
    }
    else if ([elementName isEqualToString:@"Url"]){
        
        //NSLog(@"the url is %@",elementName);
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"Url"];
        
       
    }
    
    // Clear the mutable string.
    [self.foundValue setString:@""];
   }
        else if (parser==self.xmlParser2)
        {
         
             
            if ([elementName isEqualToString:@"AppExtend"]) {
                // If the closing element equals to "geoname" then the all the data of a neighbour country has been parsed and the dictionary should be added to the neighbours data array.
                [self.arrNeighboursData2 addObject:[[NSDictionary alloc] initWithDictionary:self.dictTempDataStorage2]];
               // NSLog(@"the elements inside an array2 are %@",self.arrNeighboursData2);
  
            }
            
            
            else if ([elementName isEqualToString:@"Url"]){
                // If the country name element was found then store it.
                [self.dictTempDataStorage2 setObject:[NSString stringWithString:self.foundValue2] forKey:@"Url"];
            }
            else if ([elementName isEqualToString:@"AppImgUrl"]){
                // If the toponym name element was found then store it.
                [self.dictTempDataStorage2 setObject:[NSString stringWithString:self.foundValue2] forKey:@"AppImgUrl"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:elementName]];

            }
            
            else if ([elementName isEqualToString:@"Name"]){
                // If the toponym name element was found then store it.
                [self.dictTempDataStorage2 setObject:[NSString stringWithString:self.foundValue2] forKey:@"Name"];
            }
            // Clear the mutable string.
            [self.foundValue2 setString:@""];
        }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // Store the found characters if only we're interested in the current element.
    if (parser==self.xmlParser) {
        if ([self.currentElement isEqualToString:@"Title"] ||
            [self.currentElement isEqualToString:@"AdImgUrl"] ||
            [self.currentElement isEqualToString:@"Url"]) {
            
            
            
            if (![string isEqualToString:@"\n"]) {
                [self.foundValue appendString:string];
            }
        }
    }
   else if (parser==self.xmlParser2)
   {
       if ([self.currentElement2 isEqualToString:@"Url"] ||
           [self.currentElement2 isEqualToString:@"AppImgUrl"]||[self.currentElement2 isEqualToString:@"Name"]) {
           
           
           
           if (![string isEqualToString:@"\n"]) {
               [self.foundValue2 appendString:string];
           }
       }

   }
    
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    // When the parsing has been finished then simply reload the table view.
    if (parser==self.xmlParser2) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.collection reloadData];
        });
    }
    
    else if (parser==self.xmlParser)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.advertisment.userInteractionEnabled=YES;
        });
    }
    
    
    }


- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"the imageurl is %@",imageclickurl);
        NSString *newstring=[imageclickurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *newString1 = [newstring substringFromIndex:1];
    NSLog(@"the url is %@",newString1);
    NSURL *url = [NSURL URLWithString:[newString1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"the url is %@",url);
    [[UIApplication sharedApplication] openURL:url];
    
}



-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"the total items are %lu",(unsigned long)self.arrNeighboursData2.count);
    if (self.arrNeighboursData2.count==0) {
        self.refresh.hidden=NO;
    }
    else
    {
        self.refresh.hidden=YES;

    }
    return self.arrNeighboursData2.count;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0; // This is the minimum inter item spacing, can be more
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"MyCell"
                                    forIndexPath:indexPath];
   // myCell.tag=indexPath.row;
    
     // self.collection.hidden=YES;
    if (self.arrNeighboursData2.count==0) {
        self.collection.userInteractionEnabled=YES;
 

    }
    else
    {
        received=TRUE;
        
        NSString *imageurl =[[self.arrNeighboursData2 objectAtIndex:indexPath.row] objectForKey:@"AppImgUrl"];
        NSString *newimage=[NSString stringWithFormat:@"http://%@",imageurl];
        NSString *name =[[self.arrNeighboursData2 objectAtIndex:indexPath.row] objectForKey:@"Name"];
        
        NSURL *url = [NSURL URLWithString:[newimage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        
           // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
   
//            NSData *data = [NSData dataWithContentsOfURL :url];
//            UIImage *image1=[UIImage imageWithData:data];
//        //[myCell.imageView sd_setImageWithURL:url];
//            if (image1) {
        
                //if (myCell.tag == indexPath.row)
                //{
                    //dispatch_async(dispatch_get_main_queue(), ^{
                        [myCell.imageView sd_setImageWithURL:url];
                   // myCell.imageView.image = image1;
                        self.collection.userInteractionEnabled=YES;

                         self.collection.hidden=NO;
                        [self.loginindicator stopAnimating];
                    //});
                //}
          //  }
            
             // });
        myCell.appname.text=name;
        

 
    }
    
     [self.loginindicator stopAnimating];
        return myCell;
    

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"the item selected is at %ld",(long)indexPath.row);
    
    NSString *imageurl =[[self.arrNeighboursData2 objectAtIndex:indexPath.row] objectForKey:@"Url"];
    
    NSString *newstring=[imageurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *newString1 = [newstring substringFromIndex:1];
    NSLog(@"the new string1 is %@",newString1);
    NSURL *url = [NSURL URLWithString:[newString1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  
    [[UIApplication sharedApplication] openURL:url];
    

    NSLog(@"the image URL is%@",newstring);
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) { // UIAlertView with tag 1 detected
        if (buttonIndex == 0)
        {
            
            [self.tabBarController setSelectedIndex:0];
        }
    }
}




- (IBAction)refresh:(id)sender {
    [self.loginindicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self downloadbackground];
        [self downloadNeighbourCountries];
    });
}
@end
