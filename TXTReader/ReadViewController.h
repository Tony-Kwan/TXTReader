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

@interface ReadViewController : UIViewController

@property (nonatomic, strong) Book* book;
@property (nonatomic, assign) NSInteger currentPageIndex;

- (id) initWithBook:(Book*)book;

@end
