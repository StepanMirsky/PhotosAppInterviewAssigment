//
//  AssetCollectionPreview.m
//  PhotosAppInterviewAssigment
//
//  Created by Мирский Степан Алексеевич on 26/10/2016.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import "AssetCollectionPreview.h"

@implementation AssetCollectionPreview

- (instancetype)initWithTitle:(NSString *)title count:(NSInteger)count collection:(PHAssetCollection *)collection
{
    self = [super init];
    if (self) {
        self.title = title;
        self.count = count;
        self.assetCollection = collection;
    }
    return self;
}

@end
