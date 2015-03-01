//
//  TextViewController.m
//  TXTReader
//
//  Created by 关仲贤 on 15/2/25.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "TextViewController.h"
#import "PYUtils.h"


@interface TextViewController ()

@end

@implementation TextViewController

- (id) initWithText:(NSAttributedString*)text color:(UIColor *)color andFont:(UIFont *)font {
    if((self = [super init])) {
        self.view.backgroundColor = [[GlobalSettingAttrbutes shareSetting] skin][1];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textColor = [[GlobalSettingAttrbutes shareSetting] skin][0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = font;
        self.textLabel.numberOfLines = 0;
//        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.clipsToBounds = NO;
        self.textLabel.layer.masksToBounds = NO;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:self.textLabel];
        
//        WS(weakSelf);
//        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakSelf.view).offset(TEXTVIEW_HORIZONTAL_INSET);
//            make.right.equalTo(weakSelf.view).offset(-TEXTVIEW_HORIZONTAL_INSET);
//            make.top.equalTo(weakSelf.view).offset(TEXTVIEW_VERTICAL_INSET);
//            make.bottom.equalTo(weakSelf.view).offset(-TEXTVIEW_VERTICAL_INSET);
//        }];
        CGFloat labelWidth = [PYUtils screenWidth]-2*TEXTVIEW_HORIZONTAL_INSET;
        CGRect frame = CGRectMake(TEXTVIEW_HORIZONTAL_INSET, TEXTVIEW_VERTICAL_INSET, labelWidth, CGFLOAT_MAX);
        CGRect textRect = [text boundingRectWithSize:frame.size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
//        PrintCGRect(frame);
        PrintCGRect(textRect);
//        PYLog(@"=========");
        frame.size = textRect.size;
        self.textLabel.frame = frame;
        if(frame.size.width < labelWidth-TEXTVIEW_HORIZONTAL_INSET) {
        }
        else {
            self.textLabel.center = CGPointMake(self.view.center.x, self.textLabel.center.y);
        }
        self.textLabel.attributedText = text;
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
