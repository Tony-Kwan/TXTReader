//
//  BookCellCollectionViewCell.h
//  CollectionViewTest
//
//  Created by 关仲贤 on 15/2/3.
//  Copyright (c) 2015年 Tony-Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookCell;

@protocol BookCellDelegate <NSObject>

- (void) bookCellDeleteButtonDidClick:(BookCell*)cell;

@end

@interface BookCell : UICollectionViewCell

@property (nonatomic, weak) id<BookCellDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *btnDelete;

- (UIImage*) getCoverImage;
- (void) startAnimating;
- (void) stopAnimating;

@end
