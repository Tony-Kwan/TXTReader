//
//  RootViewController.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "RootViewController.h"
#import "PYUtils.h"
#import "FileUtils.h"
#import "PYAnimator.h"

#import "SettingViewController.h"
#import "ReadViewController.h"

#import "BookShelfCollectionView.h"
#import "BookShelfTableView.h"
#import "BookShelfDelegate.h"

@interface RootViewController()
<
BookShelfDelegate,
UIViewControllerTransitioningDelegate,
ReadViewControllerDelegate
>
{
    CGRect _openBookCellFrame;
    PYAnimator *_animator;
    ReadViewController *readVC;
}

@property (nonatomic, strong) BookShelfCollectionView *collectionView;
@property (nonatomic, strong) BookShelfTableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;

@end

@implementation RootViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    self.collectionView = [[BookShelfCollectionView alloc] init];
    [self.view addSubview:self.collectionView];
    
    self.tableView = [[BookShelfTableView alloc] init];
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    
    self.tableView.bookShelfDelegate = self.collectionView.bookShelfDelegate = self;
}

- (void) setupNavigationItem {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setAlpha:0.2];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    self.navigationItem.title = @"TXT Reader";
    
    UIButton *btnSetting = [[UIButton alloc] init];
    [btnSetting addTarget:self action:@selector(clickSetting:) forControlEvents:UIControlEventTouchUpInside];
    btnSetting.backgroundColor = CLEAR_COLOR;
    btnSetting.tintColor = self.view.tintColor;
    UIImage *settingImage = [UIImage imageNamed:@"setting_btn"];
    [btnSetting setImage:settingImage forState:UIControlStateNormal];
//    [btnSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnSetting setTitle:@"setting" forState:UIControlStateNormal];
    [btnSetting sizeToFit];
//    btnSetting.layer.cornerRadius = 3.0f;
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSetting];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    //@"网格", @"列表"
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[[UIImage imageNamed:@"grid_btn"], [UIImage imageNamed:@"list_btn"]]];
    [self.segmentControl addTarget:self action:@selector(segmentControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentControl.tintColor = WHITE_COLOR;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.segmentControl];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[GlobalSettingAttrbutes shareSetting] clearCache];
}

#pragma mark - event
- (void) clickSetting:(id)sender {
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    SettingViewController* settingVC = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"sss"];
    [self.navigationController presentViewController:settingVC animated:YES completion:nil];
}

- (void) segmentControlValueDidChange:(UISegmentedControl*)segmentControl {
    self.collectionView.hidden = segmentControl.selectedSegmentIndex;
    self.tableView.hidden = !self.collectionView.hidden;
}

#pragma mark - BookShelfDelegate
- (void) openBook:(Book *)book {   
    NSLog(@"%s %@", __PRETTY_FUNCTION__, book);
    if(book.encoding != kUnknownStringEncoding) {
        readVC = [[ReadViewController alloc] initWithBook:book];
        readVC.delegate = self;
        [book parseBook];

        if(![DBUtils queryBook:book]) {
            book.canPaginate = YES;
            [book paginate];
            [NSThread sleepForTimeInterval:0.5];
        }
        
        UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController:readVC];
        if(self.collectionView.hidden == NO) {
            NSUInteger idx = [[BookSource shareInstance] indexOfBook:book];
            BookCell *cell = (BookCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
            readVC.coverImage = [cell getCoverImage];
            
            naviC.transitioningDelegate = self;
            CGRect cellFrame = cell.frame;
            _openBookCellFrame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y - self.collectionView.contentOffset.y, cellFrame.size.width, cellFrame.size.height);
//            UIView *v = [[UIView alloc] initWithFrame:_openBookCellFrame];
//            v.backgroundColor = [UIColor randomColor];
//            [self.view addSubview:v];
        }
        [self.navigationController presentViewController:naviC animated:YES completion:nil];
        [[BookSource shareInstance] setReadingBook:book];
    }
    else {
        PYLog(@"nuknowencoding");
    }
}

#pragma mark - ReadViewControllerDelegate
- (void) didEndReadBook:(Book *)book {
    NSUInteger idx = [[BookSource shareInstance] indexOfBook:book];
    book.lastUpdate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    [self.tableView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]]];
    
//    if(![DBUtils isBookInDB:book]) {
//        [DBUtils addBook:book];
//    }
//    else {
//        [DBUtils updateWithBook:book];
//    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _animator = [[PYAnimator alloc] initWithOriginFrame:_openBookCellFrame];
    return _animator;
}

//- (id<UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed {

//}

@end
