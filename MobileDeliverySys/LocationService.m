//
//  LocationService.m
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/14.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import "LocationService.h"

@implementation LocationService

static CLLocationManager *currentLocationManager;

- (void)GetCurrentAddress:(id<LocationServiceDelegate>)callbackObj
{
    currentLocationManager.delegate = self;
    currentLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [currentLocationManager startUpdatingLocation];
}

+ (CLLocationManager *)LocationManagerInstance
{
    if (currentLocationManager == nil) {
        currentLocationManager = [[CLLocationManager alloc] init];
    }
    return currentLocationManager;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"遇到错误" message:@"获取地理位置失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
}

@end
