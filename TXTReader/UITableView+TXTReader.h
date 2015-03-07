//
//  UITableView+TXTReader.h
//  TXTReader
//
//  Created by PYgzx on 15/3/6.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITableViewBuilder;

typedef void(^UITableViewBuildBlock)(UITableViewBuilder* builder);

@interface UITableViewBuilder : NSObject

@property (nonatomic, weak) id<UITableViewDataSource> dataSource;
@property (nonatomic, weak) id<UITableViewDelegate> delegate;
@property (nonatomic, assign) Class cellClass;
@property (nonatomic, strong) NSString* cellIndentifier;
@property (nonatomic, assign) CGRect frame;

- (UITableView*) build;

@end








@interface UITableView(TXTReader)

+ (instancetype) createWithBlock:(UITableViewBuildBlock)block;

@end
