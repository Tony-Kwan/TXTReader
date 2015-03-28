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
#import "PYStepper.h"

#define SUBVIEW_HEIGHT_FACTOR 0.25f

static NSString *skinSelectorCellIndentifier = @"skinSelectorCell";

@interface SettingView()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UISlider *slider;
//@property (nonatomic, strong) UIButton *btnNight;
@property (nonatomic, strong) UISegmentedControl *rowSpaceControl;
@property (nonatomic, strong) PYStepper *fontSizeStepper;
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
    self.backgroundColor = [APP_COLOR colorWithAlphaComponent:0.9];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    self.slider = [[UISlider alloc] init];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 1.f;
    self.slider.value = [[UIScreen mainScreen] brightness];
//    self.slider.minimumTrackTintColor = [UIColor blackColor];
//    self.slider.maximumTrackTintColor = [UIColor whiteColor];
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"slider-black-track"] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"slider-white-track"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"slider-thumb"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.slider];
    
//    self.btnNight = [PYUtils customButtonWith:@"夜" target:self andAction:@selector(clickNight:)];
//    [self.btnNight setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
//    [self.contentView addSubview:self.btnNight];
    
    self.fontSizeStepper = [[PYStepper alloc] init];
    self.fontSizeStepper.minimumValue = 15;
    self.fontSizeStepper.maximumValue = 22;
    self.fontSizeStepper.value = 17;
    self.fontSizeStepper.tintColor = APP_TINTCOLOR;
    [self.fontSizeStepper addTarget:self action:@selector(fontSizeDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.fontSizeStepper];
    
    CGFloat collectionViewHeight = self.bounds.size.height * SUBVIEW_HEIGHT_FACTOR - 10;
    CGFloat inset = 2;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(collectionViewHeight - inset * 2, collectionViewHeight - inset * 2);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset*2, inset, inset*2);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.skinSelector = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
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
    self.rowSpaceControl.tintColor = APP_TINTCOLOR;
    self.rowSpaceControl.selectedSegmentIndex = 1;
    [self.rowSpaceControl addTarget:self action:@selector(rowSpaceValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.rowSpaceControl];
    
    WS(weakSelf);
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.height.equalTo(weakSelf.contentView).multipliedBy(SUBVIEW_HEIGHT_FACTOR);
    }];
    [_fontSizeStepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.slider.mas_bottom).offset(5);
        make.left.right.equalTo(weakSelf.slider);
        make.height.equalTo(weakSelf.contentView).multipliedBy(SUBVIEW_HEIGHT_FACTOR).offset(-10);
    }];
    [_skinSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.slider);
        make.top.equalTo(weakSelf.fontSizeStepper.mas_bottom).offset(5);
        make.height.equalTo(weakSelf.contentView).multipliedBy(SUBVIEW_HEIGHT_FACTOR).offset(-10);
    }];
    [_rowSpaceControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView).offset(-5);
        make.left.right.equalTo(weakSelf.slider);
        make.top.equalTo(weakSelf.skinSelector.mas_bottom).offset(5);
    }];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self.skinSelector selectItemAtIndexPath:[NSIndexPath indexPathForItem:[[GlobalSettingAttrbutes shareSetting] skinIndex] inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

#pragma mark - Event
- (void) sliderValueChange:(UISlider*)slider {
    [[UIScreen mainScreen] setBrightness:slider.value];
}

//- (void) clickNight:(UIButton*)btn {
//    if(btn.state != UIControlStateNormal) {
//        
//    }
//}

- (void) fontSizeDidChange:(UIStepper*)stepper {
    [self.delegate changeFontSizeTo:self.fontSizeStepper.value];
}

- (void) rowSpaceValueDidChange:(UISegmentedControl*)rowSpaceSC {
    [self.delegate changeRowSpaceIndexTo:rowSpaceSC.selectedSegmentIndex];
}

#pragma mark - CollectionView datasource && delegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[GlobalSettingAttrbutes shareSetting] skins] count];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SkinSelectorCell *cell = (SkinSelectorCell*)[collectionView dequeueReusableCellWithReuseIdentifier:skinSelectorCellIndentifier forIndexPath:indexPath];
    
    NSArray *skin = [[[GlobalSettingAttrbutes shareSetting] skins] objectAtIndex:indexPath.item];
    cell.textLabel.textColor = skin[0];
    if([skin[1] isKindOfClass:[UIColor class]]) {
        cell.textLabel.backgroundColor = skin[1];
    }
    else {
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.imageView.image = skin[1];
    }
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate changeSkinTo:indexPath.item];
}

@end
