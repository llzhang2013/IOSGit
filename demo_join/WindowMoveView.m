//
//  WindowMoveView.m
//  demo_join
//
//  Created by zhanglili on 2018/7/6.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "WindowMoveView.h"

@implementation WindowMoveView

-(void)initSelf{
    self.frame=CGRectMake(0,0,100,100);
    self.windowLevel=UIWindowLevelAlert+1;
    self.backgroundColor=[UIColor grayColor];
     [self makeKeyAndVisible];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch=[touches anyObject];
  
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    //求偏移量 = 手指当前点的X - 手指上一个点的X
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint prePoint = [touch previousLocationInView:self];
    
    NSLog(@"zhw---ccurrentPoint = %@", NSStringFromCGPoint(currentPoint));
    NSLog(@"zhw---prePiont = %@", NSStringFromCGPoint(prePoint));
    
    CGFloat offSetX = currentPoint.x - prePoint.x;
    CGFloat offSetY = currentPoint.y - prePoint.y;
    
    //平移
    self.transform = CGAffineTransformTranslate(self.transform, offSetX, offSetY);
   
}

@end
