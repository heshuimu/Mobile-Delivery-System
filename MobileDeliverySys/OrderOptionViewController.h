//
//  OrderOptionViewController.h
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/9.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONRequest.h"
#import "OrderInfoAccess.h"
#import "OrderDetailViewController.h"

@interface OrderOptionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *OrderNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *Button1;
@property (weak, nonatomic) IBOutlet UIButton *Button2;
@property (weak, nonatomic) IBOutlet UIButton *Button3;
@property (weak, nonatomic) IBOutlet UIButton *Button4;
@property (weak, nonatomic) IBOutlet UIButton *Button5;
@property (weak, nonatomic) IBOutlet UIButton *Button6;

@property NSMutableDictionary* InfoDictionary;
@property long StateChangeIndicator;

@end
