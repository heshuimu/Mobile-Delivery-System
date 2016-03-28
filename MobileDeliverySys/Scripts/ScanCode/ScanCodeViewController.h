//
//  ScanCodeViewController.h
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/8.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JSONRequest.h"
#import "OrderOptionViewController.h"
#import "OrderInfoAccess.h"

@interface ScanCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, JSONRequestDelegate>
@property (strong, nonatomic) IBOutlet UIView *CameraView;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property NSMutableDictionary* recievedDictionary;

@end
