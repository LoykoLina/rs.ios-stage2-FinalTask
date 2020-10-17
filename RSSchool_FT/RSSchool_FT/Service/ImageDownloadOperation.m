//
//  ImageDownloadOperation.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "ImageDownloadOperation.h"

@interface ImageDownloadOperation ()

@property (nonatomic, copy) NSString *url;

@end

@implementation ImageDownloadOperation

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)main {
    
    if (self.isCancelled) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]
                                      dataTaskWithURL:url
                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError * error) {
        if (!data) {
            return;
        }
        if (weakSelf.isCancelled) {
            return;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        weakSelf.image = image;
        if (weakSelf.completion) {
            weakSelf.completion(image);
        }
    }];

    if (self.isCancelled) {
        return;
    }
    
    [dataTask resume];
}

@end
