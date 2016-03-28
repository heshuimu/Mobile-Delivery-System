//
//  OrderInfoAccess.m
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/10.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import "OrderInfoAccess.h"

@implementation OrderInfoAccess

static OrderInfoObj *currentInfo;
static NSMutableDictionary *currentInfoDic;
static NSString *currentButtonAvailability;

+(void)AttachOrderInfo:(OrderInfoObj *)updateInfo
{
    currentInfo = updateInfo;
    NSLog(@"Order info has been updated");
}

+(void)AttachButtonAvailabilityInfo:(NSString *)updateInfo
{
    for (int count = 0; count < updateInfo.length; count++) {
        if ([updateInfo characterAtIndex:count] != 'N' && [updateInfo characterAtIndex:count] != 'Y') {
            NSLog(@"String Contains unexpected character");
            return;
        }
    }
    currentButtonAvailability = updateInfo;
    NSLog(@"Button info has been updated");
}

+(OrderInfoObj *)GetOrderInfoWithInfo:(OrderInfoObj *) updateInfo
{
    if (currentInfo == nil)
    {
        NSLog(@"Be ware, current interface has no order info");
    }
    return currentInfo;
}

+(void)AttachOrderInfoDictionaryWithDic:(NSMutableDictionary *)dic;
{
    currentInfoDic = dic;
}

+(NSObject *)ReturnValueForKeyString:(NSString *)key
{
    return [currentInfoDic objectForKey:key];
}

+(char)ReturnCharForKey:(int)key
{
    return [currentButtonAvailability characterAtIndex:key];
}

+(void)ChangeValueForKey:(NSString *)key ToValue:(NSObject *)value
{
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@", @"Changing value for key: ", key]);
    [currentInfoDic removeObjectForKey:key];
    [currentInfoDic setObject:value forKey:key];
}

@end
