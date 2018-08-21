//
//  NIMModel.m
//  NIM
//
//  Created by Dowin on 2017/4/28.
//  Copyright © 2017年 Dowin. All rights reserved.
//

#import "YNIMModel.h"

@implementation YNIMModel
+(instancetype)initShareMD{
    static YNIMModel *nimModel =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nimModel = [[YNIMModel alloc]init];
    });
    return nimModel;
}



-(void)setUserProfileDic:(NSDictionary *)userProfileDic{
  if(_userProfileDic!=userProfileDic){
    _userProfileDic = userProfileDic;
    self.myBlock(16, userProfileDic);
  }
}



- (void)setRecentDict:(NSDictionary *)recentDict{
    if (_recentDict != recentDict) {
        _recentDict = recentDict;
        self.myBlock(1, recentDict);
    }
}

-(void)setNetStatus:(NSString *)NetStatus{
    if (_NetStatus != NetStatus) {
        _NetStatus = NetStatus;
        self.myBlock(0, NetStatus);
    }
}

-(void)setNIMKick:(NSString *)NIMKick{
    if (_NIMKick != NIMKick) {
        _NIMKick = NIMKick;
        self.myBlock(2, NIMKick);
    }
}
-(void)setContactList:(NSMutableDictionary *)contactList{
    if (_contactList != contactList) {
        _contactList = contactList;
        self.myBlock(3, contactList);
    }
}
-(void)setNotiArr:(NSMutableArray *)notiArr{
        self.myBlock(5, notiArr);
}
-(void)setTeamArr:(NSMutableArray *)teamArr{
    self.myBlock(4, teamArr);
}
//未读条数
-(void)setUnreadCount:(NSInteger)unreadCount{
    self.myBlock(6, [NSString stringWithFormat:@"%ld",unreadCount]);
}
//
-(void)setResorcesArr:(NSMutableArray *)ResorcesArr{
    self.myBlock(7, ResorcesArr);
}
//开始发送
-(void)setStartSend:(NSDictionary *)startSend{
    self.myBlock(8, startSend);
}
//结束发送
-(void)setEndSend:(NSDictionary *)endSend{
    self.myBlock(9, endSend);
}
//发送进度（图片等附件）
-(void)setProcessSend:(NSDictionary *)processSend{
    self.myBlock(10, processSend);
}
//已读通知
-(void)setReceipt:(NSString *)receipt{
    self.myBlock(11, receipt);
}
//发送消息
-(void)setSendState:(NSMutableArray *)sendState{
    if (_sendState != sendState) {
        self.myBlock(12, sendState);
    }
}
//黑名单列表
-(void)setBankList:(NSMutableArray *)bankList{
    self.myBlock(13, bankList);
}
//录音进度
-(void)setAudioDic:(NSDictionary *)audioDic{
   
    self.myBlock(14, audioDic);
}
// 登录
-(void)setTimLogin:(NSString *)timLogin{
    self.myBlock(15, timLogin);
}

@end
