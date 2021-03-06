//
//  AlbumPickerController.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"
#import "ELCAssetGroupCell.h"

@interface ELCAlbumPickerController ()

@property (nonatomic, retain) ALAssetsLibrary *library;

@end

@implementation ELCAlbumPickerController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self.navigationItem setTitle:NSLocalizedStringFromTable(@"Loading...", @"ELCImagePicker", @"")];

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parent action:@selector(cancelImagePicker)];
	[self.navigationItem setRightBarButtonItem:cancelButton];

	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;

	ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
	self.library = assetLibrary;

	// Load Albums into assetGroups
	dispatch_async(dispatch_get_main_queue(), ^{
		// Group enumerator Block
		void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
			if (group == nil) {
				return;
			}

			// added fix for camera albums order
			NSString *sGroupPropertyName = (NSString *) [group valueForProperty:ALAssetsGroupPropertyName];
			NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];

			if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
				[self.assetGroups insertObject:group atIndex:0];
			}
			else {
				[self.assetGroups addObject:group];
			}

			// Reload albums
			[self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
		};

		// Group Enumerator Failure Block
		void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {

			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Error", @"ELCImagePicker", @"")
			                                                message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]]
						                                         delegate:nil
										                        cancelButtonTitle:NSLocalizedStringFromTable(@"Ok", @"ELCImagePicker", @"")
																			      otherButtonTitles:nil];
			[alert show];

			NSLog(@"A problem occured %@", [error description]);
		};

		// Enumerate Albums
		[self.library enumerateGroupsWithTypes:ALAssetsGroupAll
		                            usingBlock:assetGroupEnumerator
							                failureBlock:assetGroupEnumberatorFailure];

	});

	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)reloadTableView
{
	[self.tableView reloadData];
	[self.navigationItem setTitle:NSLocalizedStringFromTable(@"Photos", @"ELCImagePicker", @"")];
}

- (void)selectedAssets:(NSArray*)assets
{
	[_parent selectedAssets:assets];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.assetGroups count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ELCAssetGroupCell";

	ELCAssetGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[ELCAssetGroupCell alloc] initWithReuseIdentifier:CellIdentifier];
	}

	ALAssetsGroup *assetsGroup = (ALAssetsGroup *) [self.assetGroups objectAtIndex:indexPath.row];
	[assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];

	[cell setAssertsGroup:assetsGroup];

	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	ELCAssetTablePicker *picker = [[ELCAssetTablePicker alloc] initWithNibName:nil bundle:nil];
	picker.parent = self;

	picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
	[picker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];

	picker.assetPickerFilterDelegate = self.assetPickerFilterDelegate;

	[self.navigationController pushViewController:picker animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 86;
}


@end

