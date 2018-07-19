//
//  ViewController.m
//  Demo04_加入直播间并互动
//
//  Created by jameskhdeng(邓凯辉) on 2018/4/3.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "ViewController.h"
#import <ILiveSDK/ILiveLoginManager.h>
#import "CreateRoomViewController.h"
#import "MoveRenderView.h"
#import "SuspandViewController.h"
#import "WindowMoveView.h"


//static NSString * const kUserName1 = @"zll2";
//static NSString * const kUserSig1 = @"eJxlj9FOgzAUhu95iqa3Gm1pmWDixWQmMkZk2QjGG0JogQpCKWVuM767ji2RxHP7ff-5z-kyAABwu9rcpFnWDo1O9EFyCO4BRPD6D0opWJLqhCj2D-K9FIonaa65GiG2LMtEaOoIxhstcnExjnVtTmjPqmSsOMfpb9axMZku6EUxwuApcr21extH9cbPcmpbgtPlgJZ88Pz9W7dSURj0iIbFlY-nHXuZe4Xr381s0VbHsqN88f6p7KAMd9INFiSNm-jwmm3X7eNziaLqYVKpxQe--EMQdWxnNr15x1Uv2mYUTIQtbBJ0Gmh8Gz9gglx6" ;

static NSString * const kUserName1 = @"zll1";
static NSString * const kUserSig1 = @"eJxlj8FOhDAURfd8RcMWoy1QAiYugBBDwhjNiI5uGoQydixQSnEA47*rOIlNfNtz7r15HwYAwLzPtudFWXZjq4iaBTXBJTChefYHhWAVKRRxZPUP0kkwSUlRKypXiDDGNoS6wyraKlazk7FwjjQ6VG9knfiNu9-ZwEeOXjCw-Qo3SR6nEVfjvGStNT-kB*s6sZ5u*8c*nodUKbpHNz0vGi8pa9s-hCwJMW-oVPrH2buI6ikNl4w*77zxKDZx1-jOdpe68vUuGl66-EqbVKyhp38c6AZ*4AYafadyYF27CjZEGNkO-DnT*DS*ADgbXgI_" ;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userIDTF;
@property (weak, nonatomic) IBOutlet UITextField *userSigTF;
@property (nonatomic, strong) UIAlertController *alertCtrl;
@property (nonatomic, strong) UIWindow *myWindow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置userId和userSig
    self.userIDTF.text = kUserName1;
    self.userSigTF.text = kUserSig1;
    
    //获取版本号
    NSLog(@"ILiveSDK version:%@",[[ILiveSDK getInstance] getVersion]);
    NSLog(@"AVSDK version:%@",[QAVContext getVersion]);
    NSLog(@"IMSDK version:%@",[[TIMManager sharedInstance] GetVersion]);
    
//    2018-07-13 13:47:00.974769+0800 demo_join[78164:4329375] ILiveSDK version:1.8.4.13473
//    2018-07-13 13:47:00.974967+0800 demo_join[78164:4329375] AVSDK version:1.9.8.8.release- 36687
//    2018-07-13 13:47:00.975237+0800 demo_join[78164:4329375] IMSDK version:v2.5.6.11389.11327
 //   SuspandViewController *vc1 = [[SuspandViewController alloc]init];
    
//    UIViewController *vc =  self.navigationController.viewControllers[0];
//    [vc addChildViewController:vc1];
//    [vc.view addSubview:vc1.view];
    
//    NSArray *arr1 = [[NSArray alloc]initWithObjects:@"1", nil];
//    NSArray *arr2 = [[NSArray alloc]initWithObjects:@"12", nil];
//    NSArray *arr3 = arr1;
//    arr1 = arr2;
//    NSLog(@"%@,%@",arr1,arr3);
    
    
    
}

// 登录按钮点击
- (IBAction)onLogin:(id)sender {
 
//    SuspandViewController *vc = [[SuspandViewController alloc]init];
//    [self addChildViewController:vc];
//    [self.view addSubview:vc.view];
   
   // [self.navigationController pushViewController:vc animated:YES];
  //  return;
    
    //登录sdk
    [[ILiveLoginManager getInstance] iLiveLogin:self.userIDTF.text sig:self.userSigTF.text succ:^{
        //        weakSelf.alertCtrl.title = @"登录成功";
        //        [weakSelf presentViewController:weakSelf.alertCtrl animated:YES completion:nil];
        
        // 登录成功，跳转到创建房间页
        CreateRoomViewController *createRoomVC = [[CreateRoomViewController alloc] init];
        createRoomVC.suprerVC = self;
        [self.navigationController pushViewController:createRoomVC animated:YES];
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        // 登录失败
        self.alertCtrl.title = @"登录失败";
        self.alertCtrl.message = [NSString stringWithFormat:@"errId:%d errMsg:%@",errId, errMsg];
        [self presentViewController:self.alertCtrl animated:YES completion:nil];
    }];
}

#pragma mark - Accessor
- (UIAlertController *)alertCtrl {
    if (!_alertCtrl) {
        _alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        [_alertCtrl addAction:action];
    }
    return _alertCtrl;
}


@end
