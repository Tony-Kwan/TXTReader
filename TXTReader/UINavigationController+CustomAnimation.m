//
//  UINavigationController+Animation.m
//  VisionCut
//
//  Created by 关仲贤 on 15/1/6.
//  Copyright (c) 2015年 dji. All rights reserved.
//

#import "UINavigationController+CustomAnimation.h"
#import "PYUtils.h"


@implementation UINavigationController (CustomAnimation)

- (void)customMoveInPushViewController:(UIViewController *)viewController from:(NSString*)dir
{
    CATransition *transition = [CATransition animation];
    transition.duration = CONTROLLER_ANIMATION_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = [self adjustIOS7:dir];
    [self pushViewController:viewController animated:NO];
    [self.view.layer addAnimation:transition forKey:nil];
}

- (void)customMoveInPopViewControllerFrom:(NSString*)dir
{
    CATransition *transition = [CATransition animation];
    transition.duration = CONTROLLER_ANIMATION_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = [self adjustIOS7:dir];
    
    [self popViewControllerAnimated:NO];
    [self.view.layer addAnimation:transition forKey:nil];
}

- (void) customPushViewComtroller:(UIViewController*)viewController from:(NSString*)dir{
    CATransition *transition = [CATransition animation];
    transition.duration = CONTROLLER_ANIMATION_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = [self adjustIOS7:dir];
    
    [self pushViewController:viewController animated:NO];
    [self.view.layer addAnimation:transition forKey:nil];
    
}

- (void)customPopViewControllerFrom:(NSString*)dir
{
    CATransition *transition = [CATransition animation];
    transition.duration = CONTROLLER_ANIMATION_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = [self adjustIOS7:dir];
    [self popViewControllerAnimated:NO];
    [self.view.layer addAnimation:transition forKey:nil];
}

- (void)customPopToRootViewControllerFrom:(NSString*)dir {
    CATransition *transition = [CATransition animation];
    transition.duration = CONTROLLER_ANIMATION_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionReveal;
    transition.subtype = [self adjustIOS7:dir];
    [self.view.layer addAnimation:transition forKey:nil];
    [self popToRootViewControllerAnimated:NO];
    
}

- (void)customRevealPopViewControllerFrom:(NSString*)dir
{
    CATransition *transition = [CATransition animation];
    transition.duration = CONTROLLER_ANIMATION_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionReveal;
    transition.subtype = [self adjustIOS7:dir];
    
    [self popViewControllerAnimated:NO];
//    [self printViewControllers];
    [self.view.layer addAnimation:transition forKey:nil];
}

- (void) printViewControllers {
    for (UIViewController* vc in self.viewControllers) {
        NSLog(@"^_^ %@", vc);
    }
}

#pragma mark - private
- (NSString*) adjustIOS7:(NSString *)dir {
    if([PYUtils iOSVersionGreaterOrEqual_8]) {
        return dir;
    }
    
//    NSLog(@"before adajustios7: %@", dir);
    NSString *ret = dir;
    NSInteger flag = [PYUtils getCurrentOrientation];
    
    if(flag == UIDeviceOrientationUnknown) {
    }
    else if(flag == UIDeviceOrientationLandscapeLeft) {
        ret = [self turnLeft:dir];
    }
    else if(flag == UIDeviceOrientationLandscapeRight) {
        ret = [self turnRight:dir];
    }
    else if(flag == UIDeviceOrientationPortrait) {
        
    }
    else if(flag == UIDeviceOrientationPortraitUpsideDown) {
        
    }
//    NSLog(@"after adajustios7: %@  |  ori = %@", ret, @(flag));
    return ret;
}

- (NSString*) turnLeft:(NSString*)dir {
    if(dir == kCATransitionFromTop) {
        return kCATransitionFromLeft;
    }
    else if(dir == kCATransitionFromBottom) {
        return kCATransitionFromRight;
    }
    else if(dir == kCATransitionFromLeft) {
        return kCATransitionFromBottom;
    }
    else {
        return kCATransitionFromTop;
    }
}

- (NSString*) turnRight:(NSString*)dir {
    if(dir == kCATransitionFromTop) {
        return kCATransitionFromRight;
    }
    else if(dir == kCATransitionFromBottom) {
        return kCATransitionFromLeft;
    }
    else if(dir == kCATransitionFromLeft) {
        return kCATransitionFromTop;
    }
    else {
        return kCATransitionFromBottom;
    }
}



@end
