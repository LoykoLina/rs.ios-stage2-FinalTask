//
//  LoadingFooter.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/24/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "LoadingFooter.h"

@implementation LoadingFooter

- (void)configure {
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    [self addSubview:self.activityView];
    
    self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.activityView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.activityView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor]
    ]];
    
    [self.activityView startAnimating];
}

@end
