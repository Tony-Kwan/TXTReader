//
//  PYCollectionViewFlowLayout.m
//  CollectionViewTest
//
//  Created by 关仲贤 on 15/2/3.
//  Copyright (c) 2015年 Tony-Kwan. All rights reserved.
//

#import "PYCollectionViewFlowLayout.h"

static NSString* collectionViewKeyPath = @"collectionView";

typedef enum {
    PYScroll_UNKNOWN,
    PYScroll_UP,
    PYScroll_DOWN
}PYScrollDirection;

@interface UICollectionViewCell (CellImage)

- (UIImage*) getCellImage;

@end

@implementation UICollectionViewCell (CellImage)

- (UIImage*) getCellImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end

/*======================================================================================*/
/*======================================================================================*/

@interface PYCollectionViewFlowLayout()
<
UIGestureRecognizerDelegate
>
{
    
}

@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, assign) CGPoint currentViewCenter;
@property (nonatomic, assign) CGPoint panTranslationInCollectionView;
@property (nonatomic, assign) UIEdgeInsets scrollingTriggerEdgeInsets;
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, strong) NSDictionary *bookShelfRects;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) PYScrollDirection oldScrollDir;

@end

@implementation PYCollectionViewFlowLayout

- (id) init {
    self = [super init];
    if(self) {
        [self _setup];
    }
    return  self;
}

- (void) _setup {
    _oldScrollDir = PYScroll_UNKNOWN;
    _scrollSpeed = 300.f;
    _scrollingTriggerEdgeInsets = UIEdgeInsetsMake(10.0f, 50.0f, 50.0f, 40.0f);
    
    CGFloat width = 60;
    self.itemSize = CGSizeMake(width, width/9.0f*16.0f);
    self.sectionInset = _scrollingTriggerEdgeInsets;
    self.minimumLineSpacing = 40;
    self.minimumInteritemSpacing = 20;
    
    [self addObserver:self forKeyPath:collectionViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void) _setupCollectionView {
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _longPress.minimumPressDuration = 0.1;
    _longPress.delegate = self;
    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPress];
        }
    }
    
    [self.collectionView addGestureRecognizer:_longPress];
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _pan.delegate = self;
    [self.collectionView addGestureRecognizer:_pan];
    
//    // Useful in multiple scenarios: one common scenario being when the Notification Center drawer is pulled down
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActive:) name: UIApplicationWillResignActiveNotification object:nil];
}

- (void) _invalidateLayoutIfNeed {
    NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:self.currentView.center];
    NSIndexPath *preIndexPath = self.selectedIndexPath;
    
    if(!newIndexPath || [newIndexPath isEqual:preIndexPath]) {
        return;
    }
    
    if([self.dataSource respondsToSelector:@selector(collectionView:canMoveIndexPathFrom:toIndexPath:)]) {
        if(![self.dataSource collectionView:self.collectionView canMoveIndexPathFrom:preIndexPath toIndexPath:newIndexPath]) {
            return;
        }
    }
    
    self.selectedIndexPath = newIndexPath;
    
    if([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
        [self.dataSource collectionView:self.collectionView itemAtIndexPath:preIndexPath willMoveToIndexPath:newIndexPath];
    }
    
    __weak typeof (self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        __strong typeof (self) strongSelf = weakSelf;
        if(strongSelf) {
            [strongSelf.collectionView deleteItemsAtIndexPaths:@[preIndexPath]];
            [strongSelf.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
        }
    } completion:^(BOOL finished) {
        __strong typeof (self) strongSelf = weakSelf;
        if([strongSelf.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
            [strongSelf.dataSource collectionView:self.collectionView itemAtIndexPath:preIndexPath didMoveToIndexPath:newIndexPath];
        }
    }];
}

- (void) _setupScrollTimerInDirection:(PYScrollDirection)dir {
    _oldScrollDir = dir;
    [self _invalidatesScrollTimer];
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleScroll:)];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) _invalidatesScrollTimer {
    if(!self.timer.paused) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void) _applyLayoutAttributes:(UICollectionViewLayoutAttributes*)attr {
    if([attr.indexPath isEqual:self.selectedIndexPath]) {
        attr.hidden = YES;
    }
}

- (id<PYCollectionVieDelegateFlowLayout>)delegate {
    return (id<PYCollectionVieDelegateFlowLayout>)self.collectionView.delegate;
}

- (id<PYCollectionViewDateSource>)dataSource {
    return  (id<PYCollectionViewDateSource>)self.collectionView.dataSource;
}

#pragma mark - UICollectionViewLayout overridden methods
- (void) prepareLayout {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super prepareLayout];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    int sectionCount = (int)self.collectionView.numberOfSections;
    
    CGFloat y = 0;
    CGFloat availableWidth = self.collectionViewContentSize.width - (self.sectionInset.left + self.sectionInset.right);
    int itemsAcross = floorf((availableWidth + self.minimumInteritemSpacing) / (self.itemSize.width + self.minimumInteritemSpacing));
    
    for(int section = 0; section < sectionCount; section++) {
        y += self.headerReferenceSize.height + self.sectionInset.top;
        
        int itemCount = (int)[self.collectionView numberOfItemsInSection:section];
        int rows = ceilf(itemCount / (float)itemsAcross);
        for(int row = 0; row < rows; row ++) {
            y += self.itemSize.height;
            UIOffset adjustment = UIOffsetZero;
            if([self.delegate respondsToSelector:@selector(collectionView:layout:decorationViewAdjustmentForRow:inSection:)]) {
                adjustment = [self.delegate collectionView:self.collectionView layout:self decorationViewAdjustmentForRow:row inSection:section];
            }
            
            CGSize bookShelfSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForDecorationViewForRow:row inSection:section];
            
            dict[[NSIndexPath indexPathForItem:row inSection:section]] = [NSValue valueWithCGRect:CGRectMake(adjustment.horizontal, adjustment.vertical + y, bookShelfSize.width, bookShelfSize.height)];
            
            if(row < rows - 1) {
                y += self.minimumLineSpacing;
            }
        }
        
        y += self.sectionInset.bottom + self.footerReferenceSize.height;
    }
    
    self.bookShelfRects = [NSDictionary dictionaryWithDictionary:dict];
}

- (NSArray*) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *attr in array) {
        if(attr.representedElementCategory == UICollectionElementCategoryCell) {
            [self _applyLayoutAttributes:attr];
        }
    }
    NSMutableArray *newArray = [array mutableCopy];
    [self.bookShelfRects enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(CGRectIntersectsRect([obj CGRectValue], rect)) {
            UICollectionViewLayoutAttributes *shelfAttribute = [self layoutAttributesForDecorationViewOfKind:PYCollectionViewLayoutDecorationViewKind atIndexPath:key];
            [newArray addObject:shelfAttribute];
        }
    }];
    
    return [newArray copy];
}

- (UICollectionViewLayoutAttributes*) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    if(attr.representedElementCategory == UICollectionElementCategoryCell) {
        [self _applyLayoutAttributes:attr];
    }
    
    return attr;
}

- (UICollectionViewLayoutAttributes*) layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    id shelfRect = self.bookShelfRects[indexPath];
    if(!shelfRect) {
        return nil;
    }
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    attributes.frame = [shelfRect CGRectValue];
    attributes.zIndex = -1;
    
    return  attributes;
}

#pragma mark - KVO
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:collectionViewKeyPath]) {
        if(self.collectionView) {
            [self _setupCollectionView];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Gesture Delegate & handle
- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if([self.pan isEqual:gestureRecognizer]) {
        return  self.selectedIndexPath != nil;
    }
    return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.longPress isEqual:gestureRecognizer]) {
        return [self.pan isEqual:otherGestureRecognizer];
    }
    
    if ([self.pan isEqual:gestureRecognizer]) {
        return [self.longPress isEqual:otherGestureRecognizer];
    }
    
    return NO;
}

- (void) handleLongPress:(UILongPressGestureRecognizer*)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            if([self.dataSource respondsToSelector:@selector(collectionView:canMoveIndexPath:)]) {
                if(![self.dataSource collectionView:self.collectionView canMoveIndexPath:currentIndexPath]) {
                    return;
                }
            }
            else {
                return;
            }
            
            self.selectedIndexPath = currentIndexPath;
            if([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:self.selectedIndexPath];
            }
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
            self.currentView = [[UIView alloc] initWithFrame:cell.frame];
            cell.highlighted = YES;
            UIImageView *hightedImageView = [[UIImageView alloc] initWithImage:[cell getCellImage]];
            hightedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            cell.highlighted = NO;
            UIImageView *normalImageView = [[UIImageView alloc] initWithImage:[cell getCellImage]];
            normalImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight;
            normalImageView.alpha = 1.f;
            
            [self.currentView addSubview:normalImageView];
            [self.currentView addSubview:hightedImageView];
            [self.collectionView addSubview:self.currentView];
            self.currentViewCenter = self.currentView.center;
            
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.2 animations:^{
                __strong typeof(self) strongSelf = weakSelf;
                if(strongSelf) {
                    strongSelf.currentView.transform = CGAffineTransformMakeScale(ZOOM_FACTOR, ZOOM_FACTOR);
                    hightedImageView.alpha = 0.0f;
                }
            } completion:^(BOOL finished) {
                __strong typeof(self) strongSelf = weakSelf;
                if(strongSelf) {
                    [hightedImageView removeFromSuperview];
                    if([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
                        [strongSelf.delegate collectionView:self.collectionView layout:self didBeginDraggingItemAtIndexPath:self.selectedIndexPath];
                    }
                }
            }];
            [self invalidateLayout];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            NSIndexPath *currentIndexPath = self.selectedIndexPath;
            if(currentIndexPath) {
                if([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
                    [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:currentIndexPath];
                }
                self.selectedIndexPath = nil;
                self.currentViewCenter = CGPointZero;
                
                UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:currentIndexPath];
                
                __weak typeof (self) weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
                    __strong typeof(self) strongSelf = weakSelf;
                    if(strongSelf) {
                        strongSelf.currentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        strongSelf.currentView.center = layoutAttributes.center;
                    }
                } completion:^(BOOL finished) {
                    __strong typeof(self) strongSelf = weakSelf;
                    if(strongSelf) {
                        [strongSelf.currentView removeFromSuperview];
                        strongSelf.currentView = nil;
                        [strongSelf invalidateLayout];
                        if([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
                            [strongSelf.delegate collectionView:self.collectionView layout:self didEndDraggingItemAtIndexPath:currentIndexPath];
                        }
                    }
                }];
            }
        }
            break;
        default:break;
    }
}

- (void) handlePan:(UIPanGestureRecognizer*)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        case  UIGestureRecognizerStateChanged: {
            self.panTranslationInCollectionView = [pan translationInView:self.collectionView];
            CGPoint viewCenter = self.currentView.center = CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
            [self _invalidateLayoutIfNeed];
            
            if(viewCenter.y < (CGRectGetMinY(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.top)) {
                [self _setupScrollTimerInDirection:PYScroll_UP];
            }
            else {
                if(viewCenter.y > (CGRectGetMaxY(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.bottom)) {
                    [self _setupScrollTimerInDirection:PYScroll_DOWN];
                }
                else {
                    [self _invalidatesScrollTimer];
                }
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self _invalidatesScrollTimer];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Timer
- (void) handleScroll:(CADisplayLink*)timer {
    if(_oldScrollDir == PYScroll_UNKNOWN) {
        return;
    }
    
    CGSize frameSize = self.collectionView.bounds.size;
    CGSize contentSize = self.collectionView.contentSize;
    CGPoint contentOffset = self.collectionView.contentOffset;
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    CGFloat dis = rint(self.scrollSpeed / 60.f);
    CGPoint translation = CGPointZero;
    
    
    switch (_oldScrollDir) {
        case PYScroll_UP: {
            dis = -dis;
            CGFloat minY = -contentInset.top;
            if(contentOffset.y + dis < minY) {
                dis = -contentOffset.y - contentInset.top;
            }
            translation = CGPointMake(0.0f, dis);
        }
            break;
        case PYScroll_DOWN: {
            CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height + contentInset.bottom;
            if(contentOffset.y + dis >= maxY) {
                dis = maxY - contentOffset.y;
            }
            translation = CGPointMake(0.0f, dis);
        }
            break;
        default:
            break;
    }
    
    self.currentViewCenter = CGPointAdd(self.currentViewCenter, translation);
    self.currentView.center = CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
    self.collectionView.contentOffset = CGPointAdd(contentOffset, translation);
}

@end
