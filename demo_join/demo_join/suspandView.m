//
//  suspandView.m
//  demo_join
//
//  Created by zhanglili on 2018/7/3.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "suspandView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "Masonry.h"


@interface suspandView(){
    CGFloat offX;
    CGFloat offY;
}
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation suspandView

-(void)initWithController:(UIViewController *)viewController rootView:(UIView *)rootView{
    self.selfController = viewController;
    self.rootView = rootView;
    _smallWidth = 100;
    _smallHeight = 150;
    _bigWidth = WINDOWS.width;
    _bigHeight = WINDOWS.height;
    self.backgroundColor = [UIColor blackColor];
    
    UIWindow *window = [[UIWindow alloc]init];
    [window addSubview:self];
    window.windowLevel = UIWindowLevelAlert+1;
    [window makeKeyAndVisible];
    _myWindow = window;
    
    [self setMode:NoneFrame];
   // [self showActivity];
    //[self showCamera:<#(BOOL)#>]
    
}
-(void)showActivity{
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self addSubview:self.activityIndicator];
    self.activityIndicator.center = self.center;
    self.activityIndicator.hidesWhenStopped = NO;
    [self.activityIndicator startAnimating];
}

-(void)showCamera:(BOOL)isMaster{
    if(self.activityIndicator){
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
    //如果是我发起的视频 出现等待接受 否则出现收起等按钮
    [self setMode:BigFrame];

}

-(void)showCameraView:(BOOL)isMaster{
        if(isMaster){
            [self makeWaitingView];
        }else{
            [self makeLivingButtonView];
        }
}

-(void)setMode:(FramMode)mode{
    if(mode==SmallFrame){
        if(self.buttonBKView){
         // [self.buttonBKView removeFromSuperview];
            self.buttonBKView.hidden = YES;
        }
        _viewWidth = _smallWidth;
        _viewHeight = _smallHeight;
        self.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        _myWindow.frame = CGRectMake(WINDOWS.width-_viewWidth, 0, _viewWidth, _viewHeight);
    }else if(mode==BigFrame){
        _viewWidth = _bigWidth;
        _viewHeight = _bigHeight;
        self.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        _myWindow.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        if(self.buttonBKView){
         //[self addSubview:self.buttonBKView];
            self.buttonBKView.hidden = NO;
        }
    }else if(mode==NoneFrame){
        self.frame = CGRectZero;
        _myWindow.frame = CGRectZero;
    }
    _mode = mode;
}

-(void)makeWaitingView{
   UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self addSubview:view];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    //[button setTitle:@"取消" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
    [button addTarget:self.selfController action:@selector(cancelVideoInvite) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

    [self makeTopView:view];
    self.waitingAccepetView = view;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(@80);
        //make.center.equalTo(view);
        make.bottom.equalTo(view).offset(-50);
        make.width.equalTo(@55);
        make.height.equalTo(@55);
        make.centerX.equalTo(view);
    }];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 300, 50, 50)];
    //[button setTitle:@"收起" forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"small"] forState:UIControlStateNormal];
    [button1 addTarget:self.selfController action:@selector(smallView) forControlEvents:UIControlEventTouchUpInside];
     [view addSubview:button1];
    
   
}

-(void)makeTopView:(UIView *)view{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [imageView.layer setCornerRadius:30];
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor redColor];
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
    name.text = @"张伟";
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


-(void)makeLivingButtonView{
    if(self.waitingAccepetView){
        [self.waitingAccepetView removeFromSuperview];
        self.waitingAccepetView = nil;
    }
 
    self.buttonBKView = [[UIView alloc]init];
    [self addSubview:self.buttonBKView];
    [self.buttonBKView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-50));
        make.height.equalTo(@100);
        
    }];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    //[button setTitle:@"收起" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"small"] forState:UIControlStateNormal];
    [button addTarget:self.selfController action:@selector(smallView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(120, 0, 100, 50)];
    button2.tag = 102;
    //[button2 setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [button2 addTarget:self.selfController action:@selector(changeCamera)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(230, 0, 50, 50)];
    button3.tag = 103;
    //[button3 setTitle:@"结束" forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
    [button3 addTarget:self.selfController action:@selector(cancelWindow)
      forControlEvents:UIControlEventTouchUpInside];
    [self.buttonBKView addSubview:button];
    [self.buttonBKView addSubview:button2];
    [self.buttonBKView addSubview:button3];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.centerY.equalTo(button2);
        
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_right).offset(40);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.bottom.equalTo(@0);
        
    }];
    
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button2.mas_right).offset(40);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.bottom.equalTo(@0);
        
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch=[touches anyObject];
    _startPoint=[touch locationInView:_rootView];
    CGPoint viewCenter =self.superview.center;
    offX = viewCenter.x - _startPoint.x;
    offY = viewCenter.y - _startPoint.y;
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint currentPoint=[touch locationInView:_rootView];
    if(_mode==BigFrame){
        if(CGRectContainsPoint(self.smallRenderView.frame, currentPoint)){
            //  [super touchesMoved:touches withEvent:event];
            
            //            CGPoint newPoint = CGPointMake(currentPoint.x+offX, currentPoint.y+offY);
            CGPoint newPoint = CGPointMake(currentPoint.x, currentPoint.y);
            self.smallRenderView.center=newPoint;
        }
        
    }else{
        [super touchesMoved:touches withEvent:event];
        
        CGPoint newPoint = CGPointMake(currentPoint.x+offX, currentPoint.y+offY);
        self.superview.center=newPoint;
    }
    
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch=[touches anyObject];
    CGPoint currentPoint=[touch locationInView:_rootView];
    if ((pow((_startPoint.x-currentPoint.x), 2)+pow((_startPoint.y-currentPoint.y), 2))<1) {
        if ([self.suspendDelegate respondsToSelector:@selector(suspendCustomViewClicked:point:)]) {
            [self.suspendDelegate  suspendCustomViewClicked:self point:currentPoint];
            
        }
    }
    CGFloat left = currentPoint.x;
    CGFloat right = WINDOWS.width - currentPoint.x;
    CGFloat top = currentPoint.y+NavigationBarHeight;
    CGFloat bottom = WINDOWS.height - currentPoint.y-TabBarHeight-NavigationBarHeight;
    ButtonDirection direction = ButtonDirectionLeft;
    CGFloat minDistance = left;
    if (right < minDistance) {
        minDistance = right;
        direction = ButtonDirectionRight;
    }
    //    if (top < minDistance) {
    //        minDistance = top;
    //        direction = ButtonDirectionTop;
    //    }
    //    if (bottom < minDistance) {
    //        direction = ButtonDirectionBottom;
    //    }
    NSInteger topOrButtom;
    if (self.superview.center.y<_viewHeight/2+NavigationBarHeight) {
        topOrButtom=_viewHeight/2+NavigationBarHeight;
    }else if (self.superview.center.y>WINDOWS.height-TabBarHeight-_viewHeight/2-NavigationBarHeight){
        topOrButtom=WINDOWS.height-TabBarHeight-_viewHeight/2-NavigationBarHeight;
    }else{
        topOrButtom=self.superview.center.y;
    }
    NSInteger leftOrRight;
    if (self.superview.center.x<_viewWidth/2) {
        leftOrRight=_viewWidth/2;
    }else if (self.superview.center.x>WINDOWS.width-_viewWidth/2){
        leftOrRight=WINDOWS.width-_viewWidth/2;
    }else{
        leftOrRight=self.superview.center.x;
    }
    
    switch (direction) {
        case ButtonDirectionLeft:
        {
            
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.frame.size.width/2, topOrButtom);
            }];
            
            break;
        }
        case ButtonDirectionRight:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(WINDOWS.width - self.superview.frame.size.width/2, topOrButtom);
            }];
            
            break;
        }
        case ButtonDirectionTop:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(leftOrRight, self.superview.frame.size.height/2+NavigationBarHeight);
            }];
            
            break;
        }
        case ButtonDirectionBottom:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(leftOrRight, WINDOWS.height - self.superview.frame.size.height/2-TabBarHeight);
            }];
            
            break;
        }
        default:
            break;
    }
    
}
@end

