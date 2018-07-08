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
- (void)suspendCustomViewClicked:(id)sender point:(CGPoint)point;
@end

typedef NS_ENUM(NSInteger,FramMode){
    SmallFrame  =0,
    BigFrame    =1,
};

@interface suspandView : UIView

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat smallWidth;
@property (nonatomic, assign) CGFloat smallHeight;
@property (nonatomic, assign) CGFloat bigWidth;
@property (nonatomic, assign) CGFloat bigHeight;

@property (nonatomic, weak) id<SuspendCustomViewDelegate> suspendDelegate;
@property (nonatomic, strong) UIView *buttonBKView;
@property (nonatomic, assign) FramMode mode;
@property (nonatomic, strong) UIView *rootView;
-(void)initSelf;

@end
