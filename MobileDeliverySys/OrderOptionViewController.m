//
//  OrderOptionViewController.m
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/9.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import "OrderOptionViewController.h"

@interface OrderOptionViewController ()

@end

@implementation OrderOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Here!");
    [OrderInfoAccess AttachOrderInfoDictionaryWithDic:_InfoDictionary];
    NSString* OrderIDStr = [NSString stringWithString:(NSString *)[OrderInfoAccess ReturnValueForKeyString:@"orderid"]];
    _OrderNumberLabel.text = OrderIDStr;
    if ([OrderInfoAccess ReturnCharForKey:0] == 'N') {
        _Button1.enabled = false;
    }
    if ([OrderInfoAccess ReturnCharForKey:1] == 'N') {
        _Button2.enabled = false;
    }
    if ([OrderInfoAccess ReturnCharForKey:2] == 'N') {
        _Button3.enabled = false;
    }
    if ([OrderInfoAccess ReturnCharForKey:3] == 'N') {
        _Button4.enabled = false;
    }
    if ([OrderInfoAccess ReturnCharForKey:4] == 'N') {
        _Button5.enabled = false;
    }
    if ([OrderInfoAccess ReturnCharForKey:5] == 'N') {
        _Button6.enabled = false;
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

-(IBAction)GoToChangeStatusPage:(id)sender
{
    _StateChangeIndicator = [sender tag];
    [self performSegueWithIdentifier:@"GoToConfirmOrderOperation" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"GoToConfirmOrderOperation"]){
        OrderDetailViewController *controller = (OrderDetailViewController *)segue.destinationViewController;
        controller.StateChangeIndicator = _StateChangeIndicator;
    }
}

@end
