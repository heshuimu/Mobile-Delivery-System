//
//  ViewController.m
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/6.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import "LogonViewController.h"

@implementation LogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _LogonActWheel.hidden = true;
}

-(IBAction)LoginAction:(id)sender
{
    _LogonActWheel.hidden = false;
    [_LogonActWheel startAnimating];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BaseHost, LogonAddr];
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
        NSLog(@"Succeeded login attempt");
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self performSegueWithIdentifier:@"GoToMainView" sender:self];
        }];
    }
    else if([[resultData objectForKey:@"flat"] boolValue] == false)
    {
        NSLog(@"Failed login attempt");
        [self DisplayDialogBoxWithString:@"登录失败，可能是用户名或密码错误"];
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
    _LogonActWheel.hidden = true;
    [_LogonActWheel stopAnimating];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_UsernameTextField resignFirstResponder];
    [_PasswordTextField resignFirstResponder];
}

/*
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"GoToMainView"]){
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        ScanCodeViewController *controller = (ScanCodeViewController *)navController.topViewController;
        controller.currentSession = self.currentSession;
    }
}
 */

@end
