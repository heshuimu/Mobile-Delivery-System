//
//  ConfirmDeliveryViewController.m
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/14.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import "ConfirmDeliveryViewController.h"

@interface ConfirmDeliveryViewController ()

@end

@implementation ConfirmDeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_DeliveryExceptionButton setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateDisabled];
    [_NormalDeliveryButton setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateDisabled];
    _PhotoNameArray = [[NSMutableArray alloc] init];
     _UploadNormalImageIndicator.hidden = true;
    // Do any additional setup after loading the view.
    NSString* OrderIDStr = [NSString stringWithString:(NSString *)[OrderInfoAccess ReturnValueForKeyString:@"orderid"]];
    _OrderIDLabel.text = OrderIDStr;
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = false;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([OrderInfoAccess ReturnCharForKey:6] == 'N') {
        _VerifyButton.enabled = false;
    }
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
- (IBAction)ConfirmNormalDelivery:(id)sender {
    _UploadNormalImageIndicator.hidden = false;
    [_UploadNormalImageIndicator startAnimating];
    [self presentViewController:_picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Entered");
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self UploadImage:chosenImage];
}

- (void) UploadImage:(UIImage *)image
{
    _NormalDeliveryButton.enabled = false;
    _DeliveryExceptionButton.enabled = false;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BaseHost, UploadImageAddr];
    NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
    [[JSONRequest sharedInstance] POSTJSONDataFromServerWithString:urlStr withImageData:imageData target:self];
}

- (void)recieveJSONReturn:(NSData *)data
{
    NSLog(@"Data recieved");
    NSError *localError = nil;
    NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    if ([[resultData objectForKey:@"flat"] boolValue] == true) {
        NSLog(@"Succeeded upload attempt: %@", [resultData objectForKey:@"filename"]);
        [_PhotoNameArray addObject:[resultData objectForKey:@"filename"]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self performSegueWithIdentifier:@"GoToConfirmationCode" sender:self];
        }];
    } else if([[resultData objectForKey:@"flat"] boolValue] == false)
    {
        NSLog(@"Failed upload attempt");
        [self DisplayDialogBoxWithString:@"上传失败"];
    }
    else
    {
        NSLog(@"Unknown return value");
        [self DisplayDialogBoxWithString:@"意外的服务器反馈，可能是服务器故障"];
    }
    [self performSelectorOnMainThread:@selector(HideSpinningWheelRightNow) withObject:nil waitUntilDone:false];
}

-(void) DisplayDialogBoxWithString:(NSString *)str
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"遇到错误" message:str delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    [myAlertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

-(void)communicationFailedWithError:(NSError *)err
{
    [self DisplayDialogBoxWithString:@"通信错误"];
    [self performSelectorOnMainThread:@selector(HideSpinningWheelRightNow) withObject:nil waitUntilDone:false];
}

-(void) HideSpinningWheelRightNow
{
    _UploadNormalImageIndicator.hidden = true;
    [_UploadNormalImageIndicator stopAnimating];
    _NormalDeliveryButton.enabled = true;
    _DeliveryExceptionButton.enabled = true;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"GoToConfirmationCode"]){
        VeriCodeViewController *controller = (VeriCodeViewController *)segue.destinationViewController;
        controller.PhotoArray = _PhotoNameArray;
    }
}

@end
