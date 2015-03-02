//
//  FileUtils.m
//  TXTReader
//
//  Created by PYgzx on 15/2/19.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "FileUtils.h"

#define RECOGNIZE_ENCODING(bytes, a, b) ((bytes[0] == a) && (bytes[1] == b))

const NSStringEncoding kUnknownStringEncoding = -1;

@implementation FileUtils

+ (NSStringEncoding) recognizeEncodingWithPath:(NSString *)path {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [fileHandle readDataOfLength:3];
    
    if([data length] != 3) {
        return kUnknownStringEncoding;
    }
    [fileHandle closeFile];
    return [FileUtils recognizeEncodingWithData:data];
}

+ (NSStringEncoding) recognizeEncodingWithData:(NSData*)data {
    NSStringEncoding encoding = kUnknownStringEncoding;
    const unsigned char* bytes = [data bytes];
    if(RECOGNIZE_ENCODING(bytes, 0xff, 0xfe)) {
        encoding = NSUTF16LittleEndianStringEncoding;
    }
    else if (RECOGNIZE_ENCODING(bytes, 0xfe, 0xff)) {
        encoding = NSUTF16BigEndianStringEncoding;
    }
    else if (RECOGNIZE_ENCODING(bytes, 0xef, 0xbb) && bytes[2] == 0xbf) {
        encoding = NSUTF8StringEncoding;
    }
    else {
        encoding = NSUTF8StringEncoding;
    }
    
    return encoding;
}

@end
