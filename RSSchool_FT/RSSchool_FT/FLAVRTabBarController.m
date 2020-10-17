//
//  FLAVRTabBarController.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRTabBarController.h"
#import "FLAVRHomeController.h"
#import "FLAVRFavoritesController.h"
#import "FLAVRConvertingController.h"
#import "FLAVRSearchController.h"

@interface FLAVRTabBarController ()

@end

@implementation FLAVRTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar setTranslucent:NO];
    
    [self setupTabsControllers];
    
    self.view.backgroundColor = [UIColor colorNamed:@"flavr_white"];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self setupTabBarIndicator];
}

- (void)setupTabBarIndicator {
    CGFloat lineWidth = self.tabBar.frame.size.width/self.tabBar.items.count - 40;
    CGFloat lineHeight = 2;
    CGSize size = CGSizeMake(lineWidth, self.tabBar.frame.size.height - self.tabBar.layoutMargins.bottom);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [[UIColor colorNamed:@"main_color"] setFill];
    UIRectFill(CGRectMake(0, size.height - lineHeight, size.width, lineHeight));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.tabBar.selectionIndicatorImage = image;
}

- (void)setupTabsControllers {
    FLAVRHomeController *homeVC = [[FLAVRHomeController alloc]
                                   initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    [self setupTabViewController:homeVC
                           title:@"FLAVR"
                           image:[UIImage imageNamed:@"home_grey"]
                   selectedImage:[UIImage imageNamed:@"home_mint"]];
    
    FLAVRFavoritesController *favoritesVC = [[FLAVRFavoritesController alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    [self setupTabViewController:favoritesVC
                           title:@"FAVORITES"
                           image:[UIImage imageNamed:@"favorites_grey"]
                   selectedImage:[UIImage imageNamed:@"favorites_mint"]];
    
    FLAVRConvertingController *convertingVC = [FLAVRConvertingController new];
    [self setupTabViewController:convertingVC title:@"CONVERSION CALCULATOR"
                           image:[UIImage imageNamed:@"ic_convert_grey"]
                   selectedImage:[UIImage imageNamed:@"ic_convert_mint"]];
    
    FLAVRSearchController *searchVC = [FLAVRSearchController new];
    [self setupTabViewController:searchVC title:@"SEARCH"
                           image:[UIImage imageNamed:@"ic_search_grey"]
                   selectedImage:[UIImage imageNamed:@"ic_search_mint"]];
    
    self.viewControllers = @[[self embedInNavigationController:homeVC],
                             [self embedInNavigationController:favoritesVC],
                             convertingVC,
                             [self embedInNavigationController:searchVC]];
}

- (UINavigationController *)embedInNavigationController:(UIViewController*)vc {
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.title = vc.title;
    
    [nc.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20 weight:UIFontWeightThin]}];
    
    UIImage *image = [UIImage new];
    nc.navigationBar.shadowImage = image;
    [nc.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [nc.navigationBar setBarTintColor:[UIColor colorNamed:@"flavr_white"]];
    [nc.navigationBar setTranslucent:NO];
    
    return nc;
}

- (void)setupTabViewController:(UIViewController *)vc title:(NSString*)title image:()image selectedImage:()selectedImage{
    vc.title = title;
    
    vc.tabBarItem = [[UITabBarItem alloc]
                         initWithTitle:nil
                         image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                         selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, -5, 0);
}


@end
