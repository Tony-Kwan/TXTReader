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

@end

@implementation SettingViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.tintColor = [UIColor redColor];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    btnDone.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
    [btnDone setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    btnDone.backgroundColor = [UIColor clearColor];
    [btnDone sizeToFit];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnDone];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:17];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.backgroundColor = [UIColor clearColor];
    [btnCancel sizeToFit];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickDone)];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

#pragma mark - event
- (void) clickDone {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) clickCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
