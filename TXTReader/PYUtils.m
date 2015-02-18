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

@end
