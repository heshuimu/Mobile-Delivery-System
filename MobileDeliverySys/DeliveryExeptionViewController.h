//
//  DeliveryExeptionViewController.h
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/8.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeriCodeViewController.h"
#import "JSONRequest.h"

@interface DeliveryExeptionViewController : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, JSONRequestDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *DamageImageScroll;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *DamageImageUploadIndicator;

@property (strong, nonatomic) IBOutlet UIScrollView *MissingImageScroll;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *MissingImageUploadIndicator;

@property (strong, nonatomic) IBOutlet UIScrollView *PODImageScroll;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *PODImageUploadIndicator;

@property (strong, nonatomic) IBOutlet UIButton *DamageActButton;
@property (strong, nonatomic) IBOutlet UIButton *MissingActButton;
@property (strong, nonatomic) IBOutlet UIButton *PODActButton;

@property (strong, nonatomic) IBOutlet UIButton *UploadAllActButton;

@property (strong, nonatomic) NSMutableArray* DamageImageArray;
@property (strong, nonatomic) NSMutableArray* MissingImageArray;
@property (strong, nonatomic) NSMutableArray* PODImageArray;

@property (strong, nonatomic) NSMutableArray* DamageImageNameArray;
@property (strong, nonatomic) NSMutableArray* MissingImageNameArray;
@property (strong, nonatomic) NSMutableArray* PODImageNameArray;

@property UIImage* tempImage;

@property int chosenImageArrayIndex;

@property NSMutableArray *PhotoNameArray;

@property UIImagePickerController* picker;

@end
