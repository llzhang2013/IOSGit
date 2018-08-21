//
//  YNConversionListViewController.h
//  YNHospitalUser
//
//  Created by zhanglili on 2017/8/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNIMModel.h"

@interface YNConversionListViewController : UIViewController{
@protected
  __weak CLSafeMutableArray   *_conversationList;
}
@property(nonatomic,assign)BOOL isFirst;
+(instancetype)initWithController;
- (void)getConversionList;
- (void)viewDidAppear:(BOOL)animated;
@end
