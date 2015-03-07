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
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"章 节", @"书 签"]];
    segmentControl.tintColor = self.view.tintColor;
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(segmentedControlValueDidChage:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentControl;
    
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
    [self.tableView reloadData];
}

#pragma mark - UITableView delegate && dataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Book* readingBook = [[BookSource shareInstance] readingBook];
    if(readingBook) {
        if(self.isChapterMode) {
            return readingBook.chaptersTitleRange.count;
        }
        else {
            return readingBook.bookMarksOffset.count;
        }
    }
    else {
        return 0;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MenuTableViewCellIndentifier];
    
    Book* readingBook = [[BookSource shareInstance] readingBook];
    if(self.isChapterMode) {
        NSValue *value = [readingBook.chaptersTitleRange objectAtIndex:indexPath.item];
        cell.textLabel.text = [readingBook.content substringWithRange:[value rangeValue]];
    }
    else {
        NSValue *value = [readingBook.bookMarksOffset objectAtIndex:indexPath.item];
        cell.textLabel.text = [readingBook.content substringWithRange:[value rangeValue]];
    }
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
        NSValue *value = [readingBook.bookMarksOffset objectAtIndex:indexPath.item];
        offset = [value rangeValue].location;
    }
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.delegate seekToOffset:offset];
    }];
}

@end
