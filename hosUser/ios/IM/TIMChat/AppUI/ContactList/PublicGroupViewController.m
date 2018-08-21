//
//  PublicGroupViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "PublicGroupViewController.h"

@implementation PublicGroupViewController

- (void)addRightItem
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(onClickRightItem)];
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addDoctor"] style:UIBarButtonItemStylePlain target:self action:@selector(onRightItem:)];
    self.title = @"公开群";
}

- (void)onRightItem:(UIBarButtonItem *)baritem
{
  MenuItem *addFriend = [[PopupMenuItem alloc] initWithTitle:@"创建群组" icon:[UIImage imageNamed:@"addfriend"] action:^(id<MenuAbleItem> menu) {
    NewPublicGroupViewController *vc = [[NewPublicGroupViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
    // [[AppDelegate sharedAppDelegate] pushViewController:vc];
  }];
  
  MenuItem *addGroup = [[PopupMenuItem alloc] initWithTitle:@"添加群组" icon:[UIImage imageNamed:@"add_group40"] action:^(id<MenuAbleItem> menu) {
    AddGroupViewController *vc = [[AddGroupViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
  }];
  
  
   UIView *view = [baritem valueForKey:@"view"];
  CGRect barRect = [view relativePositionTo:self.navigationController.view];
  [PopupMenu showMenuInView:self.navigationController.view fromRect:barRect menuItems:@[addFriend, addGroup]];
}



//- (void)onClickRightItem
//{
//  
//  AddGroupViewController *vc1 = [[AddGroupViewController alloc] init];
//  
//    NewPublicGroupViewController *vc = [[NewPublicGroupViewController alloc] init];
//    [[AppDelegate sharedAppDelegate] pushViewController:vc1];
//}

- (void)configOwnViews
{
    //调试手动设置管理员
//    [[IMAPlatform sharedInstance].groupAssistant ModifyGroupMemberInfoSetRole:@"@TGS#2ZHYURAEJ" user:@"wilderdev0" role:TIM_GROUP_MEMBER_ROLE_ADMIN succ:^{
//        NSLog(@"succ");
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"fail");
//    }];
    
     _groupDictionary = [[IMAPlatform sharedInstance].contactMgr publicGroups];
}

- (void)addSearchController
{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_groupDictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [_groupDictionary allKeys];
    NSString *key = array[section];
    NSArray *groups = _groupDictionary[key];
    return groups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewId = @"TextTableViewHeaderFooterView";
    TextTableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!headerView)
    {
        headerView = [[TextTableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
    }
    
    NSArray *array = [_groupDictionary allKeys];
    
    headerView.tipLabel.text = array[section];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    if (!cell)
    {
        cell = [[GroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupCell"];
    }
    
    NSArray *array = [_groupDictionary allKeys];
    NSString *key = array[indexPath.section];
    NSArray *groups = _groupDictionary[key];
    
    id<IMAGroupShowAble> chat = [groups objectAtIndex:indexPath.row];
    [cell configWith:chat];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [_groupDictionary allKeys];
    NSString *key = array[indexPath.section];
    NSArray *groups = _groupDictionary[key];
    
    IMAUser *group = [groups objectAtIndex:indexPath.row];
#if kTestChatAttachment
  // 无则重新创建
  ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:group];
#else
  ChatViewController *vc = [[IMAChatViewController alloc] initWith:group];
#endif
  if ([group isC2CType])
  {
    TIMConversation *imconv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:group.userId];
    if ([imconv getUnReadMessageNum] > 0)
    {
      [vc modifySendInputStatus:SendInputStatus_Send];
    }
  }
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
    
}




@end
