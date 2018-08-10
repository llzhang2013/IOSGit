//
//  InviteLiveViewController.m
//  demo_join
//
//  Created by zhanglili on 2018/7/23.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "InviteLiveViewController.h"
#import "Masonry.h"
//#import "SuspandViewController.h"
static dispatch_once_t onceToken;
static InviteLiveViewController *inviteLiveViewController = NULL;

@interface InviteLiveViewController ()
@property (nonatomic,strong)UIWindow *myWindow;

@end

@implementation InviteLiveViewController

+(InviteLiveViewController *)shareInviteLiveViewController{
  
    dispatch_once(&onceToken, ^{
        inviteLiveViewController = [[InviteLiveViewController alloc]init];
    });

    return inviteLiveViewController;
}
-(void)destorySelf{
    _myWindow = nil;
    inviteLiveViewController = nil;
    onceToken = 0;
}

-(void)initData:(NSString *)roomId role:(NSString *)roleName{
    self.roomId = roomId;
    self.roleName = roleName;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectZero;
    
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    window.windowLevel = UIWindowLevelAlert+1;
    [window makeKeyAndVisible];
    _myWindow = window;

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home-.png"]];

    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
   
    [button setBackgroundImage:[UIImage imageNamed:@"answer.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(accpectClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 170, 50, 50)];
    [button1 setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(refusedClicked) forControlEvents:UIControlEventTouchUpInside];
    [_myWindow addSubview:imageView];
    [_myWindow addSubview:button1];
    [_myWindow addSubview:button];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_myWindow);
        
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_myWindow).offset(-80);
        make.bottom.equalTo(_myWindow).offset(-50);
        make.width.equalTo(@55);
        make.height.equalTo(@55);
    }];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@80);
        make.bottom.equalTo(_myWindow).offset(-50);
        make.width.equalTo(@55);
        make.height.equalTo(@55);
    }];
    [self makeTopView];
}

-(void)makeTopView{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    imageView.backgroundColor = [UIColor clearColor];
    [_myWindow addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.top.equalTo(@40);
    }];
    
    UIView *rightView = [[UIView alloc]init];
    [_myWindow addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView);
        make.height.equalTo(@60);
        make.right.equalTo(@20);
        make.left.equalTo(imageView.mas_right).offset(10);
        
    }];
    
    UILabel *name = [[UILabel alloc]init];
    name.text = @"张伟";
    UILabel *ss = [[UILabel alloc]init];
    ss.text = @"邀请你视频通话";
//    name.textColor = [UIColor whiteColor];
//    ss.textColor = [UIColor whiteColor];
    [rightView addSubview:name];
    [rightView addSubview:ss];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
    
    }];
    
    [ss mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@0);
    }];
    
}

-(void)accpectClicked{
    self.resultBlock(0);
//    SuspandViewController *liveRoomVC = [SuspandViewController shareSuspandViewController];
//    liveRoomVC.isMaster = NO;
//    if(liveRoomVC.roomId){
//        NSLog(@"zlllive---正在视频中 不能再开启了");
//        return;
//    }
//    UIViewController *vc =  self.navigationController.viewControllers[0];
//    [vc addChildViewController:liveRoomVC];
//    [vc.view addSubview:liveRoomVC.view];
//    [liveRoomVC toJoinRoom:self.roomId role:self.roomId];
}

-(void)refusedClicked{
    self.resultBlock(1);
    [self destorySelf];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
