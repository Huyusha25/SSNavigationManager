//
//  OneViewController.m
//  SSNavManage
//
//  Created by HYS on 2019/11/13.
//  Copyright © 2019 HYS. All rights reserved.
//

#import "OneViewController.h"
#import "UINavigationController+SSNavigationManager.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ss_prefersnavigationBarColor = [UIColor redColor];
    self.ss_prefersNavigationBarAlpha = 0.2;
}

@end
