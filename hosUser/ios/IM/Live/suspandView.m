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

  if(isMaster){
   
  }else{
    [self makeLivingButtonView];
  }
}

-(void)setMode:(FramMode)mode{
    if(mode==SmallFrame){
        if(self.buttonBKView){
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
          self.buttonBKView.hidden = NO;
        }
    }else if(mode==NoneFrame){
      self.frame = CGRectZero;
      _myWindow.frame = CGRectZero;
    }
    _mode = mode;
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
  
  UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
  //[button setTitle:@"收起" forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"small"] forState:UIControlStateNormal];
  [button addTarget:self.myController action:@selector(smallView) forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(120, 0, 100, 50)];
  button2.tag = 102;
  //[button2 setTitle:@"切换摄像头" forState:UIControlStateNormal];
  [button2 setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
  [button2 addTarget:self.myController action:@selector(changeCamera)
    forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(230, 0, 65, 65)];
  button3.tag = 103;
  //[button3 setTitle:@"结束" forState:UIControlStateNormal];
  [button3 setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
  [button3 addTarget:self.myController action:@selector(overButtonCliced)
    forControlEvents:UIControlEventTouchUpInside];
  [self.buttonBKView addSubview:button];
  [self.buttonBKView addSubview:button2];
  [self.buttonBKView addSubview:button3];
  
  int size = 55;
  [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
    //make.left.equalTo(button.mas_right).offset(60);
    make.centerX.equalTo(self.buttonBKView);
    make.size.mas_equalTo(CGSizeMake(size, size));
    make.bottom.equalTo(@0);
    
  }];
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(button2.mas_left).offset(-50);
    make.size.mas_equalTo(CGSizeMake(size, size));
    make.centerY.equalTo(button2);
    
  }];
  
  [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(button2.mas_right).offset(50);
    make.size.mas_equalTo(CGSizeMake(size, size));
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
//    NSLog(@"self.smallRenderView.frame---%@",NSStringFromCGRect(self.smallRenderView.frame));
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

