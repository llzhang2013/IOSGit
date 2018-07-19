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
+ (SuspandViewController *)shareSuspandViewController;
-(void)didJoinRoom;
-(void)close;


@end
