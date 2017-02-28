//
//  ViewController.m
//  Demo
//
//  Created by Herui on 28/2/2017.
//  Copyright © 2017 playappstore. All rights reserved.
//

#import "ViewController.h"
#import <PASDataProvider.h>


@interface ViewController ()

@property (nonatomic, strong) PASDataProvider *dataProvider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dataProvider = [[PASDataProvider alloc] initWithConfiguration:nil];
    
  
}

- (IBAction)buttonClicked:(UIButton *)sender {
    
 
    [_dataProvider getAllAppsWithCompletion:^(id responseObject) {
        NSLog(@"res : %@", responseObject);
    }];
    
}



@end
