//
//  KJZXingWrapper.m
//  KJCodeScan
//
//  Created by TigerHu on 2024/8/28.
//

#import "KJZXingWrapper.h"
#import <ZXingObjC.h>
#import <ZXingObjC/ZXCapture.h>
#import <ZXingObjC/ZXCaptureDelegate.h>

@interface KJZXingWrapper() <ZXCaptureDelegate>

@property (nonatomic, strong) ZXCapture *capture;

@property (nonatomic, copy) void (^onSuccess)(ZXBarcodeFormat barcodeFormat,NSString *str,NSArray* resultPoints);

@property (nonatomic, assign) BOOL bNeedScanResult;

@end

@implementation KJZXingWrapper

- (id)init {
    if (self = [super init]) {
        self.capture = [[ZXCapture alloc] init];
        self.capture.camera = self.capture.back;
        self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        self.capture.rotation = 90.0f;
        self.capture.delegate = self;
        self.continuous = NO;
        self.orientation = AVCaptureVideoOrientationPortrait;
    }
    return self;
}

- (void)setOnStarted:(void (^)(void))onStarted {
    //self.capture.onStarted = onStarted;
}

- (id)initWithPreView:(UIView*)preView success:(void(^)(ZXBarcodeFormat barcodeFormat,NSString *str,NSArray* resultPoints))success
{
    if (self = [super init]) {
        
        self.capture = [[ZXCapture alloc] init];
        self.capture.camera = self.capture.back;
        self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        self.capture.rotation = 90.0f;
        self.capture.delegate = self;
        self.continuous = NO;
        self.orientation = AVCaptureVideoOrientationPortrait;
        
        self.onSuccess = success;
        
        CGRect rect = preView.frame;
        rect.origin = CGPointZero;
        
        self.capture.layer.frame = rect;
        
        [preView.layer insertSublayer:self.capture.layer atIndex:0];
    }
    return self;
}

- (void)setScanRect:(CGRect)scanRect {
    self.capture.scanRect = scanRect;
}

- (void)start {
    self.bNeedScanResult = YES;
    
    AVCaptureVideoPreviewLayer * preview = (AVCaptureVideoPreviewLayer*)self.capture.layer;
    preview.connection.videoOrientation = self.orientation;
    
    [self.capture start];
}

- (void)stop {
    self.bNeedScanResult = NO;
    [self.capture stop];
}

- (void)setOrientation:(NSInteger)orientation {
    _orientation = orientation;
    
    AVCaptureVideoPreviewLayer * preview = (AVCaptureVideoPreviewLayer*)self.capture.layer;
       preview.connection.videoOrientation = self.orientation;
}

- (void)setVideoLayerframe:(CGRect)videoLayerframe
{
    _videoLayerframe = videoLayerframe;
    
    AVCaptureVideoPreviewLayer * preview = (AVCaptureVideoPreviewLayer*)self.capture.layer;
    preview.frame = videoLayerframe;
}

- (void)openTorch:(BOOL)on_off
{
    [self.capture setTorch:on_off];
}

#pragma mark - ZXCaptureDelegate

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result
{
    if (!result) return;
    
    if (self.bNeedScanResult == NO) {
        return;
    }
    
    if (!_continuous) {
         [self stop];
    }
    
    if (_onSuccess) {
        _onSuccess(result.barcodeFormat,result.text,result.resultPoints);
    }
}

+ (UIImage *)createCodeWithString:(NSString*)str size:(CGSize)size CodeFomart:(ZXBarcodeFormat)format
{
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:str
                                  format:format
                                   width:size.width
                                  height:size.width
                                   error:nil];
    
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        return [UIImage imageWithCGImage:image.cgimage];
    } else {
        return nil;
    }
}

+ (void)recognizeImage:(UIImage*)image block:(void(^)(ZXBarcodeFormat barcodeFormat,NSString *str))block;
{
    ZXCGImageLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:image.CGImage];
    ZXHybridBinarizer *binarizer = [[ZXHybridBinarizer alloc] initWithSource: source];
    ZXBinaryBitmap *bitmap = [[ZXBinaryBitmap alloc] initWithBinarizer:binarizer];
    
    id<ZXReader> reader;
    if (NSClassFromString(@"ZXMultiFormatReader")) {
        reader = [NSClassFromString(@"ZXMultiFormatReader") performSelector:@selector(reader)];
    }
    
    NSError *error;
    ZXDecodeHints *_hints = [ZXDecodeHints hints];
    ZXResult *result = [reader decode:bitmap hints:_hints error:&error];
    
    if (result == nil) {
        block(kBarcodeFormatQRCode,nil);
        return;
    }
    
    block(result.barcodeFormat,result.text);
}

@end
