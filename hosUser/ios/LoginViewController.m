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
  UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 200, 50)];
  [but setTitle:@"登录zhanglilizhenghsi" forState:UIControlStateNormal];
  [but setBackgroundColor:[UIColor redColor]];
  [but addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:but];
  
  UIButton *but1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 200, 50)];
  [but1 setTitle:@"登录zhanglilinew" forState:UIControlStateNormal];
  [but1 setBackgroundColor:[UIColor redColor]];
  [but1 addTarget:self action:@selector(login2) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:but1];
  
}

-(void)login{
  [[[IMALoginViewController alloc] init] initIMSdk:@"" userName:@"zhanglilinewno"];
  YNIMModel *mod = [YNIMModel initShareMD];
  mod.myBlock = ^(NSInteger index, id param) {
  };
    
}
-(void)login2{
  [[[IMALoginViewController alloc] init] initIMSdk:@"" userName:@"zhanglilinew"];
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
