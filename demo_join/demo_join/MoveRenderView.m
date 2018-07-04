//
//  MoveRenderView.m
//  demo_join
//
//  Created by zhanglili on 2018/7/2.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "MoveRenderView.h"

@implementation MoveRenderView

//当开始触摸屏幕的时候调用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
}

//触摸时开始移动时调用(移动时会持续调用)
//NSSet:无序
//NSArray:有序
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    
    UITouch *touch = [touches anyObject];
    
    //求偏移量 = 手指当前点的X - 手指上一个点的X
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint prePoint = [touch previousLocationInView:self];
    
    NSLog(@"ccurrentPoint = %@", NSStringFromCGPoint(currentPoint));
    NSLog(@"prePiont = %@", NSStringFromCGPoint(prePoint));
    
    CGFloat offSetX = currentPoint.x - prePoint.x;
    CGFloat offSetY = currentPoint.y - prePoint.y;
    
    //平移
    self.transform = CGAffineTransformTranslate(self.transform, offSetX, offSetY);
}

//当手指离开屏幕时调用
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
}

//当发生系统事件时就会调用该方法(电话打入,自动关机)
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
}

@end
