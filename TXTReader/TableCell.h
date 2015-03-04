//
//  TableCell.h
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface TableCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *charCountLabel;

- (void) configureCellWithBook:(Book*)book;

@end
