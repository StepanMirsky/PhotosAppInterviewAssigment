//
//  Fetcher.m
//  PhotosAppInterviewAssigment
//
//  Created by Stepan Mirskiy on 10/23/16.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import "Fetcher.h"
#import "AssetCollectionPreview.h"

@implementation Fetcher

- (NSMutableArray *)fetchAssetCollectionWithType:(PHAssetCollectionType)type
{
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:type
                                                                          subtype:PHAssetCollectionSubtypeAny
                                                                          options:nil];
    dispatch_queue_t serialQueue = dispatch_queue_create("ru.mail.fetchCollectionsQueue", DISPATCH_QUEUE_SERIAL);
    NSMutableArray *assetCollectionsPreview = [NSMutableArray array];
    
    [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL *stop){
        dispatch_sync(serialQueue, ^{
            PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
            PHFetchResult *collectionFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
            AssetCollectionPreview *assetCollectionPreview = [[AssetCollectionPreview alloc] initWithTitle:assetCollection.localizedTitle count:collectionFetchResult.count collection:assetCollection];
            [assetCollectionsPreview addObject:assetCollectionPreview];
        });
    }];
    
    return assetCollectionsPreview;
}

- (PHFetchResult *)fetchAssetsForCollection:(PHAssetCollection *)collection
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
    options.sortDescriptors = @[
                                [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]
                                ];
    
    return [PHAsset fetchAssetsInAssetCollection:collection options:options];
}

- (void)fetchImageForAsset:(PHAsset *)asset withSize:(CGSize)size contentMode:(PHImageContentMode)contentMode callback:(void (^)(UIImage *))callback
{
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    //        requestOptions.normalizedCropRect = cell.imageView.bounds;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = true;
    //        requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:contentMode options:requestOptions resultHandler:^(UIImage *image, NSDictionary *dictionary){
        callback(image);
    }];
}

- (void)fetchImageForLastAssetInCollection:(PHAssetCollection *)collection withSize:(CGSize)size callback:(void (^)(UIImage *))callback
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[
                                [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]
                                ];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
    options.fetchLimit = 1;
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    if (fetchResult.count != 0) {
        [[PHImageManager defaultManager] requestImageForAsset:fetchResult.firstObject targetSize:size  contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *image, NSDictionary *dictionary){
            callback(image);
        }];
    }
}

@end
