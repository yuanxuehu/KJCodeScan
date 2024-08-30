//
//  KJScanResultViewController.m
//  KJCodeScan
//
//  Created by TigerHu on 2024/8/29.
//

#import "KJScanResultViewController.h"

@interface KJScanResultViewController ()

@property (nonatomic, strong) UILabel *scanText;
@property (nonatomic, strong) UILabel *scanCodeType;

@end

@implementation KJScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫码结果";
    
    self.scanText.frame = CGRectMake(0, 300, self.view.frame.size.width, 60);
    self.scanCodeType.frame = CGRectMake(0, 370, self.view.frame.size.width, 120);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _scanText.text = _strScan;
    _scanCodeType.text = [NSString stringWithFormat:@"码的类型:%@",_strCodeType];
}

- (UILabel *)scanText {
    if (!_scanText) {
        _scanText = [UILabel new];
        _scanText.textColor = UIColor.whiteColor;
        _scanText.textAlignment = NSTextAlignmentCenter;
        _scanText.numberOfLines = 0;
        [self.view addSubview:_scanText];
    }
    return _scanText;
}

- (UILabel *)scanCodeType {
    if (!_scanCodeType) {
        _scanCodeType = [UILabel new];
        _scanCodeType.textColor = UIColor.whiteColor;
        _scanCodeType.textAlignment = NSTextAlignmentCenter;
        _scanCodeType.numberOfLines = 0;
        [self.view addSubview:_scanCodeType];
    }
    return _scanCodeType;
}


@end
