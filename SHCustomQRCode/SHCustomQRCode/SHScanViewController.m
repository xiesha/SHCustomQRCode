//
//  SHScanViewController.m
//  model
//
//  Created by 查斯图 on 2019/4/12.
//  Copyright © 2019 sharitu xie. All rights reserved.
//

#import "SHScanViewController.h"
#import "SHCustomQRCodeView.h"//扫描控件

@interface SHScanViewController ()

@end

@implementation SHScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    //页面标题
    self.navigationItem.title = @"扫一扫";
    
    __weak typeof(self) weakSelf = self;
    SHCustomQRCodeView *qrcodeView = [[SHCustomQRCodeView alloc] initWithFrame:self.view.bounds];
    qrcodeView.backQRCodeURL = ^(NSString *stringValue) {
        [weakSelf alertViewTitle:@"扫描成功" Message:stringValue];
    };
    qrcodeView.backfailure = ^{
        [weakSelf alertViewTitle:@"扫描失败" Message:@"扫描失败"];
    };
    [self.view addSubview:qrcodeView];
}

- (void)alertViewTitle:(NSString *)title Message:(NSString *)message
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertV addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alertV animated:YES completion:nil];
}

@end
