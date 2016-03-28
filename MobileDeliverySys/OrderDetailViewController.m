//
//  OrderDetailViewController.m
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/13.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _UpdateStatusIndicator.hidden = true;
    
    _IsLocationReady = false;
    
    _currentLocationManager = [[CLLocationManager alloc] init];
    _geocoder = [[CLGeocoder alloc] init];

    _currentLocationManager.delegate = self;
    _currentLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([_currentLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_currentLocationManager requestWhenInUseAuthorization];
    }
    
    [_currentLocationManager startUpdatingLocation];
    
    // Do any additional setup after loading the view.
    NSString* OrderIDStr = [NSString stringWithString:(NSString *)[OrderInfoAccess ReturnValueForKeyString:@"orderid"]];
    _OrderNumberLabel.text = OrderIDStr;
    
    NSString* StartLocationStr = [NSString stringWithString:(NSString *)[OrderInfoAccess ReturnValueForKeyString:@"beginaddress"]];
    _StartLocationLabel.text = StartLocationStr;
    
    NSString* DestinationLocationStr = [NSString stringWithString:(NSString *)[OrderInfoAccess ReturnValueForKeyString:@"endaddress"]];
    _DestinationLocationLabel.text = DestinationLocationStr;
    
    NSString* StartDateStr = [NSString stringWithString:(NSString *)[OrderInfoAccess ReturnValueForKeyString:@"eta"]];
    _StartDateLabel.text = StartDateStr;
    
    NSString* ETDStr = [NSString stringWithString:(NSString *)[OrderInfoAccess ReturnValueForKeyString:@"etd"]];
    _ETDLabel.text = ETDStr;
    
    NSString* StatusStr = [NSString stringWithFormat:@"%@%@%@", [self WhatIsTheState:[(NSString *)[OrderInfoAccess ReturnValueForKeyString:@"orderstate"] integerValue]] , @"➡️", [self WhatIsTheState:_StateChangeIndicator]];
    _StatusLabel.text = StatusStr;
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

-(IBAction)SubmitNewStatus:(id)sender
{
    CLAuthorizationStatus LocStat = [CLLocationManager authorizationStatus];
    if (LocStat == kCLAuthorizationStatusAuthorizedWhenInUse && _IsLocationReady)
    {
        _UpdateStatusIndicator.hidden = false;
        [_UpdateStatusIndicator startAnimating];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", BaseHost, UpdateStatusAddr];
        urlStr = [[JSONRequest sharedInstance] AppendGETParameterWithString:urlStr withKey:@"orderid" withValue:_OrderNumberLabel.text isFirstParameter:true];
        urlStr = [[JSONRequest sharedInstance] AppendGETParameterWithString:urlStr withKey:@"orderstate" withValue:[NSString stringWithFormat:@"%ld", _StateChangeIndicator] isFirstParameter:false];
        urlStr = [[JSONRequest sharedInstance] AppendGETParameterWithString:urlStr withKey:@"nowaddress" withValue:_CurrentLocationLabel.text isFirstParameter:false];
        urlStr = [[JSONRequest sharedInstance] AppendGETParameterWithString:urlStr withKey:@"warningstate" withValue:@"1" isFirstParameter:false];
        NSString *encodedUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[JSONRequest sharedInstance] GETJSONDataFromSeverWithString:encodedUrl target:self];
    }else if (LocStat == kCLAuthorizationStatusAuthorizedWhenInUse && _IsLocationReady == false)
    {
        [self DisplayDialogBoxWithString:@"地理位置获取尚未完成，请稍等"];
    }
    else if (LocStat != kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self DisplayDialogBoxWithString:@"程序没有获得地理位置的权限，请前往设置>隐私>定位服务中打开对本程序的地理位置授权"];
    }
}


-(void)recieveJSONReturn:(NSData *)data
{
    NSLog(@"Data recieved");
    NSError *localError = nil;
    NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    if ([[resultData objectForKey:@"flat"] boolValue] == true) {
        NSLog(@"Succeeded update attempt");
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self performSegueWithIdentifier:@"GoToUpdateSuccessful" sender:self];
        }];
    }
    else if([[resultData objectForKey:@"flat"] boolValue] == false)
    {
        NSLog(@"Failed update attempt");
        [self DisplayDialogBoxWithString:@"更新状态失败"];
    }
    else
    {
        NSLog(@"Unknown return value");
        [self DisplayDialogBoxWithString:@"意外的服务器反馈，可能是服务器故障"];
    }
    [self performSelectorOnMainThread:@selector(HideSpinningWheelRightNow) withObject:nil waitUntilDone:false];
}

-(NSString *)WhatIsTheState:(long)StateIndex
{
    switch (StateIndex) {
        case 1:
            return @"取货";
        case 2:
            return @"离开发运地";
        case 3:
            return @"在途中";
        case 4:
            return @"到达货运地";
        case 5:
            return @"送达客户";
        case 6:
            return @"拍照上传";
        default:
            return @"未知状态";
    }

}

-(void) DisplayDialogBoxWithString:(NSString *)str
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"遇到错误" message:str delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    [myAlertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

-(void)communicationFailedWithError:(NSError *)err
{
    NSLog(@"%@",err.localizedDescription);
    [self DisplayDialogBoxWithString:@"通信错误"];
    [self performSelectorOnMainThread:@selector(HideSpinningWheelRightNow) withObject:nil waitUntilDone:false];
}

-(void) HideSpinningWheelRightNow
{
    _UpdateStatusIndicator.hidden = true;
    [_UpdateStatusIndicator stopAnimating];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    _CurrentLocationLabel.text=@"📍无法获得地理位置";
    [self DisplayDialogBoxWithString:@"获取地理位置失败"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    [_currentLocationManager stopUpdatingLocation];
    
    NSLog(@"Resolving the Address");
    [_geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            _placemark = [placemarks lastObject];
            _CurrentLocationLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",_placemark.country, _placemark.administrativeArea, _placemark.locality, _placemark.subLocality, _placemark.thoroughfare,_placemark.subThoroughfare];
            _IsLocationReady = true;
            NSLog(@"%@", _CurrentLocationLabel.text);
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

@end
