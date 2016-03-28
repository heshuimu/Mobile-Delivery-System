//
//  OrderInfoAccess.h
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/10.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderInfoObj.h"

@interface OrderInfoAccess : NSObject

+(void)AttachOrderInfo:(OrderInfoObj *)updateInfo;
+(OrderInfoObj *)GetOrderInfoWithInfo:(OrderInfoObj *) updateInfo;
+(void)AttachOrderInfoDictionaryWithDic:(NSMutableDictionary *)dic;
+(NSObject *)ReturnValueForKeyString:(NSString *)key;
+(void)ChangeValueForKey:(NSString *)key ToValue:(NSObject *)value;
+(void)AttachButtonAvailabilityInfo:(NSString *)updateInfo;
+(char)ReturnCharForKey:(int)key;

@end
