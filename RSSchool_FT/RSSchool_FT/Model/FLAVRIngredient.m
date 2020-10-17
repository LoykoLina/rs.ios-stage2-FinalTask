//
//  FLAVRIngredient.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/25/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRIngredient.h"

@interface FLAVRIngredient ()

@end

@implementation FLAVRIngredient


- (instancetype)initWithName:(NSString*)name
                sourceAmount:(NSString*)sourceAmount
                  sourceUnit:(NSString*)sourceUnit
                  targetUnit:(NSString*)targetUnit {
    self = [super init];
    if (self) {
        _name = name;
        _sourceAmount = sourceAmount;
        _sourceUnit = sourceUnit;
        _targetUnit = targetUnit;
    }
    return self;
}

- (void)configureConversionResult:(NSDictionary *)dictionary {
    if ([dictionary[@"answer"] rangeOfString:self.name].location != NSNotFound) {
        NSNumber *resultAmount = [NSNumber numberWithFloat:roundf([dictionary[@"targetAmount"] floatValue] * 4) / 4];
        
        NSMutableString *strFormat = [@"%d " mutableCopy];
        if (resultAmount.intValue == 0) {
            strFormat = [@"" mutableCopy];
        }
        NSInteger remainder = (int)(resultAmount.floatValue * 100) % 100;
        
        switch (remainder) {
            case 25:
                [strFormat appendString:@"1/4  %@"];
                self.conversionResult = [NSString stringWithFormat:strFormat,
                                         resultAmount.intValue,
                                         dictionary[@"targetUnit"]];
                break;
            case 50:
                [strFormat appendString:@"1/2  %@"];
                self.conversionResult = [NSString stringWithFormat:strFormat,
                                         resultAmount.intValue,
                                         dictionary[@"targetUnit"]];
                break;
            case 75:
                [strFormat appendString:@"3/4  %@"];
                self.conversionResult = [NSString stringWithFormat:strFormat,
                                         resultAmount.intValue,
                                         dictionary[@"targetUnit"]];
                break;
            case 0:
                [strFormat appendString:@"%@"];
                self.conversionResult = [NSString stringWithFormat:strFormat,
                                         resultAmount.intValue,
                                         dictionary[@"targetUnit"]];
                break;
        }
    }
}

@end
