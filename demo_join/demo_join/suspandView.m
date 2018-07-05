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

-(void)setMode:(FramMode)mode{
    if(mode==SmallFrame){
        self.frame = CGRectMake(0, 0, _smallWidth, _smallHeight);
        self.superview.frame = CGRectMake(_bigWidth-_smallWidth, 0, _smallWidth, _smallHeight);
        [self.buttonBKView removeFromSuperview];
        
    }else if(mode==BigFrame){
        self.frame = CGRectMake(0, 0, _bigWidth, _bigHeight);
        self.superview.frame = CGRectMake(0, 0, _bigWidth, _bigHeight);
        [self addButtons];
    }
    _mode = mode;
}

- (void)initWithSuspendType:(NSString *)suspendType{
    [self addButtons];
}

-(void)addButtons{
    if(self.buttonBKView){
        [self addSubview:self.buttonBKView];
        return;
    }
    self.buttonBKView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-100, _viewWidth, 100)];
    self.buttonBKView.backgroundColor = [UIColor redColor];
    [self addSubview:self.buttonBKView];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    button.tag=100;
    [button setTitle:@"收起" forState:UIControlStateNormal];
   // [button addTarget:self action:@selector(smallView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(60, 0, 50, 50)];
    [button1 setTitle:@"上麦" forState:UIControlStateNormal];
    button1.tag=101;
    //[button1 addTarget:self action:@selector(upToVideo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(120, 0, 100, 50)];
    button2.tag = 102;
    [button2 setTitle:@"切换摄像头" forState:UIControlStateNormal];
   // [button2 addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(230, 0, 50, 50)];
    button3.tag = 103;
    [button3 setTitle:@"结束" forState:UIControlStateNormal];
    [self.buttonBKView addSubview:button];
    [self.buttonBKView addSubview:button1];
    [self.buttonBKView addSubview:button2];
    [self.buttonBKView addSubview:button3];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch=[touches anyObject];
    _startPoint=[touch locationInView:_rootView];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(_mode==BigFrame){
        return;
    }
    [super touchesMoved:touches withEvent:event];
    UITouch *touch=[touches anyObject];
    CGPoint currentPoint=[touch locationInView:_rootView];

    self.superview.center =currentPoint;
    
    
//    UITouch *touch = [touches anyObject];
//
//    //求偏移量 = 手指当前点的X - 手指上一个点的X
//    CGPoint currentPoint = [touch locationInView:self.superview];
//    CGPoint prePoint = [touch previousLocationInView:self.superview];
//
//    NSLog(@"zll--currentPoint = %@", NSStringFromCGPoint(currentPoint));
//    NSLog(@"zll--prePiont = %@", NSStringFromCGPoint(prePoint));
//
//    CGFloat offSetX = currentPoint.x - prePoint.x;
//    CGFloat offSetY = currentPoint.y - prePoint.y;
//
//    //平移
//    self.superview.transform = CGAffineTransformTranslate(self.superview.transform, offSetX, offSetY);
//    NSLog(@"zll--self.superview=%@",NSStringFromCGRect(self.superview.frame));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
   
    

    UITouch *touch=[touches anyObject];
    CGPoint currentPoint=[touch locationInView:_rootView];
     NSLog(@"zll--currentPointEnd=%@",NSStringFromCGPoint(currentPoint));
    
    if ((pow((_startPoint.x-currentPoint.x), 2)+pow((_startPoint.y-currentPoint.y), 2))<1) {
        if ([self.suspendDelegate respondsToSelector:@selector(suspendCustomViewClicked:)]) {
            [self.suspendDelegate  suspendCustomViewClicked:self];

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
