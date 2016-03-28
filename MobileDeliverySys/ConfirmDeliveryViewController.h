//
//  ConfirmDeliveryViewController.h
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/14.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoAccess.h"
#import "VeriCodeViewController.h"
#import "JSONRequest.h"

@interface ConfirmDeliveryViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, JSONRequestDelegate>

@property (weak, nonatomic) IBOutlet UILabel *OrderIDLabel;
@property (weak, nonatomic) IBOutlet UIButton *NormalDeliveryButton;
@property (weak, nonatomic) IBOutlet UIButton *DeliveryExceptionButton;

@property UIImagePickerController* picker;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *UploadNormalImageIndicator;
@property (weak, nonatomic) IBOutlet UIButton *VerifyButton;

@property NSMutableArray *PhotoNameArray;

@end
