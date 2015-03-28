//
//  TextViewController.h
//  TXTReader
//
//  Created by 关仲贤 on 15/2/25.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *bgImageView;

- (id) initWithText:(NSAttributedString*)text color:(UIColor*)color andFont:(UIFont*)font;

//- (void) setTextColor:(UIColor*)textColor andBackgoundColor:(UIColor*)bgColor;
- (void) setSkin:(NSArray*)skin;

@end
