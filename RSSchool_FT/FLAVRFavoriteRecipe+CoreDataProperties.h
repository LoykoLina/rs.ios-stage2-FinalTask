//
//  FLAVRFavoriteRecipe+CoreDataProperties.h
//  RSSchool_FT
//
//  Created by Lina Loyko on 9/3/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//
//

#import "FLAVRFavoriteRecipe+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FLAVRFavoriteRecipe (CoreDataProperties)

+ (NSFetchRequest<FLAVRFavoriteRecipe *> *)fetchRequest;

@property (nonatomic) int32_t identifier;
@property (nullable, nonatomic, copy) NSString *cuisine;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *imageURL;
@property (nonatomic) int16_t servings;
@property (nonatomic) int16_t readyInMinutes;
@property (nullable, nonatomic, copy) NSString *instruction;
@property (nullable, nonatomic, retain) NSArray<NSString*> *ingredients;

@end

NS_ASSUME_NONNULL_END
