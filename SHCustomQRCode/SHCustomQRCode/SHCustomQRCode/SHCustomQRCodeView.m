//
//  SHCustomQRCodeView.m
//  model
//
//  Created by 查斯图 on 2019/5/23.
//  Copyright © 2019 sharitu xie. All rights reserved.
//

#import "SHCustomQRCodeView.h"
#import <AVFoundation/AVFoundation.h>

//颜色(默认支付宝蓝)
#define STYLECOLOR [UIColor colorWithRed:57/255.f green:187/255.f blue:255/255.f alpha:1.0]

@interface SHCustomQRCodeView()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic , strong ) AVCaptureDevice         *   device;
@property (nonatomic , strong ) AVCaptureDeviceInput    *   input;
@property (nonatomic , strong ) AVCaptureMetadataOutput *   output;
@property (nonatomic , strong ) AVCaptureSession        *   session;
@property (nonatomic , strong ) AVCaptureVideoPreviewLayer *previewlayer;
@property (nonatomic , strong ) UIView                  *   hudView;
@end

@implementation SHCustomQRCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.grayColor;
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        BOOL isAvailableA = authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && isAvailableA == NO){//判断相机
            _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
            _output = [[AVCaptureMetadataOutput alloc] init];
            [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [_output setRectOfInterest:CGRectMake((frame.size.height - 220)*0.5/UIScreen.mainScreen.bounds.size.height,
                                                  (frame.size.width - 220)*0.5/UIScreen.mainScreen.bounds.size.width,
                                                  220/UIScreen.mainScreen.bounds.size.height,
                                                  220/UIScreen.mainScreen.bounds.size.width)];
            _session = [[AVCaptureSession alloc] init];
            [_session setSessionPreset:AVCaptureSessionPresetHigh];
            if ([_session canAddInput:_input]) {
                [_session addInput:_input];
            }
            if ([_session canAddOutput:_output]) {
                [_session addOutput:_output];
            }
            _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
            _previewlayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
            _previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _previewlayer.frame = self.layer.bounds;
            [self.layer insertSublayer:_previewlayer atIndex:0];
            [_session startRunning];
            
        }else{//相机不可用
            !self.backfailure ? : self.backfailure();
        }
    }
    [self addSubview:self.hudView];
    return self;
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        !self.backQRCodeURL ? : self.backQRCodeURL(metadataObject.stringValue);
    }
}

#pragma mark - lazy
//懵层
- (UIView *)hudView
{
    if (!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:self.bounds];
        CGFloat x = (self.frame.size.width - 220)*0.5;
        CGFloat y = (self.frame.size.height - 220)*0.5;
        CGFloat height = 220;
        //镂空
        CGRect qrRect = CGRectMake(x,y,height, height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.frame cornerRadius:0];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRect:qrRect];
        [path appendPath:circlePath];
        [path setUsesEvenOddFillRule:YES];
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.path = path.CGPath;
        fillLayer.fillRule = kCAFillRuleEvenOdd;
        fillLayer.fillColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4].CGColor;
        fillLayer.opacity = 0.5;
        [_hudView.layer addSublayer:fillLayer];
        
        //白色矩形
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, height, height)];
        CAShapeLayer *shapLayer = [CAShapeLayer layer];
        shapLayer.backgroundColor = UIColor.clearColor.CGColor;
        shapLayer.path = bezierPath.CGPath;
        shapLayer.lineWidth = 0.5;
        shapLayer.strokeColor = UIColor.whiteColor.CGColor;
        shapLayer.fillColor = UIColor.clearColor.CGColor;
        [_hudView.layer addSublayer:shapLayer];
        
        //绿色四个角落
        UIBezierPath *cornerBezierPath = [UIBezierPath bezierPath];
        
        [cornerBezierPath moveToPoint:CGPointMake(x, y+30)];//左上角
        [cornerBezierPath addLineToPoint:CGPointMake(x, y)];
        [cornerBezierPath addLineToPoint:CGPointMake(x+30, y)];
        
        [cornerBezierPath moveToPoint:CGPointMake(x+height-30, y)];//右上角
        [cornerBezierPath addLineToPoint:CGPointMake(x+height, y)];
        [cornerBezierPath addLineToPoint:CGPointMake(x+height, y+30)];
        
        [cornerBezierPath moveToPoint:CGPointMake(x+height, y+height-30)];//左上角
        [cornerBezierPath addLineToPoint:CGPointMake(x+height, y+height)];
        [cornerBezierPath addLineToPoint:CGPointMake(x+height-30, y+height)];
        
        [cornerBezierPath moveToPoint:CGPointMake(x+30, y+height)];//左上角
        [cornerBezierPath addLineToPoint:CGPointMake(x, y+height)];
        [cornerBezierPath addLineToPoint:CGPointMake(x, y+height-30)];
        
        CAShapeLayer *cornerShapLayer = [CAShapeLayer layer];
        cornerShapLayer.backgroundColor = UIColor.clearColor.CGColor;
        cornerShapLayer.path = cornerBezierPath.CGPath;
        cornerShapLayer.lineWidth = 3.0;
        cornerShapLayer.strokeColor = STYLECOLOR.CGColor;
        cornerShapLayer.fillColor = UIColor.clearColor.CGColor;
        [_hudView.layer addSublayer:cornerShapLayer];
        
        //光标
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(x+3, y+3, height-6, 1.5);
        gradientLayer.colors = [self colorWithBasicColor:STYLECOLOR];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        [gradientLayer addAnimation:[self positionBasicAnimate] forKey:nil];
        [_hudView.layer addSublayer:gradientLayer];
    }
    return _hudView;
}
//动画
- (CABasicAnimation *)positionBasicAnimate
{
    CGFloat x = (self.frame.size.width - 220)*0.5;
    CGFloat y = (self.frame.size.height - 220)*0.5;
    CGFloat height = 220;
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"position"];
    animate.removedOnCompletion = NO;
    animate.duration = 2.0;
    animate.fillMode = kCAFillModeRemoved;
    animate.repeatCount = HUGE_VAL;
    animate.fromValue = [NSValue valueWithCGPoint:CGPointMake(x+height*0.5, y+3)];
    animate.toValue = [NSValue valueWithCGPoint:CGPointMake(x+height*0.5, y+height-3)];
    animate.autoreverses = YES;
    return animate;
}

- (NSArray<UIColor *> *)colorWithBasicColor:(UIColor *)basicCoclor
{
    CGFloat R, G, B, amplitude;
    amplitude = 90/255.0;
    NSInteger numComponents = CGColorGetNumberOfComponents(basicCoclor.CGColor);
    NSArray *colors;
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(basicCoclor.CGColor);
        R = components[0];
        G = components[1];
        B = components[2];
        colors = @[(id)[UIColor colorWithWhite:0.667 alpha:0.2].CGColor,
                   (id)basicCoclor.CGColor,
                   (id)[UIColor colorWithRed:R+amplitude > 1.0 ? 1.0:R+amplitude
                                        green:G+amplitude > 1.0 ? 1.0:G+amplitude
                                        blue:B+amplitude > 1.0 ? 1.0:B+amplitude alpha:1.0].CGColor,
                   (id)[UIColor colorWithRed:R+amplitude > 1.0 ? 1.0:R+amplitude*2
                                        green:G+amplitude > 1.0 ? 1.0:G+amplitude*2
                                        blue:B+amplitude > 1.0 ? 1.0:B+amplitude*2 alpha:1.0].CGColor,
                   (id)[UIColor colorWithRed:R+amplitude > 1.0 ? 1.0:R+amplitude
                                        green:G+amplitude > 1.0 ? 1.0:G+amplitude
                                        blue:B+amplitude > 1.0 ? 1.0:B+amplitude alpha:1.0].CGColor,
                   (id)basicCoclor.CGColor,
                   (id)[UIColor colorWithWhite:0.667 alpha:0.2].CGColor,];
    }else{
        colors = @[(id)basicCoclor.CGColor,
                   (id)basicCoclor.CGColor,];
    }
    return colors;
}

@end
