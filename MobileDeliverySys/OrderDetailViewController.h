//
//  OrderDetailViewController.h
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/13.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONRequest.h"
#import "OrderInfoAccess.h"

@interface OrderDetailViewController : UIViewController <JSONRequestDelegate, CLLocationManagerDelegate>

@property long StateChangeIndicator;

@property (weak, nonatomic) IBOutlet UILabel *OrderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *StartLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *DestinationLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *StartDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ETDLabel;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *UpdateStatusIndicator;
@property (weak, nonatomic) IBOutlet UILabel *CurrentLocationLabel;

@property (weak, nonatomic) IBOutlet UIButton *ConfirmStatusButton;

@property CLLocationManager *currentLocationManager;
@property CLGeocoder *geocoder;
@property CLPlacemark *placemark;
@property BOOL IsLocationReady;


@end
