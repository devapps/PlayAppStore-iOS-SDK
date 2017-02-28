//
//  PASApplication.m
//  PlayAppStore
//
//  Created by Herui on 27/2/2017.
//  Copyright © 2017 playappstore. All rights reserved.
//

#import "PASApplication.h"
#import "LSApplicationProxy.h"
#import "LSApplicationWorkspace.h"
#import <UIKit/UIKit.h>

typedef void (^PASInstallationCompletion)(BOOL, NSError *);


@interface PASApplication ()

@property (nonatomic, strong) NSMutableArray<LSApplicationProxy *> *proxies;

@property (nonatomic, copy) NSString *bundleVersion;
@property (nonatomic, copy) NSString *bundleIdentifier;
@property (nonatomic, copy) NSURL *manifestURL;
@property (nonatomic, strong) NSProgress *internalProgress;
@property (nonatomic, strong) NSProgress *installationProgress;
@property (nonatomic, copy) PASInstallationCompletion installationCompletion;
@property (nonatomic, strong) NSTimer *installationCheckingTimer;



@end

@implementation PASApplication

- (void)dealloc {
    NSLog(@"dealloc");
    if (self.internalProgress) {
        [self.internalProgress removeObserver:self forKeyPath:@"fractionCompleted"];
    }
}


- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier manifestURL:(NSURL *)manifestURL bundleVersion:(NSString *)bundleVersion {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSParameterAssert(bundleIdentifier);
    _bundleIdentifier = bundleIdentifier;
    if (manifestURL) {
        _manifestURL = manifestURL;
    }
    if (bundleVersion) {
        _bundleVersion = bundleVersion;
    }
    
    [self reloadProxies];
    return self;
}



- (void)reloadProxies {
    LSApplicationWorkspace *workspace =  (LSApplicationWorkspace *)[LSApplicationWorkspace defaultWorkspace];
    NSMutableArray *mutableArray = @[].mutableCopy;
    NSArray *allApplications = (NSMutableArray<LSApplicationProxy *> *)workspace.allApplications;
    for (LSApplicationProxy *proxy in allApplications) {
        if ([proxy.applicationIdentifier isEqualToString:self.bundleIdentifier]) {
            [mutableArray addObject:proxy];
        }
    }
    self.proxies = mutableArray;
    
}

#pragma mark - Public
- (void)installWithProgress:(NSProgress * __autoreleasing *)progress completion:(void (^)(BOOL finished, NSError *error))completion {
    // in progress
    if (self.installationProgress) {
        return;
    }
    if (![self isInstallable]) {
        return;
    }
    // First step is to start the installation via itms-service
    // If this can not be done, fail immediately
    NSURL *itmsURL = self.itmsURL;
    if ([[UIApplication sharedApplication] canOpenURL:itmsURL]) {
        // We can now start the actual installation process
        NSProgress *installProgress = [NSProgress progressWithTotalUnitCount:101];
        
        self.installationProgress = installProgress;
        if (installProgress) {
            *progress = installProgress;
        }
        
        self.installationCompletion = ^(BOOL success, NSError *error){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            [self description];
#pragma clang diagnostic pop

            completion(success, error);
        };
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startMonitoring) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[UIApplication sharedApplication] openURL:itmsURL];
        
    } else {
        if (completion) {
            completion(NO, nil);
        }
    }
}


- (BOOL)launch {
    
    LSApplicationWorkspace *workspace =  (LSApplicationWorkspace *)[LSApplicationWorkspace defaultWorkspace];
    return [workspace openApplicationWithBundleID:self.bundleIdentifier];

    
}

#pragma mark - Func
- (void)finishInstallation {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.installationCompletion) {
            self.installationCompletion(YES, nil);
            [self cleanup];
        }

    });
}
- (void)failInstallationWithError:(NSError *)error {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.installationCompletion) {
            self.installationCompletion(NO, error);
        }
        [self cleanup];
    });
}

- (void)cleanup {
    self.installationCompletion = nil;
    self.installationProgress = nil;
}



#pragma mark - Notifications
- (void)startMonitoring {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    // We should now be a placeholder, if not, the user likely cancelled the operation
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self reloadProxies];
        if (self.isPlaceholder) {
            LSApplicationWorkspace *workspace = [LSApplicationWorkspace defaultWorkspace];
            NSProgress *progress = [workspace installProgressForBundleID:self.bundleIdentifier makeSynchronous:1];
            if (progress) {
                self.internalProgress = progress;
                [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionInitial context:nil];
            } else {
                [self failInstallationWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"User Cancel"}]];
            }
        }
    });
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        if ([object isKindOfClass:[NSProgress class]]) {
            NSProgress *other = (NSProgress *)object;
            NSProgress *progress = self.installationProgress;
            progress.completedUnitCount = other.completedUnitCount;
            
            if (self.installationCheckingTimer) {
                [self.installationCheckingTimer invalidate];
            }
            
            self.installationCheckingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkIfFinishedInstallation) userInfo:nil repeats:YES];
            
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

#pragma mark - Timer
- (void)checkIfFinishedInstallation {
    [self reloadProxies];
    if (self.isInstalled) {
        if (self.installationCheckingTimer) {
            [self.installationCheckingTimer invalidate];
        }
        [self finishInstallation];

    } else if (!self.isPlaceholder) {
        if (self.installationCheckingTimer) {
            [self.installationCheckingTimer invalidate];
        }
        [self failInstallationWithError:[NSError errorWithDomain:@"internal" code:1 userInfo:@{@"des": @"Internal error"}]];
        
    }
}



#pragma mark - Getter
- (BOOL)isInstallable {
    return self.manifestURL != nil;
}

- (NSURL *)itmsURL {
    return self.manifestURL;
}
    
- (BOOL)isPlaceholder {
    NSMutableArray *mutableArray = @[].mutableCopy;
    for (LSApplicationProxy *proxy in self.proxies) {
        if (proxy.isPlaceholder) {
            [mutableArray addObject:proxy];
        }
    }
    return mutableArray.count > 0;
}
- (BOOL)isInstalled {
    NSMutableArray *mutableArray = @[].mutableCopy;
    for (LSApplicationProxy *proxy in self.proxies) {
        if (proxy.isInstalled) {
            [mutableArray addObject:proxy];
        }
    }
    return mutableArray.count > 0;
    
}





@end
