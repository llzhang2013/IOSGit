//
//  suspandView.h
//  demo_join
//
//  Created by zhanglili on 2018/7/3.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WINDOWS [UIScreen mainScreen].bounds.size
#define NavigationBarHeight 0
#define TabBarHeight 0
typedef NS_ENUM(NSInteger,ButtonDirection){
    ButtonDirectionLeft    =0,
    ButtonDirectionRight   =1,
    ButtonDirectionTop     =3,
    ButtonDirectionBottom  =4
};


@protocol SuspendCustomViewDelegate <NSObject>
@optional
- (void)suspendCustomViewClicked:(id)sender point:(CGPoint)point;
@end

typedef NS_ENUM(NSInteger,FramMode){
    SmallFrame  =0,
    BigFrame    =1,
    NoneFrame   = 2
};

@interface suspandView : UIView

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat smallWidth;
@property (nonatomic, assign) CGFloat smallHeight;
@property (nonatomic, assign) CGFloat bigWidth;
@property (nonatomic, assign) CGFloat bigHeight;
@property(nonatomic,copy) NSDictionary *userInfo;

@property (nonatomic, weak) id<SuspendCustomViewDelegate> suspendDelegate;

@property (nonatomic, strong) UIView *buttonBKView;//通话过程中
@property (nonatomic, strong) UIView *waitingAccepetView;//等待对方接受

@property (nonatomic, assign) FramMode mode;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) UIView *smallRenderView;
@property (nonatomic, strong) UIWindow *myWindow;
@property (nonatomic, strong) UIViewController *myController;

-(void)initWithController:(UIViewController *)viewController rootView:(UIView *)rootView;
-(void)showActivity;
-(void)makeLivingButtonView;
-(void)showCameraView:(BOOL)isMaster;


@end
