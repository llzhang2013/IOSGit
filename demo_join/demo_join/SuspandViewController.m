//
//  SuspandViewController.m
//  demo_join
//
//  Created by zhanglili on 2018/7/3.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "SuspandViewController.h"
#import "suspandView.h"
#import <QAVSDK/QAVCommon.h>

@interface SuspandViewController ()<SuspendCustomViewDelegate>{
  
}


@property (nonatomic, strong) suspandView *customView;
@property (nonatomic, strong) UIView *buttonsBKView;

@end

@implementation SuspandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame=CGRectZero;
    [self performSelector:@selector(createBaseUI) withObject:nil afterDelay:0.1];

}

-(void)addbutton{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];

    [button setTitle:@"收起" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(smallView) forControlEvents:UIControlEventTouchUpInside];
    [_customView addSubview:button];
}


- (void)createBaseUI{
    _customView=[self createCustomView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_customView];
    [self addAction];
    
}
- (suspandView *)createCustomView{
    if(!_customView){
        suspandView *sView = [[suspandView alloc]init];
        [sView initSelf];
        sView.mode = BigFrame;
        sView.suspendDelegate=self;
        sView.backgroundColor = [UIColor grayColor];
        _customView = sView;
    }
   return _customView;
}

-(void)addAction{
    for(UIButton *btn in _customView.buttonBKView.subviews){
        if(btn.tag==100){
            [btn addTarget:self action:@selector(smallView) forControlEvents:UIControlEventTouchUpInside];
            
        }else if(btn.tag==101){
            [btn addTarget:self action:@selector(upToVideo) forControlEvents:UIControlEventTouchUpInside];
        }else if(btn.tag==102){
            [btn addTarget:self action:@selector(changeCamera)
          forControlEvents:UIControlEventTouchUpInside];
            
        }
        else if(btn.tag==103){
            [btn addTarget:self action:@selector(cancelWindow)
          forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
}

#pragma mark -- Action

-(void)changeCamera{
    
    [[ILiveRoomManager getInstance] switchCamera:^{
        
        
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        
    }];
    
}

-(void)smallView{
//       [[[ILiveRoomManager getInstance] getFrameDispatcher] modifyAVRenderView:CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.width) forIdentifier:@"zll1" srcType:QAVVIDEO_SRC_TYPE_CAMERA];
     _customView.mode = SmallFrame;
    [self changeVideoFrame];
}

- (void)cancelWindow{
    
    [[ILiveRoomManager getInstance] quitRoom:^{
        [_customView removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        
    }];
  
    
}

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

-(void)changeVideoFrame{
      [[[ILiveRoomManager getInstance] getFrameDispatcher] modifyAVRenderView:CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height) forIdentifier:@"zll1" srcType:QAVVIDEO_SRC_TYPE_CAMERA];
    
}

#pragma mark --SuspendCustomViewDelegate

- (void)suspendCustomViewClicked:(id)sender{
    NSLog(@"此处判断点击 还可以通过suspenType类型判断");
    
    if(_customView.mode==BigFrame){
        return;
    }
    _customView.mode = BigFrame;
    [self changeVideoFrame];
    
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
                renderView.frame = CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height);
                
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

#pragma mark --  selfLife
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"zll---SuspandViewController-viewWillDisappear");
}

- (void)dealloc
{
    NSLog(@"zll---SuspandViewController-dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

