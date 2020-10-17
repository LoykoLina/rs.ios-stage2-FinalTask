//
//  FLAVRSearchResultController.h
//  RSSchool_FT
//
//  Created by Lina Loyko on 9/4/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAVRRecipesListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLAVRSearchResultController : FLAVRRecipesListController

- (void)loadRecipesWithQuery:(NSString *)query;

@end

NS_ASSUME_NONNULL_END
