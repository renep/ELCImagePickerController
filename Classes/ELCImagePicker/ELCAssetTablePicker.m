//
//  AssetTablePicker.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetTablePicker.h"
#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerController.h"


@interface ELCAssetTablePicker ()

@property (nonatomic, assign) int columns;

@property (nonatomic, assign) CGFloat rowHeight;

@end

@implementation ELCAssetTablePicker




- (void)viewDidLoad {

	if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
		self.rowHeight = 120;
	} else {
		self.rowHeight = 104;
	}



	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.tableView setAllowsSelection:NO];

	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.elcAssets = tempArray;

	if (self.immediateReturn) {

	}
	else {
		UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
		[self.navigationItem setRightBarButtonItem:doneButtonItem];

		[self.navigationItem setTitle:NSLocalizedStringFromTable(@"Loading...", @"ELCImagePicker", @"")];
	}

	[self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.columns = self.view.bounds.size.width / self.rowHeight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.columns = self.view.bounds.size.width / self.rowHeight;
    [self.tableView reloadData];
}

- (void)preparePhotos {
	NSLog(@"enumerating photos");
	[self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {

		if (result == nil) {
			return;
		}

		ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
		[elcAsset setParent:self];

		BOOL isAssetFiltered = NO;
		if (self.assetPickerFilterDelegate &&
			[self.assetPickerFilterDelegate respondsToSelector:@selector(assetTablePicker:isAssetFilteredOut:)]) {
			isAssetFiltered = [self.assetPickerFilterDelegate assetTablePicker:self isAssetFilteredOut:elcAsset];
		}

		if (!isAssetFiltered) {
			[self.elcAssets addObject:elcAsset];
		}
	}];
	NSLog(@"done enumerating photos");

	dispatch_sync(dispatch_get_main_queue(), ^{
		[self.tableView reloadData];
		// scroll to bottom
		NSInteger section = [self numberOfSectionsInTableView:self.tableView] - 1;
		NSInteger row = [self tableView:self.tableView numberOfRowsInSection:section] - 1;
		if (section >= 0 && row >= 0) {
			NSIndexPath *ip = [NSIndexPath indexPathForRow:row
			                                     inSection:section];
			[self.tableView scrollToRowAtIndexPath:ip
			                      atScrollPosition:UITableViewScrollPositionBottom
											              animated:NO];
		}

		//[self.navigationItem setTitle:self.singleSelection ? @"Pick Photo" : @"Pick Photos"];
		[self.navigationItem setTitle:NSLocalizedStringFromTable(@"Select Items", @"ELCImagePicker", @"")];
	});


}

- (void)doneAction:(id)sender {
	NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];

	for (ELCAsset *elcAsset in self.elcAssets) {

		if ([elcAsset selected]) {

			[selectedAssetsImages addObject:[elcAsset asset]];
		}
	}

	[self.parent selectedAssets:selectedAssetsImages];
}

- (void)assetSelected:(id)asset {
	if (self.singleSelection) {

		for (ELCAsset *elcAsset in self.elcAssets) {
			if (asset != elcAsset) {
				elcAsset.selected = NO;
			}
		}
	}
	if (self.immediateReturn) {
		NSArray *singleAssetArray = [NSArray arrayWithObject:[asset asset]];
		[(NSObject *) self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
	}
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ceil([self.elcAssets count] / (float) self.columns);
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)path {
	NSInteger index = path.row * self.columns;
	NSInteger length = MIN(self.columns, [self.elcAssets count] - index);
	return [self.elcAssets subarrayWithRange:NSMakeRange(index, length)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	ELCAssetCell *cell = (ELCAssetCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[ELCAssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier];

	}
	else {
		[cell setAssets:[self assetsForIndexPath:indexPath]];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.rowHeight;
}

- (int)totalSelectedAssets {
	int count = 0;

	for (ELCAsset *asset in self.elcAssets) {
		if ([asset selected]) {
			count++;
		}
	}

	return count;
}

@end
