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
        self.skins = @[@[[UIColor lightTextColor], APP_COLOR],
                       @[BLACK_COLOR, WHITE_COLOR],
                       @[WHITE_COLOR, BLACK_COLOR],
                       @[[UIColor greenColor], APP_COLOR],
                       @[[UIColor blueColor], [UIColor yellowColor]],
                       @[[UIColor cyanColor], APP_COLOR],
                       @[[UIColor yellowColor], [UIColor redColor]],
                       @[[UIColor redColor], [UIColor whiteColor]]];
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
            self.rowSpace = [[USER_DEFAULTS objectForKey:GLOBAL_ROW_SPACE] floatValue];
        }
        else {
            self.rowSpace = 5.f;
        }
        if([USER_DEFAULTS objectForKey:GLOBAL_NIGHT]) {
            self.isNight = [[USER_DEFAULTS objectForKey:GLOBAL_NIGHT] boolValue];
        }
        else {
            self.isNight = NO;
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

- (NSString*) rowSpaceString {
    if(self.rowSpace < 5.f) {
        return @"小";//0
    }
    else if(self.rowSpace < 8.0) {
        return @"中";//5
    }
    else {
        return @"大";//10
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
//    _paraStyle.hyphenationFactor = 30;   // 未知
    _paraStyle.minimumLineHeight = 10;
    _paraStyle.maximumLineHeight = 30;
    
    return _paraStyle;
}

- (NSDictionary*) attributes {
    return @{NSFontAttributeName : self.font,
             NSParagraphStyleAttributeName: self.paraStyle};
}

@end
