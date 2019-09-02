//
//  ClientDefine.h
//  QRCodeDemo
//
//  Created by BaoBaoDaRen on 2019/9/2.
//  Copyright © 2019 Boris. All rights reserved.
//

#ifndef ClientDefine_h
#define ClientDefine_h

/**
 *define:获取屏幕的宽
 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

/**
 *define:获取屏幕的高
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/**
 *  设备判断...
 */
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define is_Pad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !is_Pad : NO)

//判断iPhoneX所有系列
#define ISIPhoneXSeries (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
#define StatusBar_H (ISIPhoneXSeries ? 44.0 : 20.0)
#define NavBar_H         44
#define TabBar_H  (ISIPhoneXSeries ? 83.0 : 49.0)


/**
 *define:iOS 8.0的版本判断
 */
#define iOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)

// 字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqualToString:@"(null)"]) || ([(_ref) isEqualToString:@"(Null)"]) || ([(_ref) isEqualToString:@"(NULL)"]) || ([(_ref) isEqualToString:@"(null)"]) || ([(_ref) isEqualToString:@"<null>"]) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqualToString:@""]) || ([(_ref) length] == 0))


/**
 *  解决iOS10+Xcode8 NSLog下打印不全的问题...
 */
#ifdef DEBUG
#define SLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#else
#define SLog(format, ...)
#endif

#define WeakSelf(type)  __weak typeof(type) weak##type = type; // weak


#endif /* ClientDefine_h */
