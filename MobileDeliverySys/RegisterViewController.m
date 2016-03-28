//
//  RegisterViewController.m
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/9.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _RegisterActWheel.hidden = true;
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

-(IBAction)RegisterAction:(id)sender
{
    _RegisterActWheel.hidden = false;
    [_RegisterActWheel startAnimating];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BaseHost, RegisterAddr];
    urlStr = [[JSONRequest sharedInstance] AppendGETParameterWithString:urlStr withKey:@"username" withValue:_PasswordTextField.text isFirstParameter:true];
    urlStr = [[JSONRequest sharedInstance] AppendGETParameterWithString:urlStr withKey:@"password" withValue:_UsernameTextField.text isFirstParameter:false];
    [[JSONRequest sharedInstance] GETJSONDataFromSeverWithString:urlStr target:self];
}

-(void)recieveJSONReturn:(NSData *)data
{
    NSLog(@"Data recieved");
    NSError *localError = nil;
    NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    if ([[resultData objectForKey:@"flat"] boolValue] == true) {
        NSLog(@"Succeeded register attempt");
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self performSegueWithIdentifier:@"GoToRegisterSuccessful" sender:self];
        }];
    }
    else if([[resultData objectForKey:@"flat"] boolValue] == false)
    {
        NSLog(@"Failed register attempt");
        [self DisplayDialogBoxWithString:@"注册失败，可能是用户名占用或者用户名和密码不符合规定"];
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
    _RegisterActWheel.hidden = true;
    [_RegisterActWheel stopAnimating];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_UsernameTextField resignFirstResponder];
    [_PasswordTextField resignFirstResponder];
}

@end
