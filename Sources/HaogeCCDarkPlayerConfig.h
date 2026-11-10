#pragma once

#import <Foundation/Foundation.h>

@interface HaogeCCDarkPlayerConfig : NSObject
+ (instancetype)haoge_ccdarkplayer_shared;
- (BOOL)haoge_ccdarkplayer_isEnabled;
- (id)haoge_ccdarkplayer_valueForKey:(NSString *)key defaultValue:(id)defaultValue;
- (void)haoge_ccdarkplayer_reload;
@end
