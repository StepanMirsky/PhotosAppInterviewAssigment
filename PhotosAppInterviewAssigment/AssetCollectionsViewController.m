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

@import Photos;

static NSString *const kReuseIdentifier = @"Cell";
static NSInteger const kNumberOfSections = 1;

@interface AssetCollectionsViewController ()

@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) CGSize cellSize;
@property (nonatomic) CGSize imageSize;

@end

@implementation AssetCollectionsViewController

#pragma view controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.dataSource = [NSMutableArray array];
    [self setupCollectionView];
    [self checkPhotosAuthorizationStatus];
    [self setupSizes];
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

- (void)checkPhotosAuthorizationStatus
{
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusNotDetermined:{
            NSLog(@"Access is not determined, requesting it");
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                if (status == PHAuthorizationStatusAuthorized) {
                    NSLog(@"Access granted, fetching data");
                    [self fetchDataSource];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self authorizationStatusFailedAlertController];
                        [self labelForFailedPhotosAutorization];
                    });
                }
            }];
            break;
        }
            
        case PHAuthorizationStatusDenied:
            NSLog(@"User denied access to photos");
            [self authorizationStatusFailedAlertController];
            [self labelForFailedPhotosAutorization];
            break;
            
        case PHAuthorizationStatusAuthorized:{
            NSLog(@"There is access to photos, fetching data");
            [self fetchDataSource];
            break;
        }
            
            
        case PHAuthorizationStatusRestricted:
            NSLog(@"Acess restricted");
            [self authorizationStatusFailedAlertController];
            [self labelForFailedPhotosAutorization];
            break;
    }
}

- (void)setupSizes
{
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width / 2 - 20;
    CGFloat scale = [UIScreen mainScreen].scale;
    self.cellSize = CGSizeMake(cellWidth, 200);
    self.imageSize = CGSizeMake((cellWidth - 8) * scale, (cellWidth - 8) * scale);
}

#pragma mark - collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kNumberOfSections;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    
    AssetCollectionPreview *assetCollectionPreview = self.dataSource[indexPath.row];
    cell.assetTitleLabel.text = assetCollectionPreview.title;
    cell.assetCountLabel.text = [NSString stringWithFormat:@"%ld", (long)assetCollectionPreview.count];
    
    cell.collectionPreviewImageView.layer.cornerRadius = 5.0;
    cell.collectionPreviewImageView.clipsToBounds = true;
    
    if (assetCollectionPreview.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            Fetcher *fetcher = [Fetcher new];
            [fetcher fetchImageForLastAssetInCollection:assetCollectionPreview.assetCollection withSize:self.imageSize callback:^(UIImage *image){
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.collectionPreviewImageView.image = image;
                });
            }];
        });
    } else {
        NSLog(@"no image for %@", assetCollectionPreview.title);
        cell.collectionPreviewImageView.backgroundColor = [UIColor grayColor];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellSize;
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

- (void)authorizationStatusFailedAlertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Access denied" message:@"To use this application you need to get it access to photo library" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alertController addAction:settings];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)labelForFailedPhotosAutorization
{
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.frame];
    label.text = @"Access to photos denied";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

@end
