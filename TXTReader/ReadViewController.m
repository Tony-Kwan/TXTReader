//
//  ReadViewController.m
//  TXTReader
//
//  Created by PYgzx on 15/2/20.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "ReadViewController.h"

@interface ReadViewController()
<
UIPageViewControllerDataSource,
UIPageViewControllerDelegate
>
{
    NSTimer *_barHideTimer;
}

@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation ReadViewController

- (id) initWithBook:(Book *)book {
    if((self = [super init])) {
        self.book = book;
        self.currentPageIndex = 1;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    
    self.view.backgroundColor = WHITE_COLOR;
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    TextViewController *textVC = [self createTextViewControllerWithPage];
    [self.pageViewController setViewControllers:@[textVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

- (void) setupNavigationItem {
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    self.navigationController.hidesBarsOnTap = YES;
    self.navigationController.hidesBarsOnSwipe = YES;
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.navigationController.barHideOnTapGestureRecognizer addTarget:self action:@selector(handleBarHideOnTap:)];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(clickBack:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    self.navigationItem.title = self.book.name;
}

- (void) dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - event
- (void) clickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) handleBarHideOnTap:(UITapGestureRecognizer*)tap {
    if(!self.navigationController.navigationBarHidden) {
        if(_barHideTimer) {
            [_barHideTimer invalidate];
        }
        _barHideTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideNavigationBar) userInfo:nil repeats:NO];
    }
}

- (void) hideNavigationBar {
    [_barHideTimer invalidate];
    _barHideTimer = nil;
    if(!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if(_currentPageIndex == 1) {
        return nil;
    }
    _currentPageIndex --;
    return [self createTextViewControllerWithPage];
}

- (UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    _currentPageIndex ++;
    return [self createTextViewControllerWithPage];
}

#pragma mark - private
- (TextViewController*) createTextViewControllerWithPage {
    NSString *text = [_book textAtPage:_currentPageIndex];
    if(!text) {
        return nil;
    }
    TextViewController *textVC = [[TextViewController alloc] initWithText:text color:_book.textColor andFont:_book.font];
    return textVC;
}

@end
