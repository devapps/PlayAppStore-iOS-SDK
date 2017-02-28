//
//  PASDataProvider.m
//  PlayAppStoreSDK
//
//  Created by Herui on 28/2/2017.
//
//

#import "PASDataProvider.h"
#import "PASSessionManager.h"
#import "PASConfiguration.h"

@interface PASDataProvider ()

@property (nonatomic, strong) PASSessionManager *manager;

@end

@implementation PASDataProvider

- (instancetype)initWithConfiguration:(PASConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }
    _manager = [[PASSessionManager alloc] initWithProxyDictionary:nil];
    return self;
}

- (void)getAllAppsWithCompletion:(void (^)(id responseObject))success {
    // https://10.1.33.75:1234/apps/ios
    [_manager GET:@"https://10.1.33.75:1234/apps/ios" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (success) {
            success(error);
        }
    }];
}


@end
