//
//  InviteLiveViewController.h
//  demo_join
//
//  Created by zhanglili on 2018/7/23.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^onResult)(int result);//0 接受 1 拒绝
@interface InviteLiveViewController : UIViewController
@property(nonatomic,strong) onResult resultBlock;
@property(nonatomic,copy) NSString *roomId;
@property(nonatomic,copy) NSString *roleName;
@property(nonatomic,strong) NSDictionary *userInfo;
+(InviteLiveViewController *)shareInviteLiveViewController;
-(void)destorySelf;
-(void)initData:(NSString *)roomId role:(NSDictionary *)userInfo;


@end
