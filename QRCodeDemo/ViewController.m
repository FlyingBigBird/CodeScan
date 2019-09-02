//
//  ViewController.m
//  QRCodeDemo
//
//  Created by BaoBaoDaRen on 2019/9/2.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "ViewController.h"
#import "CodeScanController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *scanBtn;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
    self.title = @"扫一扫";
    
    [self showUI];
}
- (void)showUI
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }

    self.scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.scanBtn.frame = CGRectMake(0, 0, 30, 30);
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imgV.image = [UIImage imageNamed:@"saoyisao"];
    [self.scanBtn addSubview:imgV];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.scanBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.scanBtn addTarget:self action:@selector(scanBeginning:) forControlEvents:UIControlEventTouchUpInside];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavBar_H - StatusBar_H)];
    [self.view addSubview:self.webView];
    self.webView.backgroundColor = [UIColor whiteColor];
}
- (void)scanBeginning:(UIButton *)sender
{
    CodeScanController * scanVC = [[CodeScanController alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];
    
    WeakSelf(self)
    scanVC.ScanResultsBlock = ^(CodeScanController *qrCodeScanVC,NSString *code) {
        
        // 关闭扫码
        [weakself.navigationController popViewControllerAnimated:YES];
        
        if (IsStrEmpty(code)) {
            
            return ;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:code message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"浏览器打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",code]]]];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];

        
    };
}


@end
