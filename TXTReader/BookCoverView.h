//
//  BookCoverView.h
//  ArcFlipAnimation
//
//  Created by 关仲贤 on 15/3/3.
//  Copyright (c) 2015年 臧其龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCoverView : UIView

@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, assign) CGFloat animateDuration;

- (void) startAnimation;

@end
