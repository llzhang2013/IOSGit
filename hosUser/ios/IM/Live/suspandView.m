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
#import "WaitingAccpectVC.h"

@interface suspandView(){
    CGFloat offX;
    CGFloat offY;
}
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation suspandView

-(void)initWithController:(UIViewController *)viewController rootView:(UIView *)rootView{
    self.myController = viewController;
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
    
    [self setMode:BigFrame];
    [self showActivity];
    
}
-(void)showActivity{
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    [self addSubview:self.activityIndicator];
    self.activityIndicator.center = self.center;
    self.activityIndicator.hidesWhenStopped = NO;
    [self.activityIndicator startAnimating];
}


-(void)showCameraView:(BOOL)isMaster{
  if(self.activityIndicator){
    [self.activityIndicator removeFromSuperview];
    self.activityIndicator = nil;
  }
}

-(void)setMode:(FramMode)mode{
    if(mode==SmallFrame){
//        if(self.buttonBKView){
//          self.buttonBKView.hidden = YES;
//        }
        _viewWidth = _smallWidth;
        _viewHeight = _smallHeight;
        self.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        _myWindow.frame = CGRectMake(WINDOWS.width-_viewWidth, 0, _viewWidth, _viewHeight);
    }else if(mode==BigFrame){
        _viewWidth = _bigWidth;
        _viewHeight = _bigHeight;
        self.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        _myWindow.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
//        if(self.buttonBKView){
//          self.buttonBKView.hidden = NO;
//        }
    }else if(mode==NoneFrame){
      self.frame = CGRectZero;
      _myWindow.frame = CGRectZero;
    }
    _mode = mode;
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

