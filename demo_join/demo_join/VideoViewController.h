//
//  VideoViewController.h
//  demo_join
//
//  Created by zhanglili on 2018/7/4.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ILiveSDK/ILiveCoreHeader.h>

@interface VideoViewController : UIViewController<ILiveMemStatusListener, ILiveRoomDisconnectListener>

@end
