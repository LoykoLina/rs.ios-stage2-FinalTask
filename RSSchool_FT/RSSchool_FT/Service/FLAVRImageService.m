//
//  FLAVRImageService.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 9/4/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRImageService.h"
#import "ImageDownloadOperation.h"

@interface FLAVRImageService ()

@property (nonatomic) NSCache<NSString *, UIImage *> *cache;
@property (nonatomic) NSMutableDictionary<NSString *, NSOperation *> *operations;
@property (nonatomic) NSOperationQueue *queue;

@end

@implementation FLAVRImageService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queue = [NSOperationQueue new];
        _operations = [NSMutableDictionary new];
        _cache = [[NSCache alloc] init];
    }
    return self;
}

- (void)loadImageForURL:(NSString *)url completion:(void (^)(UIImage *))completion {
    
    UIImage *image = [self.cache objectForKey:url];
    if (image) {
        completion(image);
    } else {
        if (url) {
            [self cancelDownloadingForUrl:url];
            
            ImageDownloadOperation *operation = [[ImageDownloadOperation alloc] initWithUrl:url];
            self.operations[url] = operation;
            operation.completion = ^(UIImage *image) {
                [self.cache setObject:image forKey:url];
                completion(image);
            };
            [self.queue addOperation:operation];
        }
        
    }
}

- (void)cancelDownloadingForUrl:(NSString *)url {
    NSOperation *operation = self.operations[url];
    if (!operation) {
        return;
    }
    [operation cancel];
}

@end
