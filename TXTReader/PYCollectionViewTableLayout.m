//
//  PYCollectionViewTableLayout.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "PYCollectionViewTableLayout.h"
#import "PYUtils.h"

@implementation PYCollectionViewTableLayout

- (id) init {
    if((self = [super init])) {
        self.itemSize = CGSizeMake([PYUtils screenWidth], 50);
        self.minimumInteritemSpacing = 3.f;
        self.minimumLineSpacing = 3.0f;
    }
    return self;
}

@end
