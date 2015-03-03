//
//  FileUtils.h
//  TXTReader
//
//  Created by PYgzx on 15/2/19.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUnknownStringEncoding -1

@interface FileUtils : NSObject

+ (NSStringEncoding) recognizeEncodingWithPath:(NSString*)path;
+ (NSStringEncoding) recognizeEncodingWithData:(NSData*)data;

@end
