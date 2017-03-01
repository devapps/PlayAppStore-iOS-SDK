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
    _manager = [[PASSessionManager alloc] initWithBaseURL:configuration.baseURL sessionConfiguration:nil];
    return self;
}

- (void)getAllAppsWithCompletion:(void (^)(id responseObject))success {
    // https://10.1.33.75:1234/apps/ios
    
}

- (void)getAllAppsWithParameters:(nullable NSDictionary *)parameters completion:(nullable void (^)(id _Nullable responseObject, NSError  * _Nullable error))completion {
    
    [_manager GET:@"/apps/ios" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    
}

- (void)getAllBuildsWithParameters:(nullable NSDictionary *)parameters bundleID:(NSString *)bundleID completion:(nullable void (^)(id _Nullable responseObject, NSError  * _Nullable error))completion {
    
    
    NSString *path = [@"/apps/ios/" stringByAppendingString:bundleID];
    [_manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    
}

- (void)getBuildDetailWithBundleID:(NSString *)bundleID buildID:(NSString *)buildID completion:(nullable void (^)(id _Nullable responseObject, NSError  * _Nullable error))completion {
    
    NSString *path = [NSString stringWithFormat:@"/apps/ios/%@/%@", bundleID, buildID];
    [_manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    
}


@end
