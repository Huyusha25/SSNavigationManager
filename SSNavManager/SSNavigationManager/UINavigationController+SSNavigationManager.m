//
//  UINavigationController+SSNavigationManager.m
//  SSNavManage
//
//  Created by HYS on 2019/11/13.
//  Copyright © 2019 HYS. All rights reserved.
//

#import "UINavigationController+SSNavigationManager.h"
#import <objc/runtime.h>

#define SSNavigationDefaultAlpha 0.99

/// UIViewController_Private
typedef void (^_ssVcWillAppearBlock)(UIViewController *viewController, BOOL animated) ;
@interface UIViewController (_Push)
@property (nonatomic, copy) _ssVcWillAppearBlock _ss_willAppearBlock;
@property (nonatomic, assign) BOOL _ss_alphaFlage;
@property (nonatomic, assign) BOOL _ss_hiddenFlage;


- (void)_ss_setNavigationBarAlpha:(CGFloat)alpha;
@end

@implementation UIViewController (_Push)


+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oldMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
        Method newMethod = class_getInstanceMethod(self, @selector(ss_viewWillAppear:));
        
        method_exchangeImplementations(oldMethod, newMethod);
    });
}

- (void)ss_viewWillAppear:(BOOL)animated
{
    [self ss_viewWillAppear:animated];
    
    // storyboard create navigation rootcontroller not call push _ss_hiddenFlage = nil
    if (self._ss_hiddenFlage && !self._ss_willAppearBlock) {
        __weak typeof(self) weakSelf = self;
        // set _ss_hiddenFlage
        self._ss_willAppearBlock = ^(UIViewController *viewController, BOOL animated) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.navigationController setNavigationBarHidden:strongSelf.ss_prefersNavigationBarHidden animated:YES];
        };
    }
    [self _ss_setConfige:animated];
    
}

- (void)_ss_setConfige:(BOOL)animated
{
    // set hidden
    if (self._ss_willAppearBlock) {
        self._ss_willAppearBlock(self, animated);
    }
    
    // check current controller
    if ([self isKindOfClass:NSClassFromString(@"UIEditingOverlayViewController")] || [self isKindOfClass:NSClassFromString(@"UIInputWindowController")] || [self isKindOfClass:NSClassFromString(@"UINavigationController")]) {
        return;
    }
    
    // set alpha
    if (self._ss_alphaFlage) {
        [self _ss_setNavigationBarAlpha:self.ss_prefersNavigationBarAlpha];
    } else {
        [self _ss_setNavigationBarAlpha:self.navigationController.ss_navigationBarMainAlpha];
    }
}
- (void)_ss_setNavigationBarAlpha:(CGFloat)alpha
{
    self.ss_prefersNavigationBarAlpha = alpha;
    [self _ss_setNavigationBarColor:self.ss_prefersnavigationBarColor ? self.ss_prefersnavigationBarColor : self.navigationController.ss_navigationBarMainColor alpha:alpha];
}

- (void)_ss_setNavigationBarColor:(UIColor *)color alpha:(CGFloat)alpha
{
    UIColor *newColor = [self getColorForBaseColor:color alpha:alpha];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [newColor CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.ss_prefersnavigationBarColor = color;
    
}

- (void)ss_setNavigationTempAlpha:(CGFloat)alpha
{
    [self _ss_setNavigationBarColor:self.ss_prefersnavigationBarColor ? self.ss_prefersnavigationBarColor : self.navigationController.ss_navigationBarMainColor alpha:alpha];
}

- (UIColor *)getColorForBaseColor:(UIColor *)color alpha:(CGFloat)newAlpha
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat oldAlpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&oldAlpha];
    return [UIColor colorWithRed:red green:green blue:blue alpha:newAlpha];
}
#pragma mark - property
- (void)set_ss_willAppearBlock:(_ssVcWillAppearBlock)_ss_willAppearBlock
{
    objc_setAssociatedObject(self, @selector(_ss_willAppearBlock), _ss_willAppearBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (_ssVcWillAppearBlock)_ss_willAppearBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)set_ss_alphaFlage:(BOOL)_ss_alphaFlage
{
    objc_setAssociatedObject(self, @selector(_ss_alphaFlage), @(_ss_alphaFlage), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)_ss_alphaFlage
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)set_ss_hiddenFlage:(BOOL)_ss_hiddenFlage
{
    objc_setAssociatedObject(self, @selector(_ss_hiddenFlage), @(_ss_hiddenFlage), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)_ss_hiddenFlage
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
@end

/// UIViewController_Public
@implementation UIViewController (Push)
#pragma mark - property

- (void)setSs_prefersNavigationBarHidden:(BOOL)ss_prefersNavigationBarHidden
{
    // change hidden
    self._ss_hiddenFlage = YES;
    objc_setAssociatedObject(self, @selector(ss_prefersNavigationBarHidden), @(ss_prefersNavigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ss_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setSs_prefersNavigationBarAlpha:(CGFloat)ss_prefersNavigationBarAlpha
{
    // clear push pop black
    if (ss_prefersNavigationBarAlpha >= 1) {
        ss_prefersNavigationBarAlpha = SSNavigationDefaultAlpha;
    }
    // change alpha
    self._ss_alphaFlage = YES;
    
    objc_setAssociatedObject(self, @selector(ss_prefersNavigationBarAlpha), @(ss_prefersNavigationBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ss_prefersNavigationBarAlpha
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSs_prefersnavigationBarColor:(UIColor *)ss_prefersnavigationBarColor
{
    objc_setAssociatedObject(self, @selector(ss_prefersnavigationBarColor), ss_prefersnavigationBarColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIColor *)ss_prefersnavigationBarColor
{
    return objc_getAssociatedObject(self, _cmd);
}

@end


/// UINavigationController

@implementation UINavigationController (SSNavigationManager)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // clear navigatinbar line
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        [navigationBar setShadowImage:[UIImage new]];
        
        Method oldPushMethod = class_getInstanceMethod(self, @selector(pushViewController:animated:));
        Method newPushMethod = class_getInstanceMethod(self, @selector(ss_pushViewController:animated:));
        
        method_exchangeImplementations(oldPushMethod, newPushMethod);
    });
}

- (void)ss_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // block
    __weak typeof(self) weakSelf = self;
    viewController._ss_willAppearBlock = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf setNavigationBarHidden:viewController.ss_prefersNavigationBarHidden animated:YES];
    };
    
    // set back image
    if (self.viewControllers.count > 0) {
        if (self.ss_navigationBackImage || self.ss_navigationBackTitle) {
            UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (self.ss_navigationBackImage) [backBtn setImage:self.ss_navigationBackImage forState:UIControlStateNormal];
            if (self.ss_navigationBackTitle) {
                [backBtn setTitle:self.ss_navigationBackTitle forState:UIControlStateNormal];
                [backBtn setTitleColor:self.ss_navigationBackTitleColor forState:UIControlStateNormal];
                backBtn.titleLabel.font = [UIFont systemFontOfSize:self.ss_navigationBackTitleFont];
            }
            [backBtn addTarget:self action:@selector(_ss_pop) forControlEvents:UIControlEventTouchUpInside];

            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
            viewController.navigationItem.leftBarButtonItem = backItem;

            self.interactivePopGestureRecognizer.delegate = viewController;
        }
        // 隐藏push tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // pushViewController:animated
    [self ss_pushViewController:viewController animated:animated];
}


- (void)ss_setNavigationBarColor:(UIColor *)color alpha:(CGFloat)alpha
{
    // clear push pop black
    if (alpha >= 1) {
        alpha = SSNavigationDefaultAlpha;
    }
    
    [self _ss_setNavigationBarColor:color alpha:alpha];
    
    self.ss_navigationBarMainColor = color;
    self.ss_navigationBarMainAlpha = alpha;
}

- (void)_ss_pop
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - property
- (void)setSs_navigationBarMainAlpha:(CGFloat)ss_navigationBarMainAlpha
{
    objc_setAssociatedObject(self, @selector(ss_navigationBarMainAlpha), @(ss_navigationBarMainAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ss_navigationBarMainAlpha
{
    id alpha = objc_getAssociatedObject(self, _cmd);
    return alpha ? [alpha floatValue] : SSNavigationDefaultAlpha;
}

- (void)setSs_navigationBarMainColor:(UIColor *)ss_navigationBarMainColor
{
    objc_setAssociatedObject(self, @selector(ss_navigationBarMainColor), ss_navigationBarMainColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)ss_navigationBarMainColor
{
    id color = objc_getAssociatedObject(self, _cmd);
    return color ? color : [UIColor whiteColor];
}

- (void)setSs_navigationBackImage:(UIImage *)ss_navigationBackImage
{
    objc_setAssociatedObject(self, @selector(ss_navigationBackImage), ss_navigationBackImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)ss_navigationBackImage
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSs_navigationBackTitle:(NSString *)ss_navigationBackTitle
{
    objc_setAssociatedObject(self, @selector(ss_navigationBackTitle), ss_navigationBackTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)ss_navigationBackTitle
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSs_navigationBackTitleColor:(UIColor *)ss_navigationBackTitleColor
{
    objc_setAssociatedObject(self, @selector(ss_navigationBackTitleColor), ss_navigationBackTitleColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIColor *)ss_navigationBackTitleColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSs_navigationBackTitleFont:(CGFloat)ss_navigationBackTitleFont
{
    objc_setAssociatedObject(self, @selector(ss_navigationBackTitleFont), @(ss_navigationBackTitleFont), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)ss_navigationBackTitleFont
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
@end
