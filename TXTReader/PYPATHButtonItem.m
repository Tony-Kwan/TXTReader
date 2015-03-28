//
//  PYPATHButtonItem.m
//  PathStyleButton
//
//  Created by PYgzx on 15/3/28.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "PYPATHButtonItem.h"

#define POINT_1_FACTOR 0.5f
#define POINT_2_FACTOR 1.4f
#define POINT_3_FACTOR 0.9f
#define ANIMATION_DURATION 0.5f

@implementation PYPATHButtonItem

- (id) initWithImage:(UIImage *)image startPoint:(CGPoint)startPoint endPoitn:(CGPoint)endPoint {
    if(self = [super init]) {
        self.startPoint = startPoint;
        self.endPoint = endPoint;
        
        [self setImage:image forState:UIControlStateNormal];
        self.backgroundColor = [UIColor clearColor];
        [self sizeToFit];
        
        [self configurePoints];
        
    }
    return self;
}

- (void) configurePoints {
    CGFloat x = (_endPoint.x - _startPoint.x);
    CGFloat y = (_endPoint.y - _startPoint.y);
    
    self.p1 = CGPointMake(self.startPoint.x + x*POINT_1_FACTOR, self.startPoint.y + y*POINT_1_FACTOR);
    self.p2 = CGPointMake(self.startPoint.x + x*POINT_2_FACTOR, self.startPoint.y + y*POINT_2_FACTOR);
    self.p3 = CGPointMake(self.startPoint.x + x*POINT_3_FACTOR, self.startPoint.y + y*POINT_3_FACTOR);
}

- (NSString*) description {
    return [NSString stringWithFormat:@"PYPATHButtonItem %f %f", self.endPoint.x, self.endPoint.y];
}

#pragma mark - public
- (void) startShowAnimationWithdelay:(CGFloat)delay {
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:M_PI],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = ANIMATION_DURATION;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.3],
                                [NSNumber numberWithFloat:.4], nil];
    
    CAKeyframeAnimation *pos = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pos.duration = ANIMATION_DURATION;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.startPoint.x, self.startPoint.y);
    CGPathAddLineToPoint(path, NULL, self.p1.x, self.p1.y);
//    CGPathMoveToPoint(path, NULL, self.p1.x, self.p1.y);
    CGPathAddLineToPoint(path, NULL, self.p2.x, self.p2.y);
    CGPathAddLineToPoint(path, NULL, self.p3.x, self.p3.y);
    CGPathAddLineToPoint(path, NULL, self.endPoint.x, self.endPoint.y);
    pos.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:pos, rotateAnimation, nil];
    animationgroup.beginTime = CACurrentMediaTime() + delay;
    animationgroup.duration = ANIMATION_DURATION;
    animationgroup.fillMode = kCAFillModeBoth;
    animationgroup.removedOnCompletion = NO;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationgroup.delegate = self;
    
    [self.layer addAnimation:animationgroup forKey:@"show"];
    self.center = _endPoint;
}

- (void) startHideAnimationWithdelay:(CGFloat)delay {
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:M_PI*2],[NSNumber numberWithFloat:0.f], nil];
    rotateAnimation.duration = ANIMATION_DURATION;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.0],
                                [NSNumber numberWithFloat:.4],
                                [NSNumber numberWithFloat:.5], nil];
    
    CAKeyframeAnimation *pos = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    pos.beginTime = CACurrentMediaTime() + delay;
    pos.duration = ANIMATION_DURATION;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.endPoint.x, self.endPoint.y);
    CGPathAddLineToPoint(path, NULL, self.p2.x, self.p2.y);
    CGPathAddLineToPoint(path, NULL, self.startPoint.x, self.startPoint.y);
    pos.removedOnCompletion = NO;
    pos.fillMode = kCAFillModeForwards;
    pos.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:pos, rotateAnimation, nil];
    animationgroup.beginTime = CACurrentMediaTime() + delay;
    animationgroup.duration = ANIMATION_DURATION;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationgroup.removedOnCompletion = NO;
    animationgroup.delegate = self;
    
    [self.layer addAnimation:animationgroup forKey:@"hide"];
    self.center = _startPoint;
}

@end
