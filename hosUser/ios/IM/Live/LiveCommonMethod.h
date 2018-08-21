//
//  LiveCommonMethod.h
//  YNHospitalUser
//
//  Created by zhanglili on 2018/7/17.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveCommonMethod : NSObject<AVAudioPlayerDelegate>
@property (nonatomic,strong) AVAudioPlayer *musicPlayer;
-(void)playMusic;
-(void)stopMusic;


+(void)initLiveSDK;

+(void)joinInRoom:(NSString *)roomId controlRole:(NSString *)controlRole isMaster:(BOOL)isMaster otherId:(NSString *)otherId;
+(void)quitLiveRoom;

//收到新的消息时判断是否是 视频邀请
+(void)isReceivedVideoInvition:(IMAMsg *)imamsg;

//发出消息时判断 是我发的视频请求不
+(void)isSendVideoInvite:(IMAMsg *)msg1 user:(IMAUser *)user;

+(void)sendMessage:(NSString *)content otherId:(NSString *)otherId;

//打开程序 最后一条消息是要求就弹出要求框
+(void)receivedInvition:(IMAMsg *)imamsg content:(NSString *)content other:(IMAUser *)other;

+(void)isHistoryReceivedVideoInvition:(NSDictionary *)param;

+(void)sendVideoInvitation:(NSString *)otherId;
+(void)showTip:(NSString *)message;
+(void)sendVideoMessage:(NSString *)otherId roomId:(NSString *)roomId;
+(NSString *)changeShowText:(NSString *)text;
+(IMAMsg *)filterVideoShowText:(IMAMsg *)imamsg;
+(NSDictionary *)filterVideoConversionShowText:(NSDictionary *)param;
@end
