//
//  SuspandViewController.h
//  demo_join
//
//  Created by zhanglili on 2018/7/3.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ILiveSDK/ILiveCoreHeader.h>

@interface SuspandViewController : UIViewController<ILiveMemStatusListener, ILiveRoomDisconnectListener>
@property(nonatomic,copy) NSString *roomId;
@property(nonatomic,copy) NSString *roleName;
@property(nonatomic,assign) BOOL isMaster;//是不是我发起的视频

-(void)toJoinRoom:(NSString *)roomId role:(NSString *)roleName;


+ (SuspandViewController *)shareSuspandViewController;
-(void)didJoinRoom;
-(void)close;


@end
