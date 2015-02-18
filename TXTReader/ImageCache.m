//
//  ImageCache.m
//  VisionCut
//
//  Created by 关仲贤 on 14/12/25.
//  Copyright (c) 2014年 dji. All rights reserved.
//

#import "ImageCache.h"

@interface ImageCache()
{
    NSCache *_cache;
    UIImage* _graduallyImage;
    UIImage* _graduallyTop2BottomImage;
    UIImage* _heartImage;
    UIImage* _smallPlayImage;
    UIImage* _selectedImage;
    UIImage* _photoPreviewImage;
}

@end

@implementation ImageCache

+ (ImageCache*) shareInstance {
    static ImageCache* instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id) init {
    self = [super init];
    if(self) {
        _cache = [[NSCache alloc] init];
        _graduallyImage = [UIImage imageNamed:@"gradually"];
        _graduallyTop2BottomImage = [UIImage imageNamed:@"gradually_top2bottom"];
        _heartImage = [UIImage imageNamed:@"heart"];
        _smallPlayImage = [UIImage imageNamed:@"play-btn-small"];
        _selectedImage = [UIImage imageNamed:@"selected"];
        _photoPreviewImage = [UIImage imageNamed:@"photo-preview-button"];
    }
    return self;
}

- (void) writeImage:(UIImage *)image forKey:(NSString *)key {
//    NSLog(@"ImageCache: writeForKey %@", key);
    if(!image || !image.CGImage) {
        return ;
    }
    [_cache setObject:UIImageJPEGRepresentation(image, 1.f) forKey:key];
}

- (UIImage*) readImageForKey:(NSString *)key {
//    NSLog(@"readForKey: %@", key);
    if(!key) {
        return nil;
    }
    NSData *date = [_cache objectForKey:key];
    if(date) {
        return [UIImage imageWithData:date];
    }
    else {
        return nil;
    }
}

- (UIImage*) graduallyImage {
    return _graduallyImage;
}

- (UIImage*) graduallyTop2BottomImage {
    return _graduallyTop2BottomImage;
}

- (UIImage*) heartImage {
    return _heartImage;
}

- (UIImage*) smallPlayImage {
    return _smallPlayImage;
}

- (UIImage*) selectedImage {
    return _selectedImage;
}

- (UIImage*) photoPreviewImage {
    return  _photoPreviewImage;
}

@end
