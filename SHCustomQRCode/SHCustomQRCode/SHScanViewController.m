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
    
    SHCustomQRCodeView *qrcodeView = [[SHCustomQRCodeView alloc] initWithFrame:self.view.bounds];
    __weak typeof(self) weakSelf = self;
    qrcodeView.backQRCodeURL = ^(NSString *stringValue) {
        NSLog(@"----------------扫描结果--------------------------\n%@",stringValue);
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"二维码" message:stringValue preferredStyle:UIAlertControllerStyleAlert];
        [alertV addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
        [alertV addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [weakSelf presentViewController:alertV animated:YES completion:nil];
    };
    [self.view addSubview:qrcodeView];
}

- (void)dealloc
{
    NSLog(@"----------dealloc---------");
}

@end
