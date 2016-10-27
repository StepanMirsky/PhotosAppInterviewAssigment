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

@end
