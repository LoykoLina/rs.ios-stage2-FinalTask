//
//  FLAVRIngredient.h
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/25/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLAVRIngredient : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sourceAmount;
@property (nonatomic, copy) NSString *sourceUnit;
@property (nonatomic, copy) NSString *targetUnit;
@property (nonatomic, copy) NSString *conversionResult;

- (instancetype)initWithName:(NSString*)name
                sourceAmount:(NSString*)sourceAmount
                  sourceUnit:(NSString*)sourceUnit
                  targetUnit:(NSString*)targetUnit;
- (void)configureConversionResult:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
