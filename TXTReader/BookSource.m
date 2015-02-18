//
//  BookSource.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "BookSource.h"

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
    }
    return self;
}

#pragma mark - public
- (void) loadBooks {
    NSString* str;
    
    [self.books removeAllObjects];
    for(int i = 0; i < 30; i++) {
        str = [NSString stringWithFormat:@"%d", i%3];
        NSString *bookPath = [[NSBundle mainBundle] pathForResource:str ofType:@"txt"];
        Book *book = [[Book alloc] initWithPath:bookPath];
        [self.books addObject:book];
    }
}

- (NSInteger) count {
    return self.books.count;
}

- (Book*) bookAtIndex:(NSUInteger)index {
    return (Book*)[self.books objectAtIndex:index];
}

@end
