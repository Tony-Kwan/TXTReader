//
//  VEMessageView.h
//  VisionCut
//
//  Created by 关仲贤 on 15/1/12.
//  Copyright (c) 2015年 dji. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MESSAGEVIEW_APPEAR_TIME 1.0f
#define MESSAGEVIEW_APPEAR_DURATION 0.5f

@interface VEMessageView : UIView

@property (nonatomic, strong) UILabel *messageLabel;

- (id) initWithMessage:(NSString*)message andOtherMessage:(NSString*)otherMessage;
- (void) show;
- (void)setMessageLabelText:(NSString *)text;

@end
