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
@property (nonatomic, assign) NSUInteger pageCount;
@property (nonatomic, assign) BookType type;
@property (nonatomic, strong) NSString* path;
@property (nonatomic, strong) NSDate *lastUpdate;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, retain) NSMutableArray *pageIndexArray, *chaptersTitleRange;
@property (nonatomic, assign) BOOL isPaginate;
@property (nonatomic, assign) NSStringEncoding encoding;

- (id) initWithPath:(NSString*)path;
- (NSAttributedString*) textAtPage:(NSInteger)index;
- (void) paginate;

@end
