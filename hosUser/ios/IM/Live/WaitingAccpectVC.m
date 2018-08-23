//
//  WaitingAccpectVC.m
//  YNHospitalUser
//
//  Created by zhanglili on 2018/8/21.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "WaitingAccpectVC.h"
#import "LiveCommonMethod.h"

@interface WaitingAccpectVC (){
  
}
@property (nonatomic,strong)LiveCommonMethod *liveCommonMethod;


@end

@implementation WaitingAccpectVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.frame = [UIScreen mainScreen].bounds;
  self.view.backgroundColor = [UIColor clearColor];
  self.susVC = [SuspandViewController shareSuspandViewController];
  
  [self makeWaitingView];
  [self startWaiting];
  
}

-(void)startWaiting{
  [LiveCommonMethod sendVideoMessage:self.userInfo[@"userId"] roomId:self.userInfo[@"roomId"]];
  myTimer = [NSTimer scheduledTimerWithTimeInterval:20 repeats:NO block:^(NSTimer * _Nonnull timer) {
    NSLog(@"timer发生了");
    [self overWaiting];
    [self cancelVideoInvite];
    
  }];
  
  LiveCommonMethod *live = [[LiveCommonMethod alloc]init];
  [live playMusic];
  self.liveCommonMethod = live;
}

-(void)overWaiting{
  //别人接听了
  if(myTimer){
    NSLog(@"timer停止了");
    [myTimer invalidate];
    myTimer = nil;
  }
  [self.liveCommonMethod stopMusic];
  [self.view removeFromSuperview];
  
}

-(void)cancelVideoInvite{
  [self.liveCommonMethod stopMusic];
  [self.susVC quitLiveRoom];
  [LiveCommonMethod sendMessage:kVideoCancel otherId:self.userInfo[@"userId"]];
  [self overWaiting];
  
}

-(void)makeWaitingView{
  
  UIView *view = self.view;
  
  UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
  //[button setTitle:@"取消" forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
  [button addTarget:self action:@selector(cancelVideoInvite) forControlEvents:UIControlEventTouchUpInside];
  [view addSubview:button];
  
  [self makeTopView:view];
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    //make.left.equalTo(@80);
    //make.center.equalTo(view);
    make.bottom.equalTo(view).offset(-50);
    make.width.equalTo(@55);
    make.height.equalTo(@55);
    make.centerX.equalTo(view);
  }];
  
}

-(void)makeTopView:(UIView *)view{
  UIButton *imageView = [[UIButton alloc]init];
  [imageView.layer setCornerRadius:30];
  imageView.clipsToBounds = YES;
  [imageView sd_setImageWithURL:self.userInfo[@"icon"] forState:UIControlStateNormal placeholderImage:kDefaultUserIcon];
  imageView.backgroundColor = [UIColor clearColor];
  [view addSubview:imageView];
  [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.mas_equalTo(CGSizeMake(60, 60));
    make.left.top.equalTo(@40);
  }];
  
  UIView *rightView = [[UIView alloc]init];
  [view addSubview:rightView];
  [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(imageView);
    make.height.equalTo(@60);
    make.right.equalTo(@20);
    make.left.equalTo(imageView.mas_right).offset(10);
    
  }];
  
  UILabel *name = [[UILabel alloc]init];
  name.text = self.userInfo[@"name"];
  UILabel *ss = [[UILabel alloc]init];
  ss.text = @"正在等待对方接受邀请.";
  name.textColor = [UIColor whiteColor];
  ss.textColor = [UIColor whiteColor];
  [rightView addSubview:name];
  [rightView addSubview:ss];
  [name mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.left.equalTo(@0);
    
  }];
  
  [ss mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.equalTo(@0);
  }];
  
}


@end

