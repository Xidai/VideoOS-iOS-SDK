//
//  VPWebViewController.m
//  VPInterfaceControllerDemo
//
//  Created by peter on 2018/9/13.
//  Copyright © 2018 videopls. All rights reserved.
//

#import "VPWebViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>

typedef void (^WebViewCloseHandler)(void);

@interface VPWebViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) WebViewCloseHandler closeHandle;

@end

@implementation VPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.selectionGranularity = WKSelectionGranularityDynamic;
    config.allowsInlineMediaPlayback = YES;
    WKPreferences *preferences = [WKPreferences new];
    //是否支持JavaScript
    preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preferences;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.webView];
    if (self.url) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"button_close"];
    [closeBtn setImage:image forState:UIControlStateNormal];
    CGFloat y = 0;
    if ([VPWebViewController isIPHONEX]) {
        if (self.view.bounds.size.width < self.view.bounds.size.height) {
            y = 24;
        }
    }
    
    closeBtn.frame = CGRectMake(self.view.bounds.size.width - 30 - 20, y + 20, 30, 30);
    [self.view addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.backgroundColor = [UIColor grayColor];
    self.closeBtn = closeBtn;
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
//    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right).with.offset(-20);
//        make.top.equalTo(self.view.mas_top).with.offset(20);
//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(30);
//    }];
}

- (void)loadUrl:(NSString *)url close:(void (^)(void))closeHandle {
    if (closeHandle) {
        self.closeHandle = closeHandle;
    }
    self.url = url;
    if (self.webView) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

- (void)closeBtnClicked:(id)pSender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.closeHandle) {
        self.closeHandle();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)viewDidLayoutSubviews {
    CGFloat y = 0;
    if ([VPWebViewController isIPHONEX]) {
        if (self.view.bounds.size.width < self.view.bounds.size.height) {
            y = 24;
        }
    }
    self.closeBtn.frame = CGRectMake(self.view.bounds.size.width - 30 - 20, y + 20, 30, 30);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+ (BOOL)isIPHONEX {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}

@end
