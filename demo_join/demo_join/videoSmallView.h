//
//  videoSmallView.h
//  demo_join
//
//  Created by zhanglili on 2018/7/11.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ILiveSDK/ILiveCoreHeader.h>

#define WINDOWS [UIScreen mainScreen].bounds.size

@protocol videoSmallViewDelegate <NSObject>
@optional
- (void)videoSmallViewClicked:(id)sender point:(CGPoint)point;
@end

@interface videoSmallView : UIView

@property(nonatomic,strong) ILiveRenderView *liveRenderView;
@property (nonatomic, weak) id<videoSmallViewDelegate> delegate;

@end
