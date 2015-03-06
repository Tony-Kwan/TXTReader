//
//  UITableView+TXTReader.m
//  TXTReader
//
//  Created by PYgzx on 15/3/6.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "UITableView+TXTReader.h"

@implementation UITableViewBuilder

- (UITableView*) build {
    UITableView *tv = [[UITableView alloc] initWithFrame:self.frame];
    [tv registerClass:self.cellClass forCellReuseIdentifier:self.cellIndentifier];
    tv.delegate = self.delegate;
    tv.dataSource = self.dataSource;
    
    return tv;
}

@end

@implementation UITableView(TXTReader)

+ (instancetype) createWithBlock:(UITableViewBuildBlock)block {
    NSParameterAssert(block);
    UITableViewBuilder *builder = [UITableViewBuilder new];
    block(builder);
    return [builder build];
}

@end
