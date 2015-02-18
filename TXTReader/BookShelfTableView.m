//
//  BookShelfTableView.m
//  TXTReader
//
//  Created by PYgzx on 15/2/18.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "BookShelfTableView.h"

static NSString *tableCellIndentifier = @"tableCellIndentifier";

@implementation BookShelfTableView

- (id) init {
    if((self = [super init])) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.autoresizingMask = AUTORESIZING_WIDTH_AND_HEIGHT;
        self.backgroundColor = [UIColor brownColor];
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[TableCell class] forCellReuseIdentifier:tableCellIndentifier];
    }
    return self;
}

#pragma mark - tableView delegate & dateSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[BookSource shareInstance] count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row >= [[BookSource shareInstance] count]) {
        return nil;
    }
    Book *book = [[BookSource shareInstance] bookAtIndex:indexPath.row];
    
    TableCell* cell = (TableCell*)[tableView dequeueReusableCellWithIdentifier:tableCellIndentifier forIndexPath:indexPath];
    cell.titleLabel.text = book.name;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
