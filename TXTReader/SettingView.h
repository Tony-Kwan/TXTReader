//
//  SettingView.h
//  TXTReader
//
//  Created by 关仲贤 on 15/2/26.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingViewDelegate <NSObject>
@required
- (void) changeRowSpaceTo:(CGFloat)rowSpace;
- (void) changeToNight:(BOOL)isNight;
- (void) changeFontSizeTo:(CGFloat)fontSize;
- (void) changeSkinTo:(NSInteger)index;

@end

@interface SettingView : UIView

@property (nonatomic, weak) id<SettingViewDelegate> delegate;

@end
