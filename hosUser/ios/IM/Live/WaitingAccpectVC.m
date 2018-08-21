//
//  WaitingAccpectVC.m
//  YNHospitalUser
//
//  Created by zhanglili on 2018/8/21.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "WaitingAccpectVC.h"

@interface WaitingAccpectVC ()

@end

@implementation WaitingAccpectVC

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.frame = [UIScreen mainScreen].bounds;
  self.view.backgroundColor = [UIColor clearColor];
  
  UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
  //[button setTitle:@"取消" forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
  [self.view addSubview:button];
  
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

@end
