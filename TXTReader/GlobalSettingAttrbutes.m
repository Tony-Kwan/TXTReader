//
//  GlobalSettingAttrbutes.m
//  TXTReader
//
//  Created by 关仲贤 on 15/2/27.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "GlobalSettingAttrbutes.h"

@implementation GlobalSettingAttrbutes

+ (id) shareSetting {
    static GlobalSettingAttrbutes *shareInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareInstance = [[GlobalSettingAttrbutes alloc] init];
    });
    return shareInstance;
}

- (id) init {
    if((self = [super init])) {
        self.skins = @[@[[UIColor blackColor], [UIImage imageNamed:@"karft-1"]],
                       @[[UIColor blackColor], [UIImage imageNamed:@"karft-2"]],
                       @[[UIColor whiteColor], [UIImage imageNamed:@"karft-3"]],
                       @[[UIColor lightTextColor], APP_COLOR],
                       @[BLACK_COLOR, WHITE_COLOR],
                       @[WHITE_COLOR, BLACK_COLOR],
                       @[[UIColor greenColor], APP_COLOR],
                       @[[UIColor blueColor], [UIColor yellowColor]],
                       @[[UIColor cyanColor], APP_COLOR],
                       @[[UIColor yellowColor], [UIColor redColor]],
                       @[[UIColor redColor], [UIColor whiteColor]]
                       ];
        
        if([USER_DEFAULTS objectForKey:GLOBAL_SKIN_INDEX]) {
            self.skinIndex = [[USER_DEFAULTS objectForKey:GLOBAL_SKIN_INDEX] integerValue];
        }
        else {
            self.skinIndex = 0;
        }
        if([USER_DEFAULTS objectForKey:GLOBAL_FONT_SIZE]) {
            self.fontSize = [[USER_DEFAULTS objectForKey:GLOBAL_FONT_SIZE] floatValue];
        }
        else {
            self.fontSize = 15;
        }
        if([USER_DEFAULTS objectForKey:GLOBAL_ROW_SPACE]) {
            self.rowSpaceIndex = [[USER_DEFAULTS objectForKey:GLOBAL_ROW_SPACE] integerValue];
        }
        else {
            self.rowSpaceIndex = 1;
        }
        if([USER_DEFAULTS objectForKey:GLOBAL_NIGHT]) {
            self.isNight = [[USER_DEFAULTS objectForKey:GLOBAL_NIGHT] boolValue];
        }
        else {
            self.isNight = NO;
        }
        if([USER_DEFAULTS objectForKey:GLOBAL_SCROLLMODE]) {
            self.scrollMode = [[USER_DEFAULTS objectForKey:GLOBAL_SCROLLMODE] integerValue];
        }
        else {
            self.scrollMode = 0;
        }
        
    }
    return self;
}

#pragma mark - public
- (NSArray*) skin {
    if(_skinIndex < 0 || _skinIndex >= _skins.count) {
        _skinIndex = 0;
    }
    return self.skins[self.skinIndex];
}

- (UIColor*) textColor {
    if(_skinIndex < 0 || _skinIndex >= _skins.count) {
        _skinIndex = 0;
    }
    return self.skins[_skinIndex][0];
}

- (UIColor*) backgoundColor {
    if(_skinIndex < 0 || _skinIndex >= _skins.count) {
        _skinIndex = 0;
    }
    return self.skins[_skinIndex][1];
}

- (UIFont*) font {
    return [UIFont systemFontOfSize:self.fontSize];
}

- (CGFloat) rowSpace {
    switch (self.rowSpaceIndex) {
        case 0:
            return 0.f;
        case 1:
            return 5.f;
        case 2:
            return 10.f;
        default:
            return 5.f;
    }
}

- (NSMutableParagraphStyle*) paraStyle {
    NSMutableParagraphStyle* _paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    _paraStyle.lineSpacing = self.rowSpace;
    _paraStyle.firstLineHeadIndent = 0;
    _paraStyle.headIndent = 0;
    _paraStyle.tailIndent = [PYUtils screenWidth] - 10;
    _paraStyle.paragraphSpacing = self.rowSpace * 2 + 1;
    _paraStyle.alignment = NSTextAlignmentLeft;
    _paraStyle.lineBreakMode = NSLineBreakByWordWrapping;    // 换行方式
    _paraStyle.paragraphSpacingBefore = 0;  //段落之前的间距
    _paraStyle.minimumLineHeight = 10;
    _paraStyle.maximumLineHeight = 30;
    
    return _paraStyle;
}

- (NSDictionary*) attributes {
    return @{NSFontAttributeName : self.font,
             NSParagraphStyleAttributeName: self.paraStyle};
}

@end
