//
//  MenuViewController.m
//  TXTReader
//
//  Created by 关仲贤 on 15/3/2.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"

static NSString* MenuTableViewCellIndentifier = @"mtvcid";

@interface MenuViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *bookmarksView, *chaptersView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.tintColor = [UIColor redColor];
    [self setupNavigationBar];
    
    self.bookmarksView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.bookmarksView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:MenuTableViewCellIndentifier];
    self.bookmarksView.delegate = self;
    self.bookmarksView.dataSource = self;
    
}

- (void) setupNavigationBar {
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"章节", @"书签"]];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:segmentControl];
    self.navigationController.navigationItem.rightBarButtonItem = right;
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeSystem];
    btnBack.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btnBack setTitle:@"Back" forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    btnBack.backgroundColor = [UIColor clearColor];
    [btnBack sizeToFit];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - event
- (void) clickBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView delegate && dataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MenuTableViewCellIndentifier];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
