//
//  UINavigationController+SSNavigationManager.h
//  SSNavManage
//
//  Created by HYS on 2019/11/13.
//  Copyright © 2019 HYS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Push) <UIGestureRecognizerDelegate>

/// 设置当前viewcontroller的navigation是否隐藏
@property (nonatomic, assign) BOOL ss_prefersNavigationBarHidden;

/// 设置当前viewcontroller的透明度
@property (nonatomic, assign) CGFloat ss_prefersNavigationBarAlpha;

/// 设置当前viewcontroller的导航栏颜色
@property (nonatomic, strong) UIColor *ss_prefersnavigationBarColor;

@end

@interface UINavigationController (SSNavigationManager)

/// 设置整个UINavigationController的颜色和透明度 默认定初始值color = white, alpha = 1
- (void)ss_setNavigationBarColor:(UIColor *)color alpha:(CGFloat)alpha;

/// 设置返回按钮图片
@property (nonatomic, strong) UIImage *ss_navigationBackImage;

/// 设置返回按钮title
@property (nonatomic, strong) NSString *ss_navigationBackTitle;
/// 设置返回按钮title颜色
@property (nonatomic, strong) UIColor *ss_navigationBackTitleColor;
/// 设置返回按钮title字体大小
@property (nonatomic, assign) CGFloat ss_navigationBackTitleFont;

@property (nonatomic, assign) CGFloat ss_navigationBarMainAlpha;

@property (nonatomic, strong) UIColor *ss_navigationBarMainColor;

@end
