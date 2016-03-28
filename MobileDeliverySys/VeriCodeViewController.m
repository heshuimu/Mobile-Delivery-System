//
//  VeriCodeViewController.m
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/14.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import "VeriCodeViewController.h"

@interface VeriCodeViewController ()

@end

@implementation VeriCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _VerifyIndicator.hidden = true;
    // Do any additional setup after loading the view.
    _VeriCodeLabel.text = (NSString *)[OrderInfoAccess ReturnValueForKeyString:@"yzm"];
    _IsLocationReady = false;
    
    _currentLocationManager = [[CLLocationManager alloc] init];
    _geocoder = [[CLGeocoder alloc] init];
    
    _currentLocationManager.delegate = self;
    _currentLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([_currentLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_currentLocationManager requestWhenInUseAuthorization];
    }
    
    [_currentLocationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)VerifyThenUpload:(id)sender {
    if ([_VeriCodeTextField.text isEqualToString:_VeriCodeLabel.text] && _IsLocationReady)
    {
        CLAuthorizationStatus LocStat = [CLLocationManager authorizationStatus];
        if (LocStat == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            _VerifyIndicator.hidden = false;
            [_VerifyIndicator startAnimating];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@", BaseHost, UpdateStatusAddr];
            urlStr = [[JSONRequest sharedInstance] AppendGETParameterWithString:urlStr withKey:@"orderid" withValue:(NSString *)[OrderInfoAccess ReturnValueForKeyString:@"orderid"] isFirstParameter:true];
            urlStr = [[JSONRequest sharedInstance] AppendGETParameterWithString:urlStr withKey:@"orderstate" withValue:@"6" isFirstParameter:false];
            urlStr = [[JSONRequest sharedInstance] AppendGETParameterWithString:urlStr withKey:@"nowaddress" withValue:_nowAddr isFirstParameter:false];
            urlStr = [[JSONRequest sharedInstance] AppendGETParameterWithString:urlStr withKey:@"warningstate" withValue:@"1" isFirstParameter:false];
            NSString *PhotoNameStr = [NSString stringWithString:_PhotoArray[0]];
            for (int count = 1; count < _PhotoArray.count; count++) {
                PhotoNameStr = [PhotoNameStr stringByAppendingString:@";"];
                PhotoNameStr = [PhotoNameStr stringByAppendingString:[NSString stringWithString:_PhotoArray[count]]];
            }
            urlStr = [[JSONRequest sharedInstance] AppendGETParameterWithString:urlStr withKey:@"images" withValue:PhotoNameStr isFirstParameter:false];
            NSString *encodedUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[JSONRequest sharedInstance] GETJSONDataFromSeverWithString:encodedUrl target:self];
        }else{
            [self DisplayDialogBoxWithString:@"程序没有获得地理位置的权限，请前往设置>隐私>定位服务中打开对本程序的地理位置授权"];
        }
    } else if (_IsLocationReady == false){
         [self DisplayDialogBoxWithString:@"地理位置获取尚未完成，请稍等"];
    }else{
        [self DisplayDialogBoxWithString:@"验证码输入不吻合"];
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

-(void) DisplayDialogBoxWithString:(NSString *)str
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"遇到错误" message:str delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    [myAlertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

-(void)communicationFailedWithError:(NSError *)err
{
    [self DisplayDialogBoxWithString:@"通信错误"];
    [self performSelectorOnMainThread:@selector(HideSpinningWheelRightNow) withObject:nil waitUntilDone:false];
}

-(void) HideSpinningWheelRightNow
{
    _VerifyIndicator.hidden = true;
    [_VerifyIndicator stopAnimating];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
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
            _nowAddr= [NSString stringWithFormat:@"%@%@%@%@%@%@",_placemark.country, _placemark.administrativeArea, _placemark.locality, _placemark.subLocality, _placemark.thoroughfare,_placemark.subThoroughfare];
            _IsLocationReady = true;
            NSLog(@"%@", _nowAddr);
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_VeriCodeTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
