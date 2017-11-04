//
//  UICollectionViewCell+UICollectionViewCell_Extension.m
//  PhotosAppInterviewAssigment
//
//  Created by Stepan Mirskiy on 04/11/2017.
//  Copyright © 2017 Mail.Ru Group. All rights reserved.
//

#import "UICollectionViewCell+Extension.h"

@implementation UICollectionViewCell (Extension)

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

@end
