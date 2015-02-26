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
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
