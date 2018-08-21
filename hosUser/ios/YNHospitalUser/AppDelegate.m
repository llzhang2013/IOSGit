/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif




#define BuglyAppID  @"1d466ac18c"


#import "LiveCommonMethod.h"
#import "LoginViewController.h"


@implementation AppDelegate


bool isBack = false;

- (void)configAppLaunch
{
  // 作App配置
  [[NSClassFromString(@"UICalloutBarButton") appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
}


- (void)enterMainUI
{
  //self.window.rootViewController = [[TIMTabBarController alloc] init];
  TIMTabBarController *vc = [TIMTabBarController  shareTIMTabBarController];
  UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
  [nav pushViewController:vc animated:YES];
  
}

+ (instancetype)sharedAppDelegate
{
  return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)pushToChatViewControllerWith:(IMAUser *)user
{

   TIMTabBarController *tab = [TIMTabBarController  shareTIMTabBarController];//zllsig
  [tab pushToChatViewControllerWith:user];
  
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSLog(@"程序开始运行--");
  NSDictionary *remoteUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
  if (remoteUserInfo) {
    NSLog(@"remoteUserInfo:%@",remoteUserInfo);
    
    NSMutableString *string = [NSMutableString stringWithString:@"{\n"];
    [remoteUserInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      
      [string appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    [string appendString:@"}\n"];
    
    
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推送开启"
    //
    //                                                   message:string
    //
    //                                                  delegate:self
    //
    //                                         cancelButtonTitle:@"取消"
    //
    //                                         otherButtonTitles:@"确定", nil];
    //
    //    [alert show];
    
    
  }
  
  [LiveCommonMethod initLiveSDK];
  
 
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
 
  //self.window.rootViewController = rootViewController;
  
  
//  TIMTabBarController *vc = [TIMTabBarController  shareTIMTabBarController];
//  // 初始化Nav
//  _nav = [[UINavigationController alloc]initWithRootViewController:vc];
//  [_nav setNavigationBarHidden:YES];
  LoginViewController *vc1 = [[LoginViewController alloc]init];
  
  self.window.rootViewController = vc1;
  
  [self.window makeKeyAndVisible];
  
  
  
  
  //  //bugly配置
  //  [Bugly startWithAppId:BuglyAppID];
  //  // 读取Info.plist中的参数初始化SDK
  //  [Bugly startWithAppId:nil];TOTO
  NSLog(@"home路径=%@",NSHomeDirectory());
  
  //    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
  [self handelPushNotify];
  [self setNav];
  //[self testIM];

  return YES;
}

- (void)setNav{
  [self.nav.navigationBar setBarTintColor:[UIColor blueColor]];
  [self.nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
  // 导航栏左右按钮字体颜色
  self.nav.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)handelPushNotify{
  [UIApplication sharedApplication].applicationIconBadgeNumber=0;
  if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
    NSLog(@"第一次启动,home路径=%@",NSHomeDirectory());
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
  }else{
    NSLog(@"不是第一次启动,home路径=%@",NSHomeDirectory());
  }
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
  [super applicationWillEnterForeground:application];
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  isBack = false;
}

//RCTPush
// Required to register for notifications
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
 
}
// Required for the register event.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  [super application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
 
}
// Required for the notification event.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification
{
  [super application:application didReceiveRemoteNotification:notification];
 
  
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
 
  
  NSLog(@"本地推送---%@",notification.userInfo);
  NSDictionary *userInfo = notification.userInfo;
  
  
  NSString *soundNameStr = notification.soundName;
  NSArray *array=[soundNameStr componentsSeparatedByString:@"."];
  NSString *nameStr = [array objectAtIndex:0];
  NSString *ExeStr = [array objectAtIndex:1];
  NSString *soundPath=[[NSBundle mainBundle] pathForResource:nameStr ofType:ExeStr];
  
  NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
  player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
  
  [player play];
  
  //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:userInfo[@"showText"]
  //  message:nil
  //  delegate:nil
  // cancelButtonTitle:@"OK"
  //  otherButtonTitles:nil];
  // [alert show];
  
  // 更新显示的徽章个数
  //  NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
  //  badge--;
  //  badge = badge >= 0 ? badge : 0;
  //  [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
  //[[UIApplication sharedApplication] cancelLocalNotification:notification];
  
  
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)   (UIBackgroundFetchResult))completionHandler {
 
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
   
  }
  if (isBack){
    completionHandler(UNNotificationPresentationOptionAlert);
  }
  
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
   
  }
  completionHandler();
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
  //进入后台
  [super applicationDidEnterBackground:application];
  isBack = true;
}





@end

