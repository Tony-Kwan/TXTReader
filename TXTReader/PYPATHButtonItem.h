//
//  PYPATHButtonItem.h
//  PathStyleButton
//
//  Created by PYgzx on 15/3/28.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define POINT_1_FACTOR 0.5f
#define POINT_2_FACTOR 1.4f
#define POINT_3_FACTOR 0.9f
#define ANIMATION_DURATION 0.5f
#define ITEM_ANIMATION_DELAY 0.16f

@interface PYPATHButtonItem : UIButton

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic, assign) CGPoint p1;
@property (nonatomic, assign) CGPoint p2;
@property (nonatomic, assign) CGPoint p3;

@property (nonatomic, assign) BOOL isAnimating;


- (id) initWithImage:(UIImage*)image startPoint:(CGPoint)startPoint endPoitn:(CGPoint)endPoint;

- (void) startShowAnimationWithdelay:(CGFloat)delay;
- (void) startHideAnimationWithdelay:(CGFloat)delay;

@end
