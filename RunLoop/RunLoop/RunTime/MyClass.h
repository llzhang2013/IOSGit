//
//  MyClass.h
//  RunLoop
//
//  Created by zhanglili on 2018/8/21.
//  Copyright © 2018年 zhanglili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject<NSCopying,NSCoding>
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, copy) NSString *string;
- (void)method1;
- (void)method2;
+ (void)classMethod1;

@end
