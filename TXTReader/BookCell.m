//
//  BookCellCollectionViewCell.m
//  CollectionViewTest
//
//  Created by 关仲贤 on 15/2/3.
//  Copyright (c) 2015年 Tony-Kwan. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "BookCell.h"
#import "PYUtils.h"

@interface BookCell() {
    
}

@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation BookCell

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookCover"]];
        self.coverImageView.frame = self.bounds;
        self.coverImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.coverImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/7, frame.size.width, 16)];
        self.titleLabel.text = @"no name";
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.clipsToBounds = NO;
        self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UIImage*) getCoverImage {
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
