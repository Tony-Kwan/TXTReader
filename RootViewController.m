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
        [book paginate];
        
        ReadViewController *readVC = [[ReadViewController alloc] initWithBook:book];
        UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController:readVC];
        [self.navigationController presentViewController:naviC animated:YES completion:nil];
    }
    else {
        PYLog(@"nuknowencoding");
    }
}




@end
