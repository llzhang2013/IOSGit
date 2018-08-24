//
//  LivingVideoVC.h
//  YNHospitalUser
//
//  Created by zhanglili on 2018/8/23.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuspandViewController.h"

@interface LivingVideoVC : UIViewController
@property (nonatomic, strong) UIView *buttonBKView;//通话过程中
@property (nonatomic,strong) SuspandViewController *susVC;
@property(nonatomic,copy) NSDictionary *userInfo;

@end
