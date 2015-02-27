//
//  BookShelfTableView.h
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookSource.h"
#import "TableCell.h"
#import "PYUtils.h"
#import "BookShelfDelegate.h"

@interface BookShelfTableView : UICollectionView
<
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, weak) id<BookShelfDelegate> bookShelfDelegate;

@end
