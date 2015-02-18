//
//  ImageCache.h
//  VisionCut
//
//  Created by 关仲贤 on 14/12/25.
//  Copyright (c) 2014年 dji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCache : NSObject

+ (ImageCache*) shareInstance;

- (void) writeImage:(UIImage*)image forKey:(NSString*)key;
- (UIImage*) readImageForKey:(NSString*)key;

- (UIImage*) graduallyImage;
- (UIImage*) graduallyTop2BottomImage;
- (UIImage*) heartImage;
- (UIImage*) smallPlayImage;
- (UIImage*) selectedImage;
- (UIImage*) photoPreviewImage;

@end
