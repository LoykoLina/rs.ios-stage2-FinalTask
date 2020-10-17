//
//  DataCoreService.h
//  RSSchool_FT
//
//  Created by Lina Loyko on 10/17/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FLAVRRecipe;

@interface FLAVRDataCoreService : NSObject

- (void)loadSavedItems:(void (^)(NSArray<FLAVRRecipe *> *, NSError *))completion;
- (void)isItemSavedWithId:(NSNumber *)identifier
               completion:(void (^)(BOOL isSaved, NSError *error))completion;
- (BOOL)saveItem:(FLAVRRecipe *)item;
- (BOOL)deleteItemWithId:(NSNumber *)identifier;

@end

NS_ASSUME_NONNULL_END
