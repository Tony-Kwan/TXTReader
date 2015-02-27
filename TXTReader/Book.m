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
        self.font = SYSTEM_FONT(17);
        self.textColor = BLACK_COLOR;
    }
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@", self.name, @(self.pageCount)];
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
            NSData *subData = [data subdataWithRange:NSMakeRange(0, 3)];
            _content = [[NSString alloc] initWithData:data encoding:[FileUtils recognizeEncodingWithData:subData]];
        }
    }
    self.length = _content.length;
    return _content;
}

#pragma mark - public
- (NSAttributedString*) textAtPage:(NSInteger)index {
    if(index > totalPages_) {
        return nil;
    }
    NSString *text;
    if(index == totalPages_) {
        text = [_content substringWithRange:NSMakeRange((index - 1) * charsPerPage_, charsOfLastPage_)];
    }
    else {
        text = [_content substringWithRange:NSMakeRange((index - 1) * charsPerPage_, charsPerPage_)];
    }
//    NSLog(@"\n====================\n%@\n======================\n", text);
    
    GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:text attributes:st.attributes];
    return attrText;
}

/* 判断是否需要分页和进行分页 */
- (BOOL) paging {
    GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
    /* 获取文本内容的string值 */
    NSString *text  = self.content;
//    NSLog(@"%@", text);

    preferredFont_ = self.font;
    
    CGFloat width = [PYUtils screenWidth] - 20;
    CGFloat height = [PYUtils screenHeight] - 40;
    
    /* 计算文本串的总大小尺寸 Deprecated in iOS 7.0 */
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:st.attributes context:nil];
    CGSize totalTextSize = textRect.size;
    PrintCGRect(textRect);
    PrintCGSize(totalTextSize);
    
    
    /* 开始分页 */
    if (totalTextSize.height < height) {
        /* 如果一页就能显示完，直接显示所有文本 */
        totalPages_   = 1;             // 设定总页数为1
        charsPerPage_ = [text length]; // 设定每页的字符数
        textLength_   = [text length]; // 设定文本总长度
        return NO;                     // 不用分页
    }
    else {
        /* 计算理想状态下的页面数量和每页所显示的字符数量，用来作为参考值用 */
        textLength_                       = [text length];                               // 文本的总长度
        NSUInteger referTotalPages        = (int)totalTextSize.height / (int)height + 1; // 理想状态下的总页数
        NSUInteger referCharactersPerPage = textLength_ / referTotalPages;               // 理想状态下每页的字符数
        // 输出理想状态下的参数信息
        NSLog(@"textLength             = %d", textLength_);
        NSLog(@"referTotalPages        = %@", @(referTotalPages));
        NSLog(@"referCharactersPerPage = %@", @(referCharactersPerPage));
        
        
        /* 根据referCharactersPerPage和text view的高度开始动态调整每页的字符数 */
        // 如果referCharactersPerPage过大，则直接调整至下限值，减少调整的时间
        if (referCharactersPerPage > 600) {
            referCharactersPerPage = 600;
        }
        
        // 获取理想状态下的每页文本的范围和pageText及其尺寸
        NSRange range       = NSMakeRange(referCharactersPerPage, referCharactersPerPage); // 一般第一页字符数较少，所以取第二页的文本范围作为调整的参考标准
        NSString *pageText  = [text substringWithRange:range];                             // 获取该范围内的文本
//        NSLog(@"\n------------\n%@ \n----------------", pageText);
        
        CGRect pageTextRect = [pageText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading) attributes:st.attributes context:nil];
        CGSize pageTextSize  = pageTextRect.size;
        NSLog(@"height = %f", height);
        while (pageTextSize.height > height) {
            NSLog(@"pageTextSize.height = %f", pageTextSize.height);
            referCharactersPerPage -= 2;                                      // 每页字符数减2
            range                   = NSMakeRange(0, referCharactersPerPage); // 重置每页字符的范围
            pageText                = [text substringWithRange:range];        // 重置pageText
            textRect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading) attributes:st.attributes context:nil];
            pageTextSize            = textRect.size;
        }
        
        // 根据调整后的referCharactersPerPage设定好charsPerPage_
        charsPerPage_ = referCharactersPerPage;
        NSLog(@"每页字符数: %d", charsPerPage_);
        
        // 计算totalPages_
        totalPages_ = (int)text.length / charsPerPage_ + 1;
        self.pageCount = totalPages_;
        NSLog(@"总页数: %d", totalPages_);
        
        // 计算最后一页的字符数，防止范围溢出
        charsOfLastPage_ = textLength_ - (totalPages_ - 1) * charsPerPage_;
        NSLog(@"最后一页字符数: %d", charsOfLastPage_);
        NSLog(@"==========================");
        // 分页完成
        return YES;
    }
}

@end
