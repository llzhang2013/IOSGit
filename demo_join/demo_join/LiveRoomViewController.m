//
//  LiveRoomViewController.m
//  Demo03_创建直播间
//
//  Created by jameskhdeng(邓凯辉) on 2018/3/30.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "LiveRoomViewController.h"
#import "MoveRenderView.h"
#import <QAVSDK/QAVCommon.h>


@interface LiveRoomViewController (){
    int renderViewState;//0 小 1 大
    ILiveRenderView *currentRenderView;
}

@property (weak, nonatomic) IBOutlet UIButton *upVideoButton;
@end

@implementation LiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  

    self.title = @"直播间";
    self.view.backgroundColor = [UIColor redColor];
  
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [button1 setTitle:@"放大" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(BigView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
   
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(200, 100, 100, 50)];
    [button2 setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
}

-(void)closeVoice{
   // [ILiveRoomManager getInstance] cl
}

-(void)changeCamera{
    
    [[ILiveRoomManager getInstance] switchCamera:^{
        
        
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        
    }];
    
}

-(void)smallView{
    [[[ILiveRoomManager getInstance] getFrameDispatcher] modifyAVRenderView:CGRectMake(0, 100, 100, 150) forIdentifier:@"zll1" srcType:QAVVIDEO_SRC_TYPE_CAMERA];
    self.view.frame = CGRectMake(0, 0, 100, 150);
    
}
-(void)BigView{
[[[ILiveRoomManager getInstance] getFrameDispatcher] modifyAVRenderView:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) forIdentifier:@"zll1" srcType:QAVVIDEO_SRC_TYPE_CAMERA];
}




// 房间销毁时记得调用退出房间接口
- (void)dealloc {
    [[ILiveRoomManager getInstance] quitRoom:^{
        NSLog(@"退出房间成功");
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        NSLog(@"退出房间失败 %d : %@", errId, errMsg);
    }];
}

// 上/下麦
- (IBAction)upToVideo:(id)sender {
    if ([[self.upVideoButton titleForState:UIControlStateNormal] isEqualToString:@"上麦"]) {
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
        
        [self.upVideoButton setTitle:@"下麦" forState:UIControlStateNormal];
    } else {
        // 下麦，关闭摄像头和麦克风
        [[ILiveRoomManager getInstance] enableCamera:CameraPosFront enable:NO succ:^{
            NSLog(@"打开摄像头成功");
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            NSLog(@"打开摄像头失败");
        }];
        
        [[ILiveRoomManager getInstance] enableMic:NO succ:^{
            NSLog(@"打开麦克风成功");
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            NSLog(@"打开麦克风失败");
        }];
        
        [self.upVideoButton setTitle:@"上麦" forState:UIControlStateNormal];
    }
}

#pragma mark - Custom Action

// 房间内上麦用户数量变化时调用，重新布局所有渲染视图，这里简单处理，从上到下等分布局
- (void)onCameraNumChange {
    // 获取当前所有渲染视图
    NSArray *allRenderViews = [[[ILiveRoomManager getInstance] getFrameDispatcher] getAllRenderViews];
    
    // 检测异常情况
    if (allRenderViews.count == 0) {
        return;
    }
    
    // 计算并设置每一个渲染视图的frame
    CGFloat renderViewHeight = [UIScreen mainScreen].bounds.size.height / allRenderViews.count;
    CGFloat renderViewWidth = [UIScreen mainScreen].bounds.size.width;
    __block CGFloat renderViewY = 0.f;
    CGFloat renderViewX = 0.f;
    
    [allRenderViews enumerateObjectsUsingBlock:^(ILiveRenderView *renderView, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"renderView-Frame=%@",NSStringFromCGRect(renderView.frame));
        if(idx==0){
            
            CGRect frame = CGRectMake(0, 0, renderViewWidth, [UIScreen mainScreen].bounds.size.height);
            renderView.frame = frame;
        }else{
            renderViewY = renderViewY + renderViewHeight * idx;
            CGRect frame = CGRectMake(0, 0, 200, 200);
            renderView.frame = frame;
        }
        
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
                currentRenderView = renderView;
              //  renderView.sameDirectionRenderMode = ILIVERENDERMODE_SCALETOFILL;
//                UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//
//                [window addSubview:renderView];
                
//                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 50, 50)];
//                [button setTitle:@"收起" forState:UIControlStateNormal];
//                [button addTarget:self action:@selector(smallView) forControlEvents:UIControlEventTouchUpInside];
//                [window addSubview:button];

                [self.view addSubview:renderView];
                [self.view sendSubviewToBack:renderView];
                // 房间内上麦用户数量变化，重新布局渲染视图
                [self onCameraNumChange];
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

@end

