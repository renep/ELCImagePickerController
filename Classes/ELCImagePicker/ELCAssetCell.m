//
//  AssetCell.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCAssetImageView.h"


static CGFloat ELCAssetCellImageBorder = 8.0f;

@interface ELCAssetCell ()

@property (nonatomic, retain) NSMutableArray *assetImageViews;

@end

@implementation ELCAssetCell

- (id)initWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	if (self) {
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
		[self addGestureRecognizer:tapRecognizer];
		[self setAssets:assets];
	}
	return self;
}

- (void)setAssets:(NSArray *)assets {
	self.assetImageViews = [[NSMutableArray alloc] initWithCapacity:[assets count]];
	for (ELCAsset *asset in assets) {
		ELCAssetImageView *imageView = [[ELCAssetImageView alloc] initWithAsset:asset];
		[self addSubview:imageView];
		[self.assetImageViews addObject:imageView];
	}
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer {
	CGPoint point = [tapRecognizer locationInView:self];

	[self.assetImageViews enumerateObjectsUsingBlock:^(ELCAssetImageView *imageView, NSUInteger index, BOOL *stop) {
		if (CGRectContainsPoint(imageView.frame, point)) {
				imageView.selected = !imageView.selected;
					stop = YES;
				}
	}];

}

- (void)layoutSubviews {
	CGFloat width = self.frame.size.height;

	CGFloat startX = ELCAssetCellImageBorder; //(self.bounds.size.width - totalWidth) / 2;

	CGRect frame = CGRectMake(startX, ELCAssetCellImageBorder, width-ELCAssetCellImageBorder, width-ELCAssetCellImageBorder);

	for (ELCAssetImageView *view in self.self.assetImageViews) {
		view.frame = frame;
		frame.origin.x = frame.origin.x + frame.size.width + ELCAssetCellImageBorder;
	}
}


@end
