//
//  RegisterViewController.h
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/9.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONRequest.h"

@interface RegisterViewController : UIViewController<JSONRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *UsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *RegisterButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *RegisterActWheel;

@end
