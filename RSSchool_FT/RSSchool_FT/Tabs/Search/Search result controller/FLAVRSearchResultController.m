//
//  FLAVRSearchResultController.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 9/4/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRSearchResultController.h"
#import "FLAVRImageService.h"
#import "LoadingFooter.h"
#import "FLAVRRecipe.h"
#import "FLAVRWebService.h"
#import "FLAVRAlertManager.h"

@interface FLAVRSearchResultController ()

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, copy) NSString *query;
@property (nonatomic) NSArray<FLAVRRecipe *> *dataSourceCopy;
@property (nonatomic) FLAVRWebService *service;

@end

@implementation FLAVRSearchResultController

static CGFloat const kFooterHeight = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorNamed:@"flavr_white"];
    
    self.dataSourceCopy = [NSMutableArray new];
    self.dataSource = [NSMutableArray new];
    self.imageService = [FLAVRImageService new];
    self.service = [FLAVRWebService new];
    [self.collectionView registerClass:[LoadingFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerActivityIndicatorID"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.dataSource = [NSMutableArray new];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.dataSource = [NSMutableArray new];
    self.dataSourceCopy = [NSArray new];
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.imageService cancelDownloadingForUrl:self.dataSourceCopy[indexPath.item].imageURL];
}

- (void)loadRecipesWithQuery:(NSString *)query {
    self.query = query;
    self.isLoading = YES;
       __weak typeof(self) weakSelf = self;
    [self.service loadRecipesWithQuery:query
                               completion:^(NSArray<FLAVRRecipe *> *recipes, NSError *error) {
           dispatch_async(dispatch_get_main_queue(), ^{
               if (error.code == FLAVRAlertDailyQuotaErrorType) {
                   UIAlertController *alertController = [FLAVRAlertManager alertControllerWithType:FLAVRAlertDailyQuotaErrorType];
                   [weakSelf presentViewController:alertController animated:YES completion:nil];
               } else if (error) {
                   UIAlertController *alertController = [FLAVRAlertManager alertControllerWithType:FLAVRAlertUnknownErrorType];
                   [weakSelf presentViewController:alertController animated:YES completion:nil];
               } else {
                   [weakSelf.dataSource addObjectsFromArray:recipes];
                   [weakSelf.collectionView reloadData];
                   weakSelf.dataSourceCopy = [[NSArray alloc] initWithArray:weakSelf.dataSource];
               }
               
               [weakSelf.activityIndicator stopAnimating];
               weakSelf.isLoading = NO;
           });
    }];
}

#pragma mark - Infinite scrolling configuration

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
        LoadingFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerActivityIndicatorID" forIndexPath:indexPath];
        [footer configure];
        return footer;
    }
    return [UICollectionReusableView new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.bounds.size.width, self.dataSource.count < 10 ? 0 : kFooterHeight);
}

//- (void)collectionView:(UICollectionView *)collectionView didDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
//    if (elementKind == UICollectionElementKindSectionFooter) {
//        if ([view isKindOfClass:LoadingFooter.class] && view.frame.size.height != 0) {
//            NSLog(@"[FLAVRHomeController] - load more data");
//            [self loadRecipesWithQuery:self.query];
//        }
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;

    if([scrollView.panGestureRecognizer translationInView:scrollView.superview].y < 0) {
       if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight - kFooterHeight && !self.isLoading) {
            NSLog(@"[FLAVRHomeController] - load more data");
            [self loadRecipesWithQuery:self.query];
        }
    }
}

@end
