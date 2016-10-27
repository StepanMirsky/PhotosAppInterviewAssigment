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

@end
