//
//  FLAVRParserJSON.h
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FLAVRIngredient;
@class FLAVRRecipe;

@interface FLAVRParserJSON : NSObject

- (void)parseRecipes:(NSData *)data completion:(void (^)(NSArray<FLAVRRecipe *> *, NSError *))completion;
- (void)parseConvertingAmountForIngredient:(FLAVRIngredient*)ingredient
                                      data:(NSData*)data
                                completion:(void (^)(FLAVRIngredient *, NSError *))completion;
- (void)parseSearchResultRecipe:(NSData *)data
                     completion:(void (^)(NSArray<FLAVRRecipe *> *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
