//
//  PASConfiguration.h
//  PlayAppStoreSDK
//
//  Created by Herui on 28/2/2017.
//
//

#import <Foundation/Foundation.h>

@interface PASConfiguration : NSObject

+ (PASConfiguration *)shareInstance;

/**
 *    默认服务器地址
 */
@property (nonatomic, copy) NSURL *baseURL;


/**
 *    超时时间 单位 秒
 */
@property (assign) UInt32 timeoutInterval;

@property (nonatomic, strong) NSDictionary *proxy;



@end
