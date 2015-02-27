//
//  ReadViewController.m
//  TXTReader
//
//  Created by PYgzx on 15/2/20.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "ReadViewController.h"
#import "ToolBarView.h"
#import "SettingView.h"

@interface ReadViewController()
<
UIPageViewControllerDataSource,
UIPageViewControllerDelegate,
ToolBarViewDelegate,
SettingViewDelegate
>
{
    NSTimer *_barHideTimer;
}

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) ToolBarView *toolBar;
@property (nonatomic, strong) SettingView *settingView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UILabel *messageLabel;

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
    
    CGRect tapViewFrame = self.view.bounds;
    tapViewFrame.origin.x = self.view.bounds.size.width/3;
    tapViewFrame.size.width = tapViewFrame.origin.x;
    UIView* tapView = [[UIView alloc] initWithFrame:tapViewFrame];
    tapView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tapView];
    [tapView addGestureRecognizer:_tap];
    
    CGFloat h = [PYUtils screenHeight];
    CGFloat w = [PYUtils screenWidth];
    
    self.toolBar = [[ToolBarView alloc] initWithFrame:CGRectMake(0, h, w, 88)];
    self.toolBar.delegate = self;
    [self.view addSubview:self.toolBar];
    
    self.settingView = [[SettingView alloc] initWithFrame:CGRectMake(0, h, w, h/2)];
    self.settingView.delegate = self;
    [self.view addSubview:self.settingView];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.layer.masksToBounds = YES;
    self.messageLabel.layer.cornerRadius = 5.0f;
    self.messageLabel.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.5];
    [self.view addSubview:self.messageLabel];
    
    WS(weakSelf);
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view).multipliedBy(0.4);
        make.height.mas_equalTo(50);
    }];
}

- (void) setupNavigationItem {
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.alpha = 0.4;
    
//    self.navigationController.hidesBarsOnTap = YES;
    [self.navigationController setNavigationBarHidden:YES];
    
//    [self.navigationController.barHideOnTapGestureRecognizer addTarget:self action:@selector(handleBarHideOnTap:)];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBarHideOnTap:)]; //TODO:optimization
//    [self.view addGestureRecognizer:_tap];
    
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
    if(![self isSettingViewHidden]) {
        [self showSettingView:NO];
        [self showToolBar:NO];
        return ;
    }
    if(self.navigationController.navigationBarHidden) {
        if(_barHideTimer) {
            [_barHideTimer invalidate];
        }
        _barHideTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideNavigationBar) userInfo:nil repeats:NO];
    }
    [self showToolBar:self.navigationController.navigationBarHidden];
}

- (void) hideNavigationBar {
    [_barHideTimer invalidate];
    _barHideTimer = nil;
    if(!self.navigationController.navigationBarHidden) {
        [self showToolBar:NO];
    }
}

#pragma mark - private
- (void) showToolBar:(BOOL)flag {
    CGRect frame = self.toolBar.frame;
    CGRect frame2;
    if(flag) {
        frame.origin.y = [PYUtils screenHeight] - frame.size.height;
    }
    else {
        frame.origin.y = [PYUtils screenHeight];
        frame2 = self.settingView.frame;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.toolBar.frame = frame;
    }];
    [self.navigationController setNavigationBarHidden:!flag animated:YES];
}

- (void) showSettingView:(BOOL)flag {
//    NSLog(@"%s %d", __PRETTY_FUNCTION__, flag);
    CGRect frame = self.settingView.frame;
    if(flag) {
        frame.origin.y = [PYUtils screenHeight] - frame.size.height;
        [self showToolBar:NO];
    }
    else {
        frame.origin.y = [PYUtils screenHeight];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.settingView.frame = frame;
    }];
}

- (BOOL) isSettingViewHidden {
    return self.settingView.frame.origin.y >= [PYUtils screenHeight];
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
    if(_currentPageIndex >= _book.pageCount) {
        return nil;
    }
    _currentPageIndex ++;
    return [self createTextViewControllerWithPage];
}

#pragma mark - ToolBarViewDelegate
- (void) toolBarDidClickSetting {
    [self showSettingView:YES];
}

- (void) toolBarSliderValueChangingTo:(CGFloat)value {
    [_barHideTimer invalidate];
    _barHideTimer = nil;
}

- (void) toolBarSliderValueChangedTo:(CGFloat)value {
    _barHideTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideNavigationBar) userInfo:nil repeats:NO];
}

#pragma mark - SettingViewDelegate
- (void) changeRowSpaceTo:(CGFloat)rowSpace {
    GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
    st.rowSpace = rowSpace;
    [USER_DEFAULTS setObject:@(rowSpace) forKey:GLOBAL_ROW_SPACE];
}

- (void) changeToNight:(BOOL)isNight {
    GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
    st.isNight = isNight;
    [USER_DEFAULTS setObject:@(isNight) forKey:GLOBAL_NIGHT];
}

- (void) changeFontSizeTo:(CGFloat)fontSize {
    GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
    st.fontSize = fontSize;
    [USER_DEFAULTS setObject:@(fontSize) forKey:GLOBAL_FONT_SIZE];
}

- (void) changeSkinTo:(NSInteger)index {
    TextViewController *currentVC = (TextViewController*)[[self.pageViewController viewControllers] firstObject];
    GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
    [st setSkinIndex:index];
    [currentVC setTextColor:[st skin][0] andBackgoundColor:[st skin][1]];
    [USER_DEFAULTS setObject:@(index) forKey:GLOBAL_SKIN_INDEX];
}

#pragma mark - private
- (TextViewController*) createTextViewControllerWithPage {
    NSAttributedString *text = [_book textAtPage:_currentPageIndex];
    if(!text) {
        return nil;
    }
    PYLog(@"%s %@", __PRETTY_FUNCTION__, @(_currentPageIndex));
    TextViewController *textVC = [[TextViewController alloc] initWithText:text color:_book.textColor andFont:_book.font];
    return textVC;
}

@end
