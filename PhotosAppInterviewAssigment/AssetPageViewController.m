//
//  AssetPageViewController.m
//  PhotosAppInterviewAssigment
//
//  Created by Мирский Степан Алексеевич on 27/10/2016.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import "AssetPageViewController.h"
#import "AssetViewController.h"

@interface AssetPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation AssetPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.delegate = self;
    self.dataSource = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    AssetViewController *assetViewController = [[AssetViewController alloc] init];
    assetViewController.asset = self.fetchResult[self.currentIndex];
    assetViewController.index = self.currentIndex;
    [self setViewControllers:@[assetViewController] direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    AssetViewController *currentAssetViewController = (AssetViewController *)viewController;
    if (currentAssetViewController.index > 0) {
        AssetViewController *assetViewController = [[AssetViewController alloc] init];
        assetViewController.asset = self.fetchResult[currentAssetViewController.index - 1];
        assetViewController.index = currentAssetViewController.index - 1;
        return assetViewController;
    } else {
        return nil;
    }
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    AssetViewController *currentAssetViewController = (AssetViewController *)viewController;
    if (currentAssetViewController.index < self.fetchResult.count - 1) {
        AssetViewController *assetViewController = [[AssetViewController alloc] init];
        assetViewController.asset = self.fetchResult[currentAssetViewController.index + 1];
        assetViewController.index = currentAssetViewController.index + 1;
        return assetViewController;
    } else {
        return nil;
    }
}

@end
