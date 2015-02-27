//
//  SettingView.m
//  TXTReader
//
//  Created by 关仲贤 on 15/2/26.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "SettingView.h"
#import "PYUtils.h"
#import "SkinSelectorCell.h"

#define SUBVIEW_HEIGHT_FACTOR 0.25f

static NSString *skinSelectorCellIndentifier = @"skinSelectorCell";
static const NSArray *skins;

@interface SettingView()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *btnNight;
@property (nonatomic, strong) UISegmentedControl *rowSpaceControl;
@property (nonatomic, strong) UIStepper *fontSizeStepper;
@property (nonatomic, strong) UILabel *fontSizeLabel;
@property (nonatomic, strong) UICollectionView *skinSelector;

@end

@implementation SettingView

- (id) initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setup];
    }
    return self;
}

- (void) setup {
    skins = @[@[BLACK_COLOR, WHITE_COLOR],
              @[WHITE_COLOR, BLACK_COLOR],
              @[[UIColor greenColor], UIColorFromRGB(0x282b35)],
              @[[UIColor blueColor], [UIColor yellowColor]],
              @[[UIColor cyanColor], UIColorFromRGB(0x282b35)],
              @[[UIColor yellowColor], [UIColor redColor]],
              @[[UIColor redColor], [UIColor whiteColor]]];
    
    
    self.backgroundColor = [UIColorFromRGB(0x282b35) colorWithAlphaComponent:0.9];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    self.slider = [[UISlider alloc] init];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 1.f;
    self.slider.value = [[UIScreen mainScreen] brightness];
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.slider];
    
    self.btnNight = [PYUtils customButtonWith:@"夜" target:self andAction:@selector(clickNight:)];
    [self.contentView addSubview:self.btnNight];
    
    self.fontSizeStepper = [[UIStepper alloc] init];
    self.fontSizeStepper.backgroundColor = [UIColor whiteColor];
    self.fontSizeStepper.tintColor = [UIColor redColor];
    self.fontSizeStepper.minimumValue = 15;
    self.fontSizeStepper.maximumValue = 22;
    self.fontSizeStepper.value = 17;
    [self.fontSizeStepper addTarget:self action:@selector(fontSizeDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.fontSizeStepper];
    
    self.fontSizeLabel = [[UILabel alloc] init];
    self.fontSizeLabel.backgroundColor = BLACK_COLOR;
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%ld", (long)self.fontSizeStepper.value];
    self.fontSizeLabel.textColor = [UIColor lightTextColor];
    self.fontSizeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.fontSizeLabel];
    
    CGFloat collectionViewHeight = self.bounds.size.height / 4;
    CGFloat inset = 2;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(collectionViewHeight - inset * 2, collectionViewHeight - inset * 2);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset*2, inset, inset*2);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.skinSelector = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, collectionViewHeight) collectionViewLayout:layout];
    self.skinSelector.delegate = self;
    self.skinSelector.dataSource = self;
    self.skinSelector.userInteractionEnabled = YES;
    self.skinSelector.alwaysBounceVertical = NO;
    self.skinSelector.alwaysBounceHorizontal = YES;
    self.skinSelector.showsHorizontalScrollIndicator = NO;
    self.skinSelector.showsVerticalScrollIndicator = NO;
    self.skinSelector.backgroundColor = [UIColor clearColor];
    [self.skinSelector registerClass:[SkinSelectorCell class] forCellWithReuseIdentifier:skinSelectorCellIndentifier];
    [self.contentView addSubview:self.skinSelector];
    
    self.rowSpaceControl = [[UISegmentedControl alloc] initWithItems:@[@"小", @"中", @"大"]];
    self.rowSpaceControl.tintColor = [UIColor redColor];
    self.rowSpaceControl.selectedSegmentIndex = 1;
    [self.rowSpaceControl addTarget:self action:@selector(rowSpaceValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.rowSpaceControl];
    
    WS(weakSelf);
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.btnNight.mas_left);
        make.height.equalTo(weakSelf.contentView).multipliedBy(SUBVIEW_HEIGHT_FACTOR);
    }];
    [_btnNight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(weakSelf.contentView);
        make.height.equalTo(weakSelf.contentView).multipliedBy(SUBVIEW_HEIGHT_FACTOR);
    }];
    [_fontSizeStepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.btnNight.mas_bottom);
        make.right.equalTo(weakSelf.fontSizeLabel.mas_left);
        make.height.equalTo(weakSelf.contentView).multipliedBy(SUBVIEW_HEIGHT_FACTOR);
    }];
    [_fontSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.btnNight.mas_bottom);
        make.height.equalTo(weakSelf.contentView).multipliedBy(SUBVIEW_HEIGHT_FACTOR);
        make.width.equalTo(weakSelf.fontSizeLabel.mas_height);
    }];
    [_skinSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.fontSizeStepper.mas_bottom);
        make.height.equalTo(weakSelf.contentView).multipliedBy(SUBVIEW_HEIGHT_FACTOR);
    }];
    [_rowSpaceControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.skinSelector.mas_bottom);
    }];
}

#pragma mark - Event
- (void) sliderValueChange:(UISlider*)slider {
    [[UIScreen mainScreen] setBrightness:slider.value];
}

- (void) clickNight:(UIButton*)btn {
    
}

- (void) fontSizeDidChange:(UIStepper*)stepper {
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%ld", (long)self.fontSizeStepper.value];
}

- (void) rowSpaceValueDidChange:(UISegmentedControl*)rowSpace {
    
}

#pragma mark - CollectionView datasource && delegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return skins.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SkinSelectorCell *cell = (SkinSelectorCell*)[collectionView dequeueReusableCellWithReuseIdentifier:skinSelectorCellIndentifier forIndexPath:indexPath];
    cell.textLabel.textColor = [skins objectAtIndex:indexPath.item][0];
    cell.textLabel.backgroundColor = [skins objectAtIndex:indexPath.item][1];
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
