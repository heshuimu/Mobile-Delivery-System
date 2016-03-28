//
//  VeriCodeViewController.h
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/14.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "OrderInfoAccess.h"

@interface VeriCodeViewController : UIViewController <JSONRequestDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *VeriCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *VeriCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *VerifyButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *VerifyIndicator;

@property NSMutableArray* PhotoArray;
@property BOOL IsItNormalDelivery;

@property CLLocationManager *currentLocationManager;
@property CLGeocoder *geocoder;
@property CLPlacemark *placemark;
@property BOOL IsLocationReady;
@property NSString *nowAddr;

@end
