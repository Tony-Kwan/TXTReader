//
//  BookShelfDelegate.h
//  TXTReader
//
//  Created by PYgzx on 15/2/19.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@protocol BookShelfDelegate <NSObject>
@required
- (void) openBook:(Book*)book;

@end
