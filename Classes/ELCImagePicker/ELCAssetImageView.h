//
// ELCImagePickerDemo 
//
// Created by rene on 17.10.13.
// Copyright 2013 Drobnik.com. All rights reserved.
//
// 
//


#import <Foundation/Foundation.h>

@class ELCAsset;


@interface ELCAssetImageView : UIView

- (instancetype)initWithAsset:(ELCAsset *)asset;

@property (nonatomic, assign) BOOL selected;
@property(nonatomic, retain) ELCAsset *asset;


@end