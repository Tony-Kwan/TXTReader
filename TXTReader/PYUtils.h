//
//  Created by 关仲贤 on 15/2/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "FMDB.h"
#import "GlobalSettingAttrbutes.h"

//MACRO
#define DEBUG_VERSION 1
#if DEBUG_VERSION == 1
#define PYLog(...) NSLog(__VA_ARGS__)
#else
#define PYLog(...)
#endif

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define DOCUMENTS_PATH NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)[0]
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self
#define PrintCGRect(rect) NSLog(@"%s %f %f %f %f", __PRETTY_FUNCTION__, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define PrintCGPoint(point) NSLog(@"%s %f %f", __PRETTY_FUNCTION__, point.x, point.y)
#define PrintCGSize(size) NSLog(@"%s %f %f", __PRETTY_FUNCTION__, size.width, size.height)
#define DegreesToRadians(x) (M_PI*(x)/180.0)
#define AUTORESIZING_WIDTH_AND_HEIGHT UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
#define BLACK_COLOR [UIColor blackColor]
#define WHITE_COLOR [UIColor whiteColor]
#define SYSTEM_FONT(fontSize) [UIFont systemFontOfSize:fontSize]

#define PYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(rgbValue, a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:a]

CG_INLINE CGPoint CGPointAdd(CGPoint p1, CGPoint p2) {
    return CGPointMake(p1.x+p2.x, p1.y+p2.y);
}

CG_INLINE CGRect CGRectMultiplied(CGRect rect, CGFloat m) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*m, rect.size.height*m);
}

@interface PYUtils : NSObject

+ (CGFloat) screenHeight;
+ (CGFloat) screenWidth;

+ (UIButton*) customButtonWith:(NSString*)title target:(id)obj andAction:(SEL)selector;
+ (UILabel *)customLabelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color;

+ (NSLayoutConstraint *)centerYConstraintWithItem:(id)item toItem:(id)item2;
+ (NSLayoutConstraint *)centerXConstraintWithItem:(id)item toItem:(id)item2;
+ (NSArray *)centerXYConstraintWithItem:(id)item toItem:(id)item2;
+ (NSArray *)centerXYConstraintWithItem:(id)item toItem:(id)item2 withOffsetY:(CGFloat)offsetY;

@end
