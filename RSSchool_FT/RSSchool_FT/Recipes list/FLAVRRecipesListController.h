//
//  FLAVRRecipesListController.h
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FLAVRRecipe;
@class FLAVRImageService;

@interface FLAVRRecipesListController : UICollectionViewController

@property (nonatomic) NSMutableArray<FLAVRRecipe *> *dataSource;
@property (nonatomic) FLAVRImageService *imageService;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

@end

NS_ASSUME_NONNULL_END
