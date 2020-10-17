//
//  FLAVRAlertController.h
//  RSSchool_FT
//
//  Created by Lina Loyko on 10/17/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FLAVRAlertType) {
    FLAVRAlertUnknownErrorType,
    FLAVRAlertNoInternetConnectionType,
    FLAVRAlertLoadErrorType,
    FLAVRAlertSaveErrorType,
    FLAVRAlertDeleteErrorType,
    FLAVRAlertDailyQuotaErrorType = 402
};

@interface FLAVRAlertManager : NSObject

+ (UIAlertController *)alertControllerWithType:(FLAVRAlertType)type;
+ (NSError *)createDailyQuotaError;

@end

NS_ASSUME_NONNULL_END
