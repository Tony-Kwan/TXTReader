//
//  Created by 关仲贤 on 15/2/3.
//

#import "PYUtils.h"

@implementation PYUtils

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
