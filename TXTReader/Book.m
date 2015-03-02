//
//  Book.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "Book.h"
#import "FileUtils.h"
#import "PYUtils.h"

@interface Book() {
    int totalPages_;
    int charsPerPage_, textLength_, charsOfLastPage_;
    UIFont *preferredFont_;
    NSString *strForTest, *secondPageText;
    UILabel *label;
}

@end

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
        self.encoding = 0;
    }
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"name: %@ count: %@", self.name, @(self.pageCount)];
}

#pragma mark - property
- (NSString*) content {
    if(!_content) {
        NSError *err = nil;
        NSData *data = [NSData dataWithContentsOfFile:self.path options:NSDataReadingMappedAlways error:&err];
        if(err) {
            _content = nil;
        }
        else {
            _content = [[NSString alloc] initWithData:data encoding:self.encoding];
        }
    }
    self.length = _content.length;
    return _content;
}

- (NSUInteger) pageCount {
    return self.pageIndexArray.count;
}

- (NSStringEncoding) encoding {
    if(!_encoding) {
        NSError *err = nil;
        NSData *data = [NSData dataWithContentsOfFile:self.path options:NSDataReadingMappedAlways error:&err];
        if(err) {
            _encoding = NSUTF8StringEncoding;
        }
        else {
            NSData *subData = [data subdataWithRange:NSMakeRange(0, 3)];
            _encoding = [FileUtils recognizeEncodingWithData:subData];
        }
    }
    return _encoding;
}

#pragma mark - public
- (NSAttributedString*) textAtPage:(NSInteger)index {
    if(index > self.pageIndexArray.count) {
        return nil;
    }
    NSString *text;
    if(index == self.pageIndexArray.count) {
        text = [self.content substringWithRange:NSMakeRange([[self.pageIndexArray objectAtIndex:index-1] unsignedLongLongValue], self.content.length - [[self.pageIndexArray objectAtIndex:index-1] unsignedLongLongValue])];
    }
    else {
        text = [self.content substringWithRange:NSMakeRange([[self.pageIndexArray objectAtIndex:index-1] unsignedLongLongValue], [[self.pageIndexArray objectAtIndex:index] unsignedLongLongValue] - [[self.pageIndexArray objectAtIndex:index-1] unsignedLongLongValue])];
    }
    
    GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:text attributes:st.attributes];
    return attrText;
}

#define PAGINATE_DEVIATION 3
#define PAGINATE_MIN_CHARS 100

- (void) paginate {
    GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
    NSDictionary *attrs = [st attributes];
    
    CGFloat width = [PYUtils screenWidth] - 2*TEXTVIEW_HORIZONTAL_INSET;
    CGFloat height = [PYUtils screenHeight] - 2*TEXTVIEW_VERTICAL_INSET;
    CGRect textRect;
    NSString *subText = self.content;
    self.pageIndexArray = [NSMutableArray array];
    NSUInteger length = 480;
    NSUInteger offset = 0;
    NSUInteger left, right, mid;
    CGSize boundingSize = CGSizeMake(width, CGFLOAT_MAX);
    
    PYLog(@"start | self.length = %lu", self.length);
    
    while (offset < self.length) {
        if(offset + length >= self.length) {
            length = self.length - offset;
            subText = [self.content substringWithRange:NSMakeRange(offset, length)];
            textRect = [subText boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil];
            if(textRect.size.height <= height) {
                [self.pageIndexArray addObject:@(offset)];
                break;
            }
        }
        left = PAGINATE_MIN_CHARS;
        right = length;
        while (left < right - PAGINATE_DEVIATION) {
            mid = left + (right - left) / 2;
            subText = [self.content substringWithRange:NSMakeRange(offset, mid)];
            textRect = [subText boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil];
            if(textRect.size.height > height) {
                right = mid - PAGINATE_DEVIATION;
            }
            else {
                left = mid;
            }
//            NSLog(@"%u %u %u", left, right, mid);
        }
        [self.pageIndexArray addObject:@(offset)];
        offset += left;
//        if(left == PAGINATE_MIN_CHARS)
            NSLog(@"offset = %lu, left = %lu | %f %f | index = %lu", offset, left, height, textRect.size.height, self.pageCount);
    }
    
    PYLog(@"end | self.pageCount = %lu", self.pageCount);
}

- (void) testRegular {
    NSMutableArray *captersRange = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"7.txt" ofType:nil];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path options:NSDataReadingMappedAlways error:nil];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString* parten = @"(第.回)";
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matchs = [reg matchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, text.length)];
    
    for (NSTextCheckingResult* result in matchs) {
        NSUInteger len = 0;
        //        NSLog(@"%@", [text substringWithRange:NSMakeRange(result.range.location, result.range.length)]);
        while (![[text substringWithRange:NSMakeRange(result.range.location+result.range.length+len, 1)] isEqualToString:@"\n"]) {
            len++;
        }
        NSLog(@"%u %@", len, [text substringWithRange:NSMakeRange(result.range.location, result.range.length+len)]);
        [captersRange addObject:[NSValue valueWithRange:NSMakeRange(result.range.location, result.range.length+len)]];
    }
    NSLog(@"%u", captersRange.count);
}

@end
