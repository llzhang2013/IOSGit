//
//  WaitingAccpectVC.h
//  YNHospitalUser
//
//  Created by zhanglili on 2018/8/21.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuspandViewController.h"

@interface WaitingAccpectVC : UIViewController{
   NSTimer *myTimer;
}
@property(nonatomic,copy) NSDictionary *userInfo;
@property (nonatomic,strong) SuspandViewController *susVC;
-(void)overWaiting;

@end
