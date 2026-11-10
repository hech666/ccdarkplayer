#import <UIKit/UIKit.h>
#import <dlfcn.h>

// 递归对整棵 VC 子树施加深色，避免子模块自己覆盖回来
static void CCDPApplyDark(UIViewController *vc) {
    if (!vc) return;
    if (vc.overrideUserInterfaceStyle != UIUserInterfaceStyleDark) {
        vc.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }
    for (UIViewController *child in vc.childViewControllers) {
        CCDPApplyDark(child);
    }
    if (vc.presentedViewController) {
        CCDPApplyDark(vc.presentedViewController);
    }
}

// ── 广撒网：凡类名含 CC / NowPlaying / MediaControls / ControlCenter 的 VC
// 不依赖具体类名，iOS 改内部类名也不受影响
%hook UIViewController

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    NSString *cn = NSStringFromClass(self.class);
    if ([cn hasPrefix:@"CC"]
     || [cn containsString:@"NowPlaying"]
     || [cn containsString:@"MediaControls"]
     || [cn containsString:@"ControlCenter"]) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }
}

%end

// ── SBControlCenterController 兜底：CC 弹出时递归对整棵 VC 树施加深色
// _presentForReason:animated: iOS 16+ 实际触发的方法
// presentAnimated: 旧版本兼容
%hook SBControlCenterController

- (void)_presentForReason:(NSUInteger)reason animated:(BOOL)animated {
    %orig;
    // 稍微延迟，等 VC hierarchy 搭建完成再覆盖
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CCDPApplyDark(self.viewController);
    });
}

- (void)presentAnimated:(BOOL)animated {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CCDPApplyDark(self.viewController);
    });
}

%end

%ctor {
    @autoreleasepool {
        // 强制加载可能懒加载的框架，确保 %init 时类已存在
        dlopen("/System/Library/PrivateFrameworks/ControlCenterUI.framework/ControlCenterUI", RTLD_LAZY);
        %init;
    }
}
