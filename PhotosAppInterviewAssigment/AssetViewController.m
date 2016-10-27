//
//  AssetViewController.m
//  PhotosAppInterviewAssigment
//
//  Created by Мирский Степан Алексеевич on 27/10/2016.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import "AssetViewController.h"

@interface AssetViewController ()

@property (nonatomic) UIImageView *imageView;

@end

@implementation AssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:self.imageView];
    
    [self setupConstraints];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:self.view.frame.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *image, NSDictionary *dictionary){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.contentMode = UIViewContentModeScaleAspectFit;
                self.imageView.image = image;
            });
        }];
    });
}

- (void)setupConstraints
{
    NSLayoutConstraint *imageViewTop = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0.0];
    NSLayoutConstraint *imageViewLeft = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:0.0];
    NSLayoutConstraint *imageViewRight = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:0.0];
    NSLayoutConstraint *imageViewBottom = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:0.0];
    [self.view addConstraints:@[imageViewTop, imageViewLeft, imageViewRight, imageViewBottom]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end