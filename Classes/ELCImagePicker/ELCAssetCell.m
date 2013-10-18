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

		//self.imageViewArray = [[NSMutableArray alloc] init];
		//self.overlayViewArray = [[NSMutableArray alloc] init];

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


/*
	self.rowAssets = assets;
	for (UIImageView *view in self.imageViewArray) {
		[view removeFromSuperview];
	}
	for (UIImageView *view in self.overlayViewArray) {
		[view removeFromSuperview];
	}
	//set up a pointer here so we don't keep calling [UIImage imageNamed:] if creating overlays
	UIImage *overlayImage = nil;
	for (int i = 0; i < [_rowAssets count]; ++i) {

		ELCAsset *asset = [_rowAssets objectAtIndex:i];

		if (i < [_imageViewArray count]) {
			UIImageView *imageView = [self.imageViewArray objectAtIndex:i];
			imageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
		}	else {
			UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.asset.thumbnail]];
			[_imageViewArray addObject:imageView];
		}

		if (i < [_overlayViewArray count]) {
			UIImageView *overlayView = [self.overlayViewArray objectAtIndex:i];
			overlayView.hidden = !asset.selected;
		} else {
			if (overlayImage == nil) {
				overlayImage = [UIImage imageNamed:@"Overlay.png"];
			}
			UIImageView *overlayView = [[UIImageView alloc] initWithImage:overlayImage];
			[_overlayViewArray addObject:overlayView];
			overlayView.hidden = !asset.selected;
		}
	}
	*/
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

/*
	for (int i = 0; i < [_rowAssets count]; ++i) {
		UIImageView *imageView = [_imageViewArray objectAtIndex:i];
		[imageView setFrame:frame];
		[self addSubview:imageView];

		UIImageView *overlayView = [_overlayViewArray objectAtIndex:i];
		[overlayView setFrame:frame];
		[self addSubview:overlayView];

		frame.origin.x = frame.origin.x + frame.size.width + ELCAssetCellImageBorder;
	}
	*/
}


@end
