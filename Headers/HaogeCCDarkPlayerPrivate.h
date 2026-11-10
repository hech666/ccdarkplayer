#pragma once
#import <UIKit/UIKit.h>

// ControlCenterUI.framework — iOS 16-17
@interface CCUIRootViewController : UIViewController
@end

@interface CCUIModuleCollectionViewController : UIViewController
@end

// SpringBoard
@interface SBControlCenterController : NSObject
@property (nonatomic, readonly) UIViewController *viewController;
@end
