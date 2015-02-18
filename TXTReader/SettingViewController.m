//
//  SettingViewController.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "SettingViewController.h"
#import "PYUtils.h"

@interface SettingViewController() {
    
}

@property (nonatomic, strong) UIView *naviBar;

@end

@implementation SettingViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [PYUtils screenWidth], 44)];
    self.naviBar.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.naviBar];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:btnDone];
}

@end
