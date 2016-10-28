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

#import "Fetcher.h"

static NSString *const kReuseIdentifier = @"Cell";
static NSInteger const kNumberOfSections = 1;

@interface AssetCollectionViewController ()

@property (nonatomic) PHFetchResult *fetchResult;

@end

@implementation AssetCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[AssetCollectionViewCell class] forCellWithReuseIdentifier:kReuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        Fetcher *fetcher = [Fetcher new];
        self.fetchResult = [fetcher fetchAssetsForCollection:self.assetCollection];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kNumberOfSections;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    
    PHAsset *asset = self.fetchResult[indexPath.row];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        Fetcher *fetcher = [Fetcher new];
        [fetcher fetchImageForAsset:asset withSize:cell.imageView.frame.size contentMode:PHImageContentModeAspectFill callback:^(UIImage *image){
            dispatch_async(dispatch_get_main_queue(), ^{
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
