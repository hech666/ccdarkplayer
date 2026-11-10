#import "HaogeCCDarkPlayerConfig.h"
#import "HaogeCCDarkPlayerPreferences.h"

@interface HaogeCCDarkPlayerConfig ()
@property (atomic, copy) NSDictionary *snapshot;
@property (nonatomic, strong) dispatch_queue_t reloadQueue;
@end

static void haoge_ccdarkplayer_preferencesDidChange(CFNotificationCenterRef center, void *observer,
                                          CFStringRef name, const void *object, CFDictionaryRef info) {
    HaogeCCDarkPlayerConfig *config = (__bridge HaogeCCDarkPlayerConfig *)observer;
    dispatch_async(config.reloadQueue, ^{
        [config haoge_ccdarkplayer_reload];
    });
}

@implementation HaogeCCDarkPlayerConfig

+ (instancetype)haoge_ccdarkplayer_shared {
    static HaogeCCDarkPlayerConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _reloadQueue = dispatch_queue_create("com.haoge.ccdarkplayer.preferences", DISPATCH_QUEUE_SERIAL);
        [self haoge_ccdarkplayer_reload];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
            (__bridge const void *)self, haoge_ccdarkplayer_preferencesDidChange,
            (__bridge CFStringRef)HaogeCCDarkPlayerPreferencesChanged, NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately);
        // Close the window between the first read and observer registration.
        dispatch_async(_reloadQueue, ^{ [self haoge_ccdarkplayer_reload]; });
    }
    return self;
}

- (void)haoge_ccdarkplayer_reload {
    self.snapshot = haoge_ccdarkplayer_readPreferences();
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:HaogeCCDarkPlayerPreferencesChanged object:self];
    });
}

- (id)haoge_ccdarkplayer_valueForKey:(NSString *)key defaultValue:(id)defaultValue {
    return self.snapshot[key] ?: defaultValue;
}

- (BOOL)haoge_ccdarkplayer_isEnabled {
    id value = [self haoge_ccdarkplayer_valueForKey:@"enabled" defaultValue:@(YES)];
    return [value isKindOfClass:[NSNumber class]] ? [value boolValue] : YES;
}

- (void)dealloc {
    CFNotificationCenterRemoveEveryObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                            (__bridge const void *)self);
}

@end
