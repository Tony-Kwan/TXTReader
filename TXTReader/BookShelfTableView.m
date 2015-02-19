//
//  BookShelfTableView.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "BookShelfTableView.h"

static NSString *tableCellIndentifier = @"tableCellIndentifier";

@implementation BookShelfTableView

- (id) init {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake([PYUtils screenWidth], 50);
    layout.sectionInset = UIEdgeInsetsMake(64 + 5, 0, 0, 0);
    layout.minimumInteritemSpacing = layout.minimumLineSpacing = 0;
    
    if((self = [super initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout])) {
        self.autoresizingMask = AUTORESIZING_WIDTH_AND_HEIGHT;
        self.backgroundColor = [UIColor brownColor];
        self.alwaysBounceVertical = YES;
        self.alwaysBounceHorizontal = NO;
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[TableCell class] forCellWithReuseIdentifier:tableCellIndentifier];
    }
    return self;
}

#pragma mark - collectionView delegate & dateSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[BookSource shareInstance] count];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.item >= [[BookSource shareInstance] count]) {
        return nil;
    }
    Book *book = [[BookSource shareInstance] bookAtIndex:indexPath.row];
    TableCell* cell = (TableCell*)[collectionView dequeueReusableCellWithReuseIdentifier:tableCellIndentifier forIndexPath:indexPath];
    cell.titleLabel.text = book.name;
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.bookShelfDelegate && [self.bookShelfDelegate respondsToSelector:@selector(openBook:)]) {
        Book *book = [[BookSource shareInstance] bookAtIndex:indexPath.item];
        [self.bookShelfDelegate openBook:book];
    }
}

@end
