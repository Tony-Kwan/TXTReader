//
//  PYAnimator.h
//  TXTReader
//
//  Created by PYgzx on 15/3/7.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BookCoverView.h"

@interface PYAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGRect originFrame;

- (id) initWithOriginFrame:(CGRect)frame;

@end
