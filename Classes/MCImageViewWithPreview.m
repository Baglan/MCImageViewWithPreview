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

- (void)setPreviewImage:(UIImage *)previewImage
{
    _previewImage = previewImage;
    _isSettingPreviewImage = YES;
    self.image = previewImage;
    _isSettingPreviewImage = NO;
}

+ (UIImage *)renderImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(image.size);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [image drawInRect:rect];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

- (void)setImage:(UIImage *)image
{
    _fullImage = image;
    if (_isSettingPreviewImage) {
        // This is the preview image, render it
        [super setImage:image];
    } else {
        dispatch_queue_t renderingQueue = dispatch_queue_create("MCImageViewWithPreview:setImage", NULL);
        
        dispatch_async(renderingQueue, ^(void) {
            UIImage *prerenderedImage = nil;
            prerenderedImage = [self.class renderImage:image];
            if (_fullImage == image) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [super setImage:prerenderedImage];
                });
                
            }
        });
    }
}

@end
