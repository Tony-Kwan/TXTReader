//
//  MenuViewController.h
//  TXTReader
//
//  Created by 关仲贤 on 15/3/2.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate <NSObject>
@required
- (void) seekToOffset:(NSUInteger)offset;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, weak) id<MenuViewControllerDelegate> delegate;

@end
