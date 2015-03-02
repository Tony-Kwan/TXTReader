//
//  UINavigationController+Animation.h
//  VisionCut
//
//  Created by 关仲贤 on 15/1/6.
//  Copyright (c) 2015年 dji. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CONTROLLER_ANIMATION_DURATION 0.3

typedef void(^AnimationCompleteBlock)(void);

@interface UINavigationController (CustomAnimation)

- (void)customMoveInPushViewController:(UIViewController *)viewController from:(NSString*)dir;
- (void)customMoveInPopViewControllerFrom:(NSString*)dir;
- (void) customPushViewComtroller:(UIViewController*)viewController from:(NSString*)dir;
- (void)customPopViewControllerFrom:(NSString*)dir;
- (void)customPopToRootViewControllerFrom:(NSString*)dir;
- (void)customRevealPopViewControllerFrom:(NSString*)dir;

- (void) printViewControllers;

@end
