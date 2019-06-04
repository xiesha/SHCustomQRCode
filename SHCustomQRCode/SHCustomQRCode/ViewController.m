//
//  ViewController.m
//  SHCustomQRCode
//
//  Created by 查斯图 on 2019/6/4.
//  Copyright © 2019 net.tangce.iOS. All rights reserved.
//

#import "ViewController.h"
#import "SHScanViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 150, 54)];
    [button setBackgroundColor:UIColor.blueColor];
    [button setTitle:@"点击扫描" forState:0];
    [button setTitleColor:UIColor.whiteColor forState:0];
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick
{
    [self.navigationController pushViewController:[SHScanViewController new] animated:YES];
}

@end
