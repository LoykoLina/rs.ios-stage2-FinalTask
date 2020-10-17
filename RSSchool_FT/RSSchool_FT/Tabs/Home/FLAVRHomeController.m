//
//  FLAVRHomeController.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRHomeController.h"
#import "FLAVRWebService.h"
#import "LoadingFooter.h"
#import "FLAVRRecipe.h"
#import "FLAVRAlertManager.h"

@interface FLAVRHomeController ()

@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isNeededToRefresh;
@property (nonatomic) FLAVRWebService *service;

@end

@implementation FLAVRHomeController

static CGFloat const kFooterHeight = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray new];
    self.service = [[FLAVRWebService alloc] init];
    
    [self.collectionView registerClass:[LoadingFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerActivityIndicatorID"];
    
    [self configureActivityIndicator];
    
    [self.activityIndicator startAnimating];
    [self loadRecipes];
    
    [self configureRefreshControl];
}

#pragma mark - Configure refresh control

- (void)configureRefreshControl {
    self.refreshControl = [UIRefreshControl new];
    
    self.collectionView.refreshControl = self.refreshControl;
    
    [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshData:(UIRefreshControl*)sender {
    self.isNeededToRefresh = YES;
    [self loadRecipes];
    NSLog(@"[FLAVRHomeController] - refresh data");
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

#pragma mark - Load recipes

- (void)loadRecipes {
    __weak typeof(self) weakSelf = self;
    self.isLoading = YES;
    
    [self.service loadRandomRecipes:^(NSArray<FLAVRRecipe *> *recipes, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf presentViewController:[weakSelf errorAlertController:error] animated:YES completion:nil];
            } else if (weakSelf.isNeededToRefresh) {
                weakSelf.dataSource = [recipes mutableCopy];
            } else {
                [weakSelf.dataSource addObjectsFromArray:recipes];
            }
            
            [weakSelf.refreshControl endRefreshing];
            weakSelf.isNeededToRefresh = NO;
            
            [weakSelf.activityIndicator stopAnimating];
            weakSelf.isLoading = NO;
            
            if (!error) {
                [weakSelf.collectionView reloadData];
            }
        });
    }];
}

#pragma mark - Configure error alert controller

- (UIAlertController *)errorAlertController:(NSError *)error {
    UIAlertController *alertController;

    if (error.code == NSURLErrorNotConnectedToInternet) {
        alertController = [FLAVRAlertManager alertControllerWithType:FLAVRAlertNoInternetConnectionType];
    } else if (error.code == FLAVRAlertDailyQuotaErrorType) {
        alertController = [FLAVRAlertManager alertControllerWithType:FLAVRAlertDailyQuotaErrorType];
    } else {
        alertController = [FLAVRAlertManager alertControllerWithType:FLAVRAlertUnknownErrorType];
    }
    
    return alertController;
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
    return CGSizeMake(self.collectionView.bounds.size.width, self.dataSource.count == 0 ? 0 : kFooterHeight);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (elementKind == UICollectionElementKindSectionFooter) {
        if ([view isKindOfClass:LoadingFooter.class]) {
            NSLog(@"[FLAVRHomeController] - load more data");
            [self loadRecipes];
        }
    }
}

@end
