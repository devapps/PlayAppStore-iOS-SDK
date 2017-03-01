//
//  ViewController.m
//  Demo
//
//  Created by Herui on 28/2/2017.
//  Copyright © 2017 playappstore. All rights reserved.
//

#import "ViewController.h"
#import <PASDataProvider.h>
#import <PASConfiguration.h>
#import <PASApplication.h>


@interface ViewController ()

@property (nonatomic, strong) PASDataProvider *dataProvider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    PASConfiguration *config = [PASConfiguration shareInstance];
    config.baseURL = [NSURL URLWithString:@"http://10.1.36.68:3000/"];
    _dataProvider = [[PASDataProvider alloc] initWithConfiguration:config];
    
  
}

- (IBAction)buttonClicked:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://dl.dropboxusercontent.com/s/9ppyicsss4b4fri/Manifest.plist"];
    PASApplication *app = [[PASApplication alloc] initWithBundleIdentifier:@"com.lashou.LaShouGroup" manifestURL:url bundleVersion:@"1.0"];
    
    NSProgress *progress;
    [app installWithProgress:&progress completion:^(BOOL finished, NSError *error) {
        NSLog(@"comlete");
    }];
    
    if (progress) {
        [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionInitial context:nil];
    }
    
// [_dataProvider getAllAppsWithParameters:nil completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
//     NSLog(@"%@", responseObject);
// }];
   
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = (NSProgress *)object;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"progress: %@", @(progress.fractionCompleted));
        });
    }
}



@end
