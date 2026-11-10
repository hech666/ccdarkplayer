#import <UIKit/UIKit.h>
#import "HaogeCCDarkPlayerPrivate.h"

// GlobalFontSwitcher 逆向实锤：锁屏播放器深浅靠 CSCoverSheetViewController.viewWillAppear 控制
// 此处固定 UIUserInterfaceStyleDark，无需设置项
%hook CSCoverSheetViewController

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

%end

%ctor {
    %init;
}
