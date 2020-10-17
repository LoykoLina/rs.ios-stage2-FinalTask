//
//  FLAVRImageService.h
//  RSSchool_FT
//
//  Created by Lina Loyko on 9/4/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLAVRImageService : NSObject

- (void)loadImageForURL:(NSString *)url completion:(void (^)(UIImage *))completion;
- (void)cancelDownloadingForUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
