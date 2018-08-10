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
#import "InviteLiveViewController.h"
#import "Masonry.h"



static NSString * const kUserName1 = @"zll2";
static NSString * const kUserSig1 = @"eJxlj9FOgzAUhu95iqa3Gm1pmWDixWQmMkZk2QjGG0JogQpCKWVuM767ji2RxHP7ff-5z-kyAABwu9rcpFnWDo1O9EFyCO4BRPD6D0opWJLqhCj2D-K9FIonaa65GiG2LMtEaOoIxhstcnExjnVtTmjPqmSsOMfpb9axMZku6EUxwuApcr21extH9cbPcmpbgtPlgJZ88Pz9W7dSURj0iIbFlY-nHXuZe4Xr381s0VbHsqN88f6p7KAMd9INFiSNm-jwmm3X7eNziaLqYVKpxQe--EMQdWxnNr15x1Uv2mYUTIQtbBJ0Gmh8Gz9gglx6" ;

//static NSString * const kUserName1 = @"zll1";
//static NSString * const kUserSig1 = @"eJxlj8FOhDAURfd8RcMWoy1QAiYugBBDwhjNiI5uGoQydixQSnEA47*rOIlNfNtz7r15HwYAwLzPtudFWXZjq4iaBTXBJTChefYHhWAVKRRxZPUP0kkwSUlRKypXiDDGNoS6wyraKlazk7FwjjQ6VG9knfiNu9-ZwEeOXjCw-Qo3SR6nEVfjvGStNT-kB*s6sZ5u*8c*nodUKbpHNz0vGi8pa9s-hCwJMW-oVPrH2buI6ikNl4w*77zxKDZx1-jOdpe68vUuGl66-EqbVKyhp38c6AZ*4AYafadyYF27CjZEGNkO-DnT*DS*ADgbXgI_" ;

@interface ViewController ()<AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userIDTF;
@property (weak, nonatomic) IBOutlet UITextField *userSigTF;
@property (nonatomic, strong) UIAlertController *alertCtrl;
@property (nonatomic, strong) UIWindow *myWindow;
@property (nonatomic, strong) UIView *buttonBKView;//通话过程中
@property (nonatomic,strong) AVAudioPlayer *musicPlayer;

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
   // UIViewController *vc =  self.navigationController.viewControllers[0];
    
//    InviteLiveViewController *invite = [InviteLiveViewController shareInviteLiveViewController];
//    [invite initData:@"3333" role:@"zll1"];
//    [vc addChildViewController:invite];
//    [vc.view addSubview:invite.view];
//    return;
//    self.view.backgroundColor = [UIColor blackColor];
//    [self makeLivingButtonView];
    
    if (!self.musicPlayer) {
        AVAudioSession * session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videoMusic" ofType:@"mp3"];
        NSURL *fileUrl = [NSURL URLWithString:filePath];
        self.musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
        self.musicPlayer.delegate = self;
      
    }
    
    [self playMusic];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self playMusic];
   
}

-(void)playMusic{
    if (![self.musicPlayer isPlaying]){
        [self.musicPlayer setVolume:0.6];
        [self.musicPlayer prepareToPlay];
        [self.musicPlayer play];
    }
}

-(void)smallView{
    
}

-(void)makeLivingButtonView{
  
    
    self.buttonBKView = [[UIView alloc]init];
    self.buttonBKView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.buttonBKView];
    [self.buttonBKView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-50));
        make.height.equalTo(@100);
        
    }];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    //[button setTitle:@"收起" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"small"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(smallView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(120, 0, 100, 50)];
    button2.tag = 102;
    //[button2 setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(smallView)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(230, 0, 50, 50)];
    button3.tag = 103;
    //[button3 setTitle:@"结束" forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(smallView)
      forControlEvents:UIControlEventTouchUpInside];
    [self.buttonBKView addSubview:button];
    [self.buttonBKView addSubview:button2];
    [self.buttonBKView addSubview:button3];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.centerY.equalTo(button2);
        
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_right).offset(40);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.bottom.equalTo(@0);
        
    }];
    
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button2.mas_right).offset(40);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.bottom.equalTo(@0);
        
    }];
    button.backgroundColor = [UIColor greenColor];
    button2.backgroundColor = [UIColor greenColor];
    button3.backgroundColor = [UIColor greenColor];
    
}
    

// 登录按钮点击
- (IBAction)onLogin:(id)sender {
//    [self.musicPlayer stop];
//    return;
 
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
