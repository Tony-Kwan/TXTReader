//
//  BookSource.h
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@interface BookSource : NSObject

+ (id) shareInstance;

- (void) loadBooks;
- (NSInteger) count;
- (Book*) bookAtIndex:(NSUInteger)index;

@end
