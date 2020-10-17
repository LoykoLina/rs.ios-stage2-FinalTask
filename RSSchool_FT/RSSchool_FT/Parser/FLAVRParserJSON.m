//
//  FLAVRParserJSON.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRParserJSON.h"
#import "FLAVRRecipe.h"
#import "FLAVRIngredient.h"

@implementation FLAVRParserJSON

- (void)parseRecipes:(NSData *)data completion:(void (^)(NSArray<FLAVRRecipe *> *, NSError *))completion {
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *array = dictionary[@"recipes"];
    if (error) {
        completion(nil, error);
    } else {
        NSMutableArray<FLAVRRecipe *> *recipes = [NSMutableArray new];
        for (NSDictionary *item in array) {
            [recipes addObject:[[FLAVRRecipe alloc] initWithDictionary:item]];
        }
        completion(recipes, nil);
    }
}

- (void)parseConvertingAmountForIngredient:(FLAVRIngredient*)ingredient
                                      data:(NSData*)data
                                completion:(void (^)(FLAVRIngredient *, NSError *))completion {
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        completion(nil, error);
    } else {
        [ingredient configureConversionResult:dictionary];
        completion(ingredient, error);
    }
}

- (void)parseSearchResultRecipe:(NSData *)data completion:(void (^)(NSArray<FLAVRRecipe *> *, NSError *))completion {
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *array = dictionary[@"results"];
    if (error) {
        completion(nil, error);
    } else {
        NSMutableArray<FLAVRRecipe *> *recipes = [NSMutableArray new];
        for (NSDictionary *item in array) {
            [recipes addObject:[[FLAVRRecipe alloc] initWithSearchResultsDictionary:item]];
        }
        completion(recipes, nil);
    }
}

@end
