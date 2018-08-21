//
//  MyLabel.m
//  TIMChat
//
//  Created by zhanglili on 2017/9/20.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(actionShowMenu:)];
        [self addGestureRecognizer:longPressGestureRecognizer];
    }
    return self;
}

- (void)actionShowMenu:(UILongPressGestureRecognizer *)recoginzer{
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];  //成为第一响应
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:CGRectMake([recoginzer locationInView:self].x, [recoginzer locationInView:self].y, 0, 0) inView:self]; //设置menu显示位置
        [menu setMenuVisible:YES animated:YES];  //显示menu
    }
}

/*!
 *  允许成为第一响应
 */
- (BOOL)canBecomeFirstResponder{
    return YES;
}

/*!
 *  用于控制哪些命令显示在编辑菜单中
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (void)copy:(id)sender{
    [UIPasteboard generalPasteboard].string = self.text;
}


@end
