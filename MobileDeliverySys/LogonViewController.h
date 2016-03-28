//
//  ViewController.h
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/6.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONRequest.h"
#import "Scripts/ScanCode/ScanCodeViewController.h"

@interface LogonViewController : UIViewController<JSONRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *UsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *LogonButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *LogonActWheel;


@end

