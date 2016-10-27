//
//  AssetsCollectionViewController.m
//  PhotosAppInterviewAssigment
//
//  Created by Stepan Mirskiy on 10/23/16.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import "AssetCollectionsViewController.h"
#import "Fetcher.h"
#import "AssetInfoCollectionViewCell.h"
#import "AssetCollectionPreview.h"
#import "AssetCollectionViewController.h"

#import "UIImage+Resize.h"

@import Photos;

@interface AssetCollectionsViewController ()

@property (nonatomic) NSMutableArray *dataSource;

@end

@implementation AssetCollectionsViewController

static NSString *const kReuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.dataSource = [NSMutableArray array];
    
    [self setupCollectionView];
    
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusNotDetermined:{
            NSLog(@"Access is not determined, requesting it");
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                if (status == PHAuthorizationStatusAuthorized) {
                    NSLog(@"Access granted, fetching data");
                    [self fetchDataSource];
                }
            }];
            break;
        }
            
        case PHAuthorizationStatusDenied:
            NSLog(@"User denied access to photos");
            break;
            
        case PHAuthorizationStatusAuthorized:{
            NSLog(@"There is access to photos, fetching data");
            [self fetchDataSource];
            break;
        }
            
            
        case PHAuthorizationStatusRestricted:
            NSLog(@"Acess restricted");
            break;
    }
    
}

- (void)setupCollectionView
{
    [self.collectionView registerClass:[AssetInfoCollectionViewCell class] forCellWithReuseIdentifier:kReuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchDataSource
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        Fetcher *fetcher = [Fetcher new];
        self.dataSource = [fetcher fetchAssetCollectionWithType:PHAssetCollectionTypeAlbum];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    
    AssetCollectionPreview *assetCollectionPreview = self.dataSource[indexPath.row];
    cell.assetTitleLabel.text = assetCollectionPreview.title;
    cell.assetCountLabel.text = [NSString stringWithFormat:@"%d", assetCollectionPreview.count];
    
    cell.collectionPreviewImageView.layer.cornerRadius = 5.0;
    cell.collectionPreviewImageView.clipsToBounds = true;
    
    if (assetCollectionPreview.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
            options.fetchLimit = 1;
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollectionPreview.assetCollection options:options];
            if (fetchResult.count != 0) {
                [[PHImageManager defaultManager] requestImageForAsset:fetchResult.firstObject targetSize:cell.collectionPreviewImageView.frame.size  contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *image, NSDictionary *dictionary){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.collectionPreviewImageView.image = image.cropImage;
                    });
                }];
            }
        });
    } else {
        NSLog(@"no image for %@", assetCollectionPreview.title);
        cell.collectionPreviewImageView.backgroundColor = [UIColor grayColor];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width / 2 - 20, 200);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    
    AssetCollectionPreview *assetCollectionPreview = self.dataSource[indexPath.row];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    AssetCollectionViewController *assetCollectionViewController = [[AssetCollectionViewController alloc] initWithCollectionViewLayout:collectionViewFlowLayout];
    assetCollectionViewController.assetCollection = assetCollectionPreview.assetCollection;
    [self.navigationController pushViewController:assetCollectionViewController animated:true];
}

@end
