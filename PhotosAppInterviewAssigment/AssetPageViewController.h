//
//  AssetPageViewController.h
//  PhotosAppInterviewAssigment
//
//  Created by Мирский Степан Алексеевич on 27/10/2016.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;

@interface AssetPageViewController : UIPageViewController

@property (nonatomic) PHAssetCollection *assetCollection;
@property (nonatomic) PHFetchResult *fetchResult;
@property (nonatomic) NSInteger currentIndex;

@end
