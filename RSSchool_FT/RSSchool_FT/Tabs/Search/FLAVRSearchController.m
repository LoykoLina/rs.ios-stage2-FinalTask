//
//  FLAVRSearchController.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/24/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRSearchController.h"
#import "LoadingFooter.h"
#import "FLAVRSearchResultController.h"

@interface FLAVRSearchController () <UITextFieldDelegate, UISearchBarDelegate>

@property (nonatomic) UISearchController *searchController;
@property (nonatomic) FLAVRSearchResultController *searchResultController;
@property (nonatomic) NSMutableArray<NSString*> * recents;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *recentViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *recentLabels;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation FLAVRSearchController

static NSString * const kRecentsKey = @"RecentSearches";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSearchController];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.recents = [NSMutableArray new];
    if ([userDefaults objectForKey:kRecentsKey]) {
        self.recents = [[userDefaults objectForKey:kRecentsKey] mutableCopy];
    }
    
    [self.contentView setHidden:YES];
    for (UIView *view in self.recentViews) {
        [view setHidden:YES];
    }
    
    [self configureRecentSearches];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.searchResultController.dataSource = [NSMutableArray new];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.recents forKey:kRecentsKey];
    [userDefaults synchronize];
}

- (void)configureSearchController {
    self.searchResultController = [[FLAVRSearchResultController alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Recipes...";
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.searchTextField.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
    [self.navigationItem setHidesSearchBarWhenScrolling:NO];
    
    self.navigationItem.searchController = self.searchController;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchResultController.dataSource = [NSMutableArray new];
    [self.searchResultController.collectionView reloadData];
    
    [self configureRecentSearches];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![textField.text isEqualToString:@""]) {
        [self.searchResultController.collectionView setScrollsToTop:YES];
        
        [self.searchResultController.activityIndicator startAnimating];
        [self.searchResultController loadRecipesWithQuery:textField.text];
        
        self.searchResultController.dataSource = [NSMutableArray new];
        [self.searchResultController.collectionView reloadData];
        
        [self saveSearchRequest:textField.text];
        
        return YES;
    }
    return NO;
}

- (IBAction)clearRecents:(UIButton *)sender {
    [self.contentView setHidden:YES];
    
    [self.recents removeAllObjects];
}

- (void)configureRecentSearches {
    if (self.recents.count != 0) {
        [self.contentView setHidden:NO];
        
        for (int i=0; i < self.recents.count; i++) {
            [self.recentViews[i] setHidden:NO];
            [self configureRecentView:self.recentViews[i]];
            [self.recentLabels[i] setText:self.recents[i]];
        }
    }
}

- (void)saveSearchRequest:(NSString*)search {
    [self.recents insertObject:search atIndex:0];
    if (self.recents.count > 5) {
        [self.recents removeLastObject];
    }
}

- (void)configureRecentView:(UIView*)view {
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(recentSearchTapped:)];
    tapGR.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tapGR];
}

- (void)recentSearchTapped:(UITapGestureRecognizer*)gestureRecognizer {
    [self.searchController setActive:YES];
    NSInteger index = [self.recentViews indexOfObject:gestureRecognizer.view];
    NSString *text = [self.recentLabels[index] text];
    [self.searchController.searchBar.searchTextField becomeFirstResponder];
    self.searchController.searchBar.searchTextField.text = text;
}

@end
