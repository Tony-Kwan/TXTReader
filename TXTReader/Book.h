//
//  Book.h
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BookDelegate <NSObject>
@optional
- (void) bookDidPaginate;
- (void) paginatingPregress:(CGFloat)progress;

@end

typedef enum {
    Book_TXT
}BookType;

@interface Book : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) NSUInteger pageCount;
@property (nonatomic, assign) BookType type;
@property (nonatomic, strong) NSString* path;
@property (nonatomic, strong) NSDate *lastUpdate;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, retain) NSMutableArray *pageIndexArray/*NSNumber*/, *chaptersTitleRange, *bookMarksOffset;
@property (nonatomic, assign) BOOL isPaginate;
@property (nonatomic, assign) NSStringEncoding encoding;
@property (nonatomic, assign) NSUInteger lastReadOffset;
@property (nonatomic, weak) id<BookDelegate> delegate;

@property (nonatomic, assign) BOOL canPaginate;

- (id) initWithPath:(NSString*)path;
- (NSAttributedString*) textAtPage:(NSInteger)index;
- (void) paginate;
- (void) parseBook;
- (NSUInteger) offsetOfChapterIndex:(NSUInteger)index;
- (NSAttributedString*) getStringWithOffset:(NSUInteger)offset;
- (NSAttributedString*) getBeforeStringWithOffset:(NSUInteger)offset;
- (NSInteger) getPageIndexByOffset:(NSUInteger)offset;
- (NSUInteger) length;
- (void) addBookmarkWithOffset:(NSUInteger)offset;
- (void) deleteBookmarkWithOffset:(NSInteger)offset;
- (BOOL) isOneOfBookmarkOffset:(NSUInteger)offset;

@end
