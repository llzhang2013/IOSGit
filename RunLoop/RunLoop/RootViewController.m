//
//  RootViewController.m
//  RunLoop
//
//  Created by zhanglili on 2018/7/12.
//  Copyright © 2018年 zhanglili. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "TimerViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor redColor];
    UIButton *button =  [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 50, 50)];
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"RunLoop" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goToTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
 
}

-(void)goToRunloop{
    ViewController *vc = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

-(void)goToTimer{
    for (int i = 0; i < 1000000; i++) {
          @autoreleasepool {
        NSString *str = @"abc";
        str = [str lowercaseString];
        str = [str stringByAppendingString:@"xyz"];
          }
    }
    
    
    TimerViewController *vc = [[TimerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
