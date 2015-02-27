//
//  GlobalSettingAttrbutes.h
//  TXTReader
//
//  Created by 关仲贤 on 15/2/27.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PYUtils.h"

#define GLOBAL_SKIN_INDEX @"SKIN_INDEX"
#define GLOBAL_FONT_SIZE @"FONT_SIZE"
#define GLOBAL_ROW_SPACE @"GLOBAL_ROW_SPACE"
#define GLOBAL_NIGHT @"GLOBAL_NIGHT"

#define APP_COLOR #import UIColorFromRGB(0x282b35)


@interface GlobalSettingAttrbutes : NSObject

@property (nonatomic, assign) NSInteger fontSize, skinIndex;
@property (nonatomic, strong) NSArray *skins;
@property (nonatomic, assign) CGFloat rowSpace;
@property (nonatomic, assign) BOOL isNight;

+ (id) shareSetting;

- (NSArray*) skin;
- (UIFont*) font;
- (NSString*) rowSpaceString;
- (NSMutableParagraphStyle*) paraStyle;
- (NSDictionary*) attributes;

@end
