#pragma once
#import <UIKit/UIKit.h>

// SpringBoard — SBControlCenterController
@interface SBControlCenterController : NSObject
@property (nonatomic, readonly) UIViewController *viewController;
- (void)presentAnimated:(BOOL)animated;
- (void)_presentForReason:(NSUInteger)reason animated:(BOOL)animated;
@end
