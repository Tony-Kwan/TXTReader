//
//  BookShelfCollectionView.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "BookShelfCollectionView.h"

static NSString *bookCellIndentifier = @"bookCellIndentifier";

@implementation BookShelfCollectionView

- (id) init {
    PYCollectionViewFlowLayout *layout = [PYCollectionViewFlowLayout new];
    [layout registerNib:[UINib nibWithNibName:@"PYBookShelfDecorationView" bundle:nil] forDecorationViewOfKind:PYCollectionViewLayoutDecorationViewKind];
    
    if((self = [super initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout])) {
        self.autoresizingMask = AUTORESIZING_WIDTH_AND_HEIGHT;
        self.backgroundColor = [UIColor brownColor];
        self.alwaysBounceVertical = YES;
        self.alwaysBounceHorizontal = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[BookCell class] forCellWithReuseIdentifier:bookCellIndentifier];
    }
    return self;
}

#pragma mark - collectionview delegate & datasource
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
    
    Book* book = [[BookSource shareInstance] bookAtIndex:indexPath.item];
    
    BookCell *cell = (BookCell*)[collectionView dequeueReusableCellWithReuseIdentifier:bookCellIndentifier forIndexPath:indexPath];
    cell.titleLabel.text = book.name;
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(PYCollectionViewFlowLayout *)layout referenceSizeForDecorationViewForRow:(NSInteger)row inSection:(NSInteger)section {
    return CGSizeMake([PYUtils screenWidth], 30);
}

@end
