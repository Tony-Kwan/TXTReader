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
        self.titleLabel = [UILabel new];
        self.titleLabel.autoresizingMask = AUTORESIZING_WIDTH_AND_HEIGHT;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"no name";
        [self addSubview:self.titleLabel];
    }
    return self;
}

@end
