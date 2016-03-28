//
//  LocationService.h
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/14.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationServiceDelegate <NSObject>

-(void)recieveAddress:(NSString *)parsedAddr;

@end

@interface LocationService : NSObject <CLLocationManagerDelegate>

- (void)GetCurrentAddress:(id<LocationServiceDelegate>)callbackObj;
+(CLLocationManager *)LocationManagerInstance;

@end
