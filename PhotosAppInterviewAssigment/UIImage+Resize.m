//
//  UIImage+Resize.m
//  PhotosAppInterviewAssigment
//
//  Created by Мирский Степан Алексеевич on 27/10/2016.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)cropImage
{
    UIImage *cropImage;
    
    if (self.size.width > self.size.height) {
        CGRect rect = CGRectMake((self.size.width - self.size.height) / 2, 0, self.size.height, self.size.height);
        CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
        cropImage = [UIImage imageWithCGImage:imageRef];
    } else if (self.size.width < self.size.height) {
        CGRect rect = CGRectMake(0, (self.size.height - self.size.width) / 2, self.size.width, self.size.width);
        CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
        cropImage = [UIImage imageWithCGImage:imageRef];
    } else {
        cropImage = self;
    }
    
    return cropImage;
}

@end
