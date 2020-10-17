#import "FLAVRAlertManager.h"

@interface FLAVRAlertManager ()

@end

@implementation FLAVRAlertManager

+ (UIAlertController *)alertControllerWithType:(FLAVRAlertType)type {
    UIAlertController *alertController;
    
    switch (type){
        case FLAVRAlertUnknownErrorType:
            alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                  message:[NSString stringWithFormat:@"Something went wrong"]
                                                           preferredStyle:UIAlertControllerStyleAlert];
            break;
        case FLAVRAlertNoInternetConnectionType: {
            alertController = [UIAlertController alertControllerWithTitle:@"Cellular Data is Turned Off"
                                                                  message:[NSString stringWithFormat:@"Turn on cellular data or use Wi-Fi to access data"]
                                                           preferredStyle:UIAlertControllerStyleAlert];
            NSURL *settingsURL = [NSURL URLWithString:@"App-Prefs:root=Cellular"];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Settings"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                if ([UIApplication.sharedApplication canOpenURL:settingsURL]) {
                    [UIApplication.sharedApplication openURL:settingsURL options:@{} completionHandler:nil];
                }
            }]];
            break;
        }
        case FLAVRAlertLoadErrorType:
            alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                  message:[NSString stringWithFormat:@"Can not load favorites"]
                                                           preferredStyle:UIAlertControllerStyleAlert];
            break;
        case FLAVRAlertSaveErrorType:
            alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                  message:[NSString stringWithFormat:@"Can not add recipe to favorites"]
                                                           preferredStyle:UIAlertControllerStyleAlert];
            break;
        case FLAVRAlertDeleteErrorType:
            alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                  message:[NSString stringWithFormat:@"Can not remove recipe from favorites"]
                                                           preferredStyle:UIAlertControllerStyleAlert];
            break;
        case FLAVRAlertDailyQuotaErrorType:
            alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                  message:[NSString stringWithFormat:@"Daily quota is exceeded"]
                                                           preferredStyle:UIAlertControllerStyleAlert];
            break;
    }

    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    return alertController;
}

+ (NSError *)createDailyQuotaError {
    return [NSError errorWithDomain:@"com.lina.loyko.RSSchool-FT" code:402 userInfo:@{@"error message" : @"Daily quota is exceeded"}];
}

@end
