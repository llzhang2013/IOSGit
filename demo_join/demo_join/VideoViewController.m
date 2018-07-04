//
//  VideoViewController.m
//  demo_join
//
//  Created by zhanglili on 2018/7/4.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoView.h"
#import "suspandView.h"
#import <QAVSDK/QAVCommon.h>

@interface VideoViewController ()<SuspendCustomViewDelegate>{
    CGFloat viewWidth;
    CGFloat viewHeight;
}


@property (nonatomic, strong) UIWindow *customWindow;
@property (nonatomic, strong) VideoView *customView;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectZero;
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor blueColor];
    
    [self createBaseUI];
    [self createCustomView];
    [self createButtonsView];
}

- (void)createBaseUI{
    viewWidth = WINDOWS.width;
    viewHeight = WINDOWS.height;
    _customView=[self createCustomView];
    _customWindow=[self createCustomWindow];
    [_customWindow addSubview:_customView];
    [_customWindow makeKeyAndVisible];
}

- (VideoView *)createCustomView{
    if(!_customView){
        VideoView *sView = [[VideoView alloc]init];
       
        sView.frame=CGRectMake(0, 0, viewWidth, viewHeight);
        sView.backgroundColor = [UIColor redColor];
      
        
        _customView = sView;
    }
    return _customView;
}
- (UIWindow *)createCustomWindow{
    if (!_customWindow) {
        _customWindow=[[UIWindow alloc]init];
        _customWindow.frame=CGRectMake(0,0, viewWidth, viewHeight);
        _customWindow.windowLevel=UIWindowLevelAlert+1;
        _customWindow.backgroundColor=[UIColor greenColor];
        
    }
    return _customWindow;
}

-(void)createButtonsView{
 
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 50, 50)];
    [button setTitle:@"收起" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(smallView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [button1 setTitle:@"上麦" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(upToVideo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(200, 100, 100, 50)];
    [button2 setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [_customView addSubview:button];
    [_customView addSubview:button1];
    [_customView addSubview:button2];
    
    
}

-(void)changeCamera{
    
    [[ILiveRoomManager getInstance] switchCamera:^{
        
        
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        
    }];
    
}

-(void)smallView{
    CGRect rect = CGRectMake(0, 100, 100, 150);
    [[[ILiveRoomManager getInstance] getFrameDispatcher] modifyAVRenderView:rect forIdentifier:@"zll1" srcType:QAVVIDEO_SRC_TYPE_CAMERA];
   // self.view.frame = CGRectMake(0, 0, 100, 150);
    _customView.frame = rect;
    _customWindow.frame = rect;
    
}

#pragma mark----

- (void)upToVideo{
    // 上麦，打开摄像头和麦克风
    [[ILiveRoomManager getInstance] enableCamera:CameraPosFront enable:YES succ:^{
        NSLog(@"打开摄像头成功");
        [[ILiveRoomManager getInstance] setBeauty:9.0];
        [[ILiveRoomManager getInstance] setWhite:9.0];
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        NSLog(@"打开摄像头失败");
    }];
    
    [[ILiveRoomManager getInstance] enableMic:YES succ:^{
        NSLog(@"打开麦克风成功");
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        NSLog(@"打开麦克风失败");
    }];
  
}

#pragma mark - ILiveMemStatusListener
// 音视频事件回调
- (BOOL)onEndpointsUpdateInfo:(QAVUpdateEvent)event updateList:(NSArray *)endpoints {
    if (endpoints.count <= 0) {
        return NO;
    }
    for (QAVEndpoint *endpoint in endpoints) {
        switch (event) {
            case QAV_EVENT_ID_ENDPOINT_HAS_CAMERA_VIDEO:
            {
                /*
                 创建并添加渲染视图，传入userID和渲染画面类型，这里传入 QAVVIDEO_SRC_TYPE_CAMERA（摄像头画面）,
                 */
                ILiveFrameDispatcher *frameDispatcher = [[ILiveRoomManager getInstance] getFrameDispatcher];
                ILiveRenderView *renderView = [frameDispatcher addRenderAt:CGRectZero forIdentifier:endpoint.identifier srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                renderView.frame = [UIScreen mainScreen].bounds;
                
                [_customView addSubview:renderView];
                [_customView sendSubviewToBack:renderView];
//
             
            }
                break;
            case QAV_EVENT_ID_ENDPOINT_NO_CAMERA_VIDEO:
            {
                // 移除渲染视图
                ILiveFrameDispatcher *frameDispatcher = [[ILiveRoomManager getInstance] getFrameDispatcher];
                ILiveRenderView *renderView = [frameDispatcher removeRenderViewFor:endpoint.identifier srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                renderView.backgroundColor = [UIColor clearColor];
                [renderView removeFromSuperview];
                // 房间内上麦用户数量变化，重新布局渲染视图
                [self onCameraNumChange];
            }
                break;
            default:
                break;
        }
    }
    return YES;
}

-(void)onCameraNumChange{
    
}

#pragma mark - ILiveRoomDisconnectListener
/**
 SDK主动退出房间提示。该回调方法表示SDK内部主动退出了房间。SDK内部会因为30s心跳包超时等原因主动退出房间，APP需要监听此退出房间事件并对该事件进行相应处理
 
 @param reason 退出房间的原因，具体值见返回码
 
 @return YES 执行成功
 */
- (BOOL)onRoomDisconnect:(int)reason {
    NSLog(@"房间异常退出：%d", reason);
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
