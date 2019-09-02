//
//  CodeScanController.m
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/6/21.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import "CodeScanController.h"
#import "SGQRCode.h"
#import "KBMainButton.h"

@interface CodeScanController () <BasicNavigationBarViewDelegate, SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>

@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) KBMainButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;

@end

@implementation CodeScanController

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager resetSampleBufferDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
    [self removeFlashlightBtn];
    [_manager cancelSampleBufferDelegate];
}

- (void)dealloc {
    
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scanningView];

    // 判断有无权限...
    BOOL isUseCamera = [self cameraUsageMessage];
    if (isUseCamera == YES) {
        
        [self setupQRCodeScanning];

    } else {
        
        [self cameraUseageRemindBegin];
    }
    
    [self.view addSubview:self.promptLabel];
    
    // 为了 UI 效果
    [self.view addSubview:self.bottomView];
    
    [self setCustomNavigationBar];

}
#pragma mark - 判断是否有使用权限...
- (BOOL)cameraUsageMessage
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        return NO;
    } else
    {
        return YES;
    }
}
#pragma mark - 相机使用权限提示
- (void)cameraUseageRemindBegin
{
    // 无权限 做一个友好的提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 跳转到相机权限界面...
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)setCustomNavigationBar {
    
    BasicNavigationBarView *navBar = [[BasicNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBar_H + StatusBar_H)];
    navBar.delegate = self;
    [navBar setNavigationBarWith:@"扫一扫" andBGColor:[UIColor whiteColor] andTitleColor:[UIColor colorWithHexString:@"#333333"] andImage:@"nav_left_back" andHidLine:NO];
    [self.view addSubview:navBar];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f4f6"];
}

- (void)customNavgationBarDidClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (SGQRCodeScanningView *)scanningView {
    
    if (!_scanningView) {
        
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, NavBar_H + StatusBar_H, SCREEN_WIDTH, 0.9 * SCREEN_HEIGHT - (NavBar_H + StatusBar_H))];
    }
    return _scanningView;
}

- (void)removeScanningView {
    
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)setupQRCodeScanning {
    
    self.manager = [SGQRCodeScanManager sharedManager];
    
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    _manager.delegate = self;
}

#pragma mark - - - SGQRCodeAlbumManagerDelegate
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    
    [self.view addSubview:self.scanningView];
}

- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    
    if ([result hasPrefix:@"http"]) {
        
    } else {
        
    }
}

- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    
    SLog(@"暂未识别出二维码");
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
        
    if (metadataObjects != nil && metadataObjects.count > 0) {
        
        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        [scanManager videoPreviewLayerRemoveFromSuperlayer];
        
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        self.code = [obj stringValue];
        
        if (self.ScanResultsBlock) {
            
            self.ScanResultsBlock(self, self.code);
        }
    } else {
        SLog(@"暂未识别出扫描的二维码");
    }
}
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue {
    
    if (brightnessValue < 0.2) {
        
        [self.view addSubview:self.flashlightBtn];
    } else {
        
        if (self.isSelectedFlashlightBtn == NO) {
            
            [self removeFlashlightBtn];
        }
    }
}

- (UILabel *)promptLabel {
    
    if (!_promptLabel) {
        
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

- (UIView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanningView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanningView.frame))];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}

#pragma mark - 闪光灯按钮
- (KBMainButton *)flashlightBtn {
    
    if (!_flashlightBtn) {
        
        // 添加闪光灯按钮
        _flashlightBtn = [KBMainButton buttonWithType:UIButtonTypeCustom];
        CGFloat flashlightBtnW = 60;
        CGFloat flashlightBtnH = flashlightBtnW;
        CGFloat flashlightBtnX = 0.5 * (SCREEN_WIDTH - flashlightBtnW);
        CGFloat flashlightBtnY = 0.6 * self.view.frame.size.height;
        CGFloat imgW           = 22;
        CGFloat imgH           = imgW;

        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        _flashlightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_flashlightBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [_flashlightBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];

        [_flashlightBtn setImage:[UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"] forState:(UIControlStateNormal)];
        [_flashlightBtn setImage:[UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"] forState:(UIControlStateSelected)];
        [_flashlightBtn setTitle:@"轻触照亮" forState:(UIControlStateNormal)];
        [_flashlightBtn setTitle:@"轻触关闭" forState:(UIControlStateSelected)];
        [_flashlightBtn setButonStyle:ImageTopTitleDown imgFrame:CGRectMake((flashlightBtnW - imgW) / 2.0, 10, imgW, imgH)];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}

- (void)flashlightBtnAction:(UIButton *)button {
    
    if (button.selected == NO) {
        
        [SGQRCodeHelperTool SG_openFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        
        [self removeFlashlightBtn];
    }
}

- (void)removeFlashlightBtn {
    
    __weak __typeof__ (self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [SGQRCodeHelperTool SG_CloseFlashlight];
        weakSelf.isSelectedFlashlightBtn = NO;
        weakSelf.flashlightBtn.selected = NO;
        [weakSelf.flashlightBtn removeFromSuperview];
    });
}

@end
