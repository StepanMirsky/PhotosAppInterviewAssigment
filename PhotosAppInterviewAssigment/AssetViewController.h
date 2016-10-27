//
//  AssetViewController.h
//  PhotosAppInterviewAssigment
//
//  Created by Мирский Степан Алексеевич on 27/10/2016.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;

@interface AssetViewController : UIViewController

@property (nonatomic) PHAsset *asset;
@property (nonatomic) NSInteger index;

@end
