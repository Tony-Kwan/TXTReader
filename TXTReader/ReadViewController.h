//
//  ReadViewController.h
//  TXTReader
//
//  Created by PYgzx on 15/2/20.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookSource.h"
#import "TextViewController.h"
#import "PYUtils.h"
#import "BookCoverView.h"

@protocol ReadViewControllerDelegate <NSObject>
@required
- (void) didEndReadBook:(Book*)book;

@end

@interface ReadViewController : UIViewController

@property (nonatomic, strong) Book* book;
@property (nonatomic, assign) NSUInteger currentPageIndex, currentPageOffset;
@property (nonatomic, weak) id<ReadViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage* coverImage;

- (id) initWithBook:(Book*)book;

@end
