//
//  PASConfiguration.m
//  PlayAppStoreSDK
//
//  Created by Herui on 28/2/2017.
//
//

#import "PASConfiguration.h"

@implementation PASConfiguration

+ (PASConfiguration *)shareInstance {
    static dispatch_once_t onceToken;
    static PASConfiguration *configuration;
    dispatch_once(&onceToken, ^{
        configuration = [[PASConfiguration alloc] init];
    });
    return configuration;
}

@end
