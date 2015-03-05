//
//  PYCollectionViewFlowLayout.h
//  CollectionViewTest
//
//  Created by 关仲贤 on 15/2/3.
//  Copyright (c) 2015年 Tony-Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtils.h"

#define ZOOM_FACTOR 1.2

static NSString* PYCollectionViewLayoutDecorationViewKind = @"PYCollectionViewLayoutDecorationViewKind";
static NSString* PYCollectionViewLayoutDecorationBackgroundViewKind = @"PYCollectionViewLayoutDecorationBackgroundViewKind";

@class PYCollectionViewFlowLayout;

@interface PYCollectionViewFlowLayout : UICollectionViewFlowLayout
<
UIGestureRecognizerDelegate
>

@property (nonatomic, assign) CGFloat scrollSpeed;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

/*======================================================================================*/
/*======================================================================================*/

@protocol PYCollectionViewDateSource <UICollectionViewDataSource>

@optional
- (BOOL) collectionView:(UICollectionView*)collectionView canMoveIndexPath:(NSIndexPath*)indexPath;
- (BOOL) collectionView:(UICollectionView*)collectionView canMoveIndexPathFrom:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath;

- (void) collectionView:(UICollectionView*)collectionView itemAtIndexPath:(NSIndexPath*)fromeIndexPath willMoveToIndexPath:(NSIndexPath*)toIndexPath;
- (void) collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath;

@end

/*======================================================================================*/
/*======================================================================================*/

@protocol PYCollectionVieDelegateFlowLayout <UICollectionViewDelegateFlowLayout>
@optional
- (void) collectionView:(UICollectionView*)collectionView layout:(PYCollectionViewFlowLayout*)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath*)indexPath;
- (void) collectionView:(UICollectionView*)collectionView layout:(PYCollectionViewFlowLayout*)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath*)indexPath;
- (void) collectionView:(UICollectionView*)collectionView layout:(PYCollectionViewFlowLayout*)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath*)indexPath;
- (void) collectionView:(UICollectionView*)collectionView layout:(PYCollectionViewFlowLayout*)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath*)indexPath;

- (UIOffset)collectionView:(UICollectionView*)collectionView layout:(PYCollectionViewFlowLayout*)layout decorationViewAdjustmentForRow:(NSInteger)row inSection:(NSInteger)section;

@required
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(PYCollectionViewFlowLayout*)layout referenceSizeForDecorationViewForRow:(NSInteger)row inSection:(NSInteger)section;

@end