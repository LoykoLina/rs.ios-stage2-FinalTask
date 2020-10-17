//
//  FLAVRConvertingController.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/24/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRConvertingController.h"
#import "FLAVRWebService.h"
#import "FLAVRIngredient.h"
#import "NSArray+CookingUnits.h"
#import "FLAVRAlertManager.h"

@interface FLAVRConvertingController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *sourceAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *sourceUnitLabel;
@property (weak, nonatomic) IBOutlet UITextField *ingridientNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *targetUnitLabel;

@property (nonatomic) FLAVRWebService *service;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHRConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHCConstraint;

@property (nonatomic, assign) CGFloat previousContentOffset;

@property (nonatomic) UIPickerView *sourceUnitPickerView;
@property (nonatomic) UIPickerView *targetUnitPickerView;

@end

@implementation FLAVRConvertingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[FLAVRWebService alloc] init];
    
    [self.activityIndicator setHidden:YES];
    
    self.convertButton.layer.cornerRadius = 5;
    
    self.sourceAmountTextField.delegate = self;
    self.ingridientNameTextField.delegate = self;
    
    self.sourceUnitPickerView = [UIPickerView new];
    self.sourceUnitPickerView.delegate = self;
    [self.sourceUnitPickerView selectRow:[NSArray.cookingUnits indexOfObject:@"cups"]
                             inComponent:0
                                animated:YES];
    self.targetUnitPickerView = [UIPickerView new];
    self.targetUnitPickerView.delegate = self;
    [self.targetUnitPickerView selectRow:[NSArray.cookingUnits indexOfObject:@"tablespoons"]
                             inComponent:0
                                animated:YES];
    
    [self configureLabelsWithUnitPicker];
    [self subscribeForKeyboardNotifications];
    [self configureViewTapGestureRecognizer];
}

#pragma mark - Dismiss keyboard when tap on view

- (void)configureViewTapGestureRecognizer {
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(dismissKeyboard:)];
    [tapGR setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGR];
}

-(void)dismissKeyboard:(UIGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

#pragma mark - Keyboard notifications

- (void)subscribeForKeyboardNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        if (self.ingridientNameTextField.isEditing) {
            CGRect keyboardRect = [(NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
            CGFloat y = self.targetUnitLabel.superview.frame.origin.y - keyboardRect.origin.y;
            self.previousContentOffset = self.scrollView.contentOffset.y;
            if (y < 0) {
                [self.scrollView setContentOffset:CGPointMake(0, -y)
                                         animated:YES];
            } else {
                [self.scrollView setContentOffset:CGPointMake(0, y)
                                         animated:YES];
            }
        }
        if (self.sourceAmountTextField.isEditing) {
            self.previousContentOffset = self.scrollView.contentOffset.y;
            [self.scrollView setContentOffset:CGPointZero
                                     animated:YES];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        [self.scrollView setContentOffset:CGPointMake(0, self.previousContentOffset) animated:YES];

    }
}

#pragma mark - Configure unit picker view

- (void)configureLabelsWithUnitPicker {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(configureTargetUnitPickerView:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.targetUnitLabel addGestureRecognizer:singleTap];
    [self.targetUnitLabel setUserInteractionEnabled:YES];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(configureSourceUnitPickerView:)];
    [self.sourceUnitLabel addGestureRecognizer:singleTap];
    [self.sourceUnitLabel setUserInteractionEnabled:YES];
}

- (void)configureTargetUnitPickerView:(UIGestureRecognizer *)recognizer {
    if (self.targetUnitLabel.isHighlighted) {
        [self dismissUnitPickerView:self.targetUnitPickerView forLabel:self.targetUnitLabel];
    } else {
        [self showUnitPickerView:self.targetUnitPickerView  forLabel:self.targetUnitLabel];
        if (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
            CGFloat y = self.contentViewHCConstraint.constant - self.view.frame.size.height;
            
            [self.scrollView setContentOffset:CGPointMake(0, y)
                                     animated:YES];
        }
    }
}

- (void)configureSourceUnitPickerView:(UIGestureRecognizer *)recognizer {
    if (self.sourceUnitLabel.isHighlighted) {
        [self dismissUnitPickerView:self.sourceUnitPickerView forLabel:self.sourceUnitLabel];
    } else {
        [self showUnitPickerView:self.sourceUnitPickerView  forLabel:self.sourceUnitLabel];
    }
}

- (void)dismissUnitPickerView:(UIPickerView *)pickerView forLabel:(UILabel *)label {
    [label setHighlighted:NO];
    
    self.contentViewHRConstraint.constant -= pickerView.bounds.size.height;
    self.contentViewHCConstraint.constant -= pickerView.bounds.size.height;
    
    self.scrollView.contentSize = self.contentView.bounds.size;
    
    __weak typeof(self) weakSelf = self;
    [UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [pickerView removeFromSuperview];
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
}

- (void)showUnitPickerView:(UIPickerView *)pickerView forLabel:(UILabel *)label {
    [label setHighlighted:YES];
    
    [label.superview addSubview:pickerView];
    
    [NSLayoutConstraint activateConstraints:@[
        [pickerView.centerXAnchor constraintEqualToAnchor:pickerView.superview.centerXAnchor],
        [pickerView.topAnchor constraintEqualToAnchor:label.bottomAnchor constant:10],
        [pickerView.heightAnchor constraintEqualToConstant:110],
        [pickerView.superview.bottomAnchor constraintEqualToAnchor:pickerView.bottomAnchor constant:10]
    ]];
    pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    __weak typeof(self) weakSelf = self;
    [UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
    
    self.contentViewHRConstraint.constant += pickerView.bounds.size.height;
    self.contentViewHCConstraint.constant += pickerView.bounds.size.height;
    self.scrollView.contentSize = self.contentView.bounds.size;
}

#pragma mark  - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return NSArray.cookingUnits.count;
}

#pragma mark  - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return NSArray.cookingUnits[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.sourceUnitLabel.isHighlighted) {
        self.sourceUnitLabel.text = NSArray.cookingUnits[row];
    } else if(self.targetUnitLabel.isHighlighted) {
        self.targetUnitLabel.text = NSArray.cookingUnits[row];
    }
    
}

#pragma mark - Convert amount

- (IBAction)convert:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if (self.sourceUnitLabel.isHighlighted) {
        [self configureSourceUnitPickerView:nil];
    }
    if (self.targetUnitLabel.isHighlighted) {
        [self configureTargetUnitPickerView:nil];
    }
    
    if (![self.ingridientNameTextField.text isEqualToString:@""] && ![self.sourceAmountTextField.text isEqualToString:@""]) {
        FLAVRIngredient *ingredient = [[FLAVRIngredient alloc] initWithName:self.ingridientNameTextField.text
                                                               sourceAmount:self.sourceAmountTextField.text
                                                                 sourceUnit:self.sourceUnitLabel.text
                                                                 targetUnit:self.targetUnitLabel.text];

        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];

        [self.service convertAmountForIngredient:ingredient copletion:^(FLAVRIngredient *resultIngredient, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error.code == FLAVRAlertDailyQuotaErrorType) {
                    UIAlertController *alertController = [FLAVRAlertManager alertControllerWithType:FLAVRAlertDailyQuotaErrorType];
                    [weakSelf presentViewController:alertController animated:YES completion:nil];
                }
                
                if (error) {
                    [weakSelf animateTextChangeForLabel:weakSelf.resultLabel
                                                   text:@"Oops... Please, try again later"];
                } else {
                    if (resultIngredient.conversionResult) {
                        [weakSelf animateTextChangeForLabel:weakSelf.resultLabel
                                                       text:resultIngredient.conversionResult];
                    } else {
                        [weakSelf animateTextChangeForLabel:weakSelf.resultLabel
                                                       text:@"Invalid ingredient"];
                    }
                }

                [weakSelf.activityIndicator stopAnimating];
                [weakSelf.activityIndicator setHidden:YES];
            });
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf animateTextChangeForLabel:weakSelf.resultLabel
                                           text:@"Please, fill in the ingredient name and its amount"];
        });
    }
}

- (void)animateTextChangeForLabel:(UILabel*)label text:(NSString*)text {
    [UIView transitionWithView:label
                    duration:0.25f
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
        label.text = text;
    } completion:nil];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
