//
// ELCImagePickerDemo 
//
// Created by rene on 17.10.13.
//
// 
//


#import "ELCAssetImageView.h"
#import "ELCAsset.h"


@interface ELCAssetImageView ()
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UIView *highLightView;
@property(nonatomic, retain) UIImageView *checkImage;
@end

@implementation ELCAssetImageView {
}

- (instancetype)initWithAsset:(ELCAsset *)asset {
	UIImage *image = [UIImage imageWithCGImage:asset.asset.thumbnail];
	CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
	self = [super initWithFrame:frame];
	if (self) {
		self.asset = asset;
		self.imageView = [[UIImageView alloc] initWithImage:image];
		self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:self.imageView];
		self.highLightView = [[UIView alloc] initWithFrame:frame];
		self.highLightView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
		self.highLightView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.highLightView.hidden = YES;
		[self addSubview:self.highLightView];

		self.checkImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ELCAssertCheckedImage.png"]];
		[self.highLightView addSubview:self.checkImage];

	}
	return self;

}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	self.imageView.frame = frame;
	self.highLightView.frame = frame;

	CGSize imageSize = self.checkImage.image.size;
	CGSize highlightSize = self.highLightView.frame.size;
	self.checkImage.frame = CGRectMake(highlightSize.width-imageSize.width, highlightSize.height - imageSize.height, imageSize.width, imageSize.height );
}


- (void)setSelected:(BOOL)selected {
	self.highLightView.hidden = !selected;
	self.asset.selected = selected;
}

- (BOOL)selected {
	return !self.highLightView.hidden;
}


@end