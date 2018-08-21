//
//  NSString+ThreeDES.h
//  3DE
//
//  Created by Brandon Zhu on 31/10/2012.
//  Copyright (c) 2012 Brandon Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreeDES : NSObject
+ (NSString *)encrypt:(NSString *)plainText withKey:(NSData *)keyData;
+ (NSString *)decrypt:(NSString *)encryptText withKey:(NSData *)data;
@end
