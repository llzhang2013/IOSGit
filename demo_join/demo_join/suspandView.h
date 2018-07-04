//
//  suspandView.h
//  demo_join
//
//  Created by zhanglili on 2018/7/3.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WINDOWS [UIScreen mainScreen].bounds.size

@protocol SuspendCustomViewDelegate <NSObject>
@optional
- (void)suspendCustomViewClicked:(id)sender;
- (void)dragToTheLeft;
- (void)dragToTheRight;
- (void)dragToTheTop;
- (void)dragToTheBottom;


@end


@interface SuspendView : UIView
@end

@interface suspandView : UIView

@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, weak) id<SuspendCustomViewDelegate> suspendDelegate;
@property (nonatomic, strong) SuspendView *customContentView;
@property (nonatomic, strong) UIView *buttonBKView;
- (void)initWithSuspendType:(NSString *)suspendType;

@end
