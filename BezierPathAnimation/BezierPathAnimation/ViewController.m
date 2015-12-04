//
//  ViewController.m
//  BezierPathAnimation
//
//  Created by Rory on 15/12/5.
//  Copyright (c) 2015年 Rory. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 100, 40)];
    lab.backgroundColor = [UIColor redColor];
    [self.view addSubview:lab];
}


@end
