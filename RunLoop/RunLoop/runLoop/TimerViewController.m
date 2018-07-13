//
//  TimerViewController.m
//  RunLoop
//
//  Created by zhanglili on 2018/7/12.
//  Copyright © 2018年 zhanglili. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController ()
@property (nonatomic,assign)int count;
@property (nonatomic,strong)UILabel *timerLabel ;
@property (nonatomic,strong)NSThread *subThread;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lable = [[UILabel alloc]init];
    lable.frame = CGRectMake(0, 100, 100, 100);
    [self.view addSubview:lable];
    self.timerLabel = lable;
    
    // 第一种写法
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//    [timer fire];
    
    // 第二种写法
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
//    [timer fire];
    
    //3
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    [timer fire];
    
    [self createThread];
    
}
- (void)timerUpdate
{
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    NSLog(@"启动RunLoop后--%@",[NSRunLoop currentRunLoop].currentMode);
    //    NSLog(@"currentRunLoop:%@",[NSRunLoop currentRunLoop]);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.count ++;
        NSString *timerText = [NSString stringWithFormat:@"计时器:%d",self.count];
        self.timerLabel.text = timerText;
    });
}

//方案二  首先是创建一个子线程
- (void)createThread
{
    NSThread *subThread = [[NSThread alloc] initWithTarget:self selector:@selector(timerTest) object:nil];
    [subThread start];
    self.subThread = subThread;
}

// 创建timer，并添加到runloop的mode中
- (void)timerTest
{
    NSLog(@"当前线程：%@",[NSThread currentThread]);//子线程
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    NSLog(@"启动RunLoop前--%@",runLoop.currentMode);
    NSLog(@"currentRunLoop:%@",runLoop);
    
    //添加到了子线程 的defaultmode 里  这样跟主线程互补影响
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    [timer fire];
    [runLoop run];
}

@end
// 第二种写法 = 第一种写法 滑动tableView的时候timerUpdate方法，并不会调用。
//    原因是当我们滑动scrollView时，主线程的RunLoop 会切换到UITrackingRunLoopMode这个Mode，执行的也是UITrackingRunLoopMode下的任务（Mode中的item），而timer 是添加在NSDefaultRunLoopMode下的，所以timer任务并不会执行，只有当UITrackingRunLoopMode的任务执行完毕，runloop切换到NSDefaultRunLoopMode后，才会继续执行timer。
//总结
//
//1、如果是在主线程中运行timer，想要timer在某界面有视图滚动时，依然能正常运转，那么将timer添加到RunLoop中时，就需要设置mode 为NSRunLoopCommonModes。
//2、如果是在子线程中运行timer,那么将timer添加到RunLoop中后，Mode设置为NSDefaultRunLoopMode或NSRunLoopCommonModes均可，但是需要保证RunLoop在运行，且其中有任务。


