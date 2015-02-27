//
//  Book.h
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    Book_TXT
}BookType;

@interface Book : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) NSUInteger length; //byte
@property (nonatomic, assign) int pageCount;
@property (nonatomic, assign) BookType type;
@property (nonatomic, strong) NSString* path;
@property (nonatomic, strong) NSDate *lastUpdate;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSMutableParagraphStyle *paraStyle;

- (id) initWithPath:(NSString*)path;
- (NSAttributedString*) textAtPage:(NSInteger)index;
- (BOOL) paging;

@end
