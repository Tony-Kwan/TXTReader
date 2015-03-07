//
//  UIColor.m
//  TXTReader
//
//  Created by PYgzx on 15/3/7.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "UIColor+TXTReader.h"

@implementation UIColor(TXTReader)

+ (UIColor*) randomColor {
    return [UIColor colorWithRed:(CGFloat)(arc4random()%255)/255.f green:(CGFloat)(arc4random()%255)/255.f blue:(CGFloat)(arc4random()%255)/255.f  alpha:1.0f];
}

@end
