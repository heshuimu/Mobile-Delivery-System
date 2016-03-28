//
//  WelcomeViewController.m
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/9.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Login:(id)sender
{
    [self performSegueWithIdentifier:@"GoToLogonView" sender:self];
}

-(IBAction)Register:(id)sender
{
    [self performSegueWithIdentifier:@"GoToRegisterView" sender:self];
}

#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"GoToLogonView"]){
        LogonViewController *controller = [segue destinationViewController];
        controller.currentSession = self.currentSession;
    }
    if([segue.identifier isEqualToString:@"GoToRegisterView"]){
        RegisterViewController *controller = [segue destinationViewController];
        controller.currentSession = self.currentSession;
    }

}
 */


@end
