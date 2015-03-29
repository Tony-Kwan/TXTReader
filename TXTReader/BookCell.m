//
//  BookCellCollectionViewCell.m
//  CollectionViewTest
//
//  Created by 关仲贤 on 15/2/3.
//  Copyright (c) 2015年 Tony-Kwan. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "BookCell.h"
#import "PYUtils.h"

@interface BookCell() {
    
}

@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation BookCell

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        
        self.coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookCover"]];
        self.coverImageView.frame = self.bounds;
        self.coverImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.coverImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/7, frame.size.width, 16)];
        self.titleLabel.text = @"no name";
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.clipsToBounds = NO;
        self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnDelete setImage:[UIImage imageNamed:@"btn-remove"] forState:UIControlStateNormal];
        [self.btnDelete addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnDelete];
        [self.btnDelete sizeToFit];
        
        self.btnDelete.frame = CGRectMake(CGRectGetMaxX(self.bounds)-CGRectGetWidth(self.btnDelete.frame), 0, CGRectGetWidth(self.btnDelete.frame), CGRectGetHeight(self.btnDelete.frame));
        
    }
    return self;
}

#pragma mark - public
- (UIImage*) getCoverImage {
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void) startAnimating {
    CGFloat radius = M_PI/120.f;
    CGFloat duration = 0.3;
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = @[
                               @0.f,
                               @(radius),
                               @0.f,
                               @(-radius),
                               @0.f
                               ];
    rotateAnimation.duration = duration;
    
    CGPoint center = self.center;
    CGFloat offsetX = arc4random()%2;
    CGFloat offsetY = arc4random()%2;
    CAKeyframeAnimation *pos = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pos.duration = duration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y);
    CGPathAddLineToPoint(path, NULL, center.x-offsetX, center.y-offsetY);
    CGPathAddLineToPoint(path, NULL, center.x, center.y);
    CGPathAddLineToPoint(path, NULL, center.x+offsetX, center.y-offsetY);
    CGPathAddLineToPoint(path, NULL, center.x, center.y);
    pos.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:pos, rotateAnimation, nil];
    animationgroup.duration = duration;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationgroup.delegate = self;
    animationgroup.repeatCount = HUGE_VALF;
    
    [self.layer addAnimation:animationgroup forKey:@"r"];
}

- (void) stopAnimating {
    [self.layer removeAllAnimations];
}


#pragma mark - event
- (void) clickDelete {
    if(self.delegate && [self.delegate respondsToSelector:@selector(bookCellDeleteButtonDidClick:)]) {
        [self.delegate bookCellDeleteButtonDidClick:self];
    }
}

@end
