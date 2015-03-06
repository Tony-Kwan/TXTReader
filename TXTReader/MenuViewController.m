//
//  MenuViewController.m
//  TXTReader
//
//  Created by 关仲贤 on 15/3/2.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "PYUtils.h"
#import "BookSource.h"

static NSString* MenuTableViewCellIndentifier = @"mtvcid";

@interface MenuViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, getter=isChapterMode) BOOL chapterMode;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.tintColor = [UIColor redColor];
    [self setupNavigationBar];
    
    self.tableView = [UITableView createWithBlock:^(UITableViewBuilder *builder) {
        builder.cellIndentifier = MenuTableViewCellIndentifier;
        builder.cellClass = [MenuTableViewCell class];
        builder.frame = self.view.bounds;
        builder.delegate = self;
        builder.dataSource = self;
    }];
    [self.view addSubview:self.tableView];
    
    self.chapterMode = YES;
}

- (void) setupNavigationBar {
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"章节", @"书签"]];
    segmentControl.tintColor = self.view.tintColor;
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(segmentedControlValueDidChage:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:segmentControl];
    self.navigationItem.rightBarButtonItem = right;
    
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

- (void) segmentedControlValueDidChage:(UISegmentedControl*)segmentControl {
    self.chapterMode = segmentControl.selectedSegmentIndex == 0;
}

#pragma mark - UITableView delegate && dataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Book* readingBook = [[BookSource shareInstance] readingBook];
    if(readingBook) {
        return readingBook.chaptersTitleRange.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MenuTableViewCellIndentifier];
    
    Book* readingBook = [[BookSource shareInstance] readingBook];
    NSValue *r = [readingBook.chaptersTitleRange objectAtIndex:indexPath.item];
    cell.textLabel.text = [readingBook.content substringWithRange:[r rangeValue]];
//    NSLog(@"%@ %@ %@", r, readingBook.content, [readingBook.content substringWithRange:[r rangeValue]]);
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *readingBook = [[BookSource shareInstance] readingBook];
    NSUInteger offset;
    if(self.isChapterMode) {
        NSValue *value = [readingBook.chaptersTitleRange objectAtIndex:indexPath.item];
        offset = [value rangeValue].location;
    }
    else {
        
    }
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.delegate seekToOffset:offset];
    }];
}

@end
