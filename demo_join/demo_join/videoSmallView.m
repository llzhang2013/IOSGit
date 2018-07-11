//
//  videoSmallView.m
//  demo_join
//
//  Created by zhanglili on 2018/7/11.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "videoSmallView.h"

@implementation videoSmallView

-(void)setLiveRenderView:(ILiveRenderView *)liveRenderView{
    liveRenderView.frame = CGRectMake(0, 0, 100, 150);
    [self addSubview:liveRenderView];
    _liveRenderView = liveRenderView;
}


@end
