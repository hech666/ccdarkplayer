#import <UIKit/UIKit.h>
#import "HaogeCCDarkPlayerPrivate.h"
#import <dlfcn.h>

// CCUIRootViewController: iOS 16-17 控制中心根 VC
// overrideUserInterfaceStyle 设 dark 后，trait 自动向下传递给所有子模块（包括 Now Playing）
%hook CCUIRootViewController

- (void)viewDidLoad {
    %orig;
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    %orig;
    if (self.overrideUserInterfaceStyle != UIUserInterfaceStyleDark) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }
}

%end

// CCUIModuleCollectionViewController: 承载各模块单元格的 VC，也设一遍防止子模块自己覆盖
%hook CCUIModuleCollectionViewController

- (void)viewDidLoad {
    %orig;
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

%end

%ctor {
    @autoreleasepool {
        // ControlCenterUI.framework 在 SpringBoard 启动时可能尚未加载（懒加载）
        // dlopen 强制提前加载，确保 Logos %init 时能找到目标类
        dlopen("/System/Library/PrivateFrameworks/ControlCenterUI.framework/ControlCenterUI", RTLD_LAZY);
        // 必须显式调用 %init，否则所有 %hook 都不会生效
        %init;
    }
}
