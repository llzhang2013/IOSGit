//
//  LoginViewController.m
//  YNHospitalUser
//
//  Created by zhanglili on 2018/8/21.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "LoginViewController.h"
#import "IMALoginViewController.h"
#import "YNIMModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.frame = [UIScreen mainScreen].bounds;
  self.view.backgroundColor = [UIColor whiteColor];
  UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 50, 50)];
  [but setTitle:@"登录" forState:UIControlStateNormal];
  [but setBackgroundColor:[UIColor redColor]];
  [but addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:but];
  
}

-(void)login{
  [[[IMALoginViewController alloc] init] initIMSdk:@"" userName:@"zhanglilizhengshi"];
  YNIMModel *mod = [YNIMModel initShareMD];
  mod.myBlock = ^(NSInteger index, id param) {
  };
    
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
