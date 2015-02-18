//
//  BookCellCollectionViewCell.m
//  CollectionViewTest
//
//  Created by 关仲贤 on 15/2/3.
//  Copyright (c) 2015年 Tony-Kwan. All rights reserved.
//

#import "BookCell.h"
#import "PYUtils.h"

@implementation BookCell

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.text = @"no name";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.autoresizingMask = AUTORESIZING_WIDTH_AND_HEIGHT;
        [self addSubview:self.titleLabel];
    }
    return self;
}

@end
