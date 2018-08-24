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
#import <TILLiveSDK/TILLiveSDK.h>
#import "videoSmallView.h"
#import "InviteLiveViewController.h"
#import "LiveCommonMethod.h"
#import "WaitingAccpectVC.h"
#import "LivingVideoVC.h"
#import "ILiveRenderView+move.h"

@interface SuspandViewController ()<SuspendCustomViewDelegate>{
  ILiveRenderView *bigRenderView;
  NSMutableArray *smallRenders;
  CGRect smallRect;
  CGRect bigRect;
  NSTimer *myTimer;
}
@property (nonatomic, strong) suspandView *customView;
@property (nonatomic, strong) UIView *buttonsBKView;
@property (nonatomic, strong) UIWindow *myWindow;
@property (nonatomic, strong) UIAlertController *alertCtrl;     //!< 提示框
@property (nonatomic,strong)WaitingAccpectVC *waitVC;
@property (nonatomic,strong)LivingVideoVC *videoButtonVC;

@end

static SuspandViewController *SuspandViewControllerSingle = nil;
static dispatch_once_t onceToken;

@implementation SuspandViewController

//TODO 1 实现单利(以实现)  2 自己的是小屏幕 3 测试小屏幕的时候来个视频（其实本身在请求视频的时候是不能缩小）

+ (SuspandViewController *)shareSuspandViewController
{
  dispatch_once(&onceToken, ^{
    if(SuspandViewControllerSingle==nil){
      SuspandViewControllerSingle = [[SuspandViewController alloc]init];
    }
  });
  return SuspandViewControllerSingle;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.frame = CGRectZero;
  //    self.view.frame=[UIScreen mainScreen].bounds;设置也没用 因为view加载在最底层 会被上面的view覆盖
  [self performSelector:@selector(createBaseUI) withObject:nil afterDelay:0.1];
}

- (void)createBaseUI{
  if(SuspandViewControllerSingle==nil){
    return;
  }
  _customView=[self createCustomView];
  smallRect =CGRectMake(_customView.frame.size.width-_customView.smallWidth, 0,  _customView.smallWidth,  _customView.smallHeight);
  bigRect = CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height);
}

- (suspandView *)createCustomView{
  if(!_customView){
    suspandView *sView = [[suspandView alloc]init];
    [sView initWithController:self rootView:self.view.superview];
    sView.suspendDelegate=self;
    _customView = sView;
  }
  return _customView;
}

-(void)toJoinRoom:(NSString *)roomId role:(NSDictionary *)userInfo{
  NSString *roleName = userInfo[@"userId"];
  self.userInfo = userInfo;
  
  ILiveRoomOption *option = [ILiveRoomOption defaultHostLiveOption];
  option.imOption.imSupport = NO;
  option.avOption.autoCamera = YES;
  option.avOption.autoMic = YES;
  option.memberStatusListener = self;
  option.roomDisconnectListener = self;
  // 该参数代表进房之后使用什么规格音视频参数，参数具体值为客户在腾讯云实时音视频控制台画面设定中配置的角色名（例如：默认角色名为user, 可设置controlRole = @"user"）
  option.controlRole = roleName;
  NSLog(@"开始加入房间");
  [[ILiveRoomManager getInstance] joinRoom:[roomId intValue] option:option succ:^{
    NSLog(@"加入房间成功，跳转到房间页");
  } failed:^(NSString *module, int errId, NSString *errMsg) {
    NSLog(@"加入房间失败--%@",errMsg);
    [LiveCommonMethod showTip:[NSString stringWithFormat:@"视频通话失败%@",errMsg]];
    [self destroySelf];
    
  }];
}

- (void)quitLiveRoom{
  
  [[ILiveRoomManager getInstance] quitRoom:^{
    NSLog(@"zlllive---退出房间成功");
    [self destroySelf];
  } failed:^(NSString *module, int errId, NSString *errMsg) {
    NSLog(@"zlllive---退出房间失败-%@",errMsg);
  }];
}

-(void)destroySelf{
  if(self.waitVC){
    [self.waitVC overWaiting];
  }
  [_customView removeFromSuperview];
  _customView.myWindow = nil;
  [self.view removeFromSuperview];
  [self removeFromParentViewController];
  SuspandViewControllerSingle = nil;
  onceToken = 0;
}

#pragma mark --- addView

-(void)showWaitView{
 
  WaitingAccpectVC *vc = [[WaitingAccpectVC alloc]init];
  vc.userInfo = self.userInfo;
   self.waitVC = vc;
  [_customView.myWindow addSubview:vc.view];
}

-(void)showVideoView{
  if(!self.videoButtonVC){
    LivingVideoVC *vc = [[LivingVideoVC alloc]init];
    vc.userInfo = self.userInfo;
    self.videoButtonVC = vc;
  }
 
  [_customView addSubview:self.videoButtonVC.view];
}

#pragma mark --- action
-(void)changeCamera{
  
  [[ILiveRoomManager getInstance] switchCamera:^{
  } failed:^(NSString *module, int errId, NSString *errMsg) {
  }];
}

-(void)smallView{
  _customView.mode = SmallFrame;
  [self changeVideoFrame];
}

-(void)overButtonCliced{//点击结束按钮 谁点击谁发送已结束
  [self quitLiveRoom];
}

#pragma mark -------

-(void)changeVideoFrame{
  [self modifyRenderViewFrame:bigRenderView frame:CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height)];
  //先出线对方 对方结束  点击收起 就没了
  NSLog(@"zll---bigRenderView---%@",bigRenderView);
  if(_customView.mode == SmallFrame){//大的变小的 小的变没有
    self.videoButtonVC.view.hidden = YES;
    [smallRenders enumerateObjectsUsingBlock:^(ILiveRenderView *renderView, NSUInteger idx, BOOL * _Nonnull stop) {
      [self modifyRenderViewFrame:renderView frame:CGRectZero];
    }];
  }else{
    self.videoButtonVC.view.hidden = NO;
    [smallRenders enumerateObjectsUsingBlock:^(ILiveRenderView *renderView, NSUInteger idx, BOOL * _Nonnull stop) {
      [self modifyRenderViewFrame:renderView frame:CGRectMake(_customView.frame.size.width-_customView.smallWidth, 0,  _customView.smallWidth,  _customView.smallHeight)];
    }];
  }
}

-(void)modifyRenderViewFrame:(ILiveRenderView *)view frame:(CGRect)frame{
  [[TILLiveManager getInstance] modifyAVRenderView:frame forIdentifier:view.identifier srcType:QAVVIDEO_SRC_TYPE_CAMERA];
}

#pragma mark --SuspendCustomViewDelegate

-(void)suspendCustomViewClicked:(id)sender point:(CGPoint)point{
  NSLog(@"此处判断点击 还可以通过suspenType类型判断");
  if(_customView.mode==BigFrame){
  if(CGRectContainsPoint(_customView.smallRenderView.frame,point)&&smallRenders.count>0){
    [self changSmallRenderToBig];
    }
  }else{
    _customView.mode = BigFrame;
    [self changeVideoFrame];
  }
}

-(void)changSmallRenderToBig{
  ILiveRenderView *renderView =smallRenders[0];
  [self modifyRenderViewFrame:renderView frame:bigRect];
  [self modifyRenderViewFrame:bigRenderView frame:smallRect];
  _customView.smallRenderView = bigRenderView;
  [smallRenders addObject:bigRenderView];
  bigRenderView = renderView;
  [smallRenders removeObject:renderView];
  [_customView sendSubviewToBack:bigRenderView];
  NSLog(@"引用计数%@,%@",[bigRenderView valueForKey:@"retainCount"],[renderView valueForKey:@"retainCount"]);
  bigRenderView.mode = @0;
  ILiveRenderView *renderView1 =smallRenders[0];
  renderView1.mode = @1;
  
  
}

#pragma mark - ILiveMemStatusListener
-(void)onCameraAdd:(ILiveRenderView *)renderView{
  if(!_customView){
    [self createBaseUI];
  }

  if(!bigRenderView){
    [_customView showCameraView:self.isMaster];
    if(self.isMaster){
      [self showWaitView];
    }
  }else{
    if(self.isMaster){
      [self.waitVC overWaiting];
    }
    [self showVideoView];
  }
  
  if(!smallRenders){
    smallRenders = [[NSMutableArray alloc]init];
  }
  
  
  [self modifyRenderViewFrame:renderView frame:CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height)];
  [_customView addSubview:renderView];
  
  if(!bigRenderView){//第一个来
    bigRenderView = renderView;
    renderView.mode = @0;
    [[ILiveRoomManager getInstance] setBeauty:5.0];
    [[ILiveRoomManager getInstance] setWhite:5.0];
    
  }else{
       renderView.mode = @1;
      [self modifyRenderViewFrame:renderView frame: CGRectMake(_customView.frame.size.width-_customView.smallWidth, 0,  _customView.smallWidth,  _customView.smallHeight)];
      if(!smallRenders){
        smallRenders = [[NSMutableArray alloc]init];
      }
      [smallRenders addObject:renderView];
      _customView.smallRenderView = renderView;
    if([renderView.identifier isEqualToString:self.userInfo[@"userId"]]){
      [self performSelector:@selector(changSmallRenderToBig) withObject:nil afterDelay:1];
  
    }
    

  }
  [_customView sendSubviewToBack:bigRenderView];
  
}



-(void)onCameraRemove:(ILiveRenderView *)renderView{
  //有一方离开就结束
  [self quitLiveRoom];
  return;
  [renderView removeFromSuperview];
  NSLog(@"zlllive----onCameraRemove0-%@,%@",renderView.identifier,bigRenderView.identifier);
  if([renderView.identifier isEqualToString:bigRenderView.identifier]){
    NSLog(@"zlllive----onCameraRemove1");
    if(smallRenders.count>0){
      NSLog(@"zlllive----onCameraRemove2");
      bigRenderView = smallRenders[0];
      [smallRenders removeObjectAtIndex:0];
      _customView.smallRenderView = nil;
      bigRenderView.frame = CGRectMake(0, 0, _customView.frame.size.width, _customView.frame.size.height);
      [_customView sendSubviewToBack:bigRenderView];
    }
  }
}

- (BOOL)onEndpointsUpdateInfo:(QAVUpdateEvent)event updateList:(NSArray *)endpoints {
  NSLog(@"zlllive---onEndpointsUpdateInfo-%ld",event);
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
  [LiveCommonMethod showTip:@"通讯异常"];
  [self quitLiveRoom];
  return YES;
}

#pragma mark --  selfLife

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
}

@end

