//
//  PYPATHButton.h
//  PathStyleButton
//
//  Created by PYgzx on 15/3/28.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PYPATHButtonDelegate <NSObject>

- (void) PYPATHButtonDidClickAtIndex:(NSUInteger)index;

@end


@interface PYPATHButton : UIView

@property (nonatomic, weak) id<PYPATHButtonDelegate> delegate;

- (id) initWithMainImage:(UIImage*)mainImage buttonItems:(NSArray*)items;

@end
