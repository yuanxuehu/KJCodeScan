//
//  KJScanZXingViewController.m
//  KJCodeScan
//
//  Created by TigerHu on 2024/8/29.
//

#import "KJScanZXingViewController.h"
#import <ZXingObjc/ZXResultPoint.h>
#import "KJScanResultViewController.h"

@interface KJScanZXingViewController ()

//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;
//相册
@property (nonatomic, strong) UIButton *btnPhoto;
//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;

@end

@implementation KJScanZXingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ZXing";
    
    __weak __typeof(self) weakSelf = self;
    [self requestCameraPemissionWithResult:^(BOOL granted) {
        if (granted) {
            [weakSelf startScan];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.firstLoad) {
        [self startScan];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    [self drawBottomItems];
//    [self drawTitle];
//    [self.view bringSubviewToFront:_topTitle];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
 
    [self stopScan];
}

- (void)stopScan
{
    [_zxingObj stop];
}


//启动设备
- (void)startScan
{
    if (!self.cameraPreView) {
        
        CGRect frame = self.view.bounds;
        
        UIView *videoView = [[UIView alloc]initWithFrame:frame];
        videoView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:videoView atIndex:0];
        
        self.cameraPreView = videoView;
    }
        
    __weak __typeof(self) weakSelf = self;
    if (!_zxingObj) {
        self.zxingObj = [[KJZXingManager alloc]initWithPreView:self.cameraPreView success:^(ZXBarcodeFormat barcodeFormat, NSString *str, NSArray *resultPoints) {
            [weakSelf handleZXingResultWithFormat:barcodeFormat resultStr:str];
        }];
    }
    _zxingObj.continuous = self.continuous;
    _zxingObj.orientation = UIDeviceOrientationPortrait;

#if TARGET_OS_SIMULATOR
    
#else
    [_zxingObj start];
#endif
    
    _zxingObj.onStarted = ^{
        
    };

    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark - 图片识别处理
//继承者实现
- (void)recognizeImageWithImage:(UIImage *)image
{
    __weak __typeof(self) weakSelf = self;
    
    [KJZXingManager recognizeImage:image block:^(ZXBarcodeFormat barcodeFormat, NSString *str) {
        [weakSelf handleZXingResultWithFormat:barcodeFormat resultStr:str];
    }];
}

- (void)handleZXingResultWithFormat:(ZXBarcodeFormat)barcodeFormat resultStr:(NSString *)resultStr {
    KJScanResultViewController *vc = [[KJScanResultViewController alloc] init];
    vc.strScan = resultStr;
    vc.strCodeType = [self convertZXBarcodeFormat:barcodeFormat];
    [self.navigationController pushViewController:vc animated:NO];
}

- (NSString *)convertZXBarcodeFormat:(ZXBarcodeFormat)barCodeFormat
{
    NSString *strAVMetadataObjectType = nil;
    
    switch (barCodeFormat) {
        case kBarcodeFormatQRCode:
            strAVMetadataObjectType = AVMetadataObjectTypeQRCode;
            break;
        case kBarcodeFormatEan13:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN13Code;
            break;
        case kBarcodeFormatEan8:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN8Code;
            break;
        case kBarcodeFormatPDF417:
            strAVMetadataObjectType = AVMetadataObjectTypePDF417Code;
            break;
        case kBarcodeFormatAztec:
            strAVMetadataObjectType = AVMetadataObjectTypeAztecCode;
            break;
        case kBarcodeFormatCode39:
            strAVMetadataObjectType = AVMetadataObjectTypeCode39Code;
            break;
        case kBarcodeFormatCode93:
            strAVMetadataObjectType = AVMetadataObjectTypeCode93Code;
            break;
        case kBarcodeFormatCode128:
            strAVMetadataObjectType = AVMetadataObjectTypeCode128Code;
            break;
        case kBarcodeFormatDataMatrix:
            strAVMetadataObjectType = AVMetadataObjectTypeDataMatrixCode;
            break;
        case kBarcodeFormatITF:
            strAVMetadataObjectType = AVMetadataObjectTypeITF14Code;
            break;
        case kBarcodeFormatRSS14:
            break;
        case kBarcodeFormatRSSExpanded:
            break;
        case kBarcodeFormatUPCA:
            break;
        case kBarcodeFormatUPCE:
            strAVMetadataObjectType = AVMetadataObjectTypeUPCECode;
            break;
        default:
            break;
    }
    
    return strAVMetadataObjectType;
}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        return;
    }
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds)-110,CGRectGetWidth(self.view.bounds), 100);
    self.bottomItemsView = [[UIView alloc]initWithFrame:frame];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)*1/4, CGRectGetHeight(_bottomItemsView.frame)/2);
     [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPhoto = [[UIButton alloc]init];
    _btnPhoto.bounds = _btnFlash.bounds;
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)*3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];
    
}

#pragma mark -底部功能项
//打开相册
- (void)openPhoto {
    __weak __typeof(self) weakSelf = self;
    [self authorizePhotoPermissionWithCompletion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto:NO];
        }
    }];
}

//开关闪光灯
- (void)openOrCloseFlash {
    self.isOpenFlash = !self.isOpenFlash;
    [_zxingObj openTorch:self.isOpenFlash];
   
    if (self.isOpenFlash) {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    } else {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    }
}

@end
