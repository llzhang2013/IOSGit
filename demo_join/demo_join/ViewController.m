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
    
//    MoveRenderView *view = [[MoveRenderView alloc]initWithFrame:CGRectMake(0, 400, 100, 100)];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
    
    SuspandViewController *vc = [[SuspandViewController alloc]init];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
//    WindowMoveView *view1 = [[WindowMoveView alloc]init];
//    [view1 initSelf];
//    [view1 makeKeyAndVisible];
//  //  [self.view addSubview:view1];
////
//    UIWindow *window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
//    window.backgroundColor = [UIColor blueColor];
//    //window.windowLevel = UIWindowLevelAlert+1;
//    [window makeKeyAndVisible];
//    _myWindow = window;
  
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
