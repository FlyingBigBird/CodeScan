//
//  CodeScanController.h
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/6/21.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeScanController : UIViewController

@property (nonatomic, copy) void (^ScanResultsBlock)(CodeScanController * qrCodeScanVC, NSString *code);

@end
