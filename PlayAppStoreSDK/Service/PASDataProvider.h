//
//  PASDataProvider.h
//  PlayAppStoreSDK
//
//  Created by Herui on 28/2/2017.
//
//

#import <Foundation/Foundation.h>

@class PASConfiguration;
@interface PASDataProvider : NSObject


- (instancetype)initWithConfiguration:(PASConfiguration *)configuration;


- (void)getAllAppsWithParameters:(nullable NSDictionary *)parameters completion:(nullable void (^)(id _Nullable responseObject, NSError  * _Nullable error))completion;

- (void)getAllBuildsWithParameters:(nullable NSDictionary *)parameters bundleID:(NSString *)bundleID completion:(nullable void (^)(id _Nullable responseObject, NSError  * _Nullable error))success;

- (void)getBuildDetailWithBundleID:(NSString *)bundleID buildID:(NSString *)buildID completion:(nullable void (^)(id _Nullable responseObject, NSError  * _Nullable error))success;




@end
