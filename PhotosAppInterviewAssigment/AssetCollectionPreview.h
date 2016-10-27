//
//  AssetCollectionPreview.h
//  PhotosAppInterviewAssigment
//
//  Created by Мирский Степан Алексеевич on 26/10/2016.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Photos;

@interface AssetCollectionPreview : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSInteger count;
@property (nonatomic) PHAssetCollection *assetCollection;

- (instancetype)initWithTitle:(NSString *)title count:(NSInteger)count collection:(PHAssetCollection *)collection;

@end
