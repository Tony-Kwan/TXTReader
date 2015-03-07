//
//  ToolBarView.h
//  TXTReader
//
//  Created by 关仲贤 on 15/2/26.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookSource.h"

@protocol ToolBarViewDelegate <NSObject>
@required
- (void) toolBarDidClickSetting;
- (void) toolBarDidClickMenu;
- (void) toolBarSliderValueChangingTo:(CGFloat)value;
- (void) toolBarSliderValueChangedTo:(CGFloat)value;

@end

@interface ToolBarView : UIView

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *btnSetting, *btnMenu;

@property (nonatomic, strong) UIButton *btnLastReading;
@property (nonatomic, strong) UILabel *progressLabel, *paginatingLabel;
@property (nonatomic, weak) id<ToolBarViewDelegate> delegate;

@end
