//
//  SuspandViewController.h
//  demo_join
//
//  Created by zhanglili on 2018/7/3.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ILiveSDK/ILiveCoreHeader.h>


@protocol  SuspandViewControllerDelegate <NSObject>
-(void)overVideo;//视频中 结束
-(void)cancelInviteVideo;//对方未接受时 结束

@end

@interface SuspandViewController : UIViewController<ILiveMemStatusListener, ILiveRoomDisconnectListener>
@property(nonatomic,copy) NSDictionary *userInfo;
@property(nonatomic,assign) BOOL isMaster;//是不是我发起的视频
@property(nonatomic,weak) id<SuspandViewControllerDelegate> delegate;

-(void)toJoinRoom:(NSString *)roomId role:(NSDictionary *)userInfo;

+ (SuspandViewController *)shareSuspandViewController;
-(void)close;
-(void)quitLiveRoom;

-(void)changeCamera;
-(void)smallView;
-(void)overButtonCliced;

@end
