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
    [layout registerNib:[UINib nibWithNibName:@"PYBookShelfBackgroundView" bundle:nil] forDecorationViewOfKind:PYCollectionViewLayoutDecorationBackgroundViewKind];//PYBookShelfBackgroundView
    [layout registerNib:[UINib nibWithNibName:@"PYBookShelfDecorationView" bundle:nil] forDecorationViewOfKind:PYCollectionViewLayoutDecorationViewKind];

    if((self = [super initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout])) {
//        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookShelf_background"]];
        self.autoresizingMask = AUTORESIZING_WIDTH_AND_HEIGHT;
//        self.backgroundColor = [UIColor clearColor];
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
    return [[BookSource shareInstance] count]*3;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {    
    Book* book = [[BookSource shareInstance] bookAtIndex:(indexPath.item%8)];
    
    BookCell *cell = (BookCell*)[collectionView dequeueReusableCellWithReuseIdentifier:bookCellIndentifier forIndexPath:indexPath];
    cell.titleLabel.text = book.name;
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Book* book = [[BookSource shareInstance] bookAtIndex:indexPath.item];
    [self.bookShelfDelegate openBook:book];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(PYCollectionViewFlowLayout *)layout referenceSizeForDecorationViewForRow:(NSInteger)row inSection:(NSInteger)section {
    return CGSizeMake(self.frame.size.width, 30);
}

@end
