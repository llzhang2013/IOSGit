//
//  videoSmallView.m
//  demo_join
//
//  Created by zhanglili on 2018/7/11.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "videoSmallView.h"
#import "suspandView.h"

@interface videoSmallView()
@property (nonatomic, assign) CGPoint startPoint;
@end

@implementation videoSmallView

-(void)setLiveRenderView:(ILiveRenderView *)liveRenderView{
    liveRenderView.frame = CGRectMake(0, 0, 100, 150);
    [self addSubview:liveRenderView];
    _liveRenderView = liveRenderView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch=[touches anyObject];
    _startPoint=[touch locationInView:self.superview];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

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
        if ([self.delegate respondsToSelector:@selector(videoSmallViewClicked:point:)]) {
            [self.delegate  videoSmallViewClicked:self point:currentPoint];
            
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
