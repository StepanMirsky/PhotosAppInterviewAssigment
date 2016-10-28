//
//  Fetcher.h
//  PhotosAppInterviewAssigment
//
//  Created by Stepan Mirskiy on 10/23/16.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Photos;

@interface Fetcher : NSObject

- (NSMutableArray *)fetchAssetCollectionWithType:(PHAssetCollectionType)type;
- (PHFetchResult *)fetchAssetsForCollection:(PHAssetCollection *)collection;

- (void)fetchImageForLastAssetInCollection:(PHAssetCollection *)collection withSize:(CGSize)size callback:(void (^)(UIImage *image))callback;
- (void)fetchImageForAsset:(PHAsset *)asset withSize:(CGSize)size contentMode:(PHImageContentMode)contentMode callback:(void (^)(UIImage *))callback;

@end
