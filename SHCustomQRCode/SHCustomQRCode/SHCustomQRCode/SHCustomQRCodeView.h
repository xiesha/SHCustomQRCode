//
//  SHCustomQRCodeView.h
//  model
//
//  Created by 查斯图 on 2019/5/23.
//  Copyright © 2019 sharitu xie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackQRCodeURL)(NSString  *stringValue);
typedef void(^Backfailure)(void);

@interface SHCustomQRCodeView : UIView

/**扫描成功回调*/
@property (nonatomic,copy) BackQRCodeURL backQRCodeURL;
/**扫描失败回调*/
@property (nonatomic,copy) Backfailure backfailure;

+ (instancetype)new NS_UNAVAILABLE;
@end

