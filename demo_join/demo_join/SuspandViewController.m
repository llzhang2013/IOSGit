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
    ILiveRenderView *bigRenderView;
    NSMutableArray *smallRenders;
    CGRect smallRect;
    CGRect bigRect;
    
    ILiveRenderView *selfRender;
    NSMutableArray *otherRenders;
    
    
}
@property (nonatomic, strong) suspandView *customView;
@property (nonatomic, strong) UIView *buttonsBKView;

@end

@implementation SuspandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame=CGRectZero;
    [[ILiveRoomManager getInstance] setBeauty:5.0];
    [[ILiveRoomManager getInstance] setWhite:5.0];
    [self performSelector:@selector(createBaseUI) withObject:nil afterDelay:0.1];

}
#pragma mark -- Action

-(void)changeCamera{
    
    [[ILiveRoomManager getInstance] switchCamera:^{
        
        
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        
    }];
}

-(void)smallView{
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

-(void)changeVideoFrame{
     bigRenderView.frame =CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height);
    if(_customView.mode == SmallFrame){//大的变小的 小的变没有
        [smallRenders enumerateObjectsUsingBlock:^(ILiveRenderView *renderView, NSUInteger idx, BOOL * _Nonnull stop) {
            renderView.frame = CGRectMake(0, 0,  0,  0);
        }];
    }else{
      
        [smallRenders enumerateObjectsUsingBlock:^(ILiveRenderView *renderView, NSUInteger idx, BOOL * _Nonnull stop) {
            renderView.frame = CGRectMake(_customView.frame.size.width-_customView.smallWidth, 0,  _customView.smallWidth,  _customView.smallHeight);
        }];
    }
}

#pragma mark --SuspendCustomViewDelegate

- (void)suspendCustomViewClicked:(id)sender point:(CGPoint)point{
    NSLog(@"此处判断点击 还可以通过suspenType类型判断");
    if(_customView.mode==BigFrame){
        if(CGRectContainsPoint(smallRect,point)&&smallRenders.count>0){
          //  ILiveFrameDispatcher *frameDispatcher = [[ILiveRoomManager getInstance] getFrameDispatcher];
            ILiveRenderView *renderView =smallRenders[0];
//            [frameDispatcher switchRenderViewOf:renderView.identifier srcType:QAVVIDEO_SRC_TYPE_CAMERA withRender:bigRenderView.identifier anotherSrcType:QAVVIDEO_SRC_TYPE_CAMERA];
            renderView.frame = bigRect;
            bigRenderView.frame = smallRect;
            [smallRenders addObject:bigRenderView];
             bigRenderView = renderView;
            [smallRenders removeObject:renderView];

            [_customView sendSubviewToBack:bigRenderView];
           
            
        }
     
    }else{
        _customView.mode = BigFrame;
        [self changeVideoFrame];
    }
//    if([sender isKindOfClass:ILiveRenderView.class]){
//        ILiveRenderView *renderView = (ILiveRenderView *)sender;
//        if([renderView.identifier isEqualToString:bigRenderView.identifier]){
//            if(_customView.mode==BigFrame){
//                return;
//            }else{
//                _customView.mode = BigFrame;
//                [self changeVideoFrame];
//            }
//
//        }else{//点击的小窗口
//             ILiveFrameDispatcher *frameDispatcher = [[ILiveRoomManager getInstance] getFrameDispatcher];
//            [frameDispatcher switchRenderViewOf:renderView.identifier srcType:QAVVIDEO_SRC_TYPE_CAMERA withRender:bigRenderView.identifier anotherSrcType:QAVVIDEO_SRC_TYPE_CAMERA];
//
//        }
//    }
   
}

#pragma mark - ILiveMemStatusListener
-(void)onCameraAdd:(ILiveRenderView *)renderView{
    if(!_customView){
        [self createBaseUI];
    }
    
    renderView.frame = CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height);
    [_customView addSubview:renderView];

    if(!bigRenderView){//第一个来
        bigRenderView = renderView;

    }else{//第二个 将原来的变小 这个已经是大的了
        renderView.frame = CGRectMake(_customView.frame.size.width-_customView.smallWidth, 0,  _customView.smallWidth,  _customView.smallHeight);
        if(!smallRenders){
            smallRenders = [[NSMutableArray alloc]init];
        }
        [smallRenders addObject:renderView];
    }
    [_customView sendSubviewToBack:bigRenderView];
}

-(void)onCameraRemove:(ILiveRenderView *)renderView{
    [renderView removeFromSuperview];
    if([renderView.identifier isEqualToString:bigRenderView.identifier]){
        if(smallRenders.count>0){
            bigRenderView = smallRenders[0];
            bigRenderView.frame = CGRectMake(0, 0, _customView.frame.size.width, _customView.frame.size.height);
            [_customView sendSubviewToBack:bigRenderView];
        }
    }
}


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
                renderView.identifier =endpoint.identifier;
                NSLog(@"zll----renderView.identifier=%@",renderView.identifier);
                [self onCameraAdd:renderView];
             
            }
                break;
            case QAV_EVENT_ID_ENDPOINT_NO_CAMERA_VIDEO:
            {
                // 移除渲染视图
                ILiveFrameDispatcher *frameDispatcher = [[ILiveRoomManager getInstance] getFrameDispatcher];
                ILiveRenderView *renderView = [frameDispatcher removeRenderViewFor:endpoint.identifier srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                renderView.identifier =endpoint.identifier;
                [self onCameraRemove:renderView];
  
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

#pragma mark --  selfLife

- (void)createBaseUI{
    if(_customView){
        return;
    }
    _customView=[self createCustomView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_customView];
    smallRect =CGRectMake(_customView.frame.size.width-_customView.smallWidth, 0,  _customView.smallWidth,  _customView.smallHeight);
    bigRect = CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height);
    [self addAction];
    
}
- (suspandView *)createCustomView{
    if(!_customView){
        suspandView *sView = [[suspandView alloc]init];
        [sView initSelf];
        sView.mode = BigFrame;
        sView.suspendDelegate=self;
      //  sView.backgroundColor = [UIColor grayColor];
        _customView = sView;
    }
    return _customView;
}

-(void)addAction{
    for(UIButton *btn in _customView.buttonBKView.subviews){
        if(btn.tag==100){
            [btn addTarget:self action:@selector(smallView) forControlEvents:UIControlEventTouchUpInside];
            
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

