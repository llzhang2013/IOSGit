//
//  LiveCommonMethod.m
//  YNHospitalUser
//
//  Created by zhanglili on 2018/7/17.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "LiveCommonMethod.h"
#import <ILiveSDK/ILiveSDK.h>
#import "SuspandViewController.h"
#import "InviteLiveViewController.h"
#import "ChatViewController.h"
#import "TIMAdapter.h"
#import "YNConversionListViewController.h"
#import "MBProgressHUD.h"
#import "IMALoginViewController.h"
#import "TIMTabBarController.h"


//static  const int kSDKAppID = 1400098130;
//static  const int kAccountType = 28332;


@implementation LiveCommonMethod

+(void)initLiveSDK{
  // 初始化SDK
  [IMAPlatform configWith:nil];
  [[ILiveSDK getInstance] initSdk:[kSdkAppId intValue] accountType:[kSdkAccountType intValue]];
  
}

//我已经加入 别人没有加入 我退出
+(void)quitLiveRoom{
  
  SuspandViewController *liveRoomVC = [SuspandViewController shareSuspandViewController];
  if(liveRoomVC.userInfo){
     [liveRoomVC quitLiveRoom];
  }
}



+(void)joinInRoom:(NSString *)roomId controlRole:(NSString *)controlRole isMaster:(BOOL)isMaster otherId:(NSString *)otherId{
  dispatch_async(dispatch_get_main_queue(), ^{
    SuspandViewController *liveRoomVC = [SuspandViewController shareSuspandViewController];
    liveRoomVC.isMaster = isMaster;
    if(liveRoomVC.userInfo){
      NSLog(@"zlllive---正在视频中 不能再开启了");
      return;
    }
    
    
    
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    UINavigationController *nav = app.nav;
    
    //zllsigtodo
    TIMTabBarController *tab = [TIMTabBarController shareTIMTabBarController];
    UINavigationController *nav = tab.selectedViewController;
    //zllsigtodo
    
    UIViewController *vc =  nav.viewControllers[0];
    
    [vc addChildViewController:liveRoomVC];
    [vc.view addSubview:liveRoomVC.view];
    
    IMAUser  *user = [[IMAPlatform sharedInstance].contactMgr getUserByUserId:otherId];
    NSString *userName = user.nickName;
    if(!userName||userName.length==0){
      userName = user.userId;
    }
 
    NSDictionary *dic = @{@"userId":user.userId,@"name":userName,@"icon":user.icon,@"roomId":roomId,@"masterId":controlRole};
    [liveRoomVC toJoinRoom:roomId role:dic];
  });
}

+(void)isReceivedVideoInvition:(IMAMsg *)imamsg{
  TIMTextElem *elem = (TIMTextElem *)[imamsg.msg getElem:0];
  if (![elem isKindOfClass:[TIMCustomElem class]]){
    NSString * content = [elem text];
    if([content hasPrefix:kVideoInvite]){//收到邀请
      
      NSString *roomId = [self getRoomId:content];
      [self receivedInvition:imamsg content:roomId other:nil];
      
    }else if([content isEqualToString:kVideoRefuse]){//被别人拒绝了
      [self quitLiveRoom];
    }else if([content isEqualToString:kVideoCancel]){//别人发视频 我一直不接 超时取消
      InviteLiveViewController *invite = [InviteLiveViewController shareInviteLiveViewController];
      [invite destorySelf];
    }else if([content isEqualToString:kVideoBusy]){//邀请对方时 对方正在视频中
      [self quitLiveRoom];
    }else if([content isEqualToString:kVideoOver]){//挂断
      [self quitLiveRoom];
    }
  }
}

+(void)receivedInvition:(IMAMsg *)imamsg content:(NSString *)content other:(IMAUser *)other{
  InviteLiveViewController *invite = [InviteLiveViewController shareInviteLiveViewController];
  SuspandViewController *sus = [SuspandViewController shareSuspandViewController];
  
  IMAUser * user = [imamsg getSender];
  if(!user){
    user = other;
  }
  if(invite.roomId.length>0||sus.userInfo){
    if([invite.roomId isEqualToString:content]||[sus.userInfo[@"roomId"] isEqualToString:content]){
      return;
    }
    
    [LiveCommonMethod sendMessage:kVideoBusy otherId:user.userId];
    return;
  }
  
  
  
  AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  UINavigationController *nav = app.nav;
  UIViewController *vc =  nav.viewControllers[0];
  IMAHost *host = [IMAPlatform sharedInstance].host;
  
  invite.resultBlock = ^(int result){
    if(result==0){//接受
      NSLog(@"zll---我接受了视频--");
      [self sendMessage:kVideoJoin otherId:user.userId];
      
      [LiveCommonMethod joinInRoom:content controlRole:host.userId isMaster:NO otherId:user.userId];
      
    }else{//拒绝
      NSLog(@"zll---我拒绝了视频--");
      [LiveCommonMethod sendMessage:kVideoRefuse otherId:user.userId];
    }
  };
  NSString *userName = user.nickName;
  if(!userName||userName.length==0){
    userName = user.userId;
  }
  
  NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:host.userId,@"userId",userName,@"name", user.icon,@"icon",nil];
  [invite initData:content role:dic];
  [vc addChildViewController:invite];
  [vc.view addSubview:invite.view];
  
}

+(void)isSendVideoInvite:(IMAMsg *)msg1 user:(IMAUser *)user{
  return;
  TIMTextElem *elem = (TIMTextElem *)[msg1.msg getElem:0];
  NSString * content = [elem text];
  if([content hasPrefix:kVideoInvite]){
    IMAHost *host = [IMAPlatform sharedInstance].host;
    if([msg1 isMineMsg]){
      
      [self joinInRoom:[self getRoomId:content] controlRole:host.userId isMaster:YES otherId:user.userId];
      
      NSLog(@"zll---是我启动的视频---%@",[host userId]);
    }
  }
}

+(NSString *)getRoomId:(NSString *)content{
  NSArray *arr = [content componentsSeparatedByString:@"#"];
  if(arr.count>1){
    NSString *roomId = arr[1];
    NSLog(@"zll----roomId=%@",roomId);
    return roomId;
  }
  return nil;
}

+(void)sendVideoInvitation:(NSString *)otherId{
  if([otherId hasPrefix:@"@TGS#"]){
    [self showTip:@"群组暂不支持视频聊天"];
    return;
  }
  //如果正在通话就不要发了
  IMAPlatform *mp = [IMAPlatform sharedInstance];
  
  if([LiveCommonMethod isInVideo]){
    //alert
    [self showTip:@"正在通话中"];
    
  }
  else if(!mp.isConnected){//无网络
    [self showTip:@"无网络连接"];

  }
  else{
    NSString *content = [NSString stringWithFormat:@"%@%@",kVideoInvite,[self getInitRoomId]];
    IMAHost *host = [IMAPlatform sharedInstance].host;
     [self joinInRoom:[self getRoomId:content] controlRole:host.userId isMaster:YES otherId:otherId];
    
   
  }
}

+(NSString *)getInitRoomId{
  NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
  long long int date = (long long int)time;
  NSString *str = [NSString stringWithFormat:@"%lld",date];
  NSString *str2 = [str substringFromIndex:str.length-7];
  NSLog(@"zll--产生的roomID--%@",str2);
  return str2;
  
  
}

+(void)sendVideoMessage:(NSString *)otherId roomId:(NSString *)roomId{
   NSString *content = [NSString stringWithFormat:@"%@%@",kVideoInvite,roomId];
   [self sendMessage:content otherId:otherId];
}


//我在发起视频前判断我是否正在视频中
+(BOOL)isInVideo{
  InviteLiveViewController *invite = [InviteLiveViewController shareInviteLiveViewController];
  SuspandViewController *sus = [SuspandViewController shareSuspandViewController];
  if(invite.roomId.length>0||sus.userInfo>0){
    return true;
  }
  return false;
  
}

+(void)sendMessage:(NSString *)content otherId:(NSString *)otherId{
  
  NSString *contactId = otherId;
  IMAUser  *user = [[IMAPlatform sharedInstance].contactMgr getUserByUserId:contactId];//对方的identirfier
  IMAConversation *  _conversation = [[IMAPlatform sharedInstance].conversationMgr chatWith:user];
  IMAMsg *msg = [IMAMsg msgWithText:content];
  AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  
 //zllsigTODO
  TIMTabBarController *bar = [TIMTabBarController  shareTIMTabBarController];
  UIViewController *selectVc = bar.selectedViewController;
  if ([selectVc isKindOfClass:[UINavigationController class]])
  {
    UINavigationController *nav = (UINavigationController *)selectVc;
    UIViewController *topVc = nav.topViewController;
    if([topVc isKindOfClass:[ChatViewController class]]){
      
      ChatViewController *cvc = (ChatViewController *)topVc;
      if([cvc checkSelfConversion:otherId]){
        [cvc sendMsg:msg];
        return;
      }
      
    }
    
  }
  [_conversation sendMessage:msg completion:^(NSArray *imamsglist, BOOL succ, int code) {
    
  }];
  //zllsigTODO
  
  
  UIViewController *vc = app.window.rootViewController;
  if([vc isKindOfClass:[UINavigationController class]]){
    UINavigationController *nav = (UINavigationController *)vc;
    UIViewController *topVc = nav.topViewController;

    if([topVc isKindOfClass:[ChatViewController class]]){
      
      ChatViewController *cvc = (ChatViewController *)topVc;
      if([cvc checkSelfConversion:otherId]){
         [cvc sendMsg:msg];
        return;
      }
  
    }
  }
  
  [_conversation sendMessage:msg completion:^(NSArray *imamsglist, BOOL succ, int code) {
    
  }];
}

//推送问题 只调用一次
+(void)isHistoryReceivedVideoInvition:(NSDictionary *)param{
  if(![YNConversionListViewController initWithController].isFirst){
    return;
  }
  [YNConversionListViewController initWithController].isFirst = false;
  
  NSArray *arr =param[@"recents"];
  if(arr){
    for(int i=0;i<arr.count;i++){
      NSDictionary *aa = arr[i];
      if(aa[@"unreadCount"]>0&&[aa[@"content"] hasPrefix:kVideoInvite]){//有未读消息 且是视频请求 而且是最后一条 且是别人发的  就弹起视频框
        NSString *userId = aa[@"contactId"];
        IMAHost *host = [IMAPlatform sharedInstance].host;
        if([host.userId isEqualToString:userId]){
          return;
        }
        
        IMAUser *user = [[IMAUser alloc]initWith:userId];
        user.nickName = aa[@"name"];
        user.icon = aa[@"imagePath"];
        [LiveCommonMethod receivedInvition:nil content:[self getRoomId:aa[@"content"]] other:user];
      }
    }
  }
}

+(void)showTip:(NSString *)message{
  AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  UIViewController *vc = app.window.rootViewController;
  UIView *view = vc.view;
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
  hud.mode = MBProgressHUDModeText;
  hud.labelText = message;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    // Do something...
    [MBProgressHUD hideHUDForView:view animated:YES];
  });
  
}

+(NSDictionary *)filterVideoConversionShowText:(NSDictionary *)param{
  
  NSArray *arr =param[@"recents"];
  if(arr){
    for(int i=0;i<arr.count;i++){
      NSDictionary *aa = arr[i];
      NSString *text = [self changeShowText:aa[@"content"]];
      [aa setValue:text forKey:@"content"];
    }
  }
  return param;
}

+(IMAMsg *)filterVideoShowText:(IMAMsg *)imamsg{
  
  TIMTextElem *elem = (TIMTextElem *)[imamsg.msg getElem:0];
  NSString *text =[elem text];
  text =[self changeShowText:text];
 // IMAMsg *msg = [IMAMsg msgWithText:text];
  [elem setText:text];
  
  return imamsg;
  
}

+(NSString *)changeShowText:(NSString *)text{
  NSString *newText=text;
  if([text hasPrefix:kVideoPre]&&[text hasSuffix:kVideoTail]){
    NSRange range1 = [text rangeOfString:kVideoPre];
    NSRange range2 = [text rangeOfString:kVideoTail];
    newText = [text substringWithRange:NSMakeRange(range1.location+range1.length, text.length-range1.length-range2.length)];
    if([newText containsString:@"视频通话"]){
      newText = @"视频通话";
    }
  
  }else if([text hasPrefix:kVideoPre]&&[text containsString:@"视频通话"]){
    newText =  @"视频通话";
 
  }
  return newText;
  
}
#pragma mark ---  music

-(void)initPlayMusic{

//    AVAudioSession * session = [AVAudioSession sharedInstance];
////    [session setActive:YES error:nil];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
  
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videoMusic" ofType:@"mp3"];
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    self.musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
    self.musicPlayer.delegate = self;
    self.musicPlayer.numberOfLoops = -1;
    
  
}

-(void)playMusic{
  if(!self.musicPlayer){
    [self initPlayMusic];
  }

  if (![self.musicPlayer isPlaying]){
    [self.musicPlayer setVolume:1];
    [self.musicPlayer prepareToPlay];
    [self.musicPlayer play];
  }
}

-(void)stopMusic{
//  if ([self.musicPlayer isPlaying]){
  [self.musicPlayer stop];

//  }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
 
  
}


@end

