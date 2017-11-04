//
//  AssetCollectionViewController.h
//  PhotosAppInterviewAssigment
//
//  Created by Мирский Степан Алексеевич on 27/10/2016.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;

@interface AssetCollectionViewController : UICollectionViewController

@property (nonatomic) PHAssetCollection *assetCollection;

@end
