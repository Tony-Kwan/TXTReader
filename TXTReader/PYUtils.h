//
//  Created by 关仲贤 on 15/2/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Masonry.h"

//MACRO
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self
#define PrintCGRect(rect) NSLog(@"%s %f %f %f %f", __PRETTY_FUNCTION__, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define PrintCGPoint(point) NSLog(@"%s %f %f", __PRETTY_FUNCTION__, point.x, point.y)
#define PrintCGSize(size) NSLog(@"%s %f %f", __PRETTY_FUNCTION__, size.width, size.height)
#define DegreesToRadians(x) (M_PI*(x)/180.0)
#define AUTORESIZING_WIDTH_AND_HEIGHT UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
#define BLACK_COLOR [UIColor blackColor]
#define WHITE_COLOR [UIColor whiteColor]
#define SYSTEM_FONT(fontSize) [UIFont systemFontOfSize:fontSize]

CG_INLINE CGPoint CGPointAdd(CGPoint p1, CGPoint p2) {
    return CGPointMake(p1.x+p2.x, p1.y+p2.y);
}

CG_INLINE CGRect CGRectMultiplied(CGRect rect, CGFloat m) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*m, rect.size.height*m);
}

@interface PYUtils : NSObject

+ (CGFloat) screenHeight;
+ (CGFloat) screenWidth;

@end
