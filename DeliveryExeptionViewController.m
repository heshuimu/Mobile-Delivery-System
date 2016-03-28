//
//  DeliveryExeptionViewController.m
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/8.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import "DeliveryExeptionViewController.h"

@interface DeliveryExeptionViewController ()

@end

@implementation DeliveryExeptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _DamageImageUploadIndicator.hidden = true;
    _MissingImageUploadIndicator.hidden = true;
    _PODImageUploadIndicator.hidden = true;

    _DamageImageArray = [[NSMutableArray alloc] init];
    _MissingImageArray = [[NSMutableArray alloc] init];
    _PODImageArray = [[NSMutableArray alloc] init];
    _DamageImageNameArray = [[NSMutableArray alloc] init];
    _MissingImageNameArray = [[NSMutableArray alloc] init];
    _PODImageNameArray = [[NSMutableArray alloc] init];
    _chosenImageArrayIndex = 0;
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = false;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _PhotoNameArray = [[NSMutableArray alloc] init];
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

- (IBAction)OpenImageSelectorToChooseImage:(id)sender
{
    _chosenImageArrayIndex = [sender tag];
    NSLog(@"%@", [NSString stringWithFormat:@"%d", _chosenImageArrayIndex ]);
    [self presentViewController:_picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Entered");
    [self whichSpinningWheel].hidden = false;
    [[self whichSpinningWheel] startAnimating];
    _tempImage = info[UIImagePickerControllerOriginalImage];
    if ([self whichImageArray] == nil) {
        NSLog(@"No array has been returned. ");
    }
    else{
        [self UploadImage:_tempImage];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) UploadImage:(UIImage *)image
{
    _DamageActButton.enabled = false;
    _MissingActButton.enabled = false;
    _PODActButton.enabled = false;
    _UploadAllActButton.enabled = false;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BaseHost, UploadImageAddr];
    NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
    [[JSONRequest sharedInstance] POSTJSONDataFromServerWithString:urlStr withImageData:imageData target:self];
}

-(NSMutableArray *)whichImageArray
{
    switch (_chosenImageArrayIndex) {
        case 1:
            return _DamageImageArray;
            break;
        case 2:
            return _MissingImageArray;
            break;
        case 3:
            return _PODImageArray;
            break;
        default:
            break;
    }
    return nil;
}

-(NSMutableArray *)whichImageNameArray
{
    switch (_chosenImageArrayIndex) {
        case 1:
            return _DamageImageNameArray;
            break;
        case 2:
            return _MissingImageNameArray;
            break;
        case 3:
            return _PODImageNameArray;
            break;
        default:
            break;
    }
    return nil;
}

-(UIScrollView *)whichScrollView
{
    switch (_chosenImageArrayIndex) {
        case 1:
            return _DamageImageScroll;
            break;
        case 2:
            return _MissingImageScroll;
            break;
        case 3:
            return _PODImageScroll;
            break;
        default:
            break;
    }
    return nil;
}

-(UIActivityIndicatorView *)whichSpinningWheel
{
    switch (_chosenImageArrayIndex) {
        case 1:
            return _DamageImageUploadIndicator;
            break;
        case 2:
            return _MissingImageUploadIndicator;
            break;
        case 3:
            return _PODImageUploadIndicator;
            break;
        default:
            break;
    }
    return nil;
}

- (void) AddImageSubviewToDesignatedScrollView:(UIScrollView *) desScrollView withArray:(NSArray *)oriArray
{
    if (desScrollView == nil || oriArray == nil) {
        NSLog(@"Cannot add the image to designated subview since either of the parameters is nil");
        return;
    }
    int arrayCount = oriArray.count;
    CGRect frame;
    frame.origin.x = 105 * (oriArray.count - 1);
    frame.origin.y = 0;
    frame.size = CGSizeMake(100, 80);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [oriArray objectAtIndex:(arrayCount - 1)];
    [desScrollView addSubview:imageView];
    [self whichScrollView].contentSize = CGSizeMake(105 * ([[self whichImageArray] count]-1) + 100, [self whichScrollView].frame.size.height);
    NSLog(@"Add image finished");
}

- (void)recieveJSONReturn:(NSData *)data
{
    NSLog(@"Data recieved");
    NSError *localError = nil;
    NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    if ([[resultData objectForKey:@"flat"] boolValue] == true) {
        NSLog(@"Succeeded upload attempt: %@", [resultData objectForKey:@"filename"]);
        [self performSelectorOnMainThread:@selector(MainThreadSelector:) withObject:resultData waitUntilDone:false];
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
    [self whichSpinningWheel].hidden = true;
    [[self whichSpinningWheel] stopAnimating];
    _DamageActButton.enabled = true;
    _MissingActButton.enabled = true;
    _PODActButton.enabled = true;
    _UploadAllActButton.enabled = true;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"GoToConfirmationCode"]){
        VeriCodeViewController *controller = (VeriCodeViewController *)segue.destinationViewController;
        _PhotoNameArray = [[_PhotoNameArray arrayByAddingObjectsFromArray:_DamageImageNameArray] mutableCopy];
        _PhotoNameArray = [[_PhotoNameArray arrayByAddingObjectsFromArray:_MissingImageNameArray] mutableCopy];
        _PhotoNameArray = [[_PhotoNameArray arrayByAddingObjectsFromArray:_PODImageNameArray] mutableCopy];
        NSLog(@"%lu", (unsigned long)_PhotoNameArray.count);
        NSLog(@"%lu", (unsigned long)_DamageImageNameArray.count);
        NSLog(@"%lu", (unsigned long)_MissingImageNameArray.count);
        NSLog(@"%lu", (unsigned long)_PODImageNameArray.count);
        controller.PhotoArray = _PhotoNameArray;
    }
}

-(void)MainThreadSelector:(NSDictionary *)resultData
{
    [[self whichImageNameArray] addObject:[resultData objectForKey:@"filename"]];
    [[self whichImageArray] addObject:_tempImage];
    [self AddImageSubviewToDesignatedScrollView:[self whichScrollView] withArray:[self whichImageArray]];
}

@end
