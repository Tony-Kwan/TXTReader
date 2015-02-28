//
//  VEMessageView.m
//
//  Created by 关仲贤 on 15/1/12.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "VEMessageView.h"
#import "PYUtils.h"

@interface VEMessageView()

@property (nonatomic, strong) UILabel *otherMessageLabel;
@property (nonatomic) BOOL animating;

@end

@implementation VEMessageView

- (id) initWithMessage:(NSString *)message andOtherMessage:(NSString *)otherMessage {
    self = [super init];
    if(self) {
        self.layer.cornerRadius = 4.0f;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        _messageLabel = [PYUtils customLabelWithText:message fontSize:20 color:[UIColor whiteColor]];
        if(otherMessage) {
            UIView *contentView = [[UIView alloc] init];
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:contentView];
            [self addConstraints:[PYUtils centerXYConstraintWithItem:contentView toItem:self]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
            
            _otherMessageLabel = [PYUtils customLabelWithText:otherMessage fontSize:14 color:[UIColor whiteColor]];
            [contentView addSubview:_messageLabel];
            [contentView addSubview:_otherMessageLabel];
            
            [contentView addConstraint:[PYUtils centerXConstraintWithItem:_messageLabel toItem:contentView]];
            [contentView addConstraint:[PYUtils centerXConstraintWithItem:_otherMessageLabel toItem:contentView]];
            
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_messageLabel]-8-[_otherMessageLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel, _otherMessageLabel)]];
            
        }
        else {
            [self addSubview:_messageLabel];
            
            [self addConstraints:[PYUtils centerXYConstraintWithItem:_messageLabel toItem:self]];
        }
    }
    return self;
}

- (void) dealloc {
    NSLog(@"VEMessageView dealloc");
}

#pragma mark - public
- (void) show {
    if (self.animating) {
        return;
    }
    self.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.animating = YES;
    self.layer.opacity = 0.0;
    self.hidden = NO;
    [UIView animateWithDuration:MESSAGEVIEW_APPEAR_DURATION delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.layer.opacity = 1.0;
    } completion:^(BOOL finished) {
        [self hide];
    }];
}

- (void)setMessageLabelText:(NSString *)text
{
    if (self.animating) {
        return;
    }
    self.messageLabel.text = text;
}

#pragma mark - timer
- (void) hide {
    [UIView animateWithDuration:MESSAGEVIEW_APPEAR_DURATION/2 delay:MESSAGEVIEW_APPEAR_TIME options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.05, 0.05);
        self.layer.opacity = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.animating = NO;
//        [self removeFromSuperview];
    }];
    
}

@end
