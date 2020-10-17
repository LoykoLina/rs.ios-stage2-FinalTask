//
//  FLAVRCollectionCell.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRCollectionCell.h"
#import "FLAVRRecipe.h"

@interface FLAVRCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *cuisine;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *servings;
@property (weak, nonatomic) IBOutlet UIImageView *servingsImage;
@property (weak, nonatomic) IBOutlet UILabel *readyInMinutes;
@property (weak, nonatomic) IBOutlet UIImageView *readyInMinutesImage;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation FLAVRCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 10.0;
    self.containerView.clipsToBounds = YES;
}

- (void)configureWithItem:(FLAVRRecipe*)recipe {
    self.readyInMinutes.text = [NSString stringWithFormat:@"%@ minutes", recipe.readyInMinutes];
    self.cuisine.text = recipe.cuisine;
    self.servings.text = [NSString stringWithFormat:@"%@ people", recipe.servings];
    self.title.text = recipe.title;
    if (recipe.image) {
        self.imageView.image = recipe.image;
    } else {
        self.imageView.image = [UIImage imageNamed:@"Launch Screen landscape"];
    }
}

@end
