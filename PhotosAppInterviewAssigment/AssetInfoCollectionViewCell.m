//
//  AssetInfoCollectionViewCell.m
//  PhotosAppInterviewAssigment
//
//  Created by Stepan Mirskiy on 10/23/16.
//  Copyright © 2016 Mail.Ru Group. All rights reserved.
//

#import "AssetInfoCollectionViewCell.h"

@implementation AssetInfoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionPreviewImageView = [[UIImageView alloc] init];
        self.collectionPreviewImageView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:self.collectionPreviewImageView];
        
        self.assetCountLabel = [[UILabel alloc] init];
        self.assetCountLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.assetCountLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.assetCountLabel];
        
        self.assetTitleLabel = [[UILabel alloc] init];
        self.assetTitleLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.assetTitleLabel.numberOfLines = 0;
        self.assetTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.assetTitleLabel];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    NSLayoutConstraint *collectionPreviewImageViewTop = [NSLayoutConstraint constraintWithItem:self.collectionPreviewImageView
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.contentView
                                                                                     attribute:NSLayoutAttributeTop
                                                                                    multiplier:1.0
                                                                                      constant:4.0];
    NSLayoutConstraint *collectionPreviewImageViewCenterX = [NSLayoutConstraint constraintWithItem:self.collectionPreviewImageView
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                 multiplier:1.0
                                                                                   constant:0.0];
    NSLayoutConstraint *collectionPreviewImageViewLeft = [NSLayoutConstraint constraintWithItem:self.collectionPreviewImageView
                                                                                       attribute:NSLayoutAttributeLeft
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self.contentView
                                                                                       attribute:NSLayoutAttributeLeft
                                                                                      multiplier:1.0
                                                                                        constant:4.0];
    NSLayoutConstraint *collectionPreviewImageViewRight = [NSLayoutConstraint constraintWithItem:self.collectionPreviewImageView
                                                                                      attribute:NSLayoutAttributeRight
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self.contentView
                                                                                      attribute:NSLayoutAttributeRight
                                                                                     multiplier:1.0
                                                                                       constant:-4.0];
    NSLayoutConstraint *collectionPreviewImageViewHeight = [NSLayoutConstraint constraintWithItem:self.collectionPreviewImageView
                                                                                        attribute:NSLayoutAttributeHeight
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:self.collectionPreviewImageView
                                                                                        attribute:NSLayoutAttributeWidth
                                                                                       multiplier:1.0
                                                                                         constant:0.0];
    [self.contentView addConstraints:@[collectionPreviewImageViewTop, collectionPreviewImageViewLeft, collectionPreviewImageViewRight, collectionPreviewImageViewCenterX, collectionPreviewImageViewHeight]];
    
    NSLayoutConstraint *assetTitleLabelTop = [NSLayoutConstraint constraintWithItem:self.assetTitleLabel
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.collectionPreviewImageView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                           constant:4.0];
    NSLayoutConstraint *assetTitleLabelLeft = [NSLayoutConstraint constraintWithItem:self.assetTitleLabel
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.contentView
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0
                                                                            constant:4.0];
    NSLayoutConstraint *assetTitleLabelRight = [NSLayoutConstraint constraintWithItem:self.assetTitleLabel
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.contentView
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0
                                                                             constant:-4.0];
    [self.contentView addConstraints:@[assetTitleLabelTop, assetTitleLabelLeft, assetTitleLabelRight]];
    
    NSLayoutConstraint *assetCountTop = [NSLayoutConstraint constraintWithItem:self.assetCountLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.assetTitleLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:4.0];
    NSLayoutConstraint *assetCountLeft = [NSLayoutConstraint constraintWithItem:self.assetCountLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:4.0];
    NSLayoutConstraint *assetCountRight = [NSLayoutConstraint constraintWithItem:self.assetCountLabel
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.contentView
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:-4.0];
    NSLayoutConstraint *assetCountBottom = [NSLayoutConstraint constraintWithItem:self.assetCountLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:-4.0];
    [self.contentView addConstraints:@[assetCountTop, assetCountLeft, assetCountRight, assetCountBottom]];
}

@end
