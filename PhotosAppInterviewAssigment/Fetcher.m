//
//  Fetcher.m
//  PhotosAppInterviewAssigment
//
//  Created by Stepan Mirskiy on 10/23/16.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import "Fetcher.h"

@implementation Fetcher

- (void)fetchAssetCollectionWithType:(PHAssetCollectionType)type
{
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:type
                                                                          subtype:PHAssetCollectionSubtypeAny
                                                                          options:nil];
    [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL *stop){
        NSString *boolString = (stop) ? @"true" : @"false";
        NSLog(@"%@ \n%lu \n%@", assetCollection, (unsigned long)idx, boolString);
    }];
}

@end
