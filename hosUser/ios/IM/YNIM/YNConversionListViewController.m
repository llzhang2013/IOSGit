//
//  YNIMViewController.m
//  YNHospitalUser
//
//  Created by zhanglili on 2017/8/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "YNConversionListViewController.h"

@interface YNConversionListViewController ()

@end

@implementation YNConversionListViewController

+(instancetype)initWithController{
  static YNConversionListViewController *nimVC = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    nimVC = [[YNConversionListViewController alloc] init];
    nimVC.isFirst = true;
  });
  return nimVC;
}

-(void)getConversionList{

  
  NSMutableArray *sessionList = [NSMutableArray array];
  NSArray *conversationList = [[TIMManager sharedInstance] getConversationList];
  NSInteger unReadCounts = 0;
  for(TIMConversation *conversation in conversationList)
  {
    IMAConversation *conv = [[IMAConversation alloc] initWith:conversation];
 
   
    __weak id<IMAConversationShowAble> _showItem = conv;
    
    NSLog(@"0_showItem=%@",_showItem);
    NSLog(@"1_showItem=%@",[_showItem showTitle]);
    NSLog(@"2_showItem=%@",[_showItem lastMsg]);
    NSLog(@"3_showItem=%@",[_showItem showIconUrl]);
    NSLog(@"4_showItem=%@",[_showItem attributedDraft]);
    NSLog(@"6_showItem=%@", [_showItem lastAttributedMsg]);
    
    NSLog(@"conversationListlist=%@,%ld",conversationList,(long)[conversation getType]);
    
    if([_showItem lastMsg]==NULL){
      continue;
    }

    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    // 会话id
    [dic setObject:[conversation getReceiver] forKey:@"contactId"];
    // 会话类型
    [dic setObject:[NSString stringWithFormat:@"%ld", (long)[conversation getType]] forKey:@"sessionType"];
    NSLog(@"conv.imaType=%ld,%@",(long)conv.imaType,[conv lastMessage]);
    if ([conversation getType] == TIM_SYSTEM)
    {
      //资料变更消息
      if([[_showItem lastMsg] containsString:@"资料变更消息"]){
        continue;
      }

    }
  
    
   
 
    //未读
    NSInteger unReadCount = [_showItem unReadCount];
    
    if ([conversation getType] == TIM_SYSTEM)
    {
      //资料变更消息
      if([[_showItem lastMsg] containsString:@"资料变更消息"]){
        continue;
      }
      
      [dic setObject:[NSString stringWithFormat:@"%ld", (long)0] forKey:@"unreadCount"];
      
    }else{
      unReadCounts = unReadCounts + unReadCount;
      [dic setObject:[NSString stringWithFormat:@"%ld", (long)unReadCount] forKey:@"unreadCount"];
    }
    
    //群组名称或者聊天对象名称
    [dic setObject:[_showItem showTitle] forKey:@"name"];

   
//#if kTestChatAttachment
//    NSAttributedString *attributeDraft = [_showItem attributedDraft];
//    NSAttributedString *attributedText = (attributeDraft && attributeDraft.length) ? attributeDraft : [_showItem lastAttributedMsg];
//    NSLog(@"_lastMsg.attributedText=%@",attributedText);
//#else
//    NSAttributedString *draft = [_showItem attributedDraft];
//    NSAttributedString *attributedText = draft.length ? draft : [_showItem lastMsg];
//#endif
    
//    NSAttributedString *draft = [_showItem attributedDraft];
//    NSAttributedString *attributedText = draft.length ? draft : [_showItem lastMsg];
    NSAttributedString *draft = [_showItem attributedDraft];
    NSLog(@"draft=%@",draft);
    NSString *attributedText;
    if (draft.length) {
      NSLog(@"draft.string=%@",draft.string);
      attributedText = draft.string;
    }else{
      attributedText = [_showItem lastMsg];
    }


    [dic setObject:attributedText forKey:@"content"];
    
    
    IMAUser *user = [conv.lastMessage getSender];
    NSString *userName = [user showTitle];
    NSLog(@"name===%@",[user showTitle]);
    if(userName&&userName.length>0){
      NSString *content = [_showItem lastMsg];
      NSArray *tempArr = [content componentsSeparatedByString:@":"];
      if(tempArr.count>1){
        [dic setObject:[NSString stringWithFormat:@"%@:%@",userName,tempArr[1]] forKey:@"content"];
      }
      
    }
    
    //发送时间
    [dic setObject:[_showItem lastMsgTime] forKey:@"time"];
    // 头像
    if ([_showItem showIconUrl]) {
      [dic setObject:[[_showItem showIconUrl] absoluteString] forKey:@"imagePath"];
    }
       [sessionList addObject:dic];
 
  }
  NSString *badge = @"0";
  if (unReadCounts > 0 && unReadCounts <= 99)
  {
    badge = [NSString stringWithFormat:@"%d", (int)unReadCounts];
  }
  else if (unReadCounts > 99)
  {
    badge = @"99+";
  }
    NSLog(@"更新会话列表-%@",sessionList);

  NSDictionary *recentDict = @{@"recents":sessionList,@"unreadCount":badge};

  [YNIMModel initShareMD].recentDict = recentDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  NSLog(@"YNIMViewController viewDidLoad");

  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
  NSLog(@"YNIMViewController viewDidAppear");
  [super viewDidAppear:animated];
  [[IMAPlatform sharedInstance].conversationMgr releaseChattingConversation];
  [self getConversionList];
  [self configOwnViews];
}

/* 
 
 //[dic setObject:[NSString stringWithFormat:@"%@", [self imageUrlForRecentSession:recent] ?  [self imageUrlForRecentSession:recent] : @""] forKey:@"imagePath"];
 //if (recent.session.sessionType == 1) {
 //  NIMTeam *team = [[[NIMSDK sharedSDK] teamManager]teamById:recent.lastMessage.session.sessionId];
 //  [dic setObject:[NSString stringWithFormat:@"%ld",team.memberNumber] forKey:@"memberCount"];
 //}

 
 //群组名称或者聊天对象名称
 [dic setObject:[_showItem showTitle] forKey:@"name"];
 //账号
 //[dic setObject:[NSString stringWithFormat:@"%@", recent.lastMessage.from] forKey:@"account"];
 //消息类型
 //[dic setObject:[NSString stringWithFormat:@"%ld", recent.lastMessage.messageType] forKey:@"msgType"];
 //消息状态
 //[dic setObject:[NSString stringWithFormat:@"%ld", recent.lastMessage.deliveryState] forKey:@"msgStatus"];
 //消息ID
 //[dic setObject:[NSString stringWithFormat:@"%@", recent.lastMessage.messageId] forKey:@"messageId"];
 //消息内容（zcw缺对富文本支持）
 
 for (NSInteger i= 0; i<1; i++) {
 //for (NIMRecentSession *recent in NIMlistArr) {
 NSMutableDictionary *dic = [NSMutableDictionary dictionary];
 [dic setObject:@"1232343432434424342343" forKey:@"contactId"];
 [dic setObject:[NSString stringWithFormat:@"%ld", recent.session.sessionType] forKey:@"sessionType"];
 //未读
 [dic setObject:[NSString stringWithFormat:@"%ld", recent.unreadCount] forKey:@"unreadCount"];
 //群组名称或者聊天对象名称
 [dic setObject:[NSString stringWithFormat:@"%@", [self nameForRecentSession:recent] ] forKey:@"name"];
 //账号
 [dic setObject:[NSString stringWithFormat:@"%@", recent.lastMessage.from] forKey:@"account"];
 //消息类型
 [dic setObject:[NSString stringWithFormat:@"%ld", recent.lastMessage.messageType] forKey:@"msgType"];
 //消息状态
 [dic setObject:[NSString stringWithFormat:@"%ld", recent.lastMessage.deliveryState] forKey:@"msgStatus"];
 //消息ID
 [dic setObject:[NSString stringWithFormat:@"%@", recent.lastMessage.messageId] forKey:@"messageId"];
 //消息内容
 [dic setObject:[NSString stringWithFormat:@"%@", [self contentForRecentSession:recent] ] forKey:@"content"];
 //发送时间
 [dic setObject:[NSString stringWithFormat:@"%@", [self timestampDescriptionForRecentSession:recent] ] forKey:@"time"];
 
 [dic setObject:[NSString stringWithFormat:@"%@", [self imageUrlForRecentSession:recent] ?  [self imageUrlForRecentSession:recent] : @""] forKey:@"imagePath"];
 if (recent.session.sessionType == 1) {
 NIMTeam *team = [[[NIMSDK sharedSDK] teamManager]teamById:recent.lastMessage.session.sessionId];
 [dic setObject:[NSString stringWithFormat:@"%ld",team.memberNumber] forKey:@"memberCount"];
 }
 
 [sessionList addObject:dic];
 }
 
 if (sessionList) {
 resolve(sessionList);
 }else{
 reject(@"-1",error,nil);
 }*/

- (void)configOwnViews
{
  NSLog(@"YNIMViewController configOwnViews");
  IMAConversationManager *mgr = [IMAPlatform sharedInstance].conversationMgr;
  _conversationList = [mgr conversationList];
  
  
  __weak YNConversionListViewController *ws = self;
  mgr.conversationChangedCompletion = ^(IMAConversationChangedNotifyItem *item) {
    [ws onConversationChanged:item];
  };
  
  //    [[IMAPlatform sharedInstance].conversationMgr addConversationChangedObserver:self handler:@selector(onConversationChanged:) forEvent:EIMAConversation_AllEvents];
  
  
  
  self.KVOController = [FBKVOController controllerWithObserver:self];
  [self.KVOController observe:[IMAPlatform sharedInstance].conversationMgr keyPath:@"unReadMessageCount" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
    [ws onUnReadMessag];
  }];
  [ws onUnReadMessag];
}

- (void)onUnReadMessag
{
  NSInteger unRead = [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount;
  
  NSString *badge = nil;
  if (unRead > 0 && unRead <= 99)
  {
    badge = [NSString stringWithFormat:@"%d", (int)unRead];
  }
  else if (unRead > 99)
  {
    badge = @"99+";
  }
  // 抛出未读消息数，需要打开
  // self.navigationController.tabBarItem.badgeValue = badge;
  [self getConversionList];
}

- (void)onConversationChanged:(IMAConversationChangedNotifyItem *)item
{
  NSLog(@"YNIMViewController onConversationChanged=%@",item);
  [self getConversionList];
  switch (item.type)
  {
    case EIMAConversation_SyncLocalConversation:
    {
      //[self reloadData];
    }
      
      break;
    case EIMAConversation_BecomeActiveTop:
    {
      //[self.tableView beginUpdates];
      //[self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:item.index inSection:0] toIndexPath:[NSIndexPath indexPathForRow:item.toIndex inSection:0]];
      //[self.tableView endUpdates];
    }
      break;
    case EIMAConversation_NewConversation:
    {
     // [self.tableView beginUpdates];
     // NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
      //[self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
      
      //[self.tableView endUpdates];
    }
      break;
    case EIMAConversation_DeleteConversation:
    {
      //[self.tableView beginUpdates];
      //NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
      //[self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
      //[self.tableView endUpdates];
    }
      break;
    case EIMAConversation_Connected:
    {
      //[self.tableView beginUpdates];
      //NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
      //[self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
      //[self.tableView endUpdates];
    }
      break;
    case EIMAConversation_DisConnected:
    {
      //[self.tableView beginUpdates];
      //NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
      //[self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
      //[self.tableView endUpdates];
    }
      break;
    case EIMAConversation_ConversationChanged:
    {
      //[self.tableView beginUpdates];
      //NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
      //[self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
      
      //[self.tableView endUpdates];
    }
      break;
    default:
      
      break;
  }
  
}

@end
