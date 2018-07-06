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
#define NavigationBarHeight 0
#define TabBarHeight 0
typedef NS_ENUM(NSInteger,ButtonDirection){
    ButtonDirectionLeft    =0,
    ButtonDirectionRight   =1,
    ButtonDirectionTop     =3,
    ButtonDirectionBottom  =4
};

@interface suspandView()
@property (nonatomic, assign) CGPoint startPoint;

@end

@implementation suspandView

-(void)initSelf{
    _smallWidth = 100;
    _smallHeight = 150;
    _bigWidth = WINDOWS.width;
    _bigHeight = WINDOWS.height;
    
}

-(void)setMode:(FramMode)mode{
    
    if(mode==SmallFrame){
        [self.buttonBKView removeFromSuperview];
        _viewWidth = _smallWidth;
        _viewHeight = _smallHeight;
        self.frame = CGRectMake(WINDOWS.width-_viewWidth, 0, _viewWidth, _viewHeight);
        
    }else if(mode==BigFrame){
        _viewWidth = _bigWidth;
        _viewHeight = _bigHeight;
        self.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
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
    
//    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(60, 0, 50, 50)];
//    [button1 setTitle:@"上麦" forState:UIControlStateNormal];
//    button1.tag=101;
   
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(120, 0, 100, 50)];
    button2.tag = 102;
    [button2 setTitle:@"切换摄像头" forState:UIControlStateNormal];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(230, 0, 50, 50)];
    button3.tag = 103;
    [button3 setTitle:@"结束" forState:UIControlStateNormal];
    [self.buttonBKView addSubview:button];
    [self.buttonBKView addSubview:button2];
    [self.buttonBKView addSubview:button3];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch=[touches anyObject];
    _startPoint=[touch locationInView:self.superview];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(_mode==BigFrame){
        return;
    }
    UITouch *touch = [touches anyObject];

    CGPoint currentPoint = [touch locationInView:self];
    CGPoint prePoint = [touch previousLocationInView:self];
    CGFloat offSetX = currentPoint.x - prePoint.x;
    CGFloat offSetY = currentPoint.y - prePoint.y;
    
    self.transform = CGAffineTransformTranslate(self.transform, offSetX, offSetY);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
   
    UITouch *touch=[touches anyObject];
    CGPoint currentPoint=[touch locationInView:self.superview];
     NSLog(@"zll--currentPointEnd=%@",NSStringFromCGPoint(currentPoint));
    
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
    if (top < minDistance) {
        minDistance = top;
        direction = ButtonDirectionTop;
    }
    if (bottom < minDistance) {
        direction = ButtonDirectionBottom;
    }

    switch (direction) {
        case ButtonDirectionLeft:
        {
            [UIView animateWithDuration:0.3 animations:^{
              
                CGRect frame = self.frame;
                frame.origin.x = 0;
                NSLog(@"zll---self.window1=%@",NSStringFromCGRect(frame));
                self.frame = frame;
            }];
          
            break;
        }
        case ButtonDirectionRight:
        {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.frame;
                frame.origin.x = WINDOWS.width - self.frame.size.width;
                NSLog(@"zll---self.window2=%@",NSStringFromCGRect(frame));
                self.frame = frame;
            }];
           
            break;
        }
        case ButtonDirectionTop:
        {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.frame;
                frame.origin.y =0;
                NSLog(@"zll---self.window3=%@",NSStringFromCGRect(frame));
                self.frame = frame;
            }];
          
            break;
        }
        case ButtonDirectionBottom:
        {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.frame;
                frame.origin.y = WINDOWS.height - self.frame.size.height;
                NSLog(@"zll---self.window4=%@",NSStringFromCGRect(frame));
                self.frame = frame;
            }];
           
            break;
        }
        default:
            break;
    }
     CGRect frame = self.frame;
    if(frame.origin.x<0){
        frame.origin.x = 0;
    }
    if(frame.origin.y<0){
        frame.origin.y=0;
    }
    if(frame.origin.x>WINDOWS.width - self.frame.size.width){
        frame.origin.x = WINDOWS.width - self.frame.size.width;
    }
    if(frame.origin.y>WINDOWS.height - self.frame.size.height){
        frame.origin.y = WINDOWS.height - self.frame.size.height;
    }
    self.frame = frame;
}

@end
