//
//  PYStepper.m
//  CustonSteper
//
//  Created by PYgzx on 15/3/28.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "PYStepper.h"

#define BTN_WIDTH 44

@implementation PYStepper {
    UIButton *btnDec, *btnInc;
    UILabel *lbCount;
}

- (id) init {
    if(self = [super init]) {
        [self setup];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void) setup {
    self.layer.borderColor = self.tintColor.CGColor;
    self.layer.borderWidth = 1.f;
    self.layer.cornerRadius = 4.f;
    
    btnDec = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDec setTitle:@"-" forState:UIControlStateNormal];
    [btnDec setTitleColor:self.tintColor forState:UIControlStateNormal];
    btnDec.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btnDec setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btnDec addTarget:self action:@selector(clickDec) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDec];
    
    btnInc = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnInc setTitle:@"+" forState:UIControlStateNormal];
    [btnInc setTitleColor:self.tintColor forState:UIControlStateNormal];
    [btnInc setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    btnInc.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btnInc addTarget:self action:@selector(clickInc) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnInc];
    
    lbCount = [[UILabel alloc] init];
    lbCount.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    lbCount.textColor = [UIColor whiteColor];
    lbCount.textAlignment = NSTextAlignmentCenter;
    lbCount.layer.borderWidth = self.layer.borderWidth;
    lbCount.layer.borderColor = self.layer.borderColor;
    [self addSubview:lbCount];
    
    self.backgroundColor = btnInc.backgroundColor = btnDec.backgroundColor = lbCount.backgroundColor = [UIColor clearColor];
    
    _minimumValue = 15;
    _maximumValue = 22;
    _stepValue = 1;
    
    self.value = 17;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame;
    CGRect bounds = self.bounds;
    frame = CGRectMake(0, 0, BTN_WIDTH, CGRectGetHeight(bounds));
    btnDec.frame = frame;
    
    frame = CGRectMake(CGRectGetWidth(bounds)-BTN_WIDTH, 0, BTN_WIDTH, CGRectGetHeight(bounds));
    btnInc.frame = frame;
    
    frame = CGRectMake(BTN_WIDTH, 0, CGRectGetWidth(bounds)-2*BTN_WIDTH, CGRectGetHeight(bounds));
    lbCount.frame = frame;
}

#pragma mark - property
- (void) setValue:(double)value {
    _value = value;
    lbCount.text = [NSString stringWithFormat:@"Font Size: %.0f", _value];
    lbCount.font = [UIFont fontWithName:@"HelveticaNeue" size:_value];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    btnDec.enabled = _value > _minimumValue;
    btnInc.enabled = _value < _maximumValue;
}

- (void) setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.layer.borderColor = lbCount.layer.borderColor = self.tintColor.CGColor;
    [btnInc setTitleColor:self.tintColor forState:UIControlStateNormal];
    [btnDec setTitleColor:self.tintColor forState:UIControlStateNormal];
    
}

#pragma mark - event
- (void) clickDec {
    if(self.value > _minimumValue) {
        self.value -= _stepValue;
    }
}

- (void) clickInc {
    if(self.value < _maximumValue) {
        self.value += _stepValue;
    }
}

@end
