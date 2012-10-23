//
//  MCImageViewWithPreview.m
//  MCImageViewWithPreview
//
//  Created by Baglan on 10/14/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import "MCImageViewWithPreview.h"

@interface MCImageViewWithPreview () {
    BOOL _isSettingPreviewImage;
    UIImage *_fullImage;
}

@end

@implementation MCImageViewWithPreview

#pragma mark -
#pragma mark Pre-rendering

+ (UIImage *)renderImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(image.size);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [image drawInRect:rect];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

#pragma mark -
#pragma mark Cache

- (NSCache *)sharedCache
{
    __strong static NSCache * cache;
    
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
    
    return cache;
}

- (UIImage *)cachedImageForObject:(id)obj
{
    NSCache * cache = [self sharedCache];
    id image = [cache objectForKey:obj];
    image = image == NULL ? nil : image;
    return image;
}

- (void)cacheImage:(UIImage *)image forObject:(id)obj
{
    NSCache * cache = [self sharedCache];
    [cache setObject:image forKey:obj];
}

#pragma mark -
#pragma mark Preview image

- (void)setPreviewImageName:(NSString *)previewImageName
{
    _previewImageName = [previewImageName copy];
    
    UIImage * image = [self cachedImageForObject:previewImageName];
    if (!image) {
        image = [UIImage imageNamed:previewImageName];
        [self cacheImage:image forObject:previewImageName];
    }
    self.image = image;
}

#pragma mark -
#pragma mark Actual image

- (void)setImageName:(NSString *)imageName
{
    _imageName = [imageName copy];
    
    UIImage * image = [self cachedImageForObject:imageName];
    if (image) {
        // If image is already in cache, just set it
        self.image = image;
    } else {
        // If not, preprender, cache and set it
        dispatch_queue_t renderingQueue = dispatch_queue_create("MCImageViewWithPreview:setImageName", NULL);
        
        dispatch_async(renderingQueue, ^(void) {
            // Prerender
            UIImage * prerenderedImage = [self.class renderImage:[UIImage imageNamed:imageName]];
            
            // Cache
            [self cacheImage:prerenderedImage forObject:imageName];
            
            // If _imageName ivar has not changed while we were rendering it;
            // that is if this image view is not being re-used for something else
            if (_imageName == imageName) {
                // Set image to rerepdered image
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    self.image = prerenderedImage;
                });
            }
        });
    }
}

@end
