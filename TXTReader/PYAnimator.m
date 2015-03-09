//
//  PYAnimator.m
//  TXTReader
//
//  Created by PYgzx on 15/3/7.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "PYAnimator.h"
#import "ReadViewController.h"
#import "PYUtils.h"

@interface PYAnimator() {
    CGFloat _scaleX, _scaleY;
}

@end

@implementation PYAnimator

- (id) initWithOriginFrame:(CGRect)frame {
    if((self = [super init])) {
        self.originFrame = frame;
        _scaleX = frame.size.width / [[UIScreen mainScreen] bounds].size.width;
        _scaleY = frame.size.height / [[UIScreen mainScreen] bounds].size.height;
    }
    return self;
}

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 2.f;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UINavigationController *toVC = (UINavigationController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    ReadViewController *readVC = (ReadViewController*)toVC.viewControllers[0];
    
    CGRect finalFrame = UIScreenFrame;//[transitionContext finalFrameForViewController:toVC];
    
    toVC.view.frame = finalFrame;
    toVC.view.center = CGPointMake(self.originFrame.origin.x + self.originFrame.size.width/2, self.originFrame.origin.y+self.originFrame.size.height/2);
    toVC.view.transform = CGAffineTransformMakeScale(_scaleX, _scaleY);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    BookCoverView* coverView = [[BookCoverView alloc] initWithFrame:UIScreenFrame];
    [toVC.view addSubview:coverView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    coverView.animateDuration = duration;
    if(readVC.coverImage) {
        coverView.coverView.image = readVC.coverImage;
    }
    [coverView startAnimation];
    [UIView animateWithDuration:duration animations:^{
        toVC.view.center = UIScreenCenter;
        toVC.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        coverView.hidden = YES;
        [coverView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
