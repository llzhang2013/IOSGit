/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <TLSSDK/TLSStrAccountRegListener.h>
#import <TLSSDK/TLSPwdLoginListener.h>

@interface AppDelegate : IMAAppDelegate <UIApplicationDelegate,TLSStrAccountRegListener,TLSPwdLoginListener>{
  AVAudioPlayer *player;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UINavigationController *nav;

//次变量为了解决问题：从联系人列表进入聊天界面，即使不做任何操作，都会生成一个会话(现象是会话列表多出一个会话)
//@property (nonatomic, assign) BOOL isContactListEnterChatViewController;

- (void)pushToChatViewControllerWith:(IMAUser *)user;
@end
