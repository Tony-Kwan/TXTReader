//
//  RootViewController.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "RootViewController.h"
#import "PYUtils.h"
#import "PYCollectionViewFlowLayout.h"
#import "PYCollectionViewTableLayout.h"
#import "BookCell.h"
#import "TableCell.h"
#import "BookSource.h"
#import "SettingViewController.h"

static NSString *bookCellIndentifier = @"bookCellIndentifier";
static NSString *tableCellIndentifier = @"tableCellIndentifier";

@interface RootViewController()
<
UICollectionViewDelegate,
PYCollectionVieDelegateFlowLayout,
PYCollectionViewDateSource
>
{
    PYCollectionViewFlowLayout *gridLayout;
    PYCollectionViewTableLayout *tableLayout;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BookSource *bookSource;
@property (nonatomic, strong) UISegmentedControl *segmentControl;

@end

@implementation RootViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self loadBooks];
    
    gridLayout = [PYCollectionViewFlowLayout new];
    [gridLayout registerNib:[UINib nibWithNibName:@"PYBookShelfDecorationView" bundle:nil] forDecorationViewOfKind:PYCollectionViewLayoutDecorationViewKind];
    
    tableLayout = [PYCollectionViewTableLayout new];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:gridLayout];
    self.collectionView.autoresizingMask = AUTORESIZING_WIDTH_AND_HEIGHT;
    self.collectionView.backgroundColor = [UIColor brownColor];
    [self.collectionView registerClass:[BookCell class] forCellWithReuseIdentifier:bookCellIndentifier];
    [self.collectionView registerClass:[TableCell class] forCellWithReuseIdentifier:tableCellIndentifier];
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.collectionView setBounces:YES];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

- (void) setupNavigationItem {
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    self.navigationItem.title = @"TXT Reader";
    
    UIButton *btnSetting = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnSetting addTarget:self action:@selector(clickSetting:) forControlEvents:UIControlEventTouchUpInside];
    btnSetting.autoresizingMask = AUTORESIZING_WIDTH_AND_HEIGHT;
    btnSetting.backgroundColor = self.view.tintColor;
    [btnSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSetting setTitle:@"setting" forState:UIControlStateNormal];
    [btnSetting sizeToFit];
    btnSetting.layer.cornerRadius = 3.0f;
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSetting];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Grid", @"Table"]];
    [self.segmentControl addTarget:self action:@selector(segmentControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    self.segmentControl.selectedSegmentIndex = 0;
    //    segmentControl.momentary = YES;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.segmentControl];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void) loadBooks {
    self.bookSource = [BookSource new];
    [self.bookSource loadBooks];
}

#pragma mark - event
- (void) clickSetting:(id)sender {
//    NSLog(@"%@ %@", @(self.collectionView.alwaysBounceVertical), @(self.collectionView.bounces));
    SettingViewController *svc = [SettingViewController new];
    [self presentViewController:svc animated:YES completion:^{
    }];
}

- (void) segmentControlValueDidChange:(UISegmentedControl*)segmentControl {
    self.collectionView.collectionViewLayout = segmentControl.selectedSegmentIndex ? tableLayout : gridLayout;
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - collectionview delegate & datasource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.bookSource count];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.item >= _bookSource.count) {
        return nil;
    }
    
    Book* book = [self.bookSource bookAtIndex:indexPath.item];
    
    if(_segmentControl.selectedSegmentIndex == 0) {
        BookCell *cell = (BookCell*)[collectionView dequeueReusableCellWithReuseIdentifier:bookCellIndentifier forIndexPath:indexPath];
        
        cell.titleLabel.text = book.name;
        
        return cell;
    }
    else {
        TableCell *cell = (TableCell*)[collectionView dequeueReusableCellWithReuseIdentifier:tableCellIndentifier forIndexPath:indexPath];
        cell.titleLabel.text = book.name;
        return cell;
    }
    
    
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(PYCollectionViewFlowLayout *)layout referenceSizeForDecorationViewForRow:(NSInteger)row inSection:(NSInteger)section {
    return CGSizeMake([PYUtils screenWidth], 30);
}

@end
