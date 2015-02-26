//
//  ToolBarView.h
//  TXTReader
//
//  Created by 关仲贤 on 15/2/26.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolBarViewDelegate <NSObject>


@end

@interface ToolBarView : UIView

@property (nonatomic, weak) id<ToolBarViewDelegate> delegate;

@end
