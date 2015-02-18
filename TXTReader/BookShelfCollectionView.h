//
//  BookShelfCollectionView.h
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtils.h"
#import "BookCell.h"
#import "PYCollectionViewFlowLayout.h"
#import "BookSource.h"

@interface BookShelfCollectionView : UICollectionView
<
UICollectionViewDelegate,
PYCollectionVieDelegateFlowLayout,
PYCollectionViewDateSource
>

@end
