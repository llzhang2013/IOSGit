//
//  IMALoginViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

#import "TLSUI/TLSUI.h"
#import "TLSSDK/TLSRefreshTicketListener.h"
#import "TLSSDK/TLSOpenLoginListener.h"
#import <TLSSDK/TLSPwdLoginListener.h>

/**
 *  封装的登录界面，拉起TLSUI的登录界面，实现TLS的代理，票据刷新，登录TLS，登录IMSDK等操作
 */

@interface IMALoginViewController : UIViewController<TLSUILoginListener,TLSRefreshTicketListener,TLSOpenLoginListener,TLSPwdLoginListener,TLSExchangeTicketListener>//TencentSessionDelegate, WXApiDelegate,

@property(strong,nonatomic)NSString *userName;
@property(strong,nonatomic)NSString *sign;
- (void)initIMSdk:(NSString*)sign userName:(NSString *)userName;


@end
