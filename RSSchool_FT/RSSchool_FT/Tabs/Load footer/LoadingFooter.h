//
//  LoadingFooter.h
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/24/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadingFooter : UICollectionReusableView

@property (nonatomic) UIActivityIndicatorView *activityView;

- (void)configure;

@end

NS_ASSUME_NONNULL_END
