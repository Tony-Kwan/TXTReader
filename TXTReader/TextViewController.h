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

- (id) initWithText:(NSString*)text color:(UIColor*)color andFont:(UIFont*)font;

@end
