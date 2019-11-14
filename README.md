# SSNavigationManager
Navigation简单的导航控制
### 演示图
![image](https://github.com/Huyusha25/SSNavigationManager/blob/master/push.gif )
### 使用示例
```
// 导入头文件
#import "UINavigationController+SSNavigationManager.h"
```

```
// 设置初始值
@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航初始 默认白色和1
    [self ss_setNavigationBarColor:[UIColor redColor] alpha:1];
}

@end
```

```
// 隐藏navigationbar
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ss_prefersNavigationBarHidden = YES;
}

@end
```

```
// 设置透明度
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ss_prefersNavigationBarAlpha = 0.5;
}

@end
```

```
// 设置当前navigationbar颜色
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ss_prefersnavigationBarColor = [UIColor blueColor];
}

@end
```

```
// 设置当前navigationbar临时透明度-渐变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = offset / maxAlphaOffset;
    [self ss_setNavigationTempAlpha:alpha];
}
```

