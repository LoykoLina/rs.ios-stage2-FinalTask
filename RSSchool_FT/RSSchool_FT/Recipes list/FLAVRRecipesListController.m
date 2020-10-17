//
//  FLAVRRecipesListController.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRRecipesListController.h"
#import "FLAVRCollectionCell.h"
#import "FLAVRRecipeController.h"
#import "FLAVRRecipe.h"
#import "FLAVRImageService.h"

@interface FLAVRRecipesListController () <UICollectionViewDelegateFlowLayout>

@end

@implementation FLAVRRecipesListController

static NSString * const kReuseIdentifier = @"FLAVRCollectionCell";
static CGFloat const kCellSpacing = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageService = [FLAVRImageService new];
    self.collectionView.backgroundColor = [UIColor colorNamed:@"flavr_white"];;
    
    [self.collectionView registerNib:[UINib nibWithNibName:kReuseIdentifier bundle:nil]
          forCellWithReuseIdentifier:kReuseIdentifier];
    
    [self configureActivityIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark - Load image

- (void)loadImageForIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    FLAVRRecipe *recipe = self.dataSource[indexPath.item];
    [self.imageService loadImageForURL:recipe.imageURL completion:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.dataSource.count > indexPath.item) {
                if ([recipe.imageURL isEqualToString:weakSelf.dataSource[indexPath.item].imageURL]) {
                    weakSelf.dataSource[indexPath.item].image = image;
                    
                    [UIView transitionWithView:[weakSelf.collectionView cellForItemAtIndexPath:indexPath]
                                      duration:0.2
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                        [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    } completion:nil];
                    
                }
            }
            
        });
    }];
}


#pragma mark - Configure activity indicator

- (void)configureActivityIndicator {
    if (@available(iOS 13.0, *)) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    } else {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    self.collectionView.backgroundView = self.activityIndicator;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FLAVRCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    
    [cell configureWithItem:self.dataSource[indexPath.item]];
    if (!self.dataSource[indexPath.item].image) {
        [self loadImageForIndexPath:indexPath];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        [self.imageService cancelDownloadingForUrl:self.dataSource[indexPath.item].imageURL];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        return CGSizeMake((UIScreen.mainScreen.bounds.size.width - kCellSpacing) / 2 , 250);
    } if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
          self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) {
        return CGSizeMake((UIScreen.mainScreen.bounds.size.width - kCellSpacing) / 2 , 250);
    } else {
        return CGSizeMake(UIScreen.mainScreen.bounds.size.width - kCellSpacing, 250);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCellSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCellSpacing;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FLAVRRecipeController *recipeVC = [FLAVRRecipeController new];
    recipeVC.recipe = self.dataSource[indexPath.item];
    if (self.navigationController) {
        [self.navigationController pushViewController:recipeVC animated:YES];
    } else {
        recipeVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:recipeVC animated:YES completion:nil];
    }
}

@end
