//
//  FLAVRRecipe.h
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/22/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLAVRRecipe : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSMutableString *cuisine;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *dishType;
@property (nonatomic, copy) NSNumber *servings;
@property (nonatomic, copy) NSNumber *readyInMinutes;
@property (nonatomic, copy) NSNumber *identifier;
@property (nonatomic, copy) NSMutableArray<NSString*> *ingredients;
@property (nonatomic, copy) NSMutableString *instruction;
@property (nonatomic, copy) UIImage *image;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithSearchResultsDictionary:(NSDictionary *)dictionary;
//- (instancetype)initWithReadyInfo;

@end

NS_ASSUME_NONNULL_END
