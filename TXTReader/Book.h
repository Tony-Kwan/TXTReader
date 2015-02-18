//
//  Book.h
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Book_TXT
}BookType;

@interface Book : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) NSUInteger length; //byte
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) BookType type;
@property (nonatomic, strong) NSString* path;
@property (nonatomic, strong) NSDate *lastUpdate;

- (id) initWithPath:(NSString*)path;

@end
