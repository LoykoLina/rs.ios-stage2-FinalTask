//
//  FLAVRFavoritesController.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRFavoritesController.h"
#import "FLAVRDataCoreService.h"
#import "FLAVRAlertManager.h"

@interface FLAVRFavoritesController ()

@property (nonatomic) FLAVRDataCoreService *service;

@end

@implementation FLAVRFavoritesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray new];
    self.service = [FLAVRDataCoreService new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    [self.service loadSavedItems:^(NSArray<FLAVRRecipe *> *recipes, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == FLAVRAlertDailyQuotaErrorType) {
                UIAlertController *alertController = [FLAVRAlertManager alertControllerWithType:FLAVRAlertDailyQuotaErrorType];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            } else if (error) {
                UIAlertController *alertController = [FLAVRAlertManager alertControllerWithType:FLAVRAlertLoadErrorType];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            } else {
                weakSelf.dataSource = [recipes mutableCopy];
                [weakSelf.collectionView reloadData];
            }
        });
    }];
}


@end
