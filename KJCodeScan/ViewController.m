//
//  ViewController.m
//  KJCodeScan
//
//  Created by TigerHu on 2024/8/28.
//

#import "ViewController.h"
#import "KJScanZXingViewController.h"
#import "KJScanNativeViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *ZXingScanButton;
@property (nonatomic, strong) UIButton *nativeScanButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ZXingScanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.ZXingScanButton.frame = CGRectMake((self.view.frame.size.width-100)/2, 300, 100, 50);
    [self.ZXingScanButton setTitle:@"ZXing" forState:UIControlStateNormal];
    [self.ZXingScanButton addTarget:self action:@selector(ZXingScanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ZXingScanButton];
    
    self.nativeScanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nativeScanButton.frame = CGRectMake((self.view.frame.size.width-100)/2, 380, 100, 50);
    [self.nativeScanButton setTitle:@"AVFoundation" forState:UIControlStateNormal];
    [self.nativeScanButton addTarget:self action:@selector(nativeScanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nativeScanButton];
    
}

- (void)ZXingScanButtonClick:(UIButton *)sender {
    KJScanZXingViewController *vc = [[KJScanZXingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)nativeScanButtonClick:(UIButton *)sender {
    KJScanNativeViewController *vc = [[KJScanNativeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

@end
