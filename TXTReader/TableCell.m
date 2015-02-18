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
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.autoresizingMask = AUTORESIZING_WIDTH_AND_HEIGHT;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.text = @"no name";
        [self addSubview:self.titleLabel];
    }
    return self;
}

@end
