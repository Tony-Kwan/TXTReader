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

#import "SettingViewController.h"
#import "ReadViewController.h"

#import "BookShelfCollectionView.h"
#import "BookShelfTableView.h"
#import "BookShelfDelegate.h"

@interface RootViewController()
<
BookShelfDelegate
>
{
}

@property (nonatomic, strong) BookShelfCollectionView *collectionView;
@property (nonatomic, strong) BookShelfTableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;

@end

@implementation RootViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationItem];

    self.view.backgroundColor = [UIColor redColor];
    
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

#pragma mark - event
- (void) clickSetting:(id)sender {
//    NSLog(@"%@ %@", @(self.collectionView.alwaysBounceVertical), @(self.collectionView.bounces));
    SettingViewController *svc = [SettingViewController new];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:svc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

- (void) segmentControlValueDidChange:(UISegmentedControl*)segmentControl {
    self.collectionView.hidden = segmentControl.selectedSegmentIndex;
    self.tableView.hidden = !self.collectionView.hidden;
}

#pragma mark - BookShelfDelegate
- (void) openBook:(Book *)book {   
    NSLog(@"%s %@", __PRETTY_FUNCTION__, book);
//    [book paginate];
    [book paging];
    ReadViewController *readVC = [[ReadViewController alloc] initWithBook:book];
    UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController:readVC];
    [self.navigationController presentViewController:naviC animated:YES completion:nil];
}




@end
