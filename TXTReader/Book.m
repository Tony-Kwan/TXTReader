//
//  Book.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "Book.h"

@implementation Book

- (id) initWithPath:(NSString *)path {
    if((self = [super init])) {
        self.path = path;
        
        NSRange range = [path rangeOfString:@"/" options:NSBackwardsSearch];
        NSRange range2 = [path rangeOfString:@".txt" options:NSBackwardsSearch];
        self.name = [path substringWithRange:NSMakeRange(range.location+1, range2.location-range.location-1)];
        self.length = 0;
        self.type = Book_TXT;
        self.pageCount = 0;
        self.lastUpdate = [NSDate dateWithTimeIntervalSinceNow:0];
    }
    return self;
}

@end
