//
//  DataCoreService.m
//  RSSchool_FT
//
//  Created by Lina Loyko on 10/17/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "FLAVRDataCoreService.h"
#import "AppDelegate.h"
#import "FLAVRRecipe.h"
#import "FLAVRFavoriteRecipe+CoreDataProperties.h"

@interface FLAVRDataCoreService ()

@end

@implementation FLAVRDataCoreService

- (NSManagedObjectContext *)viewContext {
    return ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
}

#pragma mark - Load saved recipes

- (void)loadSavedItems:(void (^)(NSArray<FLAVRRecipe *> *, NSError *))completion {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"FLAVRFavoriteRecipe" inManagedObjectContext:[self viewContext]];
    NSError *error = nil;
    NSArray *objs = [[self viewContext] executeFetchRequest:request error:&error];
    if (error) {
        completion(nil, error);
        return;
    }
    
    NSManagedObjectContext *context = [self viewContext];
    __block NSMutableArray<FLAVRRecipe *> *items = [[NSMutableArray  alloc] init];
    
    [context performBlockAndWait:^{
        for (FLAVRFavoriteRecipe *favItem in objs) {
            FLAVRRecipe *item = [[FLAVRRecipe alloc]init];
            item.title = favItem.title;
            item.cuisine = [favItem.cuisine mutableCopy];
            item.imageURL = favItem.imageURL;
            item.servings = [NSNumber numberWithInt:favItem.servings];
            item.readyInMinutes = [NSNumber numberWithInteger:favItem.readyInMinutes];
            item.identifier = [NSNumber numberWithInt:favItem.identifier];
            item.imageURL = favItem.imageURL;
            item.instruction = [favItem.instruction mutableCopy];
            item.ingredients = [favItem.ingredients mutableCopy];

            [items addObject:item];
        }
    }];
    
    if (![context save:&error]) {
        completion(nil, error);
        return;
    }
    
    completion([[items reverseObjectEnumerator] allObjects], nil);
}

#pragma mark - Check if recipe is saved

- (void)isItemSavedWithId:(NSNumber *)identifier completion:(void (^)(BOOL isSaved, NSError *error))completion {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"FLAVRFavoriteRecipe" inManagedObjectContext:[self viewContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %d", identifier.integerValue];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSInteger isExist = [[self viewContext] countForFetchRequest:request error:&error];
    if (error) {
        completion(nil, error);
    }
    
    completion(isExist == 1, nil);
}

#pragma mark - Save recipe

- (BOOL)saveItem:(FLAVRRecipe *)item {
    NSManagedObjectContext *context = [self viewContext];
    
    __block FLAVRFavoriteRecipe *favItem;
    [context performBlockAndWait:^{
        favItem = [[FLAVRFavoriteRecipe alloc] initWithContext:context];
        
        favItem.title = item.title;
        favItem.cuisine = item.cuisine;
        favItem.imageURL = item.imageURL;
        favItem.servings = item.servings.intValue;
        favItem.readyInMinutes = item.readyInMinutes.intValue;
        favItem.identifier = item.identifier.intValue;
        favItem.imageURL = item.imageURL;
        favItem.instruction = item.instruction;
        favItem.ingredients = item.ingredients;
    }];
    
    NSError *error;
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Delete recipe

- (BOOL)deleteItemWithId:(NSNumber *)identifier {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"FLAVRFavoriteRecipe" inManagedObjectContext:[self viewContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %d", identifier.integerValue];
    request.predicate = predicate;
    
    NSError *error;
    NSArray *objs = [[self viewContext] executeFetchRequest:request error:&error];
    if (error) {
        return NO;
    }
    
    NSManagedObjectContext *context = [self viewContext];
    [context performBlockAndWait:^{
        [context deleteObject:objs[0]];
    }];

    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

@end
