//
//  BookSource.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "BookSource.h"
#import "PYUtils.h"

@interface BookSource()

@property (nonatomic, retain) NSMutableArray *books;

@end

@implementation BookSource

+ (id) shareInstance {
    static dispatch_once_t once;
    static BookSource* source;
    dispatch_once(&once, ^{
        source = [BookSource new];
        [source loadBooks];
    });
    return source;
}

- (id) init {
    if((self = [super init])) {
        self.books = [NSMutableArray array];
        _currentReadingBookIndex = -1;
    }
    return self;
}

#pragma mark - public
- (void) loadBooks {
    NSString* str;
    
    const int bookCount = 8;
    
    [self.books removeAllObjects];
    for(int i = 0; i < bookCount; i++) {
        str = [NSString stringWithFormat:@"%d", i%bookCount];
        NSString *bookPath = [[NSBundle mainBundle] pathForResource:str ofType:@"txt"];
        Book *book = [[Book alloc] initWithPath:bookPath];
        [self.books addObject:book];
    }
}

- (void) clearCache {
    PYLog(@"%s", __PRETTY_FUNCTION__);
    for (Book* book in _books) {
        book.content = nil;
    }
}

- (NSInteger) count {
    return self.books.count;
}

- (Book*) bookAtIndex:(NSUInteger)index {
    return (Book*)[self.books objectAtIndex:index];
}

- (NSUInteger) indexOfBook:(Book *)book {
    return [self.books indexOfObject:book];
}

- (Book*) currentReadingBook {
    if(_currentReadingBookIndex < 0 || _currentReadingBookIndex >= _books.count) {
        return nil;
    }
    else {
        return [_books objectAtIndex:_currentReadingBookIndex];
    }
}

@end
