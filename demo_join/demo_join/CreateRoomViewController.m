//
//  CreateRoomViewController.m
//  Demo03_创建直播间
//
//  Created by jameskhdeng(邓凯辉) on 2018/3/30.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "CreateRoomViewController.h"
#import <ILiveSDK/ILiveCoreHeader.h>
#import "LiveRoomViewController.h"
#import "SuspandViewController.h"
#import "InviteLiveViewController.h"

@interface CreateRoomViewController ()

@property (weak, nonatomic) IBOutlet UITextField *roomIDTF;
@property (nonatomic, strong) UIAlertController *alertCtrl;     //!< 提示框

@end

@implementation CreateRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建直播间";
    
    // 房间号默认值，用户也可手动输入
    self.roomIDTF.text = @"88881";
    
    // 检测音视频权限
    [self detectAuthorizationStatus];
}

// 创建房间
- (IBAction)onCreateRoom:(id)sender {
    // 1. 创建live房间页面
    LiveRoomViewController *liveRoomVC = [[LiveRoomViewController alloc] init];
    
    // 2. 创建房间配置对象
    ILiveRoomOption *option = [ILiveRoomOption defaultHostLiveOption];
    option.imOption.imSupport = NO;
    // 设置房间内音视频监听
    option.memberStatusListener = liveRoomVC;
    // 设置房间中断事件监听
    option.roomDisconnectListener = liveRoomVC;
    
    // 3. 调用创建房间接口，传入房间ID和房间配置对象
    [[ILiveRoomManager getInstance] createRoom:[self.roomIDTF.text intValue] option:option succ:^{
        // 创建房间成功，跳转到房间页
        //[self.navigationController pushViewController:liveRoomVC animated:YES];
        [self presentViewController:liveRoomVC animated:YES completion:^{
            
        }];
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        // 创建房间失败
        self.alertCtrl.title = @"创建房间失败";
        self.alertCtrl.message = [NSString stringWithFormat:@"errId:%d errMsg:%@",errId, errMsg];
        [self presentViewController:self.alertCtrl animated:YES completion:nil];
    }];
}

- (IBAction)onJoinRoom:(id)sender {
     UIViewController *vc =  self.navigationController.viewControllers[0];
    
    InviteLiveViewController *invite = [InviteLiveViewController shareInviteLiveViewController];
    [invite initData:self.roomIDTF.text role:@"zll1"];
    [vc addChildViewController:invite];
    [vc.view addSubview:invite.view];
    return;

    SuspandViewController *liveRoomVC = [SuspandViewController shareSuspandViewController];
    if(liveRoomVC.roomId){
        NSLog(@"zlllive---正在视频中 不能再开启了");
        return;
    }
   
    [vc addChildViewController:liveRoomVC];
    [vc.view addSubview:liveRoomVC.view];
    [liveRoomVC toJoinRoom:self.roomIDTF.text role:@"zll1"];
}

#pragma mark - Custom Method
// 检测音视频权限
- (void)detectAuthorizationStatus {
    // 检测是否有摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusRestricted || statusVideo == AVAuthorizationStatusDenied) {
        self.alertCtrl.message = @"获取摄像头权限失败，请前往隐私-麦克风设置里面打开应用权限";
        [self presentViewController:self.alertCtrl animated:YES completion:nil];
        return;
    } else if (statusVideo == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
        }];
    }
    
    // 检测是否有麦克风权限
    AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (statusAudio == AVAuthorizationStatusRestricted || statusAudio == AVAuthorizationStatusDenied) {
        self.alertCtrl.message = @"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限";
        [self presentViewController:self.alertCtrl animated:YES completion:nil];
        return;
    } else if (statusAudio == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            
        }];
    }
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
