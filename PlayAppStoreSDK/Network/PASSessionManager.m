//
//  PASSessionManager.m
//  PlayAppStoreSDK
//
//  Created by Herui on 28/2/2017.
//
//

#import "PASSessionManager.h"
#import "AFNetworking.h"

@interface PASSessionManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property UInt32 timeout;

@end

@implementation PASSessionManager

- (instancetype)initWithBaseURL:(nullable NSURL *)url
           sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }
    _httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    return self;

}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    return [_httpManager GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    return [_httpManager POST:URLString parameters:parameters progress:uploadProgress success:success failure:failure];
    
}

@end
