//
//  BookSource.h
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

typedef enum {
    kSort_count,
    kSort_date,
    kSort_name,
    kSort_progress
}BookSortType;

typedef void(^SortCompleteBlock)(void);



@protocol BookSourceDelegate <NSObject>

- (void) bookSourceDidChange;

@end


@interface BookSource : NSObject

@property (nonatomic, assign) NSInteger currentReadingBookIndex;
@property (nonatomic, strong) Book *readingBook;
@property (nonatomic, weak) id<BookSourceDelegate> deleaget;

+ (instancetype) shareInstance;

- (void) loadBooks;
- (void) clearCache;
- (NSInteger) count;
- (NSUInteger) indexOfBook:(Book*)book;
- (Book*) bookAtIndex:(NSUInteger)index;
- (Book*) currentReadingBook;
- (void) sortBooksWithType:(BookSortType)type completeBlock:(SortCompleteBlock)block;
- (void) moveBookFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (void) removeBookAtIndex:(NSUInteger)index;
- (void) updateBooksFromDB;

@end
