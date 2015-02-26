//
//  ToolBarView.m
//  TXTReader
//
//  Created by 关仲贤 on 15/2/26.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "ToolBarView.h"
#import "PYUtils.h"
#import <QuartzCore/QuartzCore.h>

@interface ToolBarView() {
    
}

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UIButton *btnSetting, *btnMenu;

@end

@implementation ToolBarView

- (void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat lenghts[2] = {5, 3};
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [WHITE_COLOR colorWithAlphaComponent:0.5].CGColor);
    CGContextSetLineDash(context, 0, lenghts, 2);
    CGContextMoveToPoint(context, 0, 44);
    CGContextAddLineToPoint(context, self.bounds.size.width, 44);
    CGContextStrokePath(context);    
}

- (id) initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setup];
    }
    return self;
}

- (void) setup {
    self.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.8];
    
    self.slider = [[UISlider alloc] init];
    [self.slider addTarget:self action:@selector(sliderValueDidChange) forControlEvents:UIControlEventValueChanged];
    self.slider.minimumTrackTintColor = [UIColor redColor];
    self.slider.maximumTrackTintColor = WHITE_COLOR;
    [self addSubview:self.slider];
    
    self.separator = [[UIView alloc] init];
    self.separator.backgroundColor = [WHITE_COLOR colorWithAlphaComponent:0.0];
    [self addSubview:self.separator];
    
    self.btnSetting = [PYUtils customButtonWith:@"Aa" target:self andAction:@selector(clickSetting)];
    [self addSubview:self.btnSetting];
    
    self.btnMenu = [PYUtils customButtonWith:@"Menu" target:self andAction:@selector(clickMenu)];
    [self addSubview:self.btnMenu];
    
    WS(weakSelf);
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf);
        make.height.equalTo(weakSelf).multipliedBy(0.5);
    }];
    [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
        make.centerY.equalTo(weakSelf);
    }];
    [_btnSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.separator);
        make.bottom.equalTo(weakSelf);
    }];
    [_btnMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf.separator);
    }];
}

#pragma mark - Event
- (void) sliderValueDidChange {
    
}

- (void) clickSetting {
    
}

- (void) clickMenu {
    
}

@end
