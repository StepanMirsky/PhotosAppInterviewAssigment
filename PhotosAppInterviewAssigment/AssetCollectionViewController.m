//
//  AssetCollectionViewController.m
//  PhotosAppInterviewAssigment
//
//  Created by Мирский Степан Алексеевич on 27/10/2016.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import "AssetCollectionViewController.h"
#import "AssetCollectionViewCell.h"

#import "AssetPageViewController.h"
#import "UIImage+Resize.h"

@interface AssetCollectionViewController ()

@property (nonatomic) PHFetchResult *fetchResult;

@end

@implementation AssetCollectionViewController

static NSString *const kReuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[AssetCollectionViewCell class] forCellWithReuseIdentifier:kReuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.fetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    
    PHAsset *asset = self.fetchResult[indexPath.row];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
//        requestOptions.normalizedCropRect = cell.imageView.bounds;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.synchronous = true;
//        requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:cell.imageView.frame.size contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage *image, NSDictionary *dictionary){
            dispatch_async(dispatch_get_main_queue(), ^{
//                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                cell.imageView.image = image;
            });
        }];
    });
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    
    AssetPageViewController *assetPageViewController = [[AssetPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                                        options:0];
    assetPageViewController.currentIndex = indexPath.row;
    assetPageViewController.fetchResult = self.fetchResult;
    [self.navigationController pushViewController:assetPageViewController animated:true];
}

@end
