//
//  KJScanNativeViewController.m
//  KJCodeScan
//
//  Created by TigerHu on 2024/8/30.
//

#import "KJScanNativeViewController.h"
#import "KJScanResultViewController.h"
#import "KJNativeManager.h"

@interface KJScanNativeViewController ()

/**
 @brief  扫码功能封装对象
 */
@property (nonatomic,strong) KJNativeManager *scanObj;

//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;
//相册
@property (nonatomic, strong) UIButton *btnPhoto;
//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;

@end

@implementation KJScanNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Native";
    
    __weak __typeof(self) weakSelf = self;
    [self requestCameraPemissionWithResult:^(BOOL granted) {
        if (granted) {
            [weakSelf startScan];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    [self drawBottomItems];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.firstLoad) {
        [self startScan];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
 
    [self stopScan];

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

    if (!_scanObj) {
        CGRect cropRect = CGRectZero;
        
//        if (self.isOpenInterestRect) {
//            //设置只识别框内区域
//            cropRect = [LBXScanView getScanRectWithPreView:self.view style:self.style];
//        }
        

        self.scanObj = [[KJNativeManager alloc]initWithPreView:self.cameraPreView ObjectType:@[AVMetadataObjectTypeQRCode] cropRect:cropRect videoMaxScale:^(CGFloat maxScale) {
            //[weakSelf setVideoMaxScale:maxScale];
            
        }  success:^(NSArray<KJScanResult *> *array) {
            
            [weakSelf handleNativeWithArray:array];
        }];
        [_scanObj setNeedCaptureImage:NO];
        //是否需要返回条码坐标
        _scanObj.needCodePosion = YES;
        _scanObj.continuous = self.continuous;
    }
    
    
    _scanObj.onStarted = ^{
        
    };
    
    //可动态修改
    _scanObj.orientation = AVCaptureVideoOrientationPortrait;
    
#if TARGET_OS_SIMULATOR
    
#else
     [_scanObj startScan];
#endif
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)stopScan
{
    [_scanObj stopScan];
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

#pragma mark - 图片识别处理
//继承者实现
- (void)recognizeImageWithImage:(UIImage *)image
{
    __weak __typeof(self) weakSelf = self;
    
    [KJNativeManager recognizeImage:image success:^(NSArray<KJScanResult *> *array) {
        [weakSelf handleNativeWithArray:array];
    }];
}

- (void)handleNativeWithArray:(NSArray *)resultArray {
    if (!resultArray || resultArray.count < 1) {
        NSLog(@"native扫码失败了。。。。");
        return;
    }
    
    KJScanResult *scanResult = resultArray[0];
    NSString *strResult = scanResult.strScanned;
    
    KJScanResultViewController *vc = [[KJScanResultViewController alloc] init];
    vc.strScan = strResult;
    vc.strCodeType = scanResult.strBarCodeType;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    __weak __typeof(self) weakSelf = self;
    [self authorizePhotoPermissionWithCompletion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto:NO];
        }
    }];
}

//开关闪光灯
- (void)openOrCloseFlash
{
    self.isOpenFlash = !self.isOpenFlash;
    [_scanObj setTorch:self.isOpenFlash];
   
    if (self.isOpenFlash) {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    } else {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    }
}

@end
