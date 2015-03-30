//
//  Created by 关仲贤 on 15/2/3.
//

#import "PYUtils.h"

@implementation PYUtils

+ (BOOL) iOSVersionGreaterOrEqual_8 { //7.x NO; 8.x YES
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //    NSLog(@"IOS VERSION = %f", version);
    if(version  >= 8.0) {
        return YES;
    }
    return NO;
}

+ (NSInteger) getCurrentOrientation {
    //    return [[UIDevice currentDevice] orientation];
    return [[UIApplication sharedApplication] statusBarOrientation];
}

+ (CGFloat) screenHeight {
    return  [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat) screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (UIButton*) customButtonWith:(NSString *)title target:(id)obj andAction:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = APP_FONT(17);
    return btn;
}

+ (UIButton*) customButtonWithImage:(UIImage *)image target:(id)obj andAction:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.backgroundColor = [UIColor blackColor];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UILabel *)customLabelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

// only yy-MM-dd to date
static NSString* dateFormatter = @"yyyy-MM-dd";
+ (NSDate*)string2Date:(NSString*)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [formatter setDateFormat:dateFormatter];
    return [formatter dateFromString:string];
}

+ (NSString*)date2String:(NSDate*)date shortDate:(BOOL)flag {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(flag) {
        [formatter setDateFormat:dateFormatter];
    }
    else {
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    }
    return [formatter stringFromDate:date];
}

+ (NSLayoutConstraint *)centerYConstraintWithItem:(id)item toItem:(id)item2
{
    return [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)centerXConstraintWithItem:(id)item toItem:(id)item2
{
    return [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
}

+ (NSArray *)centerXYConstraintWithItem:(id)item toItem:(id)item2
{
    return @[[PYUtils centerXConstraintWithItem:item toItem:item2], [PYUtils centerYConstraintWithItem:item toItem:item2]];
}

+ (NSArray *)centerXYConstraintWithItem:(id)item toItem:(id)item2 withOffsetY:(CGFloat)offsetY
{
    return @[
             [PYUtils centerXConstraintWithItem:item toItem:item2],
             [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:offsetY]
             ];
}

@end
