//
//  KJScanBaseViewController.h
//  KJCodeScan
//
//  Created by TigerHu on 2024/8/29.
//

#import <UIKit/UIKit.h>


@interface KJScanBaseViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//相机预览
@property (nonatomic, strong) UIView *cameraPreView;

/**
@brief 是否需要连续扫码
*/
@property (nonatomic, assign) BOOL continuous;

/// 首次加载
@property (nonatomic, assign) BOOL firstLoad;

/**
 @brief  闪关灯开启状态记录
 */
@property(nonatomic,assign)BOOL isOpenFlash;


- (void)openLocalPhoto:(BOOL)allowsEditing;

- (void)requestCameraPemissionWithResult:(void(^)( BOOL granted))completion;
- (void)authorizePhotoPermissionWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

@end
