//
//  ViewController.m
//  RunLoop
//
//  Created by zhanglili on 2018/7/12.
//  Copyright © 2018年 zhanglili. All rights reserved.
//

#import "ViewController.h"
#import "HLThread.h"

@interface ViewController ()
@property(nonatomic,strong)HLThread *subThread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr= [[NSArray alloc]init];

    // 1.测试线程的销毁
    //[self threadTest];
    //启动了runloop
    [self threadTest2];
}



- (void)threadTest
{
    HLThread *subThread = [[HLThread alloc] initWithTarget:self selector:@selector(subThreadOpetion) object:nil];
    [subThread start];
}

- (void)subThreadOpetion
{
    NSLog(@"%@----子线程任务开始",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"%@----子线程任务结束",[NSThread currentThread]);
}


#pragma mark -- runLoop
- (void)threadTest2
{
     NSLog(@"%@----主线程",[NSThread currentThread]);
    HLThread *subThread = [[HLThread alloc] initWithTarget:self selector:@selector(subThreadEntryPoint) object:nil];
    [subThread setName:@"HLThread"];
    [subThread start];
    self.subThread = subThread;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(subThreadOpetion2) onThread:self.subThread withObject:nil waitUntilDone:NO];//在子线程里执行这段代码
}

/**
 子线程启动后，启动runloop
 */
- (void)subThreadEntryPoint
{
    //这点代码是运行在子线程里的  子线程不开启runloop 就不会有runloop
//    有几点需要注意：
//    1.获取RunLoop只能使用 [NSRunLoop currentRunLoop] 或 [NSRunLoop mainRunLoop];
//    2.即使RunLoop开始运行，如果RunLoop 中的 modes 为空，或者要执行的mode里没有item，那么RunLoop会直接在当前loop中返回，并进入睡眠状态。
//    3.自己创建的Thread中的任务是在kCFRunLoopDefaultMode这个mode中执行的。
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    //如果注释了下面这一行，子线程中的任务并不能正常执行
    [runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
    NSLog(@"启动RunLoop前--%@",runLoop.currentMode);
    [runLoop run];
}


- (void)subThreadOpetion2
{
    NSLog(@"启动RunLoop后--%@",[NSRunLoop currentRunLoop].currentMode);
    NSLog(@"%@----子线程任务开始",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"%@----子线程任务结束",[NSThread currentThread]);
}




//我们在使用NSURLConnection 或者NSStream时，也需要考虑到RunLoop问题，因为默认情况下这两个类的对象生成后，都是在当前线程的NSDefaultRunLoopMode模式下执行任务。如果是在主线程，那么就会出现滚动ScrollView以及其子视图时，主线程的RunLoop切换到UITrackingRunLoopMode模式，那么NSURLConnection或者NSStream的回调就无法执行了。

//就是所有的任务都在子线程中执行，并保证子线程的RunLoop正常运行即可（即上面AFNetworking的做法，因为主线程的RunLoop切换到UITrackingRunLoopMode，并不影响其他线程执行哪个mode中的任务，计算机CPU是在每一个时间片切换到不同的线程去跑一会，呈现出的多线程效果）。

@end
