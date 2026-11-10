#import <UIKit/UIKit.h>
#import "HaogeCCDarkPlayerPrivate.h"

// CCUIRootViewController: iOS 13-17 控制中心根 VC，trait 向下传递覆盖所有子模块（包括 Now Playing 播放器）
%hook CCUIRootViewController

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

// 防止旋转/尺寸变化时被系统重置
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    %orig;
    if (self.overrideUserInterfaceStyle != UIUserInterfaceStyleDark) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }
}

%end

// CCUIContainerViewController: iOS 16 重构后部分版本的外层容器，一并覆盖
%hook CCUIContainerViewController

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

%end

// SBControlCenterController: SpringBoard 侧的 CC 管理器
// presentAnimated: 触发时对根视图直接强制深色，兜底保证
%hook SBControlCenterController

- (void)presentAnimated:(BOOL)animated {
    %orig;
    UIViewController *rootVC = self.viewController;
    if (rootVC && rootVC.overrideUserInterfaceStyle != UIUserInterfaceStyleDark) {
        rootVC.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }
}

%end
