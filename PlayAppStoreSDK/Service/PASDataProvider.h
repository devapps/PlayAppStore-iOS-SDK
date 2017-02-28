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


- (void)getAllAppsWithCompletion:(void (^)(id responseObject))success;


@end
