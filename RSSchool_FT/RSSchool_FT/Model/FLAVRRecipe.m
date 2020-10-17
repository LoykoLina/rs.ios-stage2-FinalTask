//
//  FLAVRRecipe.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/22/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRRecipe.h"

@implementation FLAVRRecipe

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self initEverythingExceptIngredientsWithDictionary:dictionary];
        
        if (!_instruction) {
            _instruction = dictionary[@"instructions"];
        }
        
        NSArray *ingredients = dictionary[@"extendedIngredients"];
        _ingredients = [NSMutableArray new];
        for (NSDictionary *ingredient in ingredients) {
            [_ingredients addObject:ingredient[@"original"]];
        }
    }
    return self;
}

- (instancetype)initWithSearchResultsDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self initEverythingExceptIngredientsWithDictionary:dictionary];
        
        NSArray *ingredients = dictionary[@"missedIngredients"];
        _ingredients = [NSMutableArray new];
        for (NSDictionary *ingredient in ingredients) {
            [_ingredients addObject:ingredient[@"originalString"]];
        }
    }
    return self;
}

- (void)initEverythingExceptIngredientsWithDictionary:(NSDictionary *)dictionary {
    _imageURL = dictionary[@"image"];
    _identifier = dictionary[@"id"];
    _title = dictionary[@"title"];
    _servings = dictionary[@"servings"];
    _readyInMinutes = dictionary[@"readyInMinutes"];
    
    NSArray *cuisines = dictionary[@"cuisines"];
    _cuisine = [NSMutableString new];
    for (NSString *cuisine in cuisines) {
        [_cuisine appendFormat:@"%@  ", cuisine];
    }
    
    NSArray *instructions = dictionary[@"analyzedInstructions"];
    if (instructions.count != 0) {
        NSArray *steps = instructions[0][@"steps"];
        _instruction = [NSMutableString new];
        for (NSDictionary *step in steps) {
            [_instruction appendFormat:@"\n%@\n", step[@"step"]];
        }
    }
}

//- (instancetype)initWithReadyInfo {
//    self = [super init];
//    if (self) {
//        _title = @"Char-Grilled Beef Tenderloin with Three-Herb Chimichurri ";
//        _servings = @2;
//        _readyInMinutes = @45;
//        _instruction = [@"For spice rub: Combine all ingredients in small bowl. Do ahead: Can be made 2 days ahead. Store airtight at room temperature. For chimichurri sauce: Combine first 8 ingredients in blender; blend until almost smooth. Add 1/4 of parsley, 1/4 of cilantro, and 1/4 of mint; blend until incorporated. Add remaining herbs in 3 more additions, pureeing until almost smooth after each addition. Do ahead: Can be made 3 hours ahead. Cover; chill. For beef tenderloin: Let beef stand at room temperature 1 hour. Prepare barbecue (high heat). Pat beef dry with paper towels; brush with oil. Sprinkle all over with spice rub, using all of mixture (coating will be thick). Place beef on grill; sear 2 minutes on each side. Reduce heat to medium-high. Grill uncovered until instant-read thermometer inserted into thickest part of beef registers 130F for medium-rare, moving beef to cooler part of grill as needed to prevent burning, and turning occasionally, about 40 minutes. Transfer to platter; cover loosely with foil and let rest 15 minutes. Thinly slice beef crosswise. Serve with chimichurri sauce. *Available at specialty foods stores and from tienda.com." mutableCopy];
//        _cuisine = [@"Mexican" mutableCopy];
//        _ingredients = [NSMutableArray arrayWithArray:@[@"1 1/2 teaspoons chipotle chile powder or ancho chile powder", @"1 3 1/2-pound beef tenderloin", @"1/2 teaspoon freshly ground black pepper", @"1 tablespoon coarse kosher salt", @"2 tablespoons dark brown sugar", @"2 cups (packed) stemmed fresh cilantro", @"1 cup (packed) stemmed fresh mint", @"3 cups (packed) stemmed fresh parsley"]];
//    }
//    return self;
//}

@end
