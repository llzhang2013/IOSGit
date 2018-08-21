//
//  IMALoginViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMALoginViewController.h"

#import "IMALoginParam.h"
#import "YNConversionListViewController.h"
#import <ILiveSDK/ILiveCoreHeader.h>

#define kDaysInSeconds(x)      (x * 24 * 60 * 60)

@interface IMALoginViewController ()
{
//微信、QQ、游客登录现在Demo中不再支持，如有需要，请用户自行完成
//    __weak id<WXApiDelegate>    _tlsuiwx;
//    TencentOAuth                *_openQQ;
    IMALoginParam               *_loginParam;
}

@end

@implementation IMALoginViewController



- (void)dealloc
{
    DebugLog(@"IMALoginViewController=====>>>>> release");
//    _tlsuiwx = nil;
//    _openQQ = nil;
    
    [_loginParam saveToLocal];
}

- (void)initIMSdk:(NSString*)sign userName:(NSString *)userName
{
  
  self.userName = userName;
  self.sign = sign;
  if([userName isEqualToString:@"zhanglilinew"]){
    self.userName = @"zhanglilinew";
    self.sign = @"eJxlj1FPgzAURt-5FYRnYyhtcZj4YCYqo9Og6CIvhEGBO1jpoI4N439XcYkk3tdzcr7cD03XdSNkz*dJmjbvQsXqKLmhX*qGaZz9QSkhixMV4zb7B-lBQsvjJFe8HSGilFqmOXUg40JBDidjKBNR1FCD4P3E6rIqHqd*M*S74cwQnoY6KEa4dF-mXnDTzHcsqtDTZvaQspyVO8zdN8IOm4v7kDVVu45ecQirKtr2XvG48KXtrG*zcoj8wuXh4C0EqpcsuHbC9m4f*EI6pIcVKa4mkwq2-PQXtmxKiU0mdM-bDhoxCpaJKLKw*XOG9ql9AfQWYMY_";

  }else{
    self.userName = @"zhanglilizhengshi";
    self.sign = @"eJxlj8FOg0AURfd8BWGr0ZkBApi4MLQitSQWLJUVoWWAJ5TSmaFQjP*uYhNJfNtzcm7ehyTLsvK6DG6S3e7Q1iIW54Yq8p2sIOX6DzYNpHEiYpWl-yDtG2A0TjJB2QixrusEoakDKa0FZHAxhiKp8woqGApa57yAicrTMh73flvad8gysTqtcchH6M3Xtruyw2FfPszWnS*icyaO7KotqkfWOmrJLTN45otjom-8IsKzzs1DDy8XZkf7wGfdO7edk9Ca3g2zLXlzTOzfvkRPxtbbWPb8fjIpYE8vz6mEaMgw8ISeKONwqEeBIKxjoqKfU6RP6Qu872Lr";
  }
  
//  self.userName = @"zhaoyonghu";
//  self.sign = @"eJxlj8FugkAURfd8BZktTTuAE0sTF0oUEFxQbardkBEGeKUwExgq2PTfq9SkJH25u3Nyb96Xoqoq2gXbexrHvK1kJHvBkPqkIozu-qAQkERURmad-IOsE1CziKaS1QPUCSEGxmMHElZJSOFmnHPKe15leTtymqSIhqHfksmlwXrUzXFNA9kAN8vQ9pbBSTvmhUPbt2xfP2ivpE*0Cffs8ONAy8AWjfB553qtyOYw54GzsrvScRfT4-vzyi8W60NQvMTbjQWpd4KCiK5x-X2-Dmez0aSEkt2*Mi*ZWpiM6CerG*DVIBhYJ7ph4ush5Vv5AR0FYD0_";
  
 
  
  
//

    // Do any additional setup after loading the view, typically from a nib.
    
    
    //[WXApi registerApp:WX_APP_ID];
    //demo暂不提供微博登录
    //[WeiboSDK registerApp:WB_APPKEY];
    
    // 因TLSSDK在IMSDK里面初始化，必须先初始化IMSDK，才能使用TLS登录
    // 导致登出然后使用相同的帐号登录，config会清掉
    
//    BOOL isAutoLogin = [IMAPlatform isAutoLogin];
//    if (isAutoLogin)
//    {
//        _loginParam = [IMALoginParam loadFromLocal];
//    }
//    else
//    {
//        _loginParam = [[IMALoginParam alloc] init];
//    }
  
  _loginParam = [[IMALoginParam alloc] init];
    
    [IMAPlatform configWith:_loginParam.config];
    
//    if (isAutoLogin && [_loginParam isVailed])
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self autoLogin];
//        });
//    }
//    else
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self pullLoginUI];
//        });
//        
//    }
//
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self pullLoginUI];
  });


}

/**
 *  自动登录
 */
- (void)autoLogin
{
    if ([_loginParam isExpired])
    {
        [[HUDHelper sharedInstance] syncLoading:@"刷新票据。。。"];
        //刷新票据
        [[TLSHelper getInstance] TLSRefreshTicket:_loginParam.identifier andTLSRefreshTicketListener:self];
    }
    else
    {
        [self loginIMSDK];
    }
}

- (void)enterMainUI
{
//    _tlsuiwx = nil;
//    _openQQ = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
      [[IMAAppDelegate sharedAppDelegate] enterMainUI];
      [[IMAPlatform sharedInstance] configOnLoginSucc:_loginParam];
    });
  
}

/**
 *  成功登录TLS之后，再登录IMSDK
 *
 *  @param userinfo 登录TLS成功之后回调回来的用户信息
 */
- (void)loginWith:(TLSUserInfo *)userinfo
{
  

//    _openQQ = nil;
//    _tlsuiwx = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (userinfo)
        {
          NSLog(@"loginWith=%@",userinfo.identifier);
            _loginParam.identifier = userinfo.identifier;//userinfo.identifier;
//            _loginParam.userSig = [[TLSHelper getInstance] getSSOTicket:_loginParam.identifier];
          _loginParam.userSig = self.sign;//[[TLSHelper getInstance] getTLSUserSig:userinfo.identifier];
            _loginParam.tokenTime = [[NSDate date] timeIntervalSince1970];
            
            // 获取本地的登录config
            [self loginIMSDK];
        }
    }); 
}

/**
 *  登录IMSDK
 */
- (void)loginIMSDK
{

    //直接登录
    __weak IMALoginViewController *weakSelf = self;
    //[[HUDHelper sharedInstance] syncLoading:@"正在登录"];
    [[IMAPlatform sharedInstance] login:_loginParam succ:^{
      NSLog(@"登录成功");
      
      //[[HUDHelper sharedInstance] syncStopLoadingMessage:@"登录成功"];
      [weakSelf registNotification];
     // [weakSelf enterMainUI];
       [[IMAPlatform sharedInstance] configOnLoginSucc:_loginParam];
      
        [[YNConversionListViewController initWithController] viewDidAppear:false];
       // 周传文修改与20170901
        [YNIMModel initShareMD].timLogin = @"timSuccess";
      
      //  [weakSelf enterMainUI];
      
      
      TIMTabBarController *vc = [TIMTabBarController  shareTIMTabBarController];
      AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      NavigationViewController *convNVC = [[NavigationViewController alloc] initWithRootViewController:vc];
      [convNVC setNavigationBarHidden:YES];
      app.window.rootViewController = convNVC;//zllsig
      
      
      
      
    } fail:^(int code, NSString *msg) {
      NSLog(@"登录失败1");
        /*[[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, msg) delay:2 completion:^{
          NSLog(@"登录失败2");
           // [weakSelf pullLoginUI];
          
        }];*/
    }];
}


//必须在登录之后上传token.在登录之后注册通知，保证通知回调也在登录之后，在通知的回调中上传的token。（回调在IMAAppDelegate的didRegisterForRemoteNotificationsWithDeviceToken中）
- (void)registNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

#pragma mak - delegate<TencentLoginDelegate>
//-(void)tencentDidNotNetWork
//{
//    DebugLog(@"tencentDidNotNetWork");
//}
//
//-(void)tencentDidLogin
//{
//    DebugLog(@"tencentDidLogin");
//}
//
//-(void)tencentDidNotLogin:(BOOL)cancelled
//{
//    DebugLog(@"tencentDidNotLogin");
//}

#pragma mark - delegate<WXApiDelegate>
//-(void) onReq:(BaseReq *)req
//{
//    DebugLog(@"onReq:%@", req);
//}
//
//-(void)onResp:(BaseResp *)resp
//{
//    DebugLog(@"%d %@ %d",resp.errCode, resp.errStr, resp.type);
//    if ([resp isKindOfClass:[SendAuthResp class]])
//    {
//        if(_tlsuiwx != nil)
//        {
//            [_tlsuiwx onResp:resp];
//        }
//    }
//}

#pragma mark - 拉起登陆框
- (void)pullLoginUI
{

  TLSUserInfo *userInfo = [[TLSUserInfo alloc]init];
  userInfo.identifier = self.userName;
  userInfo.accountType = 0;//TODO
  NSLog(@"pullLoginUI--%@",self.userName);
  
  [self loginWith:userInfo];
   // TLSUILoginSetting *setting = [[TLSUILoginSetting alloc] init];
//    _openQQ = [[TencentOAuth alloc]initWithAppId:QQ_APP_ID andDelegate:self];
//    [setting setOpenQQ:_openQQ];
//    setting.qqScope = nil;
//    setting.wxScope = @"snsapi_userinfo";
//    setting.enableWXExchange = YES;
//    setting.enableGuest = YES;
    //    _setting.needBack = YES;
    //demo暂不提供微博登录
    //    tlsSetting.wbScope = nil;
    //    tlsSetting.wbRedirectURI = @"https://api.weibo.com/oauth2/default.html";
//    _tlsuiwx = TLSUILogin(self, setting);
    //TLSUILogin(self, setting);
  /*
  [[TLSHelper getInstance] TLSPwdLogin:@"lili" andPassword:@"11111111" andTLSPwdLoginListener:self];
  
  [[TLSHelper getInstance] TLSExchangeTicket:<#(uint32_t)#> andAccountType:14974 andIdentifier:<#(NSString *)#> andAppidAt3rd:<#(NSString *)#> andUserSig: andTLSExchangeTicketListener:self]
  
  /**
   *  独立模式下换票 usersig换取A2、D2等票据
   *  在本接口的成功回调时通过getSSOTicket接口获取A2、D2等票据
   *
   *  @param identifier 帐号名
   *  @param userSig    业务后台生成的TLS用户票据
   *  @param listener   处理回调
   *
   *  @return 0表示成功；其他表示调用失败
   
  -(int)TLSExchangeTicket:(NSString *)identifier andUserSig:(NSString *)userSig andTLSExchangeTicketListener:(id<TLSExchangeTicketListener>)listener;
  
//  -(int)TLSExchangeTicket:(uint32_t)sdkappid andAccountType:(uint32_t)accountType andIdentifier:(NSString *)identifier andAppidAt3rd:(NSString *)appidAt3rd andUserSig:(NSString *)userSig andTLSExchangeTicketListener:(id<TLSExchangeTicketListener>)listener DEPRECATED_ATTRIBUTE;
  */
  
  //[[TLSHelper getInstance] TLSExchangeTicket:@"enuoadmin" andUserSig:@"eJxFkNFqgzAUQP-F140tmmamgz601oEjHUgr7foiqYlyXY0hpto59u91YtnrOVzuPffH2bHtE9caRMptio1wXh3kPI5YXjUYmfLcSjNglxDiIXS3rTQN1GoQHnKJ62GE-iUIqSzkMA5Kdam5qEBNsoFioJswCaKgqKPDW0fY2WQQt5v1w3PL9*zFv3b9WdNu729Z2VdKf9IlhEs3CWMW8Jz6VK7K1alYKxJnu*Rk86NkfVRqmjTd-PDxPlvcl4mvdOz7K5gNF2J-TugkLVRyLEMYI*y5eOI8y*qLsqn91nJ8yO8NuJpZ7A__"andTLSExchangeTicketListener:self];
  

}
/**
 *  刷新票据成功
 *  在此回调接口内，可以调用getSSOTicket获取A2等票据
 */
-(void)	OnExchangeTicketSuccess{
  NSLog(@"独立模式登录成功");
//   TLSUserInfo *userInfo = [[TLSUserInfo alloc]init];
//   userInfo.identifier = @"enuoadmin";
//   userInfo.accountType = 14974;
  
  //[self loginWith:userInfo];
}

/**
 *  刷新票据失败
 *
 *  @param errInfo 错误信息
 */
-(void)	OnExchangeTicketFail:(TLSErrInfo *)errInfo{
  NSLog(@"独立模式登录失败--%@",errInfo);
}

/**
 *  刷新票据超时
 *
 *  @param errInfo 错误信息
 */
-(void)	OnExchangeTicketTimeout:(TLSErrInfo *)errInfo{
   NSLog(@"独立模式登录超时--%@",errInfo);
}


-(void)	OnPwdLoginSuccess:(TLSUserInfo *)userInfo{
  NSLog(@"密码登录成功--%@",userInfo);
  
  //密码登录成功--acctype:0 userid:liliacount
//  TLSUserInfo *userInfo = [[TLSUserInfo alloc]init];
//  userInfo.identifier = @"lili";
//  userInfo.accountType = 0;
  
  [self loginWith:userInfo];
  
  
}

-(void)	OnPwdLoginFail:(TLSErrInfo *)errInfo{
  NSLog(@"密码登录失败--%@",errInfo);
  
}

#pragma mark - delegate<TLSUILoginListener>
-(void)TLSUILoginOK:(TLSUserInfo *)userinfo
{
    //回调时已结束登录流程 销毁微信回调对象
    //根据登录结果处理
  TLSUserInfo *userInfo = [[TLSUserInfo alloc]init];
  userInfo.identifier = @"lili";
  userInfo.accountType = 0;
  
  
    [self loginWith:userinfo];
    
}

-(void)TLSUILoginQQOK
{
    //回调时已结束登录流程 销毁微信回调对象
    
//    [[TLSHelper getInstance] TLSOpenLogin:kQQAccountType andOpenId:_openQQ.openId andAppid:QQ_APP_ID andAccessToken:_openQQ.accessToken andTLSOpenLoginListener:self];
    
}
//已经废弃
-(void)TLSUILoginWXOK:(SendAuthResp*)resp
{
    DebugLog(@"TLSUILoginWXOK");
}

-(void)TLSUILoginWXOK2:(TLSTokenInfo *)tokenInfo
{
//    [[TLSHelper getInstance] TLSOpenLogin:kWXAccountType andOpenId:tokenInfo.openid andAppid:WX_APP_ID andAccessToken:tokenInfo.accessToken andTLSOpenLoginListener:self];
}
//demo暂不提供微博登录

-(void)TLSUILoginWBOK:(WBAuthorizeResponse *)resp
{
    //    [GlobalData shareInstance].accountHelper = [AccountHelper sharedInstance];
    //    [GlobalData shareInstance].friendshipManager = [FriendshipManager sharedInstance];
    //    NSString *appid = [[NSString alloc] initWithFormat:@"%d",kSdkAppId ];
    //    [[TLSHelper getInstance] TLSOpenLogin:kWXAccountType andOpenId:tokenInfo.openid andAppid:appid andAccessToken:tokenInfo.accessToken andTLSOpenLoginListener:self];
    
}

-(void)TLSUILoginCancel
{
    //回调时已结束登录流程 销毁微信回调对象
}

#pragma mark - TLSOpenLoginListener

//第三方登录成功之后，再次登陆tls换取userinfo
-(void)OnOpenLoginSuccess:(TLSUserInfo *)userinfo
{
    //回调时已结束登录流程 销毁微信回调对象
    //根据登录结果处理
    [self loginWith:userinfo];
}

-(void)OnOpenLoginFail:(TLSErrInfo*)errInfo
{
    DebugLog(@"%@",errInfo);
}

-(void)OnOpenLoginTimeout:(TLSErrInfo*)errInfo
{
    DebugLog(@"%@",errInfo);
}

#pragma mark - Provate Methods


#pragma mark - 刷新票据代理

- (void)OnRefreshTicketSuccess:(TLSUserInfo *)userInfo
{
    [[HUDHelper sharedInstance] syncStopLoading];
    [self loginWith:userInfo];
}


- (void)OnRefreshTicketFail:(TLSErrInfo *)errInfo
{
    _loginParam.tokenTime = 0;
    NSString *err = [[NSString alloc] initWithFormat:@"刷新票据失败\ncode:%d, error:%@", errInfo.dwErrorCode, errInfo.sErrorTitle];
    
    __weak IMALoginViewController *ws = self;
    [[HUDHelper sharedInstance] syncStopLoadingMessage:err delay:2 completion:^{
        [ws pullLoginUI];
    }];
    
}


- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
{
    [self OnRefreshTicketFail:errInfo];
}

@end
