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
#import "VEMessageView.h"
#import "MenuViewController.h"

@interface ReadViewController()
<
UIPageViewControllerDataSource,
UIPageViewControllerDelegate,
ToolBarViewDelegate,
SettingViewDelegate,
MenuViewControllerDelegate,
BookDelegate
>
{
    NSTimer *_barHideTimer;
    CGRect tapViewFrame;
    BOOL _lastTimeIsBefore;
}

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) ToolBarView *toolBar;
@property (nonatomic, strong) SettingView *settingView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) VEMessageView *messageView;
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, strong) UIButton *btnBookMark;

@end

@implementation ReadViewController

- (id) initWithBook:(Book *)book {
    if((self = [super init])) {
        self.book = book;
        self.book.delegate = self;
        self.currentPageIndex = 1;
        self.currentPageOffset = 0;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];

    self.view.backgroundColor = WHITE_COLOR;
    self.view.layer.masksToBounds = self.view.clipsToBounds = NO;
    
    GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
    UIPageViewControllerTransitionStyle style = st.scrollMode == 0 ? UIPageViewControllerTransitionStylePageCurl : UIPageViewControllerTransitionStyleScroll;
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:style navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    TextViewController *textVC;
    if(self.book.pageIndexArray) {
        textVC = [self createTextViewControllerWithPage];
        PYLog(@"%s 已经分页", __PRETTY_FUNCTION__);
    }
    else {
        NSAttributedString *attrStr = [self.book getStringWithOffset:self.book.lastReadOffset];
        self.currentPageOffset = self.book.lastReadOffset;
        textVC = [self createTextViewControllerWithText:attrStr];
        PYLog(@"%s 未分页", __PRETTY_FUNCTION__);
    }
    [self.pageViewController setViewControllers:@[textVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    tapViewFrame = self.view.bounds;
    tapViewFrame.origin.x = self.view.bounds.size.width/3;
    tapViewFrame.size.width = tapViewFrame.origin.x;
    self.tapView = [[UIView alloc] initWithFrame:tapViewFrame];
    self.tapView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tapView];
    [self.tapView addGestureRecognizer:_tap];
    
    CGFloat h = [PYUtils screenHeight];
    CGFloat w = [PYUtils screenWidth];
    
    self.toolBar = [[ToolBarView alloc] initWithFrame:CGRectMake(0, h, w, 88)];
    self.toolBar.delegate = self;
    self.toolBar.slider.minimumValue = 1.0;
    self.toolBar.slider.maximumValue = (float)_book.pageCount;
    self.toolBar.paginatingLabel.hidden = self.book.pageIndexArray ? YES : NO;
    self.toolBar.progressLabel.hidden = self.toolBar.slider.hidden = !self.toolBar.paginatingLabel.hidden;
    [self.view addSubview:self.toolBar];
    
    self.settingView = [[SettingView alloc] initWithFrame:CGRectMake(0, h, w, h/2)];
    self.settingView.delegate = self;
    [self.view addSubview:self.settingView];
    
    self.messageView = [[VEMessageView alloc] initWithMessage:@"" andOtherMessage:nil];
    self.messageView.backgroundColor = [st skin][1];
    self.messageView.messageLabel.textColor = [st skin][0];
    self.messageView.layer.borderColor = self.messageView.messageLabel.textColor.CGColor;
    self.messageView.layer.borderWidth = 1.0f;
    self.messageView.hidden = YES;
    [self.view addSubview:self.messageView];
    
    WS(weakSelf);
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view).multipliedBy(0.55);
        make.height.mas_equalTo(80);
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
    backButtonItem.tintColor = WHITE_COLOR;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    self.navigationItem.title = self.book.name;
    
    self.btnBookMark = [[UIButton alloc] init];
    [_btnBookMark setImage:[UIImage imageNamed:@"bookmark_off"] forState:UIControlStateNormal];
//    [_btnBookMark setImage:[UIImage imageNamed:@"bookmark_on"] forState:UIControlStateSelected];
    [_btnBookMark addTarget:self action:@selector(clickBookMark:) forControlEvents:UIControlEventTouchUpInside];
    _btnBookMark.backgroundColor = CLEAR_COLOR;
    _btnBookMark.tintColor = self.view.tintColor;
    _btnBookMark.selected = NO;
    [_btnBookMark sizeToFit];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnBookMark];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void) updateToolBar {
    if(!self.book.pageIndexArray || _currentPageIndex <= 0 || _currentPageIndex > self.book.pageCount) {
        return;
    }
    self.toolBar.progressLabel.text = [NSString stringWithFormat:@"%@ / %@", @(_currentPageIndex), @(_book.pageCount)];
    self.toolBar.slider.value = (float)_currentPageIndex;
    self.currentPageOffset = [[self.book.pageIndexArray objectAtIndex:_currentPageIndex-1] unsignedIntegerValue];
    self.btnBookMark.selected = ![self.book isOneOfBookmarkOffset:self.currentPageOffset];
}

- (void) dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - event
- (void) clickBack:(id)sender {
    self.book.lastReadOffset = self.currentPageOffset;
    
    self.book.canPaginate = NO;
    [self dismissViewControllerAnimated:YES completion:^{
        [[BookSource shareInstance] setReadingBook:nil];
        [self.delegate didEndReadBook:self.book];
    }];
}

- (void) clickBookMark:(id)sender {
    if(self.btnBookMark.selected == NO) {
        BOOL hasNewBookMark = YES;
        if(self.book.bookMarksOffset && self.book.bookMarksOffset.count) {
            hasNewBookMark = ![self.book isOneOfBookmarkOffset:self.currentPageOffset];
        }
        if(hasNewBookMark) {
            [self.book addBookmarkWithOffset:self.currentPageOffset];
            self.btnBookMark.selected = YES;
        }
    }
    else {
        if([self.book isOneOfBookmarkOffset:self.currentPageOffset]) {
            [self.book deleteBookmarkWithOffset:self.currentPageOffset];
            self.btnBookMark.selected = NO;
        }
    }
    [self updateTimer];
}

- (void) handleBarHideOnTap:(UITapGestureRecognizer*)tap {
    if(![self isSettingViewHidden]) {
        [self showSettingView:NO];
        [self showToolBar:NO];
        return ;
    }
    if(self.navigationController.navigationBarHidden) {
        [self updateTimer];
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
- (void) showToolBar:(BOOL)flag{
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
    self.pageViewController.view.userInteractionEnabled = !flag;
    self.tapView.frame = flag ? self.view.bounds : tapViewFrame;
    [UIView animateWithDuration:0.3 animations:^{
        self.settingView.frame = frame;
    }];
}

- (BOOL) isSettingViewHidden {
    return self.settingView.frame.origin.y >= [PYUtils screenHeight];
}

- (void) updateTimer {
    if(_barHideTimer) {
        [_barHideTimer invalidate];
    }
    _barHideTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideNavigationBar) userInfo:nil repeats:NO];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
//    NSLog(@"%@ %@ %@", self.book.pageIndexArray, @(_currentPageIndex), @(self.currentPageOffset));
    if((self.book.pageIndexArray && _currentPageIndex == 1) || self.currentPageOffset == 0) {
        [self.messageView setMessageLabelText:@"已翻到第一页"];
        [self.messageView show];
        return nil;
    }
    _currentPageIndex --;
    _lastTimeIsBefore = YES;
    if(self.book.pageIndexArray) {
        return [self createTextViewControllerWithPage];
    }
    else {
        NSAttributedString *attrStr = [self.book getBeforeStringWithOffset:self.currentPageOffset-1];
        self.currentPageOffset -= attrStr.length - 1;
        return [self createTextViewControllerWithText:attrStr];
    }
}

- (UIViewController*) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if(self.book.pageIndexArray && _currentPageIndex >= _book.pageCount) {
        [self.messageView setMessageLabelText:@"已翻到最后一页"];
        [self.messageView show];
        return nil;
    }
    _currentPageIndex ++;
    _lastTimeIsBefore = NO;
    if(self.book.pageIndexArray) {
        return [self createTextViewControllerWithPage];
    }
    else {
        TextViewController *tvc = [[self.pageViewController viewControllers] firstObject];
//        PYLog(@"%s %@ %@", __PRETTY_FUNCTION__, @(self.currentPageOffset), @(tvc.textLabel.attributedText.length));
        self.currentPageOffset += tvc.textLabel.attributedText.length;
        NSAttributedString *attrStr = [self.book getStringWithOffset:self.currentPageOffset];
        return [self createTextViewControllerWithText:attrStr];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if(!completed) {
        if(_lastTimeIsBefore) {
            _currentPageIndex ++;
        }
        else {
            _currentPageIndex --;
        }
        [self updateToolBar];
    }
}

#pragma mark - ToolBarViewDelegate
- (void) toolBarDidClickSetting {
    [self showSettingView:YES];
}

- (void) toolBarDidClickMenu {
    MenuViewController *menuVC = [[MenuViewController alloc] init];
    menuVC.delegate = self;
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:menuVC];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

- (void) toolBarSliderValueChangingTo:(CGFloat)value {
    if(_barHideTimer) {
        [_barHideTimer invalidate];
        _barHideTimer = nil;
    }
    self.toolBar.progressLabel.text = [NSString stringWithFormat:@"%@ / %@", @((NSUInteger)value), @(_book.pageCount)];
}

- (void) toolBarSliderValueChangedTo:(CGFloat)value {
    _barHideTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideNavigationBar) userInfo:nil repeats:NO];
    
    _currentPageIndex = (NSUInteger)value;
    TextViewController *tVC = [self createTextViewControllerWithPage];
    [self.pageViewController setViewControllers:@[tVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark - SettingViewDelegate
- (void) changeRowSpaceIndexTo:(NSInteger)rowSpaceIndex {
    GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
    st.rowSpaceIndex = rowSpaceIndex;
    [USER_DEFAULTS setObject:@(rowSpaceIndex) forKey:GLOBAL_ROW_SPACE];
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
    self.messageView.backgroundColor = [st skin][1];
    self.messageView.messageLabel.textColor = [st skin][0];
    self.messageView.layer.borderColor = self.messageView.messageLabel.textColor.CGColor;
    
    [currentVC setTextColor:[st skin][0] andBackgoundColor:[st skin][1]];
    [USER_DEFAULTS setObject:@(index) forKey:GLOBAL_SKIN_INDEX];
    
}

#pragma mark - MenuViewControllerDelegate
- (void) seekToOffset:(NSUInteger)offset {
    NSAttributedString *pageContent = [self.book getStringWithOffset:offset];
    TextViewController *tvc = [self createTextViewControllerWithText:pageContent];
    [self.pageViewController setViewControllers:@[tvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    _currentPageIndex = [self.book getPageIndexByOffset:offset];
//    NSLog(@"%@", @(_currentPageIndex));
    [self updateToolBar];
}

#pragma mark - BookDelegate
- (void) bookDidPaginate {
    self.currentPageIndex = [self.book getPageIndexByOffset:self.currentPageOffset];
    self.toolBar.slider.maximumValue = self.book.pageIndexArray.count;
    [self updateToolBar];
    self.toolBar.paginatingLabel.hidden = YES;
    self.toolBar.progressLabel.hidden = self.toolBar.slider.hidden = NO;
    
    if(![DBUtils isBookInDB:self.book]) {
        [DBUtils addBook:self.book];
    }
    else {
        [DBUtils updateWithBook:self.book];
    }
}

- (void) paginatingPregress:(CGFloat)progress {
    self.toolBar.paginatingLabel.text = [NSString stringWithFormat:@"分页中...(%.1f%%)", progress];
}

#pragma mark - private
- (TextViewController*) createTextViewControllerWithPage {
    NSAttributedString *text = [_book textAtPage:_currentPageIndex];
    if(!text) {
        return nil;
    }
//    PYLog(@"%s %@", __PRETTY_FUNCTION__, @(_currentPageIndex));
    GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
    TextViewController *textVC = [[TextViewController alloc] initWithText:text color:st.textColor andFont:st.font];
    [self updateToolBar];
    return textVC;
}

- (TextViewController*) createTextViewControllerWithText:(NSAttributedString*)text {
    if(!text) {
        return nil;
    }
    GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
    TextViewController *textVC = [[TextViewController alloc] initWithText:text color:st.textColor andFont:st.font];
    [self updateToolBar];
    return textVC;
}

@end
