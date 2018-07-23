//
//  InviteLiveViewController.m
//  demo_join
//
//  Created by zhanglili on 2018/7/23.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "InviteLiveViewController.h"
#import "SuspandViewController.h"
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectZero;
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor blackColor];
    window.windowLevel = UIWindowLevelAlert+1;
    [window makeKeyAndVisible];
    _myWindow = window;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [button setTitle:@"接受" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(accpectClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 170, 50, 50)];
    [button1 setTitle:@"拒绝" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(refusedClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_myWindow addSubview:button1];
    [_myWindow addSubview:button];
}

-(void)accpectClicked{
    SuspandViewController *liveRoomVC = [SuspandViewController shareSuspandViewController];
    liveRoomVC.isMaster = NO;
    if(liveRoomVC.roomId){
        NSLog(@"zlllive---正在视频中 不能再开启了");
        return;
    }
    UIViewController *vc =  self.navigationController.viewControllers[0];
    [vc addChildViewController:liveRoomVC];
    [vc.view addSubview:liveRoomVC.view];
    [liveRoomVC toJoinRoom:@"8881" role:@"zll1"];
    
    
}

-(void)refusedClicked{
    [self destorySelf];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
