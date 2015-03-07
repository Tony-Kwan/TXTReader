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

@property (nonatomic, assign) NSInteger currentReadingBookIndex;
@property (nonatomic, strong) Book *readingBook;

+ (id) shareInstance;

- (void) loadBooks;
- (void) clearCache;
- (NSInteger) count;
- (NSUInteger) indexOfBook:(Book*)book;
- (Book*) bookAtIndex:(NSUInteger)index;
- (Book*) currentReadingBook;

@end
