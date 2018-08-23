//
//  LivingVideoVC.m
//  YNHospitalUser
//
//  Created by zhanglili on 2018/8/23.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "LivingVideoVC.h"


@interface LivingVideoVC ()

@end

@implementation LivingVideoVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.frame = [UIScreen mainScreen].bounds;
  self.view.backgroundColor = [UIColor clearColor];
  self.susVC = [SuspandViewController shareSuspandViewController];
  [self makeLivingButtonView];
}

-(void)changeToSmallView{
  [self.susVC smallView];
  
}

-(void)changeCamera{
  [self.susVC changeCamera];
}

-(void)overButtonCliced{
  [self.susVC overButtonCliced];
}

-(void)makeLivingButtonView{
  
  
  self.buttonBKView = [[UIView alloc]init];
  [self.view addSubview:self.buttonBKView];
  [self.buttonBKView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(@0);
    make.bottom.equalTo(@(-50));
    make.height.equalTo(@100);
    
  }];
  
  UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
  //[button setTitle:@"收起" forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"small"] forState:UIControlStateNormal];
  [button addTarget:self action:@selector(changeToSmallView) forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(120, 0, 100, 50)];
  button2.tag = 102;
  //[button2 setTitle:@"切换摄像头" forState:UIControlStateNormal];
  [button2 setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
  [button2 addTarget:self action:@selector(changeCamera)
    forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(230, 0, 65, 65)];
  button3.tag = 103;
  //[button3 setTitle:@"结束" forState:UIControlStateNormal];
  [button3 setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
  [button3 addTarget:self action:@selector(overButtonCliced)
    forControlEvents:UIControlEventTouchUpInside];
  [self.buttonBKView addSubview:button];
  [self.buttonBKView addSubview:button2];
  [self.buttonBKView addSubview:button3];
  
  int size = 55;
  [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
    //make.left.equalTo(button.mas_right).offset(60);
    make.centerX.equalTo(self.buttonBKView);
    make.size.mas_equalTo(CGSizeMake(size, size));
    make.bottom.equalTo(@0);
    
  }];
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(button2.mas_left).offset(-50);
    make.size.mas_equalTo(CGSizeMake(size, size));
    make.centerY.equalTo(button2);
    
  }];
  
  [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(button2.mas_right).offset(50);
    make.size.mas_equalTo(CGSizeMake(size, size));
    make.bottom.equalTo(@0);
    
  }];
  
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



@end

