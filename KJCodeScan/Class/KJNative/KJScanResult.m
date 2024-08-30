//
//  KJScanResult.m
//  KJCodeScan
//
//  Created by TigerHu on 2024/8/30.
//

#import "KJScanResult.h"

@implementation KJScanResult

- (instancetype)initWithScanString:(NSString*)str imgScan:(UIImage*)img barCodeType:(NSString*)type
{
    if (self = [super init]) {
        
        self.strScanned = str;
        self.imgScanned = img;
        self.strBarCodeType = type;
        self.bounds = CGRectZero;
    }
    
    return self;
}

@end
