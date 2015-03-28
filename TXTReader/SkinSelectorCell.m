//
//  SkinSelectorCell.m
//  TXTReader
//
//  Created by 关仲贤 on 15/2/26.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "SkinSelectorCell.h"
#import "GlobalSettingAttrbutes.h"

@implementation SkinSelectorCell

- (id) initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.text = @"文字";
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textLabel];
        
        self.layer.masksToBounds = self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.layer.borderWidth = 5;
    self.layer.borderColor = selected ? APP_TINTCOLOR.CGColor : [UIColor clearColor].CGColor;
}

@end
