//
//  SettingViewController.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "SettingViewController.h"
#import "PYUtils.h"
#import "GlobalSettingAttrbutes.h"

static NSString* tableViewCellIndentifier = @"tcid";

@interface SettingViewController()

@property (weak, nonatomic) IBOutlet UISwitch *nightSwitch;

@end

@implementation SettingViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.tintColor = [UIColor redColor];
    [self setupNavigationBar];
    [self configure];
}

- (void) setupNavigationBar {
    self.navigationItem.title = @"Setting";
    
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

- (void) configure {
    NSNumber *num = [USER_DEFAULTS objectForKey:GLOBAL_NIGHT];
    self.nightSwitch.on = num && [num isEqualToNumber:@(YES)];
}

#pragma mark - event
- (void) clickBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)switchNightMode:(UISwitch*)sender {
    [USER_DEFAULTS setObject:@(sender.on) forKey:GLOBAL_NIGHT];
}

@end
