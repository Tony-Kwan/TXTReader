//
//  BookCoverView.m
//  ArcFlipAnimation
//
//  Created by 关仲贤 on 15/3/3.
//  Copyright (c) 2015年 臧其龙. All rights reserved.
//

#import "BookCoverView.h"

@interface BookCoverView() {
    CAGradientLayer *shadowLayer;
}

@end

@implementation BookCoverView

- (id) initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        shadowLayer = [CAGradientLayer layer];
        shadowLayer.frame = self.bounds;
        shadowLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor,
                               (__bridge id)[UIColor whiteColor].CGColor];
        shadowLayer.startPoint = CGPointMake(0, 0.5);
        shadowLayer.endPoint = CGPointMake(1, 0.5);
        shadowLayer.opacity = 0.0;
        
        self.coverView = [[UIImageView alloc] init];
        self.coverView.layer.anchorPoint = CGPointMake(0, 0.5);
        self.coverView.frame = self.bounds;
        self.coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.coverView.layer.transform = [self transform3D];
        self.coverView.layer.contents = (id)[UIImage imageNamed:@"bookCover"].CGImage;
        self.coverView.layer.contentsGravity = kCAGravityResizeAspect;
        [self.coverView.layer addSublayer:shadowLayer];
        [self addSubview:self.coverView];
    }
    return self;
}

- (CATransform3D)transform3D
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/700;
    return transform;
}

- (void) startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.toValue = @(-M_PI);
    animation.duration = 3.f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.coverView.layer addAnimation:animation forKey:@"rotation"];
    
    CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    shadowAnimation.toValue = @(0.4);
    shadowAnimation.duration = 3.f;
    shadowAnimation.fillMode = kCAFillModeForwards;
    shadowAnimation.removedOnCompletion = NO;
    [shadowLayer addAnimation:shadowAnimation forKey:@"opacity"];
}

//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self startAnimation];
//}

@end
