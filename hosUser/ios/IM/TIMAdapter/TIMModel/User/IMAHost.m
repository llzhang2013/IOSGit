//
//  IMAHost.m
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAHost.h"

@implementation IMAHost

- (void)asyncProfile
{
    __weak IMAHost *ws = self;
    [[TIMFriendshipManager sharedInstance] GetSelfProfile:^(TIMUserProfile *selfProfile) {
        DebugLog(@"Get Self Profile Succ");
        ws.profile = selfProfile;
    } fail:^(int code, NSString *err) {
        DebugLog(@"Get Self Profile Failed: code=%d err=%@", code, err);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
    }];
}

- (BOOL)isMe:(IMAUser *)user
{
    return [self.userId isEqualToString:user.userId];
}


- (void)setLoginParm:(TIMLoginParam *)loginParm
{
    _loginParm = loginParm;
    [_loginParm saveToLocal];
}

- (NSString *)userId
{
    return _profile ? _profile.identifier : _loginParm.identifier;
}
- (NSString *)icon
{
  return self.profile.faceURL;
  // return @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2467179910,4177640389&fm=27&gp=0.jpg";//zll修改new 修改 2018 7月14号 18：06
}
- (NSString *)remark
{
    return ![NSString isEmpty:_profile.nickname] ? _profile.nickname : _profile.identifier;
}
- (NSString *)name
{
    return ![NSString isEmpty:_profile.nickname] ? _profile.nickname : _profile.identifier;
}
- (NSString *)nickName
{
    return ![NSString isEmpty:_profile.nickname] ? _profile.nickname : _profile.identifier;
}



@end
