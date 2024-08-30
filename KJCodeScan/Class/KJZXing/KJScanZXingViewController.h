//
//  KJScanZXingViewController.h
//  KJCodeScan
//
//  Created by TigerHu on 2024/8/29.
//

#import "KJScanBaseViewController.h"
#import "KJZXingManager.h"

@interface KJScanZXingViewController : KJScanBaseViewController

/**
 ZXing扫码对象
 */
@property (nonatomic, strong) KJZXingManager *zxingObj;







@end
