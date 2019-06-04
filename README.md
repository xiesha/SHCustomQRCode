# SHCustomQRCode
扫描控件封装

使用方法:
SHCustomQRCodeView *qrcodeView = [[SHCustomQRCodeView alloc] initWithFrame:self.view.bounds];
qrcodeView.backQRCodeURL = ^(NSString *stringValue) {
    //do some thing
};
qrcodeView.backfailure = ^{
    //failure
};
[self.view addSubview:qrcodeView];
