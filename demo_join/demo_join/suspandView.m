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

@implementation SuspendView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder]touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder]touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder]touchesEnded:touches withEvent:event];
}

@end

@interface suspandView()
{
    AVPlayer *_player;
    
}
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) NSString *suspendViewType;
@end

@implementation suspandView

- (void)initWithSuspendType:(NSString *)suspendType{
    
    self.suspendViewType=[NSString stringWithFormat:@"%@",suspendType];
    [self createCustomOtherView];
}
//自定义界面
- (void)createCustomOtherView{
    if (!_customContentView) {
        _customContentView=[[SuspendView alloc]init];
        _customContentView.frame=CGRectMake(0, 0, self.viewWidth, self.viewHeight);
        _customContentView.backgroundColor=[UIColor grayColor];
        _customContentView.userInteractionEnabled=YES;
        [self addSubview:_customContentView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch=[touches anyObject];
    _startPoint=[touch locationInView:_rootView];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch=[touches anyObject];
    CGPoint currentPoint=[touch locationInView:_rootView];
 
    self.superview.center =currentPoint;
    
//    UITouch *touch = [touches anyObject];
//
//    //求偏移量 = 手指当前点的X - 手指上一个点的X
//    CGPoint currentPoint = [touch locationInView:self];
//    CGPoint prePoint = [touch previousLocationInView:self];
//
//    NSLog(@"zll--ccurrentPoint = %@", NSStringFromCGPoint(currentPoint));
//    NSLog(@"zll--prePiont = %@", NSStringFromCGPoint(prePoint));
//
//    CGFloat offSetX = currentPoint.x - prePoint.x;
//    CGFloat offSetY = currentPoint.y - prePoint.y;
//
//
//    //平移
//        self.superview.transform = CGAffineTransformTranslate(self.superview.transform, offSetX, offSetY);
    
   // self.superview.center=CGPointMake(<#CGFloat x#>, <#CGFloat y#>);
//
//    //平移
//  CGAffineTransform tt = CGAffineTransformTranslate(self.transform, offSetX, offSetY);
//  CGAffineTransformTranslate(self.transform, offSetX, offSetY);
//    self.transform = tt;
//
//
    
    
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

//    switch (direction) {
//        case ButtonDirectionLeft:
//        {
//
//            [UIView animateWithDuration:0.3 animations:^{
//                self.superview.center = CGPointMake(self.superview.frame.size.width/2, topOrButtom);
//            }];
//            if ([self.suspendDelegate respondsToSelector:@selector(dragToTheLeft)]) {
//                [self.suspendDelegate dragToTheLeft];
//            }
//            break;
//        }
//        case ButtonDirectionRight:
//        {
//            [UIView animateWithDuration:0.3 animations:^{
//                self.superview.center = CGPointMake(WINDOWS.width - self.superview.frame.size.width/2, topOrButtom);
//            }];
//            if ([self.suspendDelegate respondsToSelector:@selector(dragToTheRight)]) {
//                [self.suspendDelegate dragToTheRight];
//            }
//            break;
//        }
//        case ButtonDirectionTop:
//        {
//            [UIView animateWithDuration:0.3 animations:^{
//                self.superview.center = CGPointMake(leftOrRight, self.superview.frame.size.height/2+NavigationBarHeight);
//            }];
//            if ([self.suspendDelegate respondsToSelector:@selector(dragToTheTop)]) {
//                [self.suspendDelegate dragToTheTop];
//            }
//            break;
//        }
//        case ButtonDirectionBottom:
//        {
//            [UIView animateWithDuration:0.3 animations:^{
//                self.superview.center = CGPointMake(leftOrRight, WINDOWS.height - self.superview.frame.size.height/2-TabBarHeight);
//            }];
//            if ([self.suspendDelegate respondsToSelector:@selector(dragToTheBottom)]) {
//                [self.suspendDelegate dragToTheBottom];
//            }
//            break;
//        }
//        default:
//            break;
//    }

}



@end
