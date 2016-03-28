//
//  ScanCodeViewController.m
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/8.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import "ScanCodeViewController.h"

@interface ScanCodeViewController ()

@end

@implementation ScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _captureSession = nil;
    [self startScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)startScan
{
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_CameraView.layer.bounds];
    [_CameraView.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString *ScannedValue = [NSString stringWithFormat:@"%@", [metadataObj stringValue]];
            NSLog(@"%@", ScannedValue);
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(sendJSONDataWithString:) withObject:ScannedValue waitUntilDone:NO];
        }
    }
}

-(void)CallGoToNextPage
{
    [self performSegueWithIdentifier:@"GoToOrderOption" sender:self];
    
}

-(void)stopReading
{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)sendJSONDataWithString:(NSString *)str
{
    NSArray *QRInfo = [str componentsSeparatedByString:@";"];
    if (QRInfo.count > 1){
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", BaseHost, OrderCheckAddr];
        urlStr = [[JSONRequest sharedInstance] AppendGETParameterWithString:urlStr withKey:@"orderid" withValue:[QRInfo objectAtIndex:1] isFirstParameter:true];
        [[JSONRequest sharedInstance] GETJSONDataFromSeverWithString:urlStr target:self];
        [OrderInfoAccess AttachButtonAvailabilityInfo:[QRInfo objectAtIndex:0]];
    }
    else{
        [self DisplayDialogBoxWithString:[NSString stringWithFormat:@"%@%@", @"二维码信息有误，可能不是订单二维码：", str]];
        [self performSelectorOnMainThread:@selector(startScan) withObject:nil waitUntilDone:NO];
    }
}

-(void)recieveJSONReturn:(NSData *)data
{
    NSLog(@"Data recieved");
    NSError *localError = nil;
    NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    if (localError != nil) {
        [self DisplayDialogBoxWithString:@"解读返回数据出错"];
        [self performSelectorOnMainThread:@selector(startScan) withObject:nil waitUntilDone:NO];
        return;
    }
    _recievedDictionary = resultData;
    [self performSelectorOnMainThread:@selector(CallGoToNextPage) withObject:nil waitUntilDone:NO];
}

-(void) DisplayDialogBoxWithString:(NSString *)str
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"遇到错误" message:str delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    [myAlertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

-(void)communicationFailedWithError:(NSError *)err
{
    [self DisplayDialogBoxWithString:@"通信错误"];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"GoToOrderOption"]){
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        OrderOptionViewController *controller = (OrderOptionViewController *)navController.topViewController;
        controller.InfoDictionary = _recievedDictionary;
    }
}

@end
