//
//  FLAVRRecipeController.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRRecipeController.h"
#import "FLAVRRecipe.h"
#import "FLAVRDataCoreService.h"
#import "FLAVRImageService.h"
#import "FLAVRAlertManager.h"

@interface FLAVRRecipeController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHRConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHCConstraint;
@property (nonatomic) FLAVRImageService *imageService;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *cuisineLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *servingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *readyInMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UIStackView *ingridientsStack;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) BOOL isSaved;
@property (nonatomic) FLAVRDataCoreService *service;

@end

@implementation FLAVRRecipeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController) {
        [self.navigationController.navigationBar setTintColor:UIColor.clearColor];
        [self.navigationController.navigationBar setHidden:YES];
    } else {
        UIScreenEdgePanGestureRecognizer *swipeGR = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBack:)];
        [swipeGR setEdges:UIRectEdgeLeft];
        [self.view addGestureRecognizer:swipeGR];
    }
    
    self.imageService = [FLAVRImageService new];
    self.service = [FLAVRDataCoreService new];
    [self setupItemStates];
    
    [self configure];
    [self configureBackButton];
    [self configureLikeButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    CGFloat newHeight;
    newHeight = self.instructionLabel.bounds.size.height + self.ingridientsStack.bounds.size.height - 80;
    
    self.contentViewHCConstraint.constant += newHeight;
    self.contentViewHRConstraint.constant += newHeight;

    self.scrollView.contentSize = self.contentView.bounds.size;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (!self.recipe.image) {
        [self.imageService cancelDownloadingForUrl:self.recipe.imageURL];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (!self.isSaved && self.isFavorite) {
        if (![self.service saveItem:self.recipe]) {
            [self showSaveErrorAlert];
        }
    } else if(self.isSaved && !self.isFavorite) {
        if (![self.service deleteItemWithId:self.recipe.identifier]) {
            [self showDeleteErrorAlert];
        }
    }
}

- (void)setupItemStates {
    __weak typeof(self) weakSelf = self;
    [self.service isItemSavedWithId:self.recipe.identifier completion:^(BOOL isSaved, NSError *error) {
        if (error) {
            [weakSelf.likeButton setHidden:YES];
        } else {
            weakSelf.isSaved = isSaved;
        }
    }];
    self.isFavorite = self.isSaved;
}

- (void)swipeBack:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Alert views

- (void)showSaveErrorAlert {
    UIAlertController *alertController = [FLAVRAlertManager alertControllerWithType:FLAVRAlertSaveErrorType];
    [self.parentViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)showDeleteErrorAlert {
    UIAlertController *alertController = [FLAVRAlertManager alertControllerWithType:FLAVRAlertDeleteErrorType];
    [self.parentViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Load image

- (void)loadImage {
    __weak typeof(self) weakSelf = self;
    [self.imageService loadImageForURL:self.recipe.imageURL completion:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:weakSelf.imageView
                              duration:0.2
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{ weakSelf.imageView.image = image; }
                            completion:nil];
        });
    }];
}

#pragma mark - View configuration

- (void)configure {
    self.cuisineLabel.text = self.recipe.cuisine;
    self.titleLabel.text = self.recipe.title;
    self.servingsLabel.text = [NSString stringWithFormat:@"%@ people", self.recipe.servings];
    self.readyInMinutesLabel.text = [NSString stringWithFormat:@"%@ minutes", self.recipe.readyInMinutes];
    self.instructionLabel.text = self.recipe.instruction;
    
    if (self.recipe.image) {
        self.imageView.image = self.recipe.image;
    } else {
        [self loadImage];
    }
    
    [self configureIngridientsView];
    
}

- (void)configureIngridientsView {
    self.ingridientsStack.spacing = 20;
    
    for (NSString *ingr in self.recipe.ingredients) {
        UILabel *label = [UILabel new];
        label.text = ingr;
        label.numberOfLines = 0;
        [label setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightThin]];
        
        [self.ingridientsStack addArrangedSubview:label];
    }
    
    for (UIView *view in self.ingridientsStack.arrangedSubviews) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_circle"]];
        [self.ingridientsStack.superview addSubview:imageView];
        
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [imageView.widthAnchor constraintEqualToConstant:25],
            [imageView.heightAnchor constraintEqualToConstant:25],
            [imageView.leadingAnchor constraintEqualToAnchor:self.ingridientsStack.superview.leadingAnchor constant:20],
            [imageView.topAnchor constraintEqualToAnchor:view.topAnchor],
        ]];
    }
    
    
}

- (BOOL)hidesBottomBarWhenPushed {
    return self.navigationController.topViewController == self;
}

#pragma mark - Back Button configuration

- (void)configureBackButton {
    [self.backButton setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(backButtonIsTapped:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.backButton addGestureRecognizer:singleTap];
}

- (void)backButtonIsTapped:(UIGestureRecognizer *)recognizer {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - Like Button configuration

- (void)configureLikeButton {
    [self.likeButton setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeButtonIsTapped:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.likeButton addGestureRecognizer:singleTap];
    
    if (self.isSaved) {
        [self.likeButton setImage:[UIImage imageNamed:@"ic_favorite_fill"]];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"ic_favorite"]];
    }
}

- (void)likeButtonIsTapped:(UIGestureRecognizer *)recognizer {
    if (!self.isFavorite) {
        [self.likeButton setImage:[UIImage imageNamed:@"ic_favorite_fill"]];
        self.isFavorite = YES;
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"ic_favorite"]];
        self.isFavorite = NO;
    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

@end
