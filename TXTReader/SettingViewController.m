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
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;
@property (weak, nonatomic) IBOutlet UIStepper *fontSizeStepper;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rowSpaceControl;

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
    
    num = [USER_DEFAULTS objectForKey:GLOBAL_FONT_SIZE];
    self.fontSizeStepper.value = num ? (float)[num floatValue] : 17.0;
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%d", (int)self.fontSizeStepper.value];
    
    num = [USER_DEFAULTS objectForKey:GLOBAL_ROW_SPACE];
    self.rowSpaceControl.selectedSegmentIndex = num ? [num integerValue] : 1;
}

#pragma mark - event
- (void) clickBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)switchNightMode:(UISwitch*)sender {
    [USER_DEFAULTS setObject:@(sender.on) forKey:GLOBAL_NIGHT];
}

- (IBAction)fontSizeDidChange:(UIStepper*)sender {
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
    [USER_DEFAULTS setObject:@(sender.value) forKey:GLOBAL_FONT_SIZE];
}

- (IBAction)rowSpaceDidChange:(UISegmentedControl*)sender {
    [USER_DEFAULTS setObject:@(sender.selectedSegmentIndex) forKey:GLOBAL_ROW_SPACE];
}

@end
