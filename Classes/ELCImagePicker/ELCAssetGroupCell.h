//
// ELCImagePickerDemo 
//
// Created by rene on 17.10.13.
// Copyright 2013 Drobnik.com. All rights reserved.
//
// 
//


#import <Foundation/Foundation.h>


@interface ELCAssetGroupCell : UITableViewCell


- (id)initWithReuseIdentifier:(NSString *)identifier;

- (void)setAssertsGroup:(ALAssetsGroup *)group;
@end