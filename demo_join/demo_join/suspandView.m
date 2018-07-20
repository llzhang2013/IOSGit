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
  

@interface suspandView(){
    CGFloat offX;
    CGFloat offY;
}
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;


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
    //window.backgroundColor = [UIColor yellowColor];
    [window addSubview:self];
    window.windowLevel = UIWindowLevelAlert+1;
    [window makeKeyAndVisible];
    _myWindow = window;
    
    [self setMode:BigFrame];
    [self showActivity];
    
}
-(void)showActivity{
   // UIActivity *activity = [[UIActivity alloc]init];
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    [self addSubview:self.activityIndicator];
  
    self.activityIndicator.center = self.center;
   // self.activityIndicator.color = [UIColor blueColor];
   // self.activityIndicator.backgroundColor = [UIColor cyanColor];
    self.activityIndicator.hidesWhenStopped = NO;
    [self.activityIndicator startAnimating];
}

-(void)showCamera{
    if(self.activityIndicator){
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}



-(void)setMode:(FramMode)mode{
    if(mode==SmallFrame){
        [self.buttonBKView removeFromSuperview];
        _viewWidth = _smallWidth;
        _viewHeight = _smallHeight;
         self.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        _myWindow.frame = CGRectMake(WINDOWS.width-_viewWidth, 0, _viewWidth, _viewHeight);
    }else if(mode==BigFrame){
        _viewWidth = _bigWidth;
        _viewHeight = _bigHeight;
         self.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        _myWindow.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        [self addButtons];
    }
    _mode = mode;
}

-(void)addButtons{
   
    if(self.buttonBKView){
        [self addSubview:self.buttonBKView];
        return;
    }
    self.buttonBKView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-100, _viewWidth, 50)];
    [self addSubview:self.buttonBKView];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    button.tag=100;
    [button setTitle:@"收起" forState:UIControlStateNormal];
    [button addTarget:self.selfController action:@selector(smallView) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(60, 0, 50, 50)];
//    [button1 setTitle:@"上麦" forState:UIControlStateNormal];
//    button1.tag=101;
   
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(120, 0, 100, 50)];
    button2.tag = 102;
    [button2 setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [button2 addTarget:self.selfController action:@selector(changeCamera)
  forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(230, 0, 50, 50)];
    button3.tag = 103;
    [button3 setTitle:@"结束" forState:UIControlStateNormal];
    [button3 addTarget:self.selfController action:@selector(cancelWindow)
  forControlEvents:UIControlEventTouchUpInside];
    [self.buttonBKView addSubview:button];
    [self.buttonBKView addSubview:button2];
    [self.buttonBKView addSubview:button3];
    
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
