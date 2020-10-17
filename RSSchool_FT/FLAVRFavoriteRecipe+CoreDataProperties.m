//
//  FLAVRFavoriteRecipe+CoreDataProperties.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 9/3/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//
//

#import "FLAVRFavoriteRecipe+CoreDataProperties.h"

@implementation FLAVRFavoriteRecipe (CoreDataProperties)

+ (NSFetchRequest<FLAVRFavoriteRecipe *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FLAVRFavoriteRecipe"];
}

@dynamic identifier;
@dynamic cuisine;
@dynamic title;
@dynamic imageURL;
@dynamic servings;
@dynamic readyInMinutes;
@dynamic instruction;
@dynamic ingredients;

@end
