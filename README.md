

# KJCodeScan
iOS 二维码、条形码 

### iOS扫码封装
- 扫码识别封装: 系统API(AVFoundation)、ZXing、ZBar（已放弃维护）
- 二维码、条形码
- 相册获取图片后识别
- 开关灯

### 说明
- ZXing和ZBar在使用中或多或少有不尽如人意的地方，苹果就给我们提供了系统原生的API来支持我们扫描获取二维码
- 按照识别速度来排序的话：系统API>ZBar>ZXing
