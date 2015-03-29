//
//  PYPATHButton.m
//  PathStyleButton
//
//  Created by PYgzx on 15/3/28.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "PYPATHButton.h"
#import "PYPATHButtonItem.h"


#define START_RADIUS (0)
#define END_RADIUS (M_PI/2)
#define FARTHEST_DISTANCE (100)


static CGPoint RotateCGPointAroundCenter(CGPoint point, CGPoint center, float angle)
{
    CGAffineTransform translation = CGAffineTransformMakeTranslation(center.x, center.y);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation);
    return CGPointApplyAffineTransform(point, transformGroup);
}

CG_INLINE CGPoint CGPointAdd(CGPoint p1, CGPoint p2) {
    return CGPointMake(p1.x+p2.x, p1.y+p2.y);
}

@interface PYPATHButton() {

}

@property (nonatomic, assign) BOOL hiddenButtonItems;

@property (nonatomic, strong) UIButton *btnMain;
@property (nonatomic, strong) NSMutableArray *buttonItems;
@property (nonatomic, strong) UIImageView *shadowView;

@end

@implementation PYPATHButton

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    if ([self pointInside:point withEvent:event]) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return nil;
    }
    return nil;
}

- (id) initWithMainImage:(UIImage *)mainImage buttonItems:(NSArray *)items {
    if(self = [super init]) {
        _hiddenButtonItems = YES;
        
        
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor clearColor];
        
        self.shadowView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.shadowView.contentMode = UIViewContentModeScaleToFill;
        self.shadowView.alpha = 0.0f;
        [self addSubview:self.shadowView];
        [self sendSubviewToBack:self.shadowView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        self.shadowView.userInteractionEnabled = YES;
        [self.shadowView addGestureRecognizer:tap];
        
        self.btnMain = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnMain addTarget:self action:@selector(clickMain) forControlEvents:UIControlEventTouchUpInside];
        [self.btnMain setImage:mainImage forState:UIControlStateNormal];
        self.btnMain.backgroundColor = [UIColor clearColor];
        [self.btnMain sizeToFit];
        [self addSubview:self.btnMain];
        
        CGRect frame;
        CGPoint center;
        frame = self.btnMain.frame;
//        center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - CGRectGetHeight(frame)/2.f - 10.f);
        center = CGPointMake(CGRectGetMaxX(self.frame)-CGRectGetWidth(frame)/2-10.f, CGRectGetMaxY(self.frame)-CGRectGetHeight(frame)/2-10.f);
        self.btnMain.center = center;
        
        CGPoint firstPoint = CGPointAdd(self.btnMain.center, CGPointMake(-FARTHEST_DISTANCE, 0));
        CGFloat tmpRadius = (END_RADIUS - START_RADIUS) / ((CGFloat)items.count - 1.f);
        self.buttonItems = [NSMutableArray arrayWithCapacity:items.count];
        for (NSUInteger idx = 0; idx < items.count; idx++) {
            UIImage *image = items[idx];
            CGFloat radius = START_RADIUS + tmpRadius * (idx * 1.f);
            center = RotateCGPointAroundCenter(firstPoint, self.btnMain.center, radius);

            PYPATHButtonItem *btn = [[PYPATHButtonItem alloc] initWithImage:image startPoint:self.btnMain.center endPoitn:center];
            [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonItems addObject:btn];
            [self addSubview:btn];
            btn.center = self.btnMain.center;
        }
        
        [self bringSubviewToFront:self.btnMain];
        
    }
    return self;
}

#pragma mark - property
- (void) setHiddenButtonItems:(BOOL)hiddenButtonItems {
    BOOL flag = NO;
    for (PYPATHButtonItem* item  in self.buttonItems) {
        flag |= item.isAnimating;
    }
    if(flag) {
        return;
    }
    _hiddenButtonItems = hiddenButtonItems;
    [self hideButtonItems:_hiddenButtonItems];
}

#pragma mark - event
- (void) handleTap:(UITapGestureRecognizer*)tap {
    self.hiddenButtonItems = YES;
}

- (void) clickMain {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.hiddenButtonItems = !_hiddenButtonItems;
}

- (void) clickItem:(UIButton*)btn {
    if(self.delegate && [self.delegate respondsToSelector:@selector(PYPATHButtonDidClickAtIndex:)]) {
        [self.delegate PYPATHButtonDidClickAtIndex:[self.buttonItems indexOfObject:btn]];
    }
}

#pragma mark - private
- (void) hideButtonItems:(BOOL)hidden {    
    for (PYPATHButtonItem *btnItem in self.buttonItems) {
        NSUInteger idx = [self.buttonItems indexOfObject:btnItem];
        if(!hidden) {
            [btnItem startShowAnimationWithdelay:ITEM_ANIMATION_DELAY*idx];
        }
        else {
            [btnItem startHideAnimationWithdelay:ITEM_ANIMATION_DELAY*(self.buttonItems.count-idx)];
        }
    }
    
    [UIView animateWithDuration:0.5 + (self.buttonItems.count - 1)*ITEM_ANIMATION_DELAY animations:^{
        self.shadowView.alpha = (CGFloat)!hidden;
    }];
    
//    self.userInteractionEnabled = !hidden;
}

@end
