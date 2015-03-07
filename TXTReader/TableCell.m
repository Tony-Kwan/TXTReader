//
//  TableCell.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "TableCell.h"
#import "PYUtils.h"

@implementation TableCell

- (id) initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.f;
        self.layer.cornerRadius = 3.f;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:21];
        [self.contentView addSubview:self.titleLabel];
        
        self.typeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt_indicate"]];
        self.typeImageView.contentMode = UIViewContentModeScaleToFill;
        self.typeImageView.backgroundColor = CLEAR_COLOR;
        [self.contentView addSubview:self.typeImageView];
        
        self.progressLabel = [[UILabel alloc] init];
        self.progressLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        self.progressLabel.textColor = [UIColor grayColor];
        self.progressLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.progressLabel];
        
        self.charCountLabel = [[UILabel alloc] init];
        self.charCountLabel.textAlignment = NSTextAlignmentLeft;
        self.charCountLabel.textColor = [UIColor grayColor];
        self.charCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        [self.contentView addSubview:self.charCountLabel];
        
        WS(weakSelf);
        [_typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(weakSelf.contentView).offset(10);
            make.bottom.equalTo(weakSelf.contentView).offset(-10);
            make.width.equalTo(weakSelf.typeImageView.mas_height);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.typeImageView.mas_right).offset(10);
            make.top.equalTo(weakSelf.typeImageView).offset(2);
            make.right.equalTo(weakSelf.progressLabel.mas_left);
        }];
        [_charCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.titleLabel);
            make.left.equalTo(weakSelf.titleLabel).offset(4);
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(4);
        }];
        [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).offset(-8);
            make.centerY.equalTo(weakSelf.contentView);
            make.width.mas_equalTo(50);
        }];
    }
    return self;
}

#pragma mark - public
- (void) configureCellWithBook:(Book *)book {
    self.titleLabel.text = book.name;
    self.progressLabel.text = [NSString stringWithFormat:@"%.1f%%", ((CGFloat)book.lastReadOffset / (CGFloat)(book.length))*100.f];
    self.charCountLabel.text = [NSString stringWithFormat:@"%@字", @(book.content.length)];
}


@end
