//
//  PYPATHButtonItem.h
//  PathStyleButton
//
//  Created by PYgzx on 15/3/28.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYPATHButtonItem : UIButton

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic, assign) CGPoint p1;
@property (nonatomic, assign) CGPoint p2;
@property (nonatomic, assign) CGPoint p3;


- (id) initWithImage:(UIImage*)image startPoint:(CGPoint)startPoint endPoitn:(CGPoint)endPoint;

- (void) startShowAnimationWithdelay:(CGFloat)delay;
- (void) startHideAnimationWithdelay:(CGFloat)delay;

@end
