//
//  DBUtils.h
//  TXTReader
//
//  Created by PYgzx on 15/3/8.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookSource.h"
#import "PYUtils.h"

@interface DBUtils : NSObject

+ (BOOL) queryBook:(Book*)book;
+ (void) updateWithBook:(Book*)book;
+ (void) addBook:(Book*)book;
+ (BOOL) isBookInDB:(Book*)book;

@end
