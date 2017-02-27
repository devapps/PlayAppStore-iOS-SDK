//
//  PASApplication.h
//  PlayAppStore
//
//  Created by Herui on 27/2/2017.
//  Copyright © 2017 playappstore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASApplication : NSObject

///
/// Create an application that not only refers to local applications, but also allows installation from
/// a manifest online (using itms-service, so normal requirements apply)
///
- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier manifestURL:(NSURL *)manifestURL bundleVersion:(NSString *)bundleVersion;



///
/// Install the application
/// This is only applicable for applications created with a manifest URL
///
/// - parameter completion:  Block to be executed when the installation finishes (either fails or succeeds)
/// - parameter progress: progress for the installation
///
- (void)installWithProgress:(NSProgress * __autoreleasing *)progress completion:(void (^)(BOOL finished, NSError *error))completion;

///
/// Launch the application
///
/// - returns: YES if launching was possible (does not guarantee the application was actually launched)
- (BOOL)launch;





@end
