//
//  FLAVRService.h
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FLAVRIngredient;
@class FLAVRRecipe;

@interface FLAVRWebService : NSObject

- (void)loadRandomRecipes:(void (^)(NSArray<FLAVRRecipe *> *recipes, NSError *error))completion;
- (void)convertAmountForIngredient:(FLAVRIngredient*)ingredient
                         copletion:(void (^)(FLAVRIngredient *ingredient, NSError *error))completion;
- (void)loadRecipesWithQuery:(NSString*)query
                  completion:(void (^)(NSArray<FLAVRRecipe *> *recipes, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
