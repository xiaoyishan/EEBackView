//
//  BaseVC.m
//  EEBackView
//
//  Created by aosue on 2020/11/10.
//

#import "BaseVC.h"
#import "EEBackView.h"


@interface BaseVC ()
@property (nonatomic,strong) WKWebView *webView;
//@property (nonatomic,strong) UILabel *toastView;

@property (nonatomic,strong) EEBackView *backView;
@end

@implementation BaseVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    printf("viewWillAppear");
    
    // 在导航首页不展示这个
    BOOL isHidden = (self.navigationController.viewControllers.count == 1  && !self.presentingViewController);
    self.backView.hidden = isHidden;
    
    __block typeof(self) weakSelf = self;
    self.backView.goBackBlock = ^{
        [weakSelf goBack];
    };

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (self.webUrl.length > 3) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
        [self.view addSubview:self.webView];
    }

}


-(void)goBack{
    // 关闭各种异常的弹框,loading等
//    if (_toastView && self.toastView.hidden == NO) {
//        self.toastView.hidden = YES;
//    }
    // 网页页面回退
    if (_webView && self.webView.canGoBack && self.webView.hidden == NO) {
        [self.webView goBack];
    }
    // 导航栏回退
    else if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    // 模态页面回退
    else if (self.presentingViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        // ios13模态非全屏的处理
        if(@available(iOS 13.0,*)){
            UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            if (topVC.presentedViewController) topVC = topVC.presentedViewController;
            BaseVC *vc = (BaseVC*)topVC;
            if ([topVC  isKindOfClass:[UINavigationController class]] &&
                [(UINavigationController*)topVC viewControllers].count >1) {
                vc = [(UINavigationController*)topVC viewControllers].lastObject;
            }
            
            if (vc.webView.canGoBack) {
                [vc.webView goBack];
            }else if (vc.modalPresentationStyle != UIModalPresentationFullScreen) {
                [vc.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }
}


-(EEBackView*)backView {
    if (!_backView) {
        EEBackView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:766699999333];
        if (!view) {
            _backView = [[EEBackView alloc] initWithFrame:CGRectMake(0, 0, 5, self.view.frame.size.height)];
            _backView.tag = 766699999333;
        }else{
            _backView = view;
        }
        [[UIApplication sharedApplication].keyWindow addSubview:_backView];
    }
    return _backView;
}
-(WKWebView*)webView {
    if (!_webView) {
        _webView = [WKWebView new];
        _webView.frame = self.view.bounds;
        _webView.scrollView.backgroundColor = [UIColor lightGrayColor];
    }
    return _webView;
}
//-(UILabel*)toastView {
//    if (!_toastView) {
//        _toastView = [UILabel new];
//    }
//    return _toastView;
//}

@end
