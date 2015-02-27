//
//  TextViewController.m
//  TXTReader
//
//  Created by 关仲贤 on 15/2/25.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "TextViewController.h"
#import "PYUtils.h"


#define VERTICAL_INSET 20
#define HORIZONTAL_INSET 10

@interface TextViewController ()

@end

@implementation TextViewController

- (id) initWithText:(NSAttributedString*)text color:(UIColor *)color andFont:(UIFont *)font {
    if((self = [super init])) {
        self.view.backgroundColor = [[GlobalSettingAttrbutes shareSetting] skin][1];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textColor = [[GlobalSettingAttrbutes shareSetting] skin][0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.textLabel.font = font;
        self.textLabel.attributedText = text;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentNatural;
        self.textLabel.clipsToBounds = NO;
        self.textLabel.layer.masksToBounds = NO;
        [self.view addSubview:self.textLabel];
        
        WS(weakSelf);
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view).offset(HORIZONTAL_INSET);
            make.right.equalTo(weakSelf.view).offset(-HORIZONTAL_INSET);
            make.top.equalTo(weakSelf.view).offset(VERTICAL_INSET);
            make.bottom.equalTo(weakSelf.view).offset(-VERTICAL_INSET);
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.textLabel.backgroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setTextColor:(UIColor *)textColor andBackgoundColor:(UIColor *)bgColor {
    [UIView animateWithDuration:1.5 animations:^{
        self.textLabel.textColor = textColor;
        self.view.backgroundColor = bgColor;
    }];
}

@end
