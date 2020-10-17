//
//  FLAVRService.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 8/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRWebService.h"
#import "FLAVRParserJSON.h"
#import "FLAVRRecipe.h"
#import "FLAVRIngredient.h"
#import "FLAVRAlertManager.h"

@interface FLAVRWebService ()

@property (nonatomic) NSURLSession *session;
@property (nonatomic) FLAVRParserJSON *parser;

@end

@implementation FLAVRWebService

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
        
        _parser = [FLAVRParserJSON new];
    }
    return self;
}

#pragma mark - Load random recipes

- (void)loadRandomRecipes:(void (^)(NSArray<FLAVRRecipe *> *recipes, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:@"https://api.spoonacular.com/recipes/random?apiKey=b89f136d9abc4704bf78e2949cc4f695&number=10"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20.0];
    //896b075da2fb4c35a3a510752d0c6681
    [request setHTTPMethod:@"GET"];

    __weak typeof(self) weakelf = self;
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if (httpResponse.statusCode == 402) {
            error = [FLAVRAlertManager createDailyQuotaError];
        }
        
        if (error) {
            completion(nil, error);
            return;
        } else {
            [weakelf.parser parseRecipes:data completion:completion];
        }
    }];
    
    [dataTask resume];
}

#pragma mark - Convert ingredients amount

- (void)convertAmountForIngredient:(FLAVRIngredient*)ingredient copletion:(void (^)(FLAVRIngredient *ingredient, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.spoonacular.com/recipes/convert?apiKey=b89f136d9abc4704bf78e2949cc4f695&ingredientName=%@&sourceAmount=%@&sourceUnit=%@&targetUnit=%@", ingredient.name, ingredient.sourceAmount, ingredient.sourceUnit, ingredient.targetUnit]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20.0];
        // 896b075da2fb4c35a3a510752d0c6681
        [request setHTTPMethod:@"GET"];

    __weak typeof(self) weakelf = self;
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if (httpResponse.statusCode == 402) {
            error = [FLAVRAlertManager createDailyQuotaError];
        }
        
        if (error) {
            completion(nil, error);
            return;
        } else {
            [weakelf.parser parseConvertingAmountForIngredient:ingredient
                                                          data:data
                                                    completion:completion];
        }
    }];
    
    [dataTask resume];
}

#pragma mark - Search recipes

- (void)loadRecipesWithQuery:(NSString*)query
                  completion:(void (^)(NSArray<FLAVRRecipe *> *recipes, NSError *error))completion {
    int offset = arc4random() % 890;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.spoonacular.com/recipes/searchComplex?apiKey=b89f136d9abc4704bf78e2949cc4f695&query=%@&number=10&offset=%d&addRecipeInformation=true&instructionsRequired=true&fillIngredients=true&limitLicense=false", query, offset]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20.0];
    //b89f136d9abc4704bf78e2949cc4f695
    [request setHTTPMethod:@"GET"];

    __weak typeof(self) weakelf = self;
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if (httpResponse.statusCode == 402) {
            error = [FLAVRAlertManager createDailyQuotaError];
        }
        
        if (error) {
            completion(nil, error);
            return;
        } else {
            [weakelf.parser parseSearchResultRecipe:data completion:completion];
        }
    }];
    
    [dataTask resume];
}

@end
