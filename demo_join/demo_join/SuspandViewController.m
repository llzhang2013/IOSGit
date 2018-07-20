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
@property (nonatomic, strong) UIWindow *myWindow;
@property (nonatomic, strong) UIAlertController *alertCtrl;     //!< 提示框

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
//    self.view.backgroundColor = [UIColor redColor];
   [self performSelector:@selector(createBaseUI) withObject:nil afterDelay:0.1];
}

-(void)toJoinRoom:(NSString *)roomId role:(NSString *)roleName{
    self.roleName = roleName;
    self.roomId = roomId;
    
    ILiveRoomOption *option = [ILiveRoomOption defaultHostLiveOption];
    option.imOption.imSupport = NO;
    //    // 不自动打开摄像头
    //    option.avOption.autoCamera = NO;
    //    // 不自动打开mic
    //    option.avOption.autoMic = NO;
    // 设置房间内音视频监听
    option.memberStatusListener = self;
    // 设置房间中断事件监听
    option.roomDisconnectListener = self;
    //
    // 该参数代表进房之后使用什么规格音视频参数，参数具体值为客户在腾讯云实时音视频控制台画面设定中配置的角色名（例如：默认角色名为user, 可设置controlRole = @"user"）
    option.controlRole = roleName;
    
    [[ILiveRoomManager getInstance] joinRoom:[roomId intValue] option:option succ:^{
        NSLog(@"加入房间成功，跳转到房间页");
        [self didJoinRoom];
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        // 加入房间失败
        NSLog(@"加入房间失败");
        self.alertCtrl.title = @"加入房间失败";
        self.alertCtrl.message = [NSString stringWithFormat:@"errId:%d errMsg:%@",errId, errMsg];
        [self presentViewController:self.alertCtrl animated:YES completion:nil];
        [self close];
        
    }];
}

-(void)didJoinRoom{
    [_customView showCamera];
    
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

-(void)close{
    [_customView removeFromSuperview];
    _customView.myWindow = nil;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    SuspandViewControllerSingle = nil;
    onceToken = 0;
}

- (void)cancelWindow{
    
    [[ILiveRoomManager getInstance] quitRoom:^{
        NSLog(@"zlllive---退出房间成功");
        [self close];
       
       
    } failed:^(NSString *module, int errId, NSString *errMsg) {
         NSLog(@"zlllive---退出房间失败-%@",errMsg);
    }];
}

-(void)dealloc{
    
}

-(void)changeVideoFrame{
    bigRenderView.frame =CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height);
    //先出线对方 对方结束  点击收起 就没了
    NSLog(@"zll---bigRenderView---%@",bigRenderView);
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
        if(CGRectContainsPoint(_customView.smallRenderView.frame,point)&&smallRenders.count>0){
            ILiveRenderView *renderView =smallRenders[0];
            renderView.frame = bigRect;
            bigRenderView.frame = smallRect;
            _customView.smallRenderView = bigRenderView;
            [smallRenders addObject:bigRenderView];
            bigRenderView = renderView;
            [smallRenders removeObject:renderView];
            [_customView sendSubviewToBack:bigRenderView];
            NSLog(@"引用计数%@,%@",[bigRenderView valueForKey:@"retainCount"],[renderView valueForKey:@"retainCount"]);
        }
    }else{
        _customView.mode = BigFrame;
        [self changeVideoFrame];
    }
}

#pragma mark - ILiveMemStatusListener
-(void)onCameraAdd:(ILiveRenderView *)renderView{
    if(!_customView){
        [self createBaseUI];
    }
    if(!smallRenders){
        smallRenders = [[NSMutableArray alloc]init];
    }
    
    renderView.frame = CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height);
    [_customView addSubview:renderView];
    
    if(!bigRenderView){//第一个来
        bigRenderView = renderView;
        [[ILiveRoomManager getInstance] setBeauty:5.0];
        [[ILiveRoomManager getInstance] setWhite:5.0];
        
    }else{//第二个 将原来的变小 这个已经是大的了
        renderView.frame = CGRectMake(_customView.frame.size.width-_customView.smallWidth, 0,  _customView.smallWidth,  _customView.smallHeight);
        if(!smallRenders){
            smallRenders = [[NSMutableArray alloc]init];
        }
        [smallRenders addObject:renderView];
        _customView.smallRenderView = renderView;
    }
    [_customView sendSubviewToBack:bigRenderView];
    /*永远使对方为大图  但是在切换过程中会有一闪黑屏出现
     [_customView addSubview:renderView];
     NSString *selfName =  [[TIMManager sharedInstance] getLoginUser];
    if(renderView.identifier==selfName){
        [[ILiveRoomManager getInstance] setBeauty:5.0];
        [[ILiveRoomManager getInstance] setWhite:5.0];
    }
    
    if(!bigRenderView){//第一个来是全屏的
        renderView.frame = CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height);
       // [_customView addSubview:renderView];
        bigRenderView = renderView;
       
        
    }else{//第二个来后 是自己是就是小的  是别人就是大的
       
        if(renderView.identifier==selfName){//自己 作为小的添加即可
            renderView.frame = CGRectMake(_customView.frame.size.width-_customView.smallWidth, 0,  _customView.smallWidth,  _customView.smallHeight);
          
            [smallRenders addObject:renderView];
            _customView.smallRenderView = renderView;
          //  [_customView addSubview:renderView];
            
        }else{//别人 得变大的 把大的变小的
            renderView.frame = CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height);
           // [_customView addSubview:renderView];
          //  bigRenderView.frame = CGRectMake(_customView.frame.size.width-_customView.smallWidth, 0,  _customView.smallWidth,  _customView.smallHeight);
            [[TILLiveManager getInstance] modifyAVRenderView:CGRectMake(_customView.frame.size.width-_customView.smallWidth, 0,  _customView.smallWidth,  _customView.smallHeight) forIdentifier:bigRenderView.identifier srcType:QAVVIDEO_SRC_TYPE_CAMERA];
            _customView.smallRenderView = bigRenderView;
            [smallRenders addObject:bigRenderView];
            bigRenderView = renderView;
    
        }//TODO  没实现
        
    }
    */
  
}

-(void)onCameraRemove:(ILiveRenderView *)renderView{
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
    
    self.alertCtrl.title = @"视频异常关闭";
    self.alertCtrl.message = [NSString stringWithFormat:@"errId:%d",reason ];
    [self presentViewController:self.alertCtrl animated:YES completion:nil];
    [self cancelWindow];
    return YES;
}
- (UIAlertController *)alertCtrl {
    if (!_alertCtrl) {
        _alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        [_alertCtrl addAction:action];
    }
    return _alertCtrl;
}
#pragma mark --  selfLife

- (void)createBaseUI{
    if(_customView){
        return;
    }
    _customView=[self createCustomView];
 
    smallRect =CGRectMake(_customView.frame.size.width-_customView.smallWidth, 0,  _customView.smallWidth,  _customView.smallHeight);
    bigRect = CGRectMake(0, 0,  _customView.frame.size.width,  _customView.frame.size.height);
    [self addAction];
    
}
- (suspandView *)createCustomView{
    if(!_customView){
        suspandView *sView = [[suspandView alloc]init];
        [sView initSelf];
        sView.rootView = self.view.superview;
       // sView.mode = BigFrame;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

