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
//        [source loadBooks];
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
    
    [self.books removeAllObjects];
    
    const int bookCount = 8;
    for(int i = 0; i < bookCount; i++) {
        str = [NSString stringWithFormat:@"%d", i%bookCount];
        NSString *bookPath = [[NSBundle mainBundle] pathForResource:str ofType:@"txt"];
        Book *book = [[Book alloc] initWithPath:bookPath];
        [self.books addObject:book];
    }
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:DOCUMENTS_PATH error:nil];
//    for (NSString *name in fileNames) {
//        if([name hasSuffix:@".txt"]) {
//            str = [DOCUMENTS_PATH stringByAppendingPathComponent:name];
//            NSLog(@"%@", str);
//            Book *book = [[Book alloc] initWithPath:str];
//            [self.books addObject:book];
//        }
//    }
    if(self.deleaget && [self.deleaget respondsToSelector:@selector(bookSourceDidChange)]) {
        [self.deleaget bookSourceDidChange];
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

- (void) sortBooksWithType:(BookSortType)type completeBlock:(SortCompleteBlock)block {
    NSArray *sortArray = [self.books sortedArrayUsingComparator:^NSComparisonResult(Book* obj1, Book* obj2) {
        if(type == kSort_name) {
            return [obj1.name compare:obj2.name];
        }
        else if (type == kSort_count) {
            return [[NSNumber numberWithUnsignedInteger:[obj2 length]] compare:[NSNumber numberWithUnsignedInteger:[obj1 length]]];
        }
        else if (type == kSort_date) {
            return [[obj1 lastUpdate] compare:[obj2 lastUpdate]];
        }
        else {
            return [[NSNumber numberWithFloat:((CGFloat)obj2.lastReadOffset / (CGFloat)(obj2.length))] compare:[NSNumber numberWithFloat:((CGFloat)obj1.lastReadOffset / (CGFloat)(obj1.length))]];
        }
    }];
    self.books = [NSMutableArray arrayWithArray:sortArray];
    
    if(block) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

- (void) moveBookFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    Book* book = [self.books objectAtIndex:fromIndex];
    [self.books removeObject:book];
    [self.books insertObject:book atIndex:toIndex];
    
    if(self.deleaget && [self.deleaget respondsToSelector:@selector(bookSourceDidChange)]) {
        [self.deleaget bookSourceDidChange];
    }
}

@end
