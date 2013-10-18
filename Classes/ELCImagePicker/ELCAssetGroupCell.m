//
// ELCImagePickerDemo 
//
// Created by rene on 17.10.13.
//
// 
//


#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAssetGroupCell.h"


@implementation ELCAssetGroupCell {

}

- (id)initWithReuseIdentifier:(NSString *)identifier {
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	if (self) {
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGFloat cellHeight = self.frame.size.height;
	CGFloat cellWidth = self.frame.size.width;


	CGFloat middle = ceilf(cellHeight/2.0f);
	CGFloat padding = 10;
	self.textLabel.frame = CGRectMake(cellHeight+padding, middle-21, cellWidth-2*(cellHeight+padding), 21);
	self.detailTextLabel.frame = CGRectMake(cellHeight+padding, middle, cellWidth-2*(cellHeight+padding), 21);
	CGFloat imageBorder = 8;
	self.imageView.frame = CGRectMake(imageBorder, imageBorder, cellHeight-2*imageBorder, cellHeight-2*imageBorder);
}


- (void)setAssertsGroup:(ALAssetsGroup *)assetsGroup {
	NSInteger numberOfAssets = [assetsGroup numberOfAssets];
	self.textLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
		// is iOS7 or higher
		self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
		self.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
	} else {
		self.textLabel.font = [UIFont systemFontOfSize:17.0f];
		self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
	}

	self.detailTextLabel.text =  [NSString stringWithFormat:@"%d", numberOfAssets];
	[self.imageView setImage:[UIImage imageWithCGImage:[assetsGroup posterImage]]];
	[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}
@end