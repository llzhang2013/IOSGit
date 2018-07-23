//
//  InviteLiveViewController.h
//  demo_join
//
//  Created by zhanglili on 2018/7/23.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteLiveViewController : UIViewController
@property(nonatomic,copy) NSString *roomId;
@property(nonatomic,copy) NSString *roleName;
+(InviteLiveViewController *)shareInviteLiveViewController;
-(void)destorySelf;
-(void)initData:(NSString *)roomId role:(NSString *)roleName;


@end
