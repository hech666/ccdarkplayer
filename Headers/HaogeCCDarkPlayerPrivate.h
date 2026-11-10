#pragma once
#import <UIKit/UIKit.h>

// ControlCenterUI.framework — iOS 13-17
// CCUIRootViewController: 控制中心的根 ViewController，承载全部模块
@interface CCUIRootViewController : UIViewController
@end

// CCUIContainerViewController: iOS 16 重构版本的容器层
@interface CCUIContainerViewController : UIViewController
@end

// SpringBoard — SBControlCenterController
// viewController 返回当前 CC 根视图控制器
@interface SBControlCenterController : NSObject
@property (nonatomic, readonly) UIViewController *viewController;
- (void)presentAnimated:(BOOL)animated;
@end
